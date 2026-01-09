# Employee Service Package

A robust, test-driven Dart package for managing employees, countries, and payroll logic. This package features built-in SQLite persistence and automated Tax Deducted at Source (TDS) calculations.

## 🏗 Architecture & Implementation

This project is built using a layered **Clean Architecture** approach to ensure that business logic remains independent of the database and UI.

### Dependency Tree & Implementers

* **Service Layer (`EmployeeService`)**: The primary entry point for the application. It acts as a gatekeeper, performing strict business validation before data ever touches the repository.
* **Repository Layer**: Handles the abstraction between the domain logic and the persistence layer.
* `LocalEmployeeRepository`: Manages SQL operations for employee data.
* `LocalCountryRepository`: Manages SQL operations for country and tax data.


* **Data Layer (`sqflite`)**: Handles raw SQL execution. The `DatabaseHelper` manages connection lifecycles and triggers automated seeding for the top 25 countries upon first launch.

---

## 📦 Core Models (Data Fields)

### **Employee**

* `id`: Unique integer (Primary Key).
* `fullName`: String (Required).
* `jobTitle`: String (Required).
* `salary`: Double (Gross amount).
* `countryId`: Integer (Foreign Key link to Country).
* *Computed Logic*: `netSalary` (Gross - Tax) and `taxAmount` are calculated automatically based on the linked country's tax rate.

### **Country**

* `id`: Unique integer.
* `name`: String (e.g., "India", "United States").
* `taxRate`: Double (Percentage represented as decimal, e.g., `0.10` for 10%).

### **SalaryMetrics**

* `averageSalary`: The mean gross salary across the selection.
* `minSalary` / `maxSalary`: The lowest and highest salaries found.
* `totalEmployees`: Count of employees within the filtered criteria.

---

## 🛠 Service Methods

### **Employee Operations**

* **`getEmployees(filter)`**: Retrieves a list of employees. Supports filtering by name, job title, or country.
* **`getEmployeeById(id)`**: Fetches a single employee record. Returns `null` if not found.
* **`createEmployee(employee)`**: Validates all required fields and saves the record. Returns the new ID.
* **`updateEmployee(employee)`**: Performs a **Dynamic Update**. It only modifies fields that are provided (not null/empty), preserving existing data for all other fields.
* **`deleteEmployee(id)`**: Removes a record. Throws `StateError` if the ID is invalid or missing.

### **Country & Payroll Operations**

* **`getCountries()`**: Returns all supported countries (Default includes top 25 global economies).
* **`createCountry(country)`**: Adds a new region and its tax rate to the system.
* **`getEmployeeNetSalaryById(id)`**: A specialized endpoint that returns only the final "Take-Home" pay as a `double`.
* **`getSalaryStats({filter})`**: Provides aggregate analytics (Average, Min, Max) for the dashboard.

---

## 🚀 Getting Started

### Creating an Instance

The package uses a **Factory Pattern**. Simply calling the default constructor will automatically wire up the SQLite database and seed the default tax data.

```dart

// Automatically seeds India (10% tax) and USA (12% tax)
final service = EmployeeService();

```

---

## 🤖 AI Collaboration Disclosure

This project was developed through a high-fidelity collaboration between the lead developer and **Gemini (AI)**.

* **Developer's Role**:
* Designed and decided the full project architecture and dependency flow.
* Defined all core business logic (e.g., specific TDS rates for India/USA, partial update logic).
* Directly managed the project structure and integration.


* **AI's Role (Gemini)**:
* **SQL Precision**: Used to write precise, optimized SQL queries for filtering and aggregate metrics.
* **Boilerplate Generation**: Accelerated development by generating model classes and repository boilerplate.
* **Test-Driven Development**: Assisted in generating comprehensive unit test suites based on defined business requirements to ensure zero human error in calculations.



> **P.S.** This README was also also written by AI :P 🤖✨

