import 'package:employee_service/src/database/database_schemas.dart';
import 'package:employee_service/src/database/sqflite_database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  const dbName = 'employee_management.db';
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  test('SQFLiteDBHelper is created correctly', () {
    final SqliteDatabaseHelper dbHelper = SqliteDatabaseHelper(
      databasePath: dbName,
      onCreate: (db, version) async {},
    );
    expect(dbHelper.databasePath, equals(dbName));
    expect(dbHelper.version, equals(1));
  });

  group('Initialization, and schema integrity', () {
    late SqliteDatabaseHelper dbHelper;
    setUp(() {
      dbHelper = SqliteDatabaseHelper(
        databasePath: dbName,
        onCreate: (db, version) async {
          await db.execute(DatabaseSchemas.createCountriesTable);
          await db.execute(DatabaseSchemas.createEmployeesTable);
        },
      );
    });
    tearDown(() {
      dbHelper.close();
    });

    test('Should create the correct tables on initialization', () async {
      final tables = await dbHelper.query(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN (?, ?)",
        [DatabaseSchemas.countriesTable, DatabaseSchemas.employeesTable],
      );

      final tableNames = tables.map((row) => row['name'] as String).toList();
      expect(tableNames, contains(DatabaseSchemas.countriesTable));
      expect(tableNames, contains(DatabaseSchemas.employeesTable));
    });
  });

  group('CRUD Operations', () {
    late SqliteDatabaseHelper dbHelper;
    setUp(() async {
      if (await databaseFactory.databaseExists(dbName)) {
        await databaseFactory.deleteDatabase(dbName);
      }
      dbHelper = SqliteDatabaseHelper(
        databasePath: dbName,
        onCreate: (db, version) async {
          await db.execute(DatabaseSchemas.createCountriesTable);
          await db.execute(DatabaseSchemas.createEmployeesTable);
        },
      );
    });
    tearDown(() {
      dbHelper.close();
    });
    test(
      'INSERT: Should respect positional arguments and return auto-increment ID',
      () async {
        const countryName = 'India';
        const taxRate = 0.10;

        final id = await dbHelper.insert(
          'INSERT INTO countries (name, tax_rate) VALUES (?, ?)',
          [countryName, taxRate],
        );

        expect(id, 1);
      },
    );

    test('QUERY: Should return empty list if no records match', () async {
      final result = await dbHelper.query(
        'SELECT * FROM countries WHERE id = ?',
        [99],
      );
      expect(result, isEmpty);
    });

    test(
      'UPDATE: Should respect arguments and return count of modified rows',
      () async {
        final id = await dbHelper.insert(
          'INSERT INTO countries (name, tax_rate) VALUES (?, ?)',
          ['USA', 0.12],
        );

        final affected = await dbHelper.update(
          'UPDATE countries SET tax_rate = ? WHERE id = ?',
          [0.15, id],
        );

        expect(affected, 1);
        final check = await dbHelper.query(
          'SELECT tax_rate FROM countries WHERE id = ?',
          [id],
        );
        expect(check.first['tax_rate'], 0.15);
      },
    );

    test('DELETE: Should return count of rows deleted', () async {
      final id = await dbHelper.insert(
        'INSERT INTO countries (name, tax_rate) VALUES (?, ?)',
        ['Germany', 0.20],
      );

      final deleted = await dbHelper.delete(
        'DELETE FROM countries WHERE id = ?',
        [id],
      );
      expect(deleted, 1);
    });
  });
}
