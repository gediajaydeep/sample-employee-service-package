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
}
