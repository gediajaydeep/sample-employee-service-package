// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  id: (json['id'] as num?)?.toInt(),
  fullName: json['full_name'] as String?,
  jobTitle: json['job_title'] as String?,
  salary: (json['salary'] as num?)?.toDouble(),
  countryId: (json['country_id'] as num?)?.toInt(),
  country: json['country'] == null
      ? null
      : Country.fromJson(json['country'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'id': instance.id,
  'full_name': instance.fullName,
  'job_title': instance.jobTitle,
  'salary': instance.salary,
  'country_id': instance.countryId,
  'country': instance.country?.toJson(),
};
