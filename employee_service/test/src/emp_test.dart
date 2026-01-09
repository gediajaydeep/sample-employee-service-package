import 'package:employee_service/employee_service.dart';
import 'package:employee_service/src/services/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  EmployeeService service = EmployeeService();

  test('test', () async {
    service.createCountry(Country(name: 'Vietname', taxRate: 0));
    print(
      (await service.getCountries()).map((e) {
        return e.toJson()['id'];
      }),
    );
  });
}
