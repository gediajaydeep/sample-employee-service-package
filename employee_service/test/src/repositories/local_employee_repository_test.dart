import 'package:employee_service/src/database/database_helper.dart';
import 'package:employee_service/src/models/employee.dart';
import 'package:employee_service/src/models/employee_filter.dart';
import 'package:employee_service/src/repositories/local_employee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late LocalEmployeeRepository repository;
  late MockDatabaseHelper mockDb;

  setUpAll(() {
    mockDb = MockDatabaseHelper();
    repository = LocalEmployeeRepository(mockDb);
  });
  final tEmployee = Employee(
    fullName: 'Jaydeep Gedia',
    jobTitle: 'Software Engineer',
    salary: 75000.0,
    countryId: 1,
  );

  test(
    'create : should call db.insert with correct SQL and arguments and return id when success',
    () async {
      when(() => mockDb.insert(any(), any())).thenAnswer((_) async => 1);

      final result = await repository.create(tEmployee);

      expect(result, 1);

      verify(
        () => mockDb.insert(any(that: contains('INSERT INTO employees')), [
          tEmployee.fullName,
          tEmployee.jobTitle,
          tEmployee.salary,
          tEmployee.countryId,
        ]),
      ).called(1);
    },
  );

  test(
    'create : should throw an exception when database insert fails',
    () async {
      when(
        () => mockDb.insert(any(), any()),
      ).thenThrow(Exception('Database Write Error'));

      expect(() => repository.create(tEmployee), throwsException);
    },
  );

  test(
    'deleteById : should call db.delete with correct SQL and ID and return count of deleted employee',
    () async {
      const idToDelete = 42;
      when(() => mockDb.delete(any(), any())).thenAnswer((_) async => 1);

      final result = await repository.deleteById(idToDelete);

      expect(result, 1);
      verify(
        () => mockDb.delete(any(that: contains('DELETE FROM employees')), [
          idToDelete,
        ]),
      ).called(1);
    },
  );

  test(
    'deleteById : should throw an exception if deletion fails due to DB error',
    () async {
      when(
        () => mockDb.delete(any(), any()),
      ).thenThrow(Exception('Database Error: Disk I/O failure'));

      expect(() => repository.deleteById(1), throwsException);
    },
  );

  test(
    'getById : should return a joined Employee object when record exists',
    () async {
      final mockRow = {
        'id': 1,
        'full_name': 'Jaydeep Gedia',
        'job_title': 'Developer',
        'salary': 60000.0,
        'country_id': 101,
        'country_name': 'India',
        'tax_rate': 0.15,
      };

      when(() => mockDb.query(any(), any())).thenAnswer((_) async => [mockRow]);

      final result = await repository.getById(1);

      expect(result, isNotNull);
      expect(result!.fullName, 'Jaydeep Gedia');

      expect(result.country, isNotNull);
      expect(result.country!.id, 101);
      expect(result.country!.name, 'India');
      expect(result.country!.taxRate, 0.15);

      verify(
        () => mockDb.query(
          any(that: allOf(contains('JOIN'), contains('WHERE e.id = ?'))),
          [1],
        ),
      ).called(1);
    },
  );

  test('getById should return null when employee does not exist', () async {
    when(() => mockDb.query(any(), any())).thenAnswer((_) async => []);

    final result = await repository.getById(999);

    expect(result, isNull);
  });

  test(
    'getById should throw an Exception if DB returns malformed country data',
    () async {
      final malformedRow = {
        'id': 'abx',
        'full_name': 'Jaydeep',
        'country_id': 101,
        'country_name': null,
      };
      when(
        () => mockDb.query(any(), any()),
      ).thenAnswer((_) async => [malformedRow]);

      expect(() => repository.getById(1), throwsA(isA<TypeError>()));
    },
  );
  

}
