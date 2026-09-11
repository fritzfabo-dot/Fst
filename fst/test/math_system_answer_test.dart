import 'package:flutter_test/flutter_test.dart';
import 'package:fst/models/math_problem.dart';
import 'package:fst/systems/math_system.dart';

void main() {
  test('accepts a correct answer', () {
    final mathSystem = MathSystem();

    final problem = MathProblem(
      left: 5,
      right: 6,
      operation: '+',
      answer: 11,
    );

    expect(
      mathSystem.checkAnswer(problem, '11'),
      isTrue,
    );
  });

  test('rejects an incorrect answer', () {
    final mathSystem = MathSystem();

    final problem = MathProblem(
      left: 5,
      right: 6,
      operation: '+',
      answer: 11,
    );

    expect(
      mathSystem.checkAnswer(problem, '10'),
      isFalse,
    );
  });

  test('rejects invalid input', () {
    final mathSystem = MathSystem();

    final problem = MathProblem(
      left: 5,
      right: 6,
      operation: '+',
      answer: 11,
    );

    expect(
      mathSystem.checkAnswer(problem, 'abc'),
      isFalse,
    );
  });

  test('rejects empty input', () {
    final mathSystem = MathSystem();

    final problem = MathProblem(
      left: 5,
      right: 6,
      operation: '+',
      answer: 11,
    );

    expect(
      mathSystem.checkAnswer(problem, ''),
      isFalse,
    );
  });
}