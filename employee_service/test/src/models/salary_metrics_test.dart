import 'package:employee_service/src/models/salary_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final mockDbResult = {
    'average_salary': 55000.50,
    'min_salary': 30000.0,
    'max_salary': 95000.0,
    'total_employees': 12,
  };
  test('Should create SalaryMetrics instance via constructor', () {
    final metrics = SalaryMetrics(
      averageSalary: 55000.50,
      minSalary: 30000.0,
      maxSalary: 90000.0,
      totalEmployees: 15,
    );
    expect(metrics.averageSalary, 55000.50);
    expect(metrics.minSalary, 30000.0);
    expect(metrics.maxSalary, 90000.0);
    expect(metrics.totalEmployees, 15);
  });

  test(
    'fromJson should populate every field correctly from snake_case input',
    () {
      final metrics = SalaryMetrics.fromJson(mockDbResult);

      expect(metrics.averageSalary, 55000.50);
      expect(metrics.minSalary, 30000.0);
      expect(metrics.maxSalary, 95000.0);
      expect(metrics.totalEmployees, 12);
    },
  );
}
