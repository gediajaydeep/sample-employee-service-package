import 'package:collection/collection.dart';
import 'package:employee_service/src/models/country.dart';
import 'package:employee_service/src/models/employee.dart';
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

  test('Employee model should convert fromJson or toJson correctly', () {
    final json =
        {
              'id': 1,
              'full_name': 'Jaydeep Gedia',
              'job_title': 'Software Engineer',
              'salary': 50000.0,
              'country_id': 1,
              'country': {'id': 1, 'name': 'India', 'tax_rate': 0.10},
            }
            as Map<String, dynamic>;

    final employee = Employee.fromJson(json);

    expect(employee.id, json['id']);
    expect(employee.fullName, json['full_name']);
    expect(employee.jobTitle, json['job_title']);
    expect(employee.salary, json['salary']);
    expect(employee.countryId, json['country_id']);

    expect(employee.country?.id, json['country']['id']);
    expect(employee.country?.name, json['country']['name']);
    expect(employee.country?.taxRate, json['country']['tax_rate']);

    expect(DeepCollectionEquality().equals(employee.toJson(), json), isTrue);
  });
}
