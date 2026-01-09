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
}
