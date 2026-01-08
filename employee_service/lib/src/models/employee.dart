// TODO Implement this library.
import 'package:employee_service/src/models/country.dart';

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
}
