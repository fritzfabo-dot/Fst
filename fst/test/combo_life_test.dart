import 'package:flutter_test/flutter_test.dart';
import 'package:fst/game/math_shooter_game.dart';
import 'package:fst/models/enemy.dart';
import 'package:fst/models/math_problem.dart';

void main() {
  test('player starts with 3 lives and gains +1 life on each combo hit (comboCount >= 2)', () {
    final game = MathShooterGame();
    game.startGame();

    expect(game.lives, equals(3));
    expect(game.maxLives, equals(3));
    expect(game.comboCount, equals(0));

    // First enemy
    final enemy1 = Enemy(
      x: 200,
      y: 200,
      speed: 0,
      size: 50,
      problem: MathProblem(left: 2, right: 2, operation: '+', answer: 4),
    );
    game.enemies.add(enemy1);

    // Shoot enemy 1
    game.shoot('4');
    // Bullet hits enemy 1
    bulletHitsEnemy(game, enemy1);

    expect(game.comboCount, equals(1));
    expect(game.lives, equals(3)); // Hit 1: normal hit, lives stay at 3

    // Second enemy (Combo hit!)
    final enemy2 = Enemy(
      x: 200,
      y: 200,
      speed: 0,
      size: 50,
      problem: MathProblem(left: 3, right: 3, operation: '+', answer: 6),
    );
    game.enemies.add(enemy2);

    // Shoot enemy 2
    game.shoot('6');
    // Bullet hits enemy 2
    bulletHitsEnemy(game, enemy2);

    expect(game.comboCount, equals(2));
    expect(game.lives, equals(4)); // Hit 2: Combo! Life increased to 4
    expect(game.maxLives, equals(4));

    // Third enemy (Combo hit!)
    final enemy3 = Enemy(
      x: 200,
      y: 200,
      speed: 0,
      size: 50,
      problem: MathProblem(left: 5, right: 5, operation: '+', answer: 10),
    );
    game.enemies.add(enemy3);

    // Shoot enemy 3
    game.shoot('10');
    // Bullet hits enemy 3
    bulletHitsEnemy(game, enemy3);

    expect(game.comboCount, equals(3));
    expect(game.lives, equals(5)); // Hit 3: Combo! Life increased to 5
    expect(game.maxLives, equals(5));
  });

  test('incorrect answer resets combo to 0', () {
    final game = MathShooterGame();
    game.startGame();

    final enemy = Enemy(
      x: 200,
      y: 200,
      speed: 0,
      size: 50,
      problem: MathProblem(left: 2, right: 2, operation: '+', answer: 4),
    );
    game.enemies.add(enemy);

    game.shoot('4');
    bulletHitsEnemy(game, enemy);
    expect(game.comboCount, equals(1));

    // Wrong answer
    game.shoot('99');
    expect(game.comboCount, equals(0));
  });
}

void bulletHitsEnemy(MathShooterGame game, Enemy enemy) {
  // Move bullet directly onto enemy to trigger collision
  if (game.bullets.isNotEmpty) {
    game.bullets.first.x = enemy.x;
    game.bullets.first.y = enemy.y;
    game.update(dt: 0.016, width: 400, height: 600);
  }
}
