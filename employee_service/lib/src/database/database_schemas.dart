class DatabaseSchemas {
  static const String countriesTable = 'countries';
  static const String employeesTable = 'employees';

  static const String createCountriesTable =
      '''
    CREATE TABLE $countriesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE,
      tax_rate REAL NOT NULL
    )
  ''';

  static const String createEmployeesTable =
      '''
    CREATE TABLE $employeesTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT NOT NULL,
      job_title TEXT NOT NULL,
      salary REAL NOT NULL,
      country_id INTEGER NOT NULL,
      FOREIGN KEY (country_id) REFERENCES $countriesTable (id)
    )
  ''';
}
