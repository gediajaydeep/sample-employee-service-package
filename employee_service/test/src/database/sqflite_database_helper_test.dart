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
}
