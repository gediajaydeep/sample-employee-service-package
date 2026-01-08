import 'package:flutter_test/flutter_test.dart';

void main() {
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
}
