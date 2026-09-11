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