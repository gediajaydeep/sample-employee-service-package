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
    final affectedRows = await _employeeRepo.update(employee);

    if (affectedRows == 0) {
      throw StateError(
        'Update failed: No employee found with ID ${employee.id}.',
      );
    }
  }
}
