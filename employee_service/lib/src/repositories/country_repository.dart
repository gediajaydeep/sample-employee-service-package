import '../models/index.dart' show Country;

abstract class CountryRepository {
  Future<int> create(Country country);
  Future<List<Country>> getAll();
  Future<Country?> getById(int id);
  Future<int> update(Country country);
  Future<int> delete(int id);
}
