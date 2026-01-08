import 'package:json_annotation/json_annotation.dart';

part 'salary_metrics.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class SalaryMetrics {
  final double averageSalary;
  final double minSalary;
  final double maxSalary;
  final int totalEmployees;

  SalaryMetrics({
    required this.averageSalary,
    required this.minSalary,
    required this.maxSalary,
    required this.totalEmployees,
  });

  factory SalaryMetrics.fromJson(Map<String, dynamic> json) =>
      _$SalaryMetricsFromJson(json);
}
