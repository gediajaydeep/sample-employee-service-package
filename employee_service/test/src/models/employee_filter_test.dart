import 'package:employee_service/src/models/employee_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Initial state should be empty', () {
    final filter = EmployeeFilter();
    expect(filter.isEmpty, isTrue);
  });
}
