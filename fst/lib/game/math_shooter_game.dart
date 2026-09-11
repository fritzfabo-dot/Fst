import 'dart:math';
import 'package:flutter/material.dart';

import '../models/bullet.dart';
import '../models/enemy.dart';
import '../models/floating_text.dart';
import '../models/particle.dart';
import '../models/spaceship.dart';
import '../systems/math_system.dart';

enum GameStatus {
  menu,
  playing,
  gameOver,
}

class MathShooterGame {
  final Random random = Random();
  final MathSystem mathSystem = MathSystem();

  final List<Enemy> enemies = [];
  final List<Bullet> bullets = [];
  final List<Particle> particles = [];
  final List<FloatingText> floatingTexts = [];

  final Spaceship spaceship = Spaceship(
    x: 0,
    y: 0,
  );

  GameStatus status = GameStatus.menu;

  int score = 0;
  int highScore = 0;
  int lives = 3;
  final int maxLives = 3;

  int comboCount = 0;
  int maxCombo = 0;
  int enemiesDestroyed = 0;
  int shotsFired = 0;
  int shotsHit = 0;

  double totalTime = 0.0;
  double shakeMagnitude = 0.0;
  double shakeX = 0.0;
  double shakeY = 0.0;

  double enemySpawnTimer = 0;
  bool? lastAnswerCorrect;

  double get spaceshipX => spaceship.x;
  double get spaceshipY => spaceship.y;

  int get comboMultiplier {
    if (comboCount >= 10) return 4;
    if (comboCount >= 5) return 3;
    if (comboCount >= 3) return 2;
    return 1;
  }

  double get accuracy {
    if (shotsFired == 0) return 100.0;
    return (shotsHit / shotsFired * 100.0).clamp(0.0, 100.0);
  }

  void startGame() {
    score = 0;
    lives = maxLives;
    comboCount = 0;
    maxCombo = 0;
    enemiesDestroyed = 0;
    shotsFired = 0;
    shotsHit = 0;

    enemies.clear();
    bullets.clear();
    particles.clear();
    floatingTexts.clear();

    enemySpawnTimer = 0;
    shakeMagnitude = 0;
    shakeX = 0;
    shakeY = 0;
    lastAnswerCorrect = null;
    status = GameStatus.playing;
  }

  void triggerShake(double amount) {
    shakeMagnitude = max(shakeMagnitude, amount);
  }

  void update({
    double dt = 0.016,
    required double width,
    required double height,
  }) {
    totalTime += dt;

    // Screen Shake decay
    if (shakeMagnitude > 0.01) {
      shakeX = (random.nextDouble() * 2 - 1) * shakeMagnitude;
      shakeY = (random.nextDouble() * 2 - 1) * shakeMagnitude;
      shakeMagnitude = max(0.0, shakeMagnitude - dt * 25.0);
    } else {
      shakeX = 0.0;
      shakeY = 0.0;
      shakeMagnitude = 0.0;
    }

    // Update particles & floating texts
    for (final particle in particles) {
      particle.update(dt);
    }
    particles.removeWhere((p) => p.isDead);

    for (final ft in floatingTexts) {
      ft.update(dt);
    }
    floatingTexts.removeWhere((ft) => ft.isDead);

    if (status != GameStatus.playing) {
      return;
    }

    // Position ship smoothly at bottom center of arena
    spaceship.x = width / 2;
    spaceship.y = height - 55;

    // Spawning frequency accelerates with score
    enemySpawnTimer += dt;
    final spawnInterval = max(0.85, 2.3 - (score / 350) * 0.55);

    if (enemySpawnTimer >= spawnInterval) {
      enemySpawnTimer = 0;
      spawnEnemy(width, height);
    }

    // Update enemies
    final enemiesWhoEscaped = <Enemy>[];

    for (final enemy in enemies) {
      enemy.y += enemy.speed * 55 * dt;
      enemy.rotation += dt * (enemy.type == EnemyType.dreadnought ? 0.8 : 1.5);

      if (enemy.y >= spaceship.y - 15) {
        enemiesWhoEscaped.add(enemy);
      }
    }

    // Enemies escaping -> take damage & break combo
    for (final enemy in enemiesWhoEscaped) {
      enemies.remove(enemy);
      lives -= 1;
      comboCount = 0;
      triggerShake(12.0);

      createExplosion(enemy.x, enemy.y, const Color(0xFFFF0055), count: 20);
      floatingTexts.add(
        FloatingText(
          x: enemy.x,
          y: enemy.y,
          text: '-1 SHIELD!',
          color: const Color(0xFFFF0055),
        ),
      );

      if (lives <= 0) {
        lives = 0;
        status = GameStatus.gameOver;
        if (score > highScore) {
          highScore = score;
        }
        break;
      }
    }

    // Update bullets
    for (final bullet in bullets) {
      final target = bullet.target;

      if (target != null && enemies.contains(target)) {
        final dx = target.x - bullet.x;
        final dy = target.y - bullet.y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance > 1) {
          bullet.x += (dx / distance) * bullet.speed * 60 * dt;
          bullet.y += (dy / distance) * bullet.speed * 60 * dt;
        }
      } else {
        bullet.y -= bullet.speed * 60 * dt;
      }
    }

    // Bullet-Enemy Collisions
    final bulletsToRemove = <Bullet>[];
    final enemiesToRemove = <Enemy>[];

    for (final bullet in bullets) {
      for (final enemy in enemies) {
        final dx = bullet.x - enemy.x;
        final dy = bullet.y - enemy.y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < enemy.size / 2 + 10) {
          bulletsToRemove.add(bullet);
          enemiesToRemove.add(enemy);

          shotsHit++;
          enemiesDestroyed++;
          comboCount++;
          if (comboCount > maxCombo) {
            maxCombo = comboCount;
          }

          final pointsGained = 10 * comboMultiplier;
          score += pointsGained;

          triggerShake(5.0 + comboMultiplier * 2.0);

          final explosionColor = comboMultiplier > 2
              ? const Color(0xFFFFB700)
              : const Color(0xFF00F0FF);

          createExplosion(
            enemy.x,
            enemy.y,
            explosionColor,
            count: 22 + comboMultiplier * 4,
          );

          final popupText = comboMultiplier > 1
              ? '+$pointsGained (x$comboMultiplier)'
              : '+$pointsGained';

          floatingTexts.add(
            FloatingText(
              x: enemy.x,
              y: enemy.y - 12,
              text: popupText,
              color: explosionColor,
            ),
          );

          if (comboCount == 3 || comboCount == 5 || comboCount == 10) {
            floatingTexts.add(
              FloatingText(
                x: width / 2,
                y: height / 2 - 30,
                text: 'COMBO x$comboMultiplier!',
                color: const Color(0xFFFF0055),
              ),
            );
          }

          break;
        }
      }
    }

    bullets.removeWhere((bullet) => bulletsToRemove.contains(bullet));
    enemies.removeWhere((enemy) => enemiesToRemove.contains(enemy));

    bullets.removeWhere((bullet) {
      return bullet.x < -60 || bullet.x > width + 60 || bullet.y < -60 || bullet.y > height + 60;
    });
  }

  void spawnEnemy(double width, double height) {
    const edge = 40.0;
    final minX = 45.0;
    final maxX = max(minX + 20, width - 45.0);
    final x = minX + random.nextDouble() * (maxX - minX);
    final y = -edge;

    final problem = mathSystem.generateAddition();
    final difficulty = min(score / 450, 1.0);
    final enemySpeed = 1.0 + difficulty * 1.1 + random.nextDouble() * 0.45;

    final typeIndex = random.nextInt(3);
    final type = EnemyType.values[typeIndex];
    final size = type == EnemyType.dreadnought ? 62.0 : (type == EnemyType.viper ? 52.0 : 46.0);

    enemies.add(
      Enemy(
        x: x,
        y: y,
        speed: enemySpeed,
        size: size,
        problem: problem,
        type: type,
        rotation: random.nextDouble() * pi,
      ),
    );
  }

  Enemy? getTargetForInput(String input) {
    final value = int.tryParse(input);
    if (value == null || enemies.isEmpty) {
      return null;
    }

    Enemy? bestTarget;
    double maxY = -double.infinity;

    for (final enemy in enemies) {
      if (enemy.problem.answer == value) {
        if (enemy.y > maxY) {
          maxY = enemy.y;
          bestTarget = enemy;
        }
      }
    }

    return bestTarget;
  }

  bool validateAnswer(String input) {
    final target = getTargetForInput(input);
    if (target != null) {
      lastAnswerCorrect = true;
      return true;
    }
    lastAnswerCorrect = false;
    return false;
  }

  bool shoot(String input) {
    if (status != GameStatus.playing) return false;
    shotsFired++;

    final target = getTargetForInput(input);

    if (target == null) {
      lastAnswerCorrect = false;
      comboCount = 0;
      triggerShake(4.0);
      return false;
    }

    lastAnswerCorrect = true;

    bullets.add(
      Bullet(
        x: spaceship.x,
        y: spaceship.y - 35,
        speed: 15.0,
        target: target,
      ),
    );

    return true;
  }

  void createExplosion(double x, double y, Color color, {int count = 20}) {
    particles.add(
      Particle(
        x: x,
        y: y,
        vx: 0,
        vy: 0,
        size: 5.0,
        maxLife: 0.35,
        life: 0.35,
        color: color,
        isRing: true,
      ),
    );

    for (var i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 2.0 + random.nextDouble() * 5.5;
      final life = 0.3 + random.nextDouble() * 0.55;
      final isSpark = random.nextBool();

      particles.add(
        Particle(
          x: x,
          y: y,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          size: isSpark ? (2.0 + random.nextDouble() * 2.0) : (3.5 + random.nextDouble() * 4.0),
          maxLife: life,
          life: life,
          color: color,
          isSpark: isSpark,
        ),
      );
    }
  }
}