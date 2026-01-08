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
    'getById() should use db.query should return null if record does not exist',
    () async {
      when(() => mockDb.query(any(), any())).thenAnswer((_) async => []);

      final result = await repository.getById(99);

      expect(result, isNull);
    },
  );

  test(
    'getById() should use db.query and throw an exception if db.query exception',
    () async {
      when(() => mockDb.query(any(), any())).thenThrow(Exception());

      expect(repository.getById(1), throwsException);
      verify(
        () => mockDb.query(any(that: contains('WHERE id = ?')), [1]),
      ).called(1);
    },
  );
  test(
    'getAll() should return a list of Country objects when data exists',
    () async {
      final mockRows = [
        {'id': 1, 'name': 'India', 'tax_rate': 0.10},
        {'id': 2, 'name': 'USA', 'tax_rate': 0.15},
      ];
      when(() => mockDb.query(any(), any())).thenAnswer((_) async => mockRows);

      final result = await repository.getAll();

      expect(result.length, 2);
      expect(result[0].name, 'India');
      expect(result[1].name, 'USA');
      verify(
        () => mockDb.query(any(that: contains('SELECT')), any()),
      ).called(1);
    },
  );

  test(
    'getAll() should return an empty list when the table is empty',
    () async {
      when(() => mockDb.query(any(), any())).thenAnswer((_) async => []);

      final result = await repository.getAll();

      expect(result, isEmpty);
      expect(result, isA<List<Country>>());
    },
  );
  test('getAll() should throw an exception if db.query fails', () async {
    when(() => mockDb.query(any(), any())).thenThrow(Exception());

    expect(repository.getAll(), throwsException);
  });

  test('update() should return 1 when record is updated', () async {
    final country = Country(id: 1, name: 'India', taxRate: 0.18);
    when(() => mockDb.update(any(), any())).thenAnswer((_) async => 1);

    final result = await repository.update(country);

    expect(result, 1);
    verify(
      () => mockDb.update(
        any(that: contains('UPDATE countries')),
        [country.name, country.taxRate, country.id], // Check arg order
      ),
    ).called(1);
  });

  test('update() should return 0 when ID does not exist', () async {
    final country = Country(id: 999, name: 'Ghost Country', taxRate: 0.0);
    when(() => mockDb.update(any(), any())).thenAnswer((_) async => 0);

    final result = await repository.update(country);

    expect(result, 0);
  });

  test('update() should throw exception on update error', () async {
    final country = Country(id: 1, name: 'Duplicate Name', taxRate: 0.1);
    when(
      () => mockDb.update(any(), any()),
    ).thenThrow(Exception('Database Error: UNIQUE constraint failed'));

    expect(() => repository.update(country), throwsException);
  });
}
