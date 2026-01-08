abstract class DatabaseHelper {
  Future<int> insert(String sql, [List<Object?>? args]);
  Future<List<Map<String, dynamic>>> query(String sql, [List<Object?>? args]);
  Future<int> update(String sql, [List<Object?>? args]);
  Future<int> delete(String sql, [List<Object?>? args]);
  Future<void> close();
}