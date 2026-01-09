abstract class DatabaseHelper {
  factory DatabaseHelper.defaultSQL() {
    return SqliteDatabaseHelper(
      databasePath: DatabaseSchemas.dbPath,
      onCreate: (db, version) async {
        await db.transaction((txn) async {
          await txn.execute(DatabaseSchemas.createCountriesTable);
          await txn.execute(DatabaseSchemas.createEmployeesTable);

          for (final query in DatabaseSchemas.seedCountriesQueries) {
            await txn.execute(query);
          }
        });
      },
    );
  }
  Future<int> insert(String sql, [List<Object?>? args]);
  Future<List<Map<String, dynamic>>> query(String sql, [List<Object?>? args]);
  Future<int> update(String sql, [List<Object?>? args]);
  Future<int> delete(String sql, [List<Object?>? args]);
  Future<void> close();
}