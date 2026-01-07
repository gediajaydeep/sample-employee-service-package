import 'package:flutter_test/flutter_test.dart';

import 'package:employee_service/employee_service.dart';

void main() {
test('Country model should be initializable with name and tax rate', () {
    final country = Country(name: 'India', taxRate: 0.10);
    
    expect(country.name, 'India');
    expect(country.taxRate, 0.10);
  });
}
