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
}
