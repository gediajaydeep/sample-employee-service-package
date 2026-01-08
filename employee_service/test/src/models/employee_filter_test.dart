import 'package:employee_service/src/models/employee_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Initial state should be empty', () {
    final filter = EmployeeFilter();
    expect(filter.isEmpty, isTrue);
  });

  test('byCountryId() should add a correct QueryCondition', () {
      final filter = EmployeeFilter();
      const countryId = 5;

      filter.byCountryId(countryId);

      expect(filter.isEmpty, isFalse);
      expect(filter.conditions.length, 1);
      
      final condition = filter.conditions.first;
      expect(condition.field, 'country_id');
      expect(condition.operator, QueryOperator.equals);
      expect(condition.value, countryId);
    });
}
