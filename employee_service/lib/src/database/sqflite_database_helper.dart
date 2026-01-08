import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

typedef SqliteOnCreate = Future<void> Function(Database db, int version);

class SqliteDatabaseHelper implements DatabaseHelper {
  final String databasePath;
  final int version;
  final SqliteOnCreate onCreate;

  SqliteDatabaseHelper({
    required this.databasePath,
    required this.onCreate,
    this.version = 1,
  })


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

  @override
  Future<List<Map<String, dynamic>>> query(String sql, [List<Object?>? args]) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<int> update(String sql, [List<Object?>? args]) {
    // TODO: implement update
    throw UnimplementedError();
  }}