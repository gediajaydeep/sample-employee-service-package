
import 'database_helper.dart';


class SqliteDatabaseHelper implements DatabaseHelper {
  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<int> delete(String sql, [List<Object?>? args]) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> insert(String sql, [List<Object?>? args]) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  }

  @override
  Future<int> update(String sql, [List<Object?>? args]) {
    // TODO: implement update
    throw UnimplementedError();
  }
}