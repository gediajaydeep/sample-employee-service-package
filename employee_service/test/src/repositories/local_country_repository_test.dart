import 'package:employee_service/src/database/database_helper.dart';
import 'package:employee_service/src/models/country.dart';
import 'package:employee_service/src/repositories/local_country_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

main() {
  late MockDatabaseHelper mockDb;
  late LocalCountryRepository repository;
  setUp(() {
    mockDb = MockDatabaseHelper();
    repository = LocalCountryRepository(mockDb);
  });
  test(
    'create() should call db.insert with correct SQL and arguments and return the correct if',
    () async {
      final country = Country(name: 'India', taxRate: 0.10);
      when(() => mockDb.insert(any(), any())).thenAnswer((_) async => 1);

      final result = await repository.create(country);

      expect(result, 1);
      verify(
        () => mockDb.insert(any(that: contains('INSERT INTO countries')), [
          country.name,
          country.taxRate,
        ]),
      ).called(1);
    },
  );

  test(
    'getById() should use db.query return Country object when record exists',
    () async {
      final mockRow = {'id': 1, 'name': 'USA', 'tax_rate': 0.12};
      when(() => mockDb.query(any(), any())).thenAnswer((_) async => [mockRow]);

      final result = await repository.getById(1);

      expect(result, isA<Country>());
      expect(result?.name, 'USA');
      verify(
        () => mockDb.query(any(that: contains('WHERE id = ?')), [1]),
      ).called(1);
    },
  );

  test(
    'getById() should use db.query and throw an exception if record does not exist',
    () async {
      when(() => mockDb.query(any(), any())).thenThrow(Exception());

      expect(repository.getById(1), throwsException);
      verify(
        () => mockDb.query(any(that: contains('WHERE id = ?')), [1]),
      ).called(1);
    },
  );
}
