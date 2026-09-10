import 'package:flutter_test/flutter_test.dart';
import 'package:fst/models/math_problem.dart';

void main() {
  test('MathProblem creates a correct expression', () {
    final problem = MathProblem(
      left: 3,
      right: 4,
      operation: '+',
      answer: 7,
    );

    expect(problem.expression, '3 + 4');
    expect(problem.answer, 7);
  });
}