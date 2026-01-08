import 'package:employee_service/src/database/sqflite_database_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const dbName = 'employee_management.db';
  test('SQFLiteDBHelper is created correctly', () {
    final SqliteDatabaseHelper dbHelper = SqliteDatabaseHelper(
      databasePath: dbName,
      onCreate: (db, version) async {
        
      },
    );
  });
}
