/* {"operation":"simplify","expression":"8","result":"8"} */
class Calculation {
  final String operation;
  final String expression;
  final String result;

  const Calculation({
    required this.operation,
    required this.expression,
    required this.result,
  });

  factory Calculation.fromJson(Map<String, dynamic> json) {
    return Calculation(
      operation: json['operation'],
      expression: json['expression'],
      result: json['result'],
    );
  }
}
