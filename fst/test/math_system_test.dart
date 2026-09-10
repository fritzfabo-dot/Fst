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
}