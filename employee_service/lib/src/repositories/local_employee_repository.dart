import 'package:employee_service/src/database/database_helper.dart';
import 'package:employee_service/src/database/database_schemas.dart';
import 'package:employee_service/src/models/employee.dart';
import 'package:employee_service/src/models/employee_filter.dart';
import 'package:employee_service/src/models/salary_metrics.dart';
import 'package:employee_service/src/repositories/employee_repository.dart';

class LocalEmployeeRepository implements EmployeeRepository {
  final DatabaseHelper _db;
  LocalEmployeeRepository(this._db);

  @override
  Future<int> create(Employee employee) async {
    const sql =
        '''
      INSERT INTO ${DatabaseSchemas.employeesTable} 
      (full_name, job_title, salary, country_id) VALUES (?, ?, ?, ?)
    ''';
    return await _db.insert(sql, [
      employee.fullName,
      employee.jobTitle,
      employee.salary,
      employee.countryId,
    ]);
  }

  @override
  Future<int> deleteById(int id) async {
    const sql = 'DELETE FROM ${DatabaseSchemas.employeesTable} WHERE id = ?';
    return await _db.delete(sql, [id]);
  }

  @override
  Future<Employee?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<Employee>> getEmployees(EmployeeFilter filter) {
    // TODO: implement getEmployees
    throw UnimplementedError();
  }

  @override
  Future<SalaryMetrics> getMetrics(EmployeeFilter filter) {
    // TODO: implement getMetrics
    throw UnimplementedError();
  }

  @override
  Future<int> update(Employee employee) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
