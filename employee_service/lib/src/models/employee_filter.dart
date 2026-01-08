enum QueryOperator { equals }

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

  void byCountryId(int id) {
    _conditions.add(
      QueryCondition(
        field: 'country_id',
        operator: QueryOperator.equals,
        value: id,
      ),
    );
  }

  bool get isEmpty => _conditions.isEmpty;
}
