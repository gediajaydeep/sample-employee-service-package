import '../models/employee.dart';
import '../models/salary_metrics.dart';
import '../models/employee_filter.dart';

abstract class EmployeeRepository {
  Future<int> create(Employee employee);
  Future<Employee?> getById(int id);
  Future<int> update(Employee employee);
  Future<int> delete(int id);

  Future<List<Employee>> getEmployees(EmployeeFilter filter);

  Future<SalaryMetrics> getMetrics(EmployeeFilter filter);
}
