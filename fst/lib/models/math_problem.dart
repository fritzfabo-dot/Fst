class MathProblem {
  final int left;
  final int right;
  final String operation;
  final int answer;

  MathProblem({
    required this.left,
    required this.right,
    required this.operation,
    required this.answer,
  });

  String get expression => '$left $operation $right';
}