import 'package:employee_service/src/models/country.dart';
import 'package:json_annotation/json_annotation.dart';
part 'employee.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Employee {
  final int? id;
  final String? fullName;
  final String? jobTitle;
  final double? salary;

  final int? countryId;
  final Country? country;

  Employee({
    this.id,
    this.fullName,
    this.jobTitle,
    this.salary,
    this.countryId,
    this.country,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  double get netSalary => (salary ?? 0) * (1 - (country?.taxRate ?? 0));

  double get taxAmount => (salary ?? 0) * (country?.taxRate ?? 0);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
