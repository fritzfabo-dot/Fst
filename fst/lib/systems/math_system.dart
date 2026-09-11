import 'dart:math';

import '../models/math_problem.dart';

class MathSystem {
  final Random random = Random();

  MathProblem generateAddition() {
    final left = random.nextInt(10) + 1;
    final right = random.nextInt(10) + 1;

    return MathProblem(
      left: left,
      right: right,
      operation: '+',
      answer: left + right,
    );
  }

  MathProblem generateSubtraction() {
    final left = random.nextInt(10) + 1;
    // Ensure right <= left so that left - right >= 0 (positive integer / non-negative)
    final right = random.nextInt(left) + 1;

    return MathProblem(
      left: left,
      right: right,
      operation: '-',
      answer: left - right,
    );
  }

  MathProblem generateMultiplication() {
    final left = random.nextInt(10) + 1;
    final right = random.nextInt(10) + 1;

    return MathProblem(
      left: left,
      right: right,
      operation: 'x',
      answer: left * right,
    );
  }

  // Only perfect squares so the result is always a positive integer.
  static const List<int> _perfectSquares = [1, 4, 9, 16, 25, 36, 49, 64, 81, 100];

  MathProblem generateSquareRoot() {
    final value = _perfectSquares[random.nextInt(_perfectSquares.length)];
    final answer = sqrt(value).toInt();

    return MathProblem(
      left: 0,   // unused for √ — expression only shows √right
      right: value,
      operation: '√',
      answer: answer,
    );
  }

  MathProblem generateProblem() {
    final type = random.nextInt(4);
    switch (type) {
      case 0:
        return generateAddition();
      case 1:
        return generateSubtraction();
      case 2:
        return generateMultiplication();
      case 3:
      default:
        return generateSquareRoot();
    }
  }

  bool checkAnswer(
    MathProblem problem,
    String input,
  ) {
    final value = int.tryParse(input);

    if (value == null) {
      return false;
    }

    return value == problem.answer;
  }
}