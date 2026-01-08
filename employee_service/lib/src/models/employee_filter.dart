
enum QueryOperator {
  equals,
}

class QueryCondition {
  final String field;
  final QueryOperator operator;
  final dynamic value;

  QueryCondition({
    required this.field,
    required this.operator,
    required this.value,
  });
}

class EmployeeFilter {
  final List<QueryCondition> _conditions = [];

  List<QueryCondition> get conditions => List.unmodifiable(_conditions);

  bool get isEmpty => _conditions.isEmpty;
}