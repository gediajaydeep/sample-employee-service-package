import 'package:employee_service/src/database/index.dart';
import 'package:employee_service/src/models/index.dart';
import 'package:employee_service/src/repositories/index.dart';
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
  group('create', () {
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
  });
  group('deleteById', () {
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
  });
  group('getById', () {
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

        when(
          () => mockDb.query(any(), any()),
        ).thenAnswer((_) async => [mockRow]);

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
  });

  group('getEmployees', () {
    final mockDbRows = [
      {
        'id': 1,
        'full_name': 'Jaydeep Gedia',
        'job_title': 'Developer',
        'salary': 60000.0,
        'country_id': 10,
        'country_name': 'India',
        'tax_rate': 0.15,
      },
      {
        'id': 2,
        'full_name': 'John Doe',
        'job_title': 'Manager',
        'salary': 80000.0,
        'country_id': 11,
        'country_name': 'USA',
        'tax_rate': 0.20,
      },
    ];
    test(
      'getEmployees should return a list of nested Employee objects with correct mapping',
      () async {
        final filter = EmployeeFilter();
        when(
          () => mockDb.query(any(), any()),
        ).thenAnswer((_) async => mockDbRows);

        final result = await repository.getEmployees(filter);

        expect(result.length, 2);

        expect(result[0].fullName, 'Jaydeep Gedia');
        expect(result[0].country, isNotNull);
        expect(result[0].country!.name, 'India');
        expect(result[0].country!.taxRate, 0.15);

        expect(result[1].fullName, 'John Doe');
        expect(result[1].country!.name, 'USA');

        verify(
          () => mockDb.query(
            any(
              that: allOf([contains('INNER JOIN'), isNot(contains('WHERE'))]),
            ),
            [], // Arguments list must be empty
          ),
        ).called(1);
      },
    );

    test(
      'getEmployees should return an empty list when database returns no results',
      () async {
        when(() => mockDb.query(any(), any())).thenAnswer((_) async => []);

        final result = await repository.getEmployees(EmployeeFilter());

        expect(result, isA<List<Employee>>());
        expect(result, isEmpty);
      },
    );

    test(
      'getEmployees should handle partial filters and still map correctly',
      () async {
        final filter = EmployeeFilter()..byJobTitle('Developer');
        when(
          () => mockDb.query(any(), any()),
        ).thenAnswer((_) async => [mockDbRows.first]);

        final result = await repository.getEmployees(filter);

        expect(result.length, 1);
        expect(result.first.jobTitle, 'Developer');
        verify(
          () => mockDb.query(any(that: contains('WHERE e.job_title = ?')), [
            'Developer',
          ]),
        ).called(1);
      },
    );

    test(
      'getEmployees should throw a TypeError if DB rows are missing joined country data',
      () async {
        final brokenRows = [
          {'id': 'ass', 'full_name': 'Broken Row', 'country_id': 10},
        ];
        when(
          () => mockDb.query(any(), any()),
        ).thenAnswer((_) async => brokenRows);

        expect(
          () => repository.getEmployees(EmployeeFilter()),
          throwsA(isA<TypeError>()),
        );
      },
    );
  });

  group('getMetrics', () {
    test(
      'getMetrics should return SalaryMetrics with correct aggregates and NO WHERE clause when filter is empty',
      () async {
        final emptyFilter = EmployeeFilter();
        final mockMetricsRow = {
          'average_salary': 50000.0,
          'min_salary': 20000.0,
          'max_salary': 80000.0,
          'total_employees': 5,
        };

        when(
          () => mockDb.query(any(), any()),
        ).thenAnswer((_) async => [mockMetricsRow]);

        final result = await repository.getMetrics(emptyFilter);

        expect(result.averageSalary, 50000.0);
        expect(result.totalEmployees, 5);

        verify(
          () => mockDb.query(
            any(
              that: allOf([
                contains('AVG(salary)'),
                contains('COUNT(*)'),
                isNot(contains('WHERE')),
              ]),
            ),
            [],
          ),
        ).called(1);
      },
    );

    test(
      'getMetrics should apply WHERE clause to metrics when filter is provided',
      () async {
        final filter = EmployeeFilter()..byCountryId(10);
        when(() => mockDb.query(any(), any())).thenAnswer(
          (_) async => [
            {
              'average_salary': 60000.0,
              'min_salary': 60000.0,
              'max_salary': 60000.0,
              'total_employees': 1,
            },
          ],
        );

        await repository.getMetrics(filter);

        verify(
          () =>
              mockDb.query(any(that: contains('WHERE e.country_id = ?')), [10]),
        ).called(1);
      },
    );
    test(
      'getMetrics should handle empty result set by returning zeroed metrics (or throwing depending on implementation)',
      () async {
        when(() => mockDb.query(any(), any())).thenAnswer((_) async => []);

        expect(() => repository.getMetrics(EmployeeFilter()), throwsStateError);
      },
    );
    test(
      'getMetrics should throw a TypeError if aggregate result is missing expected columns',
      () async {
        final incompleteRow = {'min_salary': 1000.0, 'total_employees': 1};

        when(
          () => mockDb.query(any(), any()),
        ).thenAnswer((_) async => [incompleteRow]);

        expect(
          () => repository.getMetrics(EmployeeFilter()),
          throwsA(isA<TypeError>()),
          reason:
              'Should throw TypeError if fromJson mapping fails due to missing keys',
        );
      },
    );
  });

  group('update', () {
    final tEmployee = Employee(
      id: 1,
      fullName: 'Jaydeep Gedia',
      jobTitle: 'Lead Developer',
      salary: 95000.0,
      countryId: 5,
    );

    test(
      'should call db.update with correct SQL and positional arguments',
      () async {
        when(() => mockDb.update(any(), any())).thenAnswer((_) async => 1);

        final result = await repository.update(tEmployee);

        expect(result, 1);

        verify(
          () => mockDb.update(
            any(
              that: allOf([
                contains('UPDATE employees'),
                contains('SET'),
                contains('WHERE id = ?'),
              ]),
            ),
            [
              tEmployee.fullName,
              tEmployee.jobTitle,
              tEmployee.salary,
              tEmployee.countryId,
              tEmployee.id,
            ],
          ),
        ).called(1);
      },
    );

    test(
      'should call db.update with correct SQL and positional arguments when only some fields are passed',
      () async {
        when(() => mockDb.update(any(), any())).thenAnswer((_) async => 1);

        final result = await repository.update(
          Employee(id: 2, fullName: 'New Name'),
        );

        expect(result, 1);

        verify(
          () => mockDb.update(
            any(
              that: allOf([
                contains('UPDATE employees'),
                contains('SET'),
                isNot(contains('salary')),
                contains('WHERE id = ?'),
              ]),
            ),
            ['New Name', 2],
          ),
        ).called(1);
      },
    );

    test(
      'should return 0 when the employee ID does not exist in database',
      () async {
        when(() => mockDb.update(any(), any())).thenAnswer((_) async => 0);

        final result = await repository.update(tEmployee);

        expect(result, 0);
      },
    );

    test(
      'should throw an exception when update fails due to constraint violation',
      () async {
        when(
          () => mockDb.update(any(), any()),
        ).thenThrow(Exception('Database Error: Foreign Key Constraint failed'));

        expect(() => repository.update(tEmployee), throwsException);
      },
    );
  });
}
