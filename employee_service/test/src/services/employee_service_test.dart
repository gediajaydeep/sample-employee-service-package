import 'package:employee_service/src/models/country.dart';
import 'package:employee_service/src/models/employee.dart';
import 'package:employee_service/src/models/employee_filter.dart';
import 'package:employee_service/src/repositories/country_repository.dart';
import 'package:employee_service/src/repositories/employee_repository.dart';
import 'package:employee_service/src/services/employee_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeRepository extends Mock implements EmployeeRepository {}

class MockCountryRepository extends Mock implements CountryRepository {}

void main() {
  late MockEmployeeRepository mockEmployeeRepo;
  late MockCountryRepository mockCountryRepo;
  late EmployeeService service;

  setUp(() {
    mockEmployeeRepo = MockEmployeeRepository();
    mockCountryRepo = MockCountryRepository();
    service = EmployeeService(
      employeeRepo: mockEmployeeRepo,
      countryRepo: mockCountryRepo,
    );
  });

  setUpAll(() {
    registerFallbackValue(EmployeeFilter());
    registerFallbackValue(Employee());
  });
  group('EmployeeService - getEmployees()', () {
    final tEmployeesFromRepo = [
      Employee(
        id: 1,
        fullName: 'Jaydeep Gedia',
        jobTitle: 'Developer',
        salary: 1000.0,
        countryId: 1,
        country: Country(id: 1, name: 'Test Country', taxRate: 0.10), // 10% tax
      ),
    ];

    test(
      'should return employees with correctly calculated net salaries',
      () async {
        final filter = EmployeeFilter();
        when(
          () => mockEmployeeRepo.getEmployees(filter),
        ).thenAnswer((_) async => tEmployeesFromRepo);

        final result = await service.getEmployees(filter);

        expect(result.length, 1);
        expect(result.first.salary, 1000.0);

        verify(() => mockEmployeeRepo.getEmployees(filter)).called(1);
      },
    );

    test('should propagate exceptions when the repository fails', () async {
      final filter = EmployeeFilter();
      when(
        () => mockEmployeeRepo.getEmployees(filter),
      ).thenThrow(Exception('Database Read Error'));

      expect(() => service.getEmployees(filter), throwsA(isA<Exception>()));
    });

    test('should handle empty lists gracefully', () async {
      when(
        () => mockEmployeeRepo.getEmployees(any()),
      ).thenAnswer((_) async => []);

      final result = await service.getEmployees(EmployeeFilter());

      expect(result, isEmpty);
    });
  });

  group('EmployeeService - getEmployeeById', () {
    const tId = 1;
    final tEmployee = Employee(
      id: tId,
      fullName: 'Jaydeep Gedia',
      jobTitle: 'Developer',
      salary: 60000.0,
      countryId: 1,
      country: Country(id: 1, name: 'India', taxRate: 0.10),
    );

    test(
      'should return an Employee when the repository finds a record',
      () async {
        when(
          () => mockEmployeeRepo.getById(tId),
        ).thenAnswer((_) async => tEmployee);

        final result = await service.getEmployeeById(tId);

        expect(result, equals(tEmployee));
        verify(() => mockEmployeeRepo.getById(tId)).called(1);
      },
    );

    test(
      'should return null when the repository cannot find the record',
      () async {
        when(
          () => mockEmployeeRepo.getById(any()),
        ).thenAnswer((_) async => null);

        final result = await service.getEmployeeById(999);

        expect(result, isNull);
        verify(() => mockEmployeeRepo.getById(999)).called(1);
      },
    );

    test(
      'should propagate (rethrow) exceptions if the repository fails',
      () async {
        when(
          () => mockEmployeeRepo.getById(any()),
        ).thenThrow(Exception('Database fetch failed'));

        expect(() => service.getEmployeeById(tId), throwsA(isA<Exception>()));
      },
    );
  });
  group('EmployeeService - createEmployee', () {
    final tEmployee = Employee(
      fullName: 'Jaydeep Gedia',
      jobTitle: 'Developer',
      salary: 50000.0,
      countryId: 1,
    );

    test(
      'should return new ID when repository successfully creates record',
      () async {
        when(() => mockEmployeeRepo.create(any())).thenAnswer((_) async => 1);

        final result = await service.createEmployee(tEmployee);

        expect(result, 1);
        verify(() => mockEmployeeRepo.create(tEmployee)).called(1);
      },
    );

    test('should propagate exceptions when the repository fails', () async {
      when(
        () => mockEmployeeRepo.create(any()),
      ).thenThrow(Exception('Database Write Failure'));

      expect(
        () => service.createEmployee(tEmployee),
        throwsA(isA<Exception>()),
      );
    });
    group('EmployeeService - _validateEmployee Logic', () {
      test(
        'should throw "Full name is required." if fullName is empty or null',
        () async {
          final invalid = Employee(
            fullName: '',
            jobTitle: 'Dev',
            salary: 1000,
            countryId: 1,
          );

          expect(
            () => service.createEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Full name is required.',
              ),
            ),
          );
        },
      );

      test(
        'should throw "Job title is required." if jobTitle is blank',
        () async {
          final invalid = Employee(
            fullName: 'Jaydeep',
            jobTitle: '   ',
            salary: 1000,
            countryId: 1,
          );

          expect(
            () => service.createEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Job title is required.',
              ),
            ),
          );
        },
      );

      test(
        'should throw "Salary must be greater than zero." if salary is 0 or negative',
        () async {
          final invalid = Employee(
            fullName: 'Jaydeep',
            jobTitle: 'Dev',
            salary: 0,
            countryId: 1,
          );

          expect(
            () => service.createEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Salary must be greater than zero.',
              ),
            ),
          );
        },
      );

      test(
        'should throw "A valid country id is required." if countryId is invalid',
        () async {
          final invalid = Employee(
            fullName: 'Jaydeep',
            jobTitle: 'Dev',
            salary: 1000,
            countryId: 0,
          );

          expect(
            () => service.createEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'A valid country id is required.',
              ),
            ),
          );
        },
      );
    });
  });
  group('EmployeeService - updateEmployee', () {
    final tValidEmployee = Employee(
      id: 1,
      fullName: 'Jaydeep Gedia',
      jobTitle: 'Lead Dev',
      salary: 2000,
      countryId: 1,
    );

    test('should complete successfully when repository returns 1', () async {
      when(() => mockEmployeeRepo.update(any())).thenAnswer((_) async => 1);

      await expectLater(service.updateEmployee(tValidEmployee), completes);

      verify(() => mockEmployeeRepo.update(tValidEmployee)).called(1);
    });

    test('should propogate exception if repository throws exception', () async {
      when(() => mockEmployeeRepo.update(any())).thenThrow(Exception());

      expect(
        () => service.updateEmployee(tValidEmployee),
        throwsA(isA<Exception>()),
      );

      verify(() => mockEmployeeRepo.update(tValidEmployee)).called(1);
    });

    test(
      'should throw StateError when repository returns 0 (ID not found)',
      () async {
        when(() => mockEmployeeRepo.update(any())).thenAnswer((_) async => 0);

        expect(
          () => service.updateEmployee(tValidEmployee),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('No employee found with ID 1'),
            ),
          ),
        );
      },
    );

    group('Validations', () {
      test(
        'should throw "Employee ID is required for updates." if id is null',
        () async {
          final invalid = Employee(id: null);

          expect(
            () => service.updateEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Employee ID is required for updates.',
              ),
            ),
          );
          verifyNever(() => mockEmployeeRepo.update(any()));
        },
      );

      test(
        'should throw "Full name can not be empty." if fullName is blank after trim',
        () async {
          final invalid = Employee(id: 1, fullName: '   ');

          expect(
            () => service.updateEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Full name can not be empty.',
              ),
            ),
          );
        },
      );

      test(
        'should throw "JobTitle can not be empty." if jobTitle is blank',
        () async {
          final invalid = Employee(id: 1, jobTitle: ' ');

          expect(
            () => service.updateEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'JobTitle name can not be empty.',
              ),
            ),
          );
        },
      );

      test(
        'should throw "Salary must be greater than zero." if salary is 0 or less',
        () async {
          final invalid = Employee(id: 1, salary: -10);

          expect(
            () => service.updateEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'Salary must be greater than zero.',
              ),
            ),
          );
        },
      );

      test(
        'should throw "A valid country id is required." if countryId is invalid',
        () async {
          final invalid = Employee(id: 1, countryId: 0);

          expect(
            () => service.updateEmployee(invalid),
            throwsA(
              isA<ArgumentError>().having(
                (e) => e.message,
                'message',
                'A valid country id is required.',
              ),
            ),
          );
        },
      );
    });
  });
  group('EmployeeService - deleteEmployee', () {
    const tId = 5;
    test('should complete successfully when repository returns 1', () async {
      when(() => mockEmployeeRepo.deleteById(tId)).thenAnswer((_) async => 1);

      await expectLater(service.deleteEmployee(tId), completes);
      verify(() => mockEmployeeRepo.deleteById(tId)).called(1);
    });

    test(
      'should throw StateError when repository returns 0 (ID not found)',
      () async {
        when(
          () => mockEmployeeRepo.deleteById(any()),
        ).thenAnswer((_) async => 0);

        expect(
          () => service.deleteEmployee(tId),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('No employee found with ID $tId'),
            ),
          ),
        );
      },
    );
    test('should propagate exceptions when the repository fails', () async {
      when(
        () => mockEmployeeRepo.deleteById(any()),
      ).thenThrow(Exception('Database disk error'));

      expect(() => service.deleteEmployee(tId), throwsA(isA<Exception>()));
    });

    test(
      'should throw ArgumentError if provided ID is invalid (<= 0)',
      () async {
        expect(
          () => service.deleteEmployee(0),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'A valid Employee ID is required for deletion.',
            ),
          ),
        );
        verifyNever(() => mockEmployeeRepo.deleteById(any()));
      },
    );
  });

  group('EmployeeService - getCountries', () {
    final tCountries = [
      Country(id: 1, name: 'India', taxRate: 0.10),
      Country(id: 2, name: 'United States', taxRate: 0.12),
    ];

    test(
      'should return a list of countries when repository call is successful',
      () async {
        when(
          () => mockCountryRepo.getAll(),
        ).thenAnswer((_) async => tCountries);

        final result = await service.getCountries();

        expect(result, equals(tCountries));
        expect(result.length, 2);
        expect(result.first.name, 'India');
        verify(() => mockCountryRepo.getAll()).called(1);
      },
    );

    test(
      'should return an empty list when no countries exist in the database',
      () async {
        when(() => mockCountryRepo.getAll()).thenAnswer((_) async => []);

        final result = await service.getCountries();

        expect(result, isEmpty);
        verify(() => mockCountryRepo.getAll()).called(1);
      },
    );

    test(
      'should propagate exceptions when the country repository fails',
      () async {
        when(
          () => mockCountryRepo.getAll(),
        ).thenThrow(Exception('Database error while fetching countries'));

        expect(() => service.getCountries(), throwsA(isA<Exception>()));
      },
    );
  });
}
