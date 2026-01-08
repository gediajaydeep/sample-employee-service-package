import 'package:employee_service/src/database/database_helper.dart';
import 'package:employee_service/src/models/employee.dart';
import 'package:employee_service/src/repositories/local_employee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late LocalEmployeeRepository repository;
  late MockDatabaseHelper mockDb;

  setUpAll(() {
    mockDb = MockDatabaseHelper();
    repository = LocalEmployeeRepository(mockDb);
  });
  final tEmployee = Employee(
    fullName: 'Jaydeep Gedia',
    jobTitle: 'Software Engineer',
    salary: 75000.0,
    countryId: 1,
  );

  test(
    'create : should call db.insert with correct SQL and arguments and return id when success',
    () async {
      when(() => mockDb.insert(any(), any())).thenAnswer((_) async => 1);

      final result = await repository.create(tEmployee);

      expect(result, 1);

      verify(
        () => mockDb.insert(any(that: contains('INSERT INTO employees')), [
          tEmployee.fullName,
          tEmployee.jobTitle,
          tEmployee.salary,
          tEmployee.countryId,
        ]),
      ).called(1);
    },
  );

  test(
    'create : should throw an exception when database insert fails',
    () async {
      when(
        () => mockDb.insert(any(), any()),
      ).thenThrow(Exception('Database Write Error'));

      expect(() => repository.create(tEmployee), throwsException);
    },
  );

  test(
    'deleteById : should call db.delete with correct SQL and ID and return count of deleted employee',
    () async {
      const idToDelete = 42;
      when(() => mockDb.delete(any(), any())).thenAnswer((_) async => 1);

      final result = await repository.deleteById(idToDelete);

      expect(result, 1);
      verify(
        () => mockDb.delete(any(that: contains('DELETE FROM employees')), [
          idToDelete,
        ]),
      ).called(1);
    },
  );

  test(
    'deleteById : should throw an exception if deletion fails due to DB error',
    () async {
      when(
        () => mockDb.delete(any(), any()),
      ).thenThrow(Exception('Database Error: Disk I/O failure'));

      expect(() => repository.deleteById(1), throwsException);
    },
  );
}
