import '../database/index.dart';
import '../models/index.dart';
import '../repositories/index.dart';

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
  Future<SalaryMetrics> getMetrics(EmployeeFilter filter) async {
    final queryData = _buildFilterQuery(filter);

    final sql =
        '''
      SELECT 
        AVG(salary) as average_salary, 
        MIN(salary) as min_salary, 
        MAX(salary) as max_salary, 
        COUNT(*) as total_employees 
      FROM ${DatabaseSchemas.employeesTable} e
      ${queryData.whereClause}
    ''';

    final results = await _db.query(sql, queryData.args);
    return SalaryMetrics.fromJson(results.first);
  }

  @override
  Future<int> update(Employee employee) async {
    final List<String> setClauses = [];
    final List<dynamic> args = [];

    if (employee.fullName != null && employee.fullName!.trim().isNotEmpty) {
      setClauses.add('full_name = ?');
      args.add(employee.fullName);
    }

    if (employee.jobTitle != null && employee.jobTitle!.trim().isNotEmpty) {
      setClauses.add('job_title = ?');
      args.add(employee.jobTitle);
    }

    if (employee.salary != null && employee.salary! > 0) {
      setClauses.add('salary = ?');
      args.add(employee.salary);
    }

    if (employee.countryId != null && employee.countryId! > 0) {
      setClauses.add('country_id = ?');
      args.add(employee.countryId);
    }

    if (setClauses.isEmpty) return 0;

    args.add(employee.id);

    final String sql =
        '''
    UPDATE ${DatabaseSchemas.employeesTable} 
    SET ${setClauses.join(', ')} 
    WHERE id = ?
  ''';

    return await _db.update(sql, args);
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
