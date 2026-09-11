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

  double enemySpawnTimer = 0;
  bool? lastAnswerCorrect;

  double get spaceshipX => spaceship.x;
  double get spaceshipY => spaceship.y;

  void startGame() {
    score = 0;
    lives = maxLives;
    enemies.clear();
    bullets.clear();
    particles.clear();
    floatingTexts.clear();
    enemySpawnTimer = 0;
    lastAnswerCorrect = null;
    status = GameStatus.playing;
  }

  void update({
    double dt = 0.016,
    required double width,
    required double height,
  }) {
    // Mettre à jour les particules et textes flottants même hors jeu (ex: fondu)
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

    // Positionnement du vaisseau au-dessus de l'arène
    spaceship.x = width / 2;
    spaceship.y = height - 50;

    // Frequence d'apparition des ennemis (s'accélère progressivement)
    enemySpawnTimer += dt;
    final spawnInterval = max(0.9, 2.2 - (score / 300) * 0.5);

    if (enemySpawnTimer >= spawnInterval) {
      enemySpawnTimer = 0;
      spawnEnemy(width, height);
    }

    // Déplacement des ennemis vers le bas (vers le vaisseau)
    final enemiesWhoEscaped = <Enemy>[];

    for (final enemy in enemies) {
      enemy.y += enemy.speed * 60 * dt;

      // Si l'ennemi franchit la ligne de défense du vaisseau
      if (enemy.y >= spaceship.y - 20) {
        enemiesWhoEscaped.add(enemy);
      }
    }

    // Traitement des ennemis ayant franchi la ligne
    for (final enemy in enemiesWhoEscaped) {
      enemies.remove(enemy);
      lives -= 1;

      // Effet visuel d'impact/dégât sur le vaisseau
      createExplosion(enemy.x, enemy.y, Colors.redAccent, count: 15);
      floatingTexts.add(
        FloatingText(
          x: enemy.x,
          y: enemy.y,
          text: '-1 HP',
          color: Colors.redAccent,
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

    // Déplacement des projectiles
    for (final bullet in bullets) {
      final target = bullet.target;

      // Si la cible est toujours vivante, suivre sa position
      if (target != null && enemies.contains(target)) {
        final dx = target.x - bullet.x;
        final dy = target.y - bullet.y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance > 1) {
          bullet.x += (dx / distance) * bullet.speed * 60 * dt;
          bullet.y += (dy / distance) * bullet.speed * 60 * dt;
        }
      } else {
        // Si la cible est détruite, le missile continue tout droit en haut sans réorienter sur un mauvais ennemi !
        bullet.y -= bullet.speed * 60 * dt;
      }
    }

    // Collisions Balles <-> Ennemis
    final bulletsToRemove = <Bullet>[];
    final enemiesToRemove = <Enemy>[];

    for (final bullet in bullets) {
      for (final enemy in enemies) {
        final dx = bullet.x - enemy.x;
        final dy = bullet.y - enemy.y;
        final distance = sqrt(dx * dx + dy * dy);

        // Si la balle touche l'ennemi
        if (distance < enemy.size / 2 + 8) {
          bulletsToRemove.add(bullet);
          enemiesToRemove.add(enemy);

          score += 10;

          // Effets visuels : explosion de particules + popup score
          createExplosion(enemy.x, enemy.y, Colors.cyanAccent, count: 18);
          floatingTexts.add(
            FloatingText(
              x: enemy.x,
              y: enemy.y - 10,
              text: '+10',
              color: Colors.cyanAccent,
            ),
          );

          break;
        }
      }
    }

    bullets.removeWhere((bullet) => bulletsToRemove.contains(bullet));
    enemies.removeWhere((enemy) => enemiesToRemove.contains(enemy));

    // Suppression des balles hors écran
    bullets.removeWhere((bullet) {
      return bullet.x < -50 || bullet.x > width + 50 || bullet.y < -50 || bullet.y > height + 50;
    });
  }

  void spawnEnemy(double width, double height) {
    const edge = 40.0;
    // Laisser une marge sur les côtés
    final minX = 40.0;
    final maxX = max(minX + 20, width - 40.0);
    final x = minX + random.nextDouble() * (maxX - minX);
    final y = -edge;

    final problem = mathSystem.generateAddition();
    final difficulty = min(score / 500, 1.0);
    final enemySpeed = 1.0 + difficulty * 1.2 + random.nextDouble() * 0.4;

    enemies.add(
      Enemy(
        x: x,
        y: y,
        speed: enemySpeed,
        size: 48 + random.nextDouble() * 12,
        problem: problem,
      ),
    );
  }

  /// Retourne l'ennemi ciblé par la saisie actuelle (celui le plus proche du bas)
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

  /// Effectue le tir en ciblant l'ennemi correspondant le plus proche du bas
  bool shoot(String input) {
    final target = getTargetForInput(input);

    if (target == null) {
      lastAnswerCorrect = false;
      return false;
    }

    lastAnswerCorrect = true;

    bullets.add(
      Bullet(
        x: spaceship.x,
        y: spaceship.y - 30,
        speed: 12.0,
        target: target,
      ),
    );

    return true;
  }

  void createExplosion(double x, double y, Color color, {int count = 15}) {
    for (var i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = 1.5 + random.nextDouble() * 4.5;
      final life = 0.3 + random.nextDouble() * 0.5;

      particles.add(
        Particle(
          x: x,
          y: y,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          size: 2.5 + random.nextDouble() * 3.5,
          maxLife: life,
          life: life,
          color: color,
        ),
      );
    }
  }
}