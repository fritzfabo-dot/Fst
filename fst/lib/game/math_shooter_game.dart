import 'dart:math';

import '../models/bullet.dart';
import '../models/enemy.dart';
import '../models/spaceship.dart';
import '../systems/math_system.dart';

class MathShooterGame {
  final Random random = Random();
  final MathSystem mathSystem = MathSystem();

  final List<Enemy> enemies = [];
  final List<Bullet> bullets = [];

  final Spaceship spaceship = Spaceship(
    x: 0,
    y: 0,
  );

  int score = 0;

  double enemySpawnTimer = 0;

  bool? lastAnswerCorrect;

  double get spaceshipX => spaceship.x;

  double get spaceshipY => spaceship.y;

  void update({
    required double width,
    required double height,
  }) {
    // Fixed spaceship position.
    spaceship.x = width / 2;
    spaceship.y = height - 380;

    // Spawn enemies.
    enemySpawnTimer += 16;

    if (enemySpawnTimer >= 900) {
      enemySpawnTimer = 0;
      spawnEnemy(width, height);
    }

    // Move enemies toward spaceship.
    for (final enemy in enemies) {
      final dx = spaceship.x - enemy.x;
      final dy = spaceship.y - enemy.y;

      final distance = sqrt(
        dx * dx + dy * dy,
      );

      if (distance > 1) {
        enemy.x += (dx / distance) * enemy.speed;
        enemy.y += (dy / distance) * enemy.speed;
      }
    }

    // Move homing bullets.
    for (final bullet in bullets) {
      final target = bullet.target;

      if (target == null || !enemies.contains(target)) {
        bullet.target = findNearestEnemy(
          bullet.x,
          bullet.y,
        );
      }

      final currentTarget = bullet.target;

      if (currentTarget != null) {
        final dx = currentTarget.x - bullet.x;
        final dy = currentTarget.y - bullet.y;

        final distance = sqrt(
          dx * dx + dy * dy,
        );

        if (distance > 1) {
          bullet.x += (dx / distance) * bullet.speed;
          bullet.y += (dy / distance) * bullet.speed;
        }
      }
    }

    // Bullet collisions.
    final bulletsToRemove = <Bullet>[];
    final enemiesToRemove = <Enemy>[];

    for (final bullet in bullets) {
      for (final enemy in enemies) {
        final dx = bullet.x - enemy.x;
        final dy = bullet.y - enemy.y;

        final distance = sqrt(
          dx * dx + dy * dy,
        );

        if (distance < enemy.size / 2 + 8) {
          bulletsToRemove.add(bullet);
          enemiesToRemove.add(enemy);

          score += 10;

          break;
        }
      }
    }

    bullets.removeWhere(
      (bullet) => bulletsToRemove.contains(bullet),
    );

    enemies.removeWhere(
      (enemy) => enemiesToRemove.contains(enemy),
    );

    // Remove enemies that reach spaceship.
    enemies.removeWhere(
      (enemy) {
        final dx = spaceship.x - enemy.x;
        final dy = spaceship.y - enemy.y;

        final distance = sqrt(
          dx * dx + dy * dy,
        );

        return distance < 55;
      },
    );

    // Remove bullets outside the screen.
    bullets.removeWhere(
      (bullet) {
        return bullet.x < -50 ||
            bullet.x > width + 50 ||
            bullet.y < -50 ||
            bullet.y > height + 50;
      },
    );
  }

  void spawnEnemy(
  double width,
  double height,
) {
  const edge = 50.0;

  final x = random.nextDouble() * width;
  final y = -edge;

  final problem = mathSystem.generateAddition();

  final difficulty = min(score / 500, 1.0);

  final enemySpeed =
      0.5 +
      difficulty * 0.8 +
      random.nextDouble() * 0.3;

  enemies.add(
    Enemy(
      x: x,
      y: y,
      speed: enemySpeed,
      size: 45 + random.nextDouble() * 20,
      problem: problem,
    ),
  );
}

  Enemy? findNearestEnemy(
    double x,
    double y,
  ) {
    if (enemies.isEmpty) {
      return null;
    }

    Enemy? nearest;
    double nearestDistance = double.infinity;

    for (final enemy in enemies) {
      final dx = enemy.x - x;
      final dy = enemy.y - y;

      final distance = dx * dx + dy * dy;

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = enemy;
      }
    }

    return nearest;
  }

  bool validateAnswer(String input) {
    if (input.isEmpty || enemies.isEmpty) {
      lastAnswerCorrect = false;
      return false;
    }

    for (final enemy in enemies) {
      if (mathSystem.checkAnswer(enemy.problem, input)) {
        lastAnswerCorrect = true;
        return true;
      }
    }

    lastAnswerCorrect = false;
    return false;
  }

  void shoot(String input) {
  final value = int.tryParse(input);

  if (value == null) {
    return;
  }

  Enemy? target;

  for (final enemy in enemies) {
    if (enemy.problem.answer == value) {
      target = enemy;
      break;
    }
  }

  if (target == null) {
    return;
  }

  bullets.add(
    Bullet(
      x: spaceship.x,
      y: spaceship.y - 40,
      speed: 9.0,
      target: target,
    ),
  );
}
}