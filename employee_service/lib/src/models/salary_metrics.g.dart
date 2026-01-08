// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salary_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalaryMetrics _$SalaryMetricsFromJson(Map<String, dynamic> json) =>
    SalaryMetrics(
      averageSalary: (json['average_salary'] as num).toDouble(),
      minSalary: (json['min_salary'] as num).toDouble(),
      maxSalary: (json['max_salary'] as num).toDouble(),
      totalEmployees: (json['total_employees'] as num).toInt(),
    );
