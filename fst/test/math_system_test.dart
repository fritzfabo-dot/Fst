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

  test('generateProblem produces both addition and subtraction problems', () {
    final mathSystem = MathSystem();
    final operations = <String>{};

    for (var i = 0; i < 100; i++) {
      final problem = mathSystem.generateProblem();
      operations.add(problem.operation);
      expect(problem.answer, greaterThanOrEqualTo(0));
    }

    expect(operations, contains('+'));
    expect(operations, contains('-'));
  });
}