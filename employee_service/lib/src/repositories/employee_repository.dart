import '../models/index.dart';

abstract class EmployeeRepository {
  Future<int> create(Employee employee);
  Future<Employee?> getById(int id);
  Future<int> update(Employee employee);
  Future<int> deleteById(int id);

  Future<List<Employee>> getEmployees(EmployeeFilter filter);

  Future<SalaryMetrics> getMetrics(EmployeeFilter filter);
}
