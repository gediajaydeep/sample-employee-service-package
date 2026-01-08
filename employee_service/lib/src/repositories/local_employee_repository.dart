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
  Future<Employee?> getById(int id) async {
    final sql = '$_baseJoinQuery WHERE e.id = ?';
    final results = await _db.query(sql, [id]);
    if (results.isEmpty) return null;
    return _mapRowToEmployee(results.first);
  }

  String get _baseJoinQuery =>
      '''
    SELECT e.*, c.name as country_name, c.tax_rate 
    FROM ${DatabaseSchemas.employeesTable} e
    INNER JOIN ${DatabaseSchemas.countriesTable} c ON e.country_id = c.id
  ''';

  Employee _mapRowToEmployee(Map<String, dynamic> row) {
    final map = Map<String, dynamic>.from(row);
    map['country'] = {
      'id': row['country_id'],
      'name': row['country_name'],
      'tax_rate': row['tax_rate'],
    };
    return Employee.fromJson(map);
  }

  @override
  Future<List<Employee>> getEmployees(EmployeeFilter filter) async {
    final queryData = _buildFilterQuery(filter);
    final sql = '$_baseJoinQuery${queryData.whereClause}';

    final results = await _db.query(sql, queryData.args);
    return results.map((row) => _mapRowToEmployee(row)).toList();
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

  _QueryParts _buildFilterQuery(EmployeeFilter filter) {
    if (filter.isEmpty) return _QueryParts('', []);

    final conditions = <String>[];
    final args = <dynamic>[];

    for (final condition in filter.conditions) {
      if (condition.operator == QueryOperator.equals) {
        conditions.add('e.${condition.field} = ?');
        args.add(condition.value);
      }
    }

    return _QueryParts(' WHERE ${conditions.join(' AND ')}', args);
  }
}

class _QueryParts {
  final String whereClause;
  final List<dynamic> args;
  _QueryParts(this.whereClause, this.args);
}
