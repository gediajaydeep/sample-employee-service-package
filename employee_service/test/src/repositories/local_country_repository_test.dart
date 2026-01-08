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
}
