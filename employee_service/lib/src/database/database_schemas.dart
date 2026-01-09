class DatabaseSchemas {
  static const String countriesTable = 'countries';
  static const String employeesTable = 'employees';
  static const String dbPath = 'employee_management.db';

  static const List<Map<String, dynamic>> _defaultCountries = [
    {'name': 'India', 'tax_rate': 0.10},
    {'name': 'United States', 'tax_rate': 0.12},
    {'name': 'China', 'tax_rate': 0.0},
    {'name': 'Japan', 'tax_rate': 0.0},
    {'name': 'Germany', 'tax_rate': 0.0},
    {'name': 'United Kingdom', 'tax_rate': 0.0},
    {'name': 'France', 'tax_rate': 0.0},
    {'name': 'Brazil', 'tax_rate': 0.0},
    {'name': 'Italy', 'tax_rate': 0.0},
    {'name': 'Canada', 'tax_rate': 0.0},
    {'name': 'Russia', 'tax_rate': 0.0},
    {'name': 'South Korea', 'tax_rate': 0.0},
    {'name': 'Australia', 'tax_rate': 0.0},
    {'name': 'Spain', 'tax_rate': 0.0},
    {'name': 'Mexico', 'tax_rate': 0.0},
    {'name': 'Indonesia', 'tax_rate': 0.0},
    {'name': 'Netherlands', 'tax_rate': 0.0},
    {'name': 'Saudi Arabia', 'tax_rate': 0.0},
    {'name': 'Turkey', 'tax_rate': 0.0},
    {'name': 'Switzerland', 'tax_rate': 0.0},
    {'name': 'Poland', 'tax_rate': 0.0},
    {'name': 'Sweden', 'tax_rate': 0.0},
    {'name': 'Norway', 'tax_rate': 0.0},
    {'name': 'Belgium', 'tax_rate': 0.0},
    {'name': 'United Arab Emirates', 'tax_rate': 0.0},
  ];

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

  static List<String> get seedCountriesQueries {
    return _defaultCountries.map((country) {
      return "INSERT INTO $countriesTable (name, tax_rate) VALUES ('${country['name']}', ${country['tax_rate']});";
    }).toList();
  }
}
