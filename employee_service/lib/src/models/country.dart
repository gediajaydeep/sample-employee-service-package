import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart'; 

@JsonSerializable(fieldRename: FieldRename.snake)
class Country {
  final int? id;
  final String name;
  final double taxRate;

  Country({
    this.id,
    required this.name,
    required this.taxRate,
  });

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}