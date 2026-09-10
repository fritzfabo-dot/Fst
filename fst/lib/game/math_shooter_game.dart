import 'dart:math';

import '../models/enemy.dart';
import '../models/bullet.dart';
import '../systems/math_system.dart';

class MathShooterGame {
  final Random random = Random();
  final MathSystem mathSystem = MathSystem();

  final List<Enemy> enemies = [];
  final List<Bullet> bullets = [];

  int score = 0;

  double spaceshipX = 0;
  double spaceshipY = 0;

  double enemySpawnTimer = 0;

  void update({
    required double width,
    required double height,
  }) {
    // Fixed spaceship position.
    spaceshipX = width / 2;
    spaceshipY = height - 120;

    // Spawn enemies.
    enemySpawnTimer += 16;

    if (enemySpawnTimer >= 900) {
      enemySpawnTimer = 0;
      spawnEnemy(width, height);
    }

    // Move enemies toward spaceship.
    for (final enemy in enemies) {
      final dx = spaceshipX - enemy.x;
      final dy = spaceshipY - enemy.y;

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
        final dx = spaceshipX - enemy.x;
        final dy = spaceshipY - enemy.y;

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

enemies.add(
  Enemy(
    x: x,
    y: y,
    speed: 1.2 + random.nextDouble() * 1.8,
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

  void shoot() {
    final target = findNearestEnemy(
      spaceshipX,
      spaceshipY,
    );

    if (target == null) {
      return;
    }

    bullets.add(
      Bullet(
        x: spaceshipX,
        y: spaceshipY - 40,
        speed: 9.0,
        target: target,
      ),
    );
  }
}