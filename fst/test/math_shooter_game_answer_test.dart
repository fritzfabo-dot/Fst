import 'package:flutter_test/flutter_test.dart';
import 'package:fst/game/math_shooter_game.dart';
import 'package:fst/models/enemy.dart';
import 'package:fst/models/math_problem.dart';

void main() {
  test('game accepts an answer matching an enemy', () {
    final game = MathShooterGame();

    game.enemies.add(
      Enemy(
        x: 100,
        y: 100,
        speed: 1,
        size: 50,
        problem: MathProblem(
          left: 5,
          right: 6,
          operation: '+',
          answer: 11,
        ),
      ),
    );

    final result = game.validateAnswer('11');

    expect(result, isTrue);
    expect(game.lastAnswerCorrect, isTrue);
  });

  test('game rejects a wrong answer', () {
    final game = MathShooterGame();

    game.enemies.add(
      Enemy(
        x: 100,
        y: 100,
        speed: 1,
        size: 50,
        problem: MathProblem(
          left: 5,
          right: 6,
          operation: '+',
          answer: 11,
        ),
      ),
    );

    final result = game.validateAnswer('10');

    expect(result, isFalse);
    expect(game.lastAnswerCorrect, isFalse);
  });

  test('game rejects empty input', () {
    final game = MathShooterGame();

    game.enemies.add(
      Enemy(
        x: 100,
        y: 100,
        speed: 1,
        size: 50,
        problem: MathProblem(
          left: 5,
          right: 6,
          operation: '+',
          answer: 11,
        ),
      ),
    );

    final result = game.validateAnswer('');

    expect(result, isFalse);
    expect(game.lastAnswerCorrect, isFalse);
  });
}