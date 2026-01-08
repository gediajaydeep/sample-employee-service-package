import 'package:employee_service/src/models/country.dart';
import 'package:employee_service/src/models/employee.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Employee model should be initializable with correct values', () {
    final employee = Employee(
      id: 1,
      fullName: 'Jaydeep Gedia',
      jobTitle: 'Software Engineer',
      salary: 50000.0,
      countryId: 1,
      country: Country(id: 1, name: 'India', taxRate: 0.10),
    );

    expect(employee.id, 1);
    expect(employee.fullName, 'Jaydeep Gedia');
    expect(employee.jobTitle, 'Software Engineer');
    expect(employee.salary, 50000.0);
    expect(employee.countryId, 1);
    expect(employee.country?.id, 1);
    expect(employee.country?.name, 'India');
    expect(employee.country?.taxRate, 0.10);
  });
}
