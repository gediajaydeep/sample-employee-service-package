import 'package:employee_service/src/database/database_schemas.dart';
import 'package:employee_service/src/models/country.dart';
import 'package:employee_service/src/repositories/country_repository.dart';

import '../database/database_helper.dart';

class LocalCountryRepository implements CountryRepository {
  final DatabaseHelper _dbHelper;

  LocalCountryRepository(this._dbHelper);

  @override
  Future<int> create(Country country) async {
    const sql =
        'INSERT INTO ${DatabaseSchemas.countriesTable} (name, tax_rate) VALUES (?, ?)';
    return await _dbHelper.insert(sql, [country.name, country.taxRate]);
  }

  @override
  Future<int> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Country>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Country?> getById(int id) async {
    const sql = 'SELECT * FROM ${DatabaseSchemas.countriesTable} WHERE id = ?';
    final maps = await _dbHelper.query(sql, [id]);
    if (maps.isEmpty) return null;
    return Country.fromJson(maps.first);
  }

  @override
  Future<int> update(Country country) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
