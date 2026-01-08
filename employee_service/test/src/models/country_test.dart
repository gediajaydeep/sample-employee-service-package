import 'package:employee_service/src/models/country.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
    test('Country model should be initializable with name and tax rate', () {
    final country = Country(name: 'India', taxRate: 0.10);
    
    expect(country.name, 'India');
    expect(country.taxRate, 0.10);
  });

  test('Country model should convert to/from JSON correctly',
  (){
    final json = {
      'name' : 'India',
      'tax_rate' : 0.10
    };
    final country = Country.fromJson(json);
    expect(country.name, equals(json['name']));
    expect(country.taxRate, equals(json['tax_rate']));

    expect(mapEquals(country.toJson(), json), isTrue) ;


  });
}