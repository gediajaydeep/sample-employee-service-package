import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';

typedef SqliteOnCreate = Future<void> Function(Database db, int version);

class SqliteDatabaseHelper implements DatabaseHelper {
  final String databasePath;
  final int version;
  final SqliteOnCreate onCreate;

  Future<Database>? _dbFuture;

  SqliteDatabaseHelper({
    required this.databasePath,
    required this.onCreate,
    this.version = 1,
  });

  Future<Database> _getDb() {
    _dbFuture ??= _open();
    return _dbFuture!.catchError((e) {
      _dbFuture = null;
      throw e;
    });
  }

  Future<Database> _open() async {
    return await openDatabase(
      databasePath,
      version: version,
      onCreate: onCreate,
    );
  }

  @override
  Future<void> close() async {
    if (_dbFuture != null) {
      final db = await _dbFuture;
      await db?.close();
      _dbFuture = null;
    }
  }

  @override
  Future<int> delete(String sql, [List<Object?>? args]) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> insert(String sql, [List<Object?>? args]) async {
    final db = await _getDb();
    return await db.rawInsert(sql, args);
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String sql, [
    List<Object?>? args,
  ]) async {
    final db = await _getDb();
    return await db.rawQuery(sql, args);
  }

  @override
  Future<int> update(String sql, [List<Object?>? args]) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
