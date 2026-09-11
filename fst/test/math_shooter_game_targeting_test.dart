import 'package:flutter_test/flutter_test.dart';
import 'package:fst/game/math_shooter_game.dart';
import 'package:fst/models/enemy.dart';
import 'package:fst/models/math_problem.dart';

void main() {
  test('shoot targets the matching enemy closest to bottom', () {
    final game = MathShooterGame();
    game.startGame();

    final higherEnemy = Enemy(
      x: 100,
      y: 50,
      speed: 1,
      size: 50,
      problem: MathProblem(
        left: 3,
        right: 4,
        operation: '+',
        answer: 7,
      ),
    );

    final lowerEnemy = Enemy(
      x: 200,
      y: 150,
      speed: 1,
      size: 50,
      problem: MathProblem(
        left: 2,
        right: 5,
        operation: '+',
        answer: 7,
      ),
    );

    game.enemies.addAll([higherEnemy, lowerEnemy]);

    final shot = game.shoot('7');

    expect(shot, isTrue);
    expect(game.bullets.length, equals(1));
    expect(game.bullets.first.target, equals(lowerEnemy));
  });

  test('bullet does not retarget to wrong enemy when original target dies', () {
    final game = MathShooterGame();
    game.startGame();

    final targetEnemy = Enemy(
      x: 100,
      y: 100,
      speed: 1,
      size: 50,
      problem: MathProblem(
        left: 4,
        right: 4,
        operation: '+',
        answer: 8,
      ),
    );

    final wrongEnemy = Enemy(
      x: 200,
      y: 120,
      speed: 1,
      size: 50,
      problem: MathProblem(
        left: 1,
        right: 1,
        operation: '+',
        answer: 2,
      ),
    );

    game.enemies.addAll([targetEnemy, wrongEnemy]);
    game.shoot('8');

    final bullet = game.bullets.first;
    expect(bullet.target, equals(targetEnemy));

    // Supprimer la cible d'origine (ex: tuée)
    game.enemies.remove(targetEnemy);

    // Exécuter une mise à jour de la boucle de jeu
    game.update(dt: 0.016, width: 400, height: 600);

    // La balle ne doit PAS avoir réorienté sa cible vers wrongEnemy !
    expect(bullet.target, equals(targetEnemy));
    expect(game.enemies.contains(bullet.target), isFalse);
  });

  test('lives decrement when enemy reaches bottom', () {
    final game = MathShooterGame();
    game.startGame();

    final escapingEnemy = Enemy(
      x: 200,
      y: 535, // Dépasse spaceship.y - 20 (550 - 20 = 530)
      speed: 1,
      size: 50,
      problem: MathProblem(
        left: 1,
        right: 2,
        operation: '+',
        answer: 3,
      ),
    );

    game.enemies.add(escapingEnemy);

    // Avancer d'un tick où l'ennemi dépasse spaceship.y - 20
    game.update(dt: 0.1, width: 400, height: 600);

    expect(game.lives, equals(2));
  });
}
