import 'package:flutter_test/flutter_test.dart';
import 'package:fst/systems/math_system.dart';

void main() {
  test('generates valid addition problems', () {
    final mathSystem = MathSystem();

    for (var i = 0; i < 20; i++) {
      final problem = mathSystem.generateAddition();

      expect(problem.operation, '+');
      expect(problem.left, greaterThanOrEqualTo(1));
      expect(problem.left, lessThanOrEqualTo(10));
      expect(problem.right, greaterThanOrEqualTo(1));
      expect(problem.right, lessThanOrEqualTo(10));
      expect(
        problem.answer,
        problem.left + problem.right,
      );
    }
  });

  test('generates valid subtraction problems with positive integer answers', () {
    final mathSystem = MathSystem();

    for (var i = 0; i < 100; i++) {
      final problem = mathSystem.generateSubtraction();

      expect(problem.operation, '-');
      expect(problem.left, greaterThanOrEqualTo(1));
      expect(problem.left, lessThanOrEqualTo(10));
      expect(problem.right, greaterThanOrEqualTo(1));
      expect(problem.right, lessThanOrEqualTo(problem.left));
      expect(problem.answer, greaterThanOrEqualTo(0));
      expect(
        problem.answer,
        problem.left - problem.right,
      );
    }
  });

  test('generates valid multiplication problems', () {
    final mathSystem = MathSystem();

    for (var i = 0; i < 50; i++) {
      final problem = mathSystem.generateMultiplication();

      expect(problem.operation, 'x');
      expect(problem.left, greaterThanOrEqualTo(1));
      expect(problem.left, lessThanOrEqualTo(10));
      expect(problem.right, greaterThanOrEqualTo(1));
      expect(problem.right, lessThanOrEqualTo(10));
      expect(
        problem.answer,
        problem.left * problem.right,
      );
    }
  });

  test('generates valid square root problems with positive integer answers', () {
    final mathSystem = MathSystem();
    const perfectSquares = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100];

    for (var i = 0; i < 50; i++) {
      final problem = mathSystem.generateSquareRoot();

      expect(problem.operation, '√');
      expect(perfectSquares, contains(problem.right));
      expect(problem.answer, greaterThan(0));
      // Answer must be exact integer square root
      expect(problem.answer * problem.answer, problem.right);
      // Expression must be rendered as √N (no left operand)
      expect(problem.expression, '√${problem.right}');
    }
  });

  test('generateProblem produces all 4 operation types', () {
    final mathSystem = MathSystem();
    final operations = <String>{};

    for (var i = 0; i < 300; i++) {
      final problem = mathSystem.generateProblem();
      operations.add(problem.operation);
      expect(problem.answer, greaterThanOrEqualTo(0));
    }

    expect(operations, contains('+'));
    expect(operations, contains('-'));
    expect(operations, contains('x'));
    expect(operations, contains('√'));
  });
}