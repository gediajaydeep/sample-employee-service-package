import 'package:employee_service/src/models/country.dart';
import 'package:employee_service/src/models/salary_metrics.dart';

import '../repositories/employee_repository.dart';
import '../repositories/country_repository.dart';
import '../models/employee.dart';
import '../models/employee_filter.dart';

abstract class EmployeeService {
  factory EmployeeService({
    required EmployeeRepository employeeRepo,
    required CountryRepository countryRepo,
  }) {
    return _EmployeeServiceImpl(employeeRepo, countryRepo);
  }
  Future<List<Employee>> getEmployees(EmployeeFilter filter);
  Future<Employee?> getEmployeeById(int id);
  Future<int> createEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
  Future<void> deleteEmployee(int id);

  Future<List<Country>> getCountries();
  Future<int> createCountry(Country country);
  Future<double> getEmployeeNetSalaryById(int id);
  Future<SalaryMetrics> getSalaryStats({EmployeeFilter? filter});
}

class _EmployeeServiceImpl implements EmployeeService {
  final EmployeeRepository _employeeRepo;
  final CountryRepository _countryRepo;

  _EmployeeServiceImpl(this._employeeRepo, this._countryRepo);

  @override
  Future<List<Employee>> getEmployees(EmployeeFilter filter) =>
      _employeeRepo.getEmployees(filter);

  @override
  Future<Employee?> getEmployeeById(int id) => _employeeRepo.getById(id);

  @override
  Future<int> createEmployee(Employee employee) {
    _validateEmployee(employee);
    return _employeeRepo.create(employee);
  }

  void _validateEmployee(Employee employee) {
    if (employee.fullName?.trim().isEmpty ?? true) {
      throw ArgumentError('Full name is required.');
    }
    if (employee.jobTitle?.trim().isEmpty ?? true) {
      throw ArgumentError('Job title is required.');
    }
    if (employee.salary == null) {
      throw ArgumentError('Salary is required.');
    }
    if (employee.salary! <= 0) {
      throw ArgumentError('Salary must be greater than zero.');
    }
    if (employee.countryId == null || employee.countryId! <= 0) {
      throw ArgumentError('A valid country id is required.');
    }
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    _validateEmployeeUpdate(employee);
    final affectedRows = await _employeeRepo.update(employee);
    if (affectedRows == 0) {
      throw StateError(
        'Update failed: No employee found with ID ${employee.id}.',
      );
    }
  }

  void _validateEmployeeUpdate(Employee employee) {
    if (employee.id == null || employee.id! <= 0) {
      throw ArgumentError('Employee ID is required for updates.');
    }
    if (employee.fullName != null && employee.fullName!.trim().isEmpty) {
      throw ArgumentError('Full name can not be empty.');
    }
    if (employee.jobTitle != null && employee.jobTitle!.trim().isEmpty) {
      throw ArgumentError('JobTitle name can not be empty.');
    }
    if (employee.salary != null && employee.salary! <= 0) {
      throw ArgumentError('Salary must be greater than zero.');
    }
    if (employee.countryId != null && employee.countryId! <= 0) {
      throw ArgumentError('A valid country id is required.');
    }
  }

  @override
  Future<void> deleteEmployee(int id) async {
    if (id <= 0) {
      throw ArgumentError('A valid Employee ID is required for deletion.');
    }
    final affectedRows = await _employeeRepo.deleteById(id);

    if (affectedRows == 0) {
      throw StateError('Delete failed: No employee found with ID $id.');
    }
  }

  @override
  Future<List<Country>> getCountries() => _countryRepo.getAll();

  @override
  Future<int> createCountry(Country country) {
    if (country.name?.trim().isEmpty ?? true) {
      throw ArgumentError('Country name is required.');
    }
    if (country.taxRate == null) {
      throw ArgumentError('Tax Rate is required.');
    }
    if (country.taxRate! < 0 || country.taxRate! > 1.0) {
      throw ArgumentError(
        'Tax rate must be between 0.0 and 1.0 (e.g., 0.15 for 15%).',
      );
    }

    return _countryRepo.create(country);
  }

  @override
  Future<double> getEmployeeNetSalaryById(int id) async {
    if (id <= 0) {
      throw ArgumentError('A valid Employee ID is required.');
    }

    final employee = await _employeeRepo.getById(id);

    if (employee == null) {
      throw StateError('Employee not found with ID $id.');
    }

    return employee.netSalary;
  }

  @override
  Future<SalaryMetrics> getSalaryStats({EmployeeFilter? filter}) {
    return _employeeRepo.getMetrics(filter ?? EmployeeFilter());
  }
}
