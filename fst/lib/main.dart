import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SpaceshipGame(),
    ),
  );
}

// ============================================================
// ENEMY DATA
// ============================================================

class Enemy {
  double x;
  double y;

  final double speed;
  final double size;

  Enemy({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });
}

// ============================================================
// BULLET DATA
// ============================================================

class Bullet {
  double x;
  double y;

  final double speed;

  // The enemy this bullet is tracking.
  Enemy? target;

  Bullet({
    required this.x,
    required this.y,
    required this.speed,
    required this.target,
  });
}

// ============================================================
// GAME
// ============================================================

class SpaceshipGame extends StatefulWidget {
  const SpaceshipGame({super.key});

  @override
  State<SpaceshipGame> createState() => _SpaceshipGameState();
}

class _SpaceshipGameState extends State<SpaceshipGame> {
  // ==========================================================
  // GAME LOOP
  // ==========================================================

  Timer? gameTimer;

  // ==========================================================
  // RANDOM
  // ==========================================================

  final Random random = Random();

  // ==========================================================
  // GAME OBJECTS
  // ==========================================================

  final List<Enemy> enemies = [];
  final List<Bullet> bullets = [];

  // ==========================================================
  // SCORE
  // ==========================================================

  int score = 0;

  // ==========================================================
  // SPACESHIP
  // ==========================================================

  // These are calculated from the screen size.
  double spaceshipX = 0;
  double spaceshipY = 0;

  // ==========================================================
  // ENEMY SPAWNING
  // ==========================================================

  double enemySpawnTimer = 0;

  @override
  void initState() {
    super.initState();

    // Start the game loop.
    gameTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) {
        updateGame();
      },
    );
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  // ==========================================================
  // GAME UPDATE
  // ==========================================================

  void updateGame() {
    if (!mounted) return;

    // --------------------------------------------------------
    // We need screen dimensions.
    // --------------------------------------------------------

    final size = MediaQuery.of(context).size;

    final gameWidth = size.width;
    final gameHeight = size.height;

    // --------------------------------------------------------
    // Fixed spaceship position.
    // --------------------------------------------------------

    spaceshipX = gameWidth / 2;
    spaceshipY = gameHeight - 120;

    // --------------------------------------------------------
    // SPAWN ENEMIES
    // --------------------------------------------------------

    enemySpawnTimer += 16;

    // Spawn approximately every 900 ms.
    if (enemySpawnTimer >= 900) {
      enemySpawnTimer = 0;
      spawnEnemy(gameWidth, gameHeight);
    }

    // --------------------------------------------------------
    // MOVE ENEMIES TOWARD SPACESHIP
    // --------------------------------------------------------

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

    // --------------------------------------------------------
    // MOVE HOMING BULLETS
    // --------------------------------------------------------

    for (final bullet in bullets) {
      final target = bullet.target;

      // If the original target disappeared,
      // find another enemy.
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

    // --------------------------------------------------------
    // BULLET COLLISIONS
    // --------------------------------------------------------

    final bulletsToRemove = <Bullet>[];
    final enemiesToRemove = <Enemy>[];

    for (final bullet in bullets) {
      for (final enemy in enemies) {
        final dx = bullet.x - enemy.x;
        final dy = bullet.y - enemy.y;

        final distance = sqrt(
          dx * dx + dy * dy,
        );

        // Collision radius.
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

    // --------------------------------------------------------
    // REMOVE ENEMIES THAT REACH THE SPACESHIP
    // --------------------------------------------------------

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

    // --------------------------------------------------------
    // REMOVE BULLETS WITH NO TARGET
    // --------------------------------------------------------

    bullets.removeWhere(
      (bullet) {
        return bullet.x < -50 ||
            bullet.x > gameWidth + 50 ||
            bullet.y < -50 ||
            bullet.y > gameHeight + 50;
      },
    );

    // --------------------------------------------------------
    // REDRAW
    // --------------------------------------------------------

    setState(() {});
  }

  // ============================================================
  // SPAWN RANDOM ENEMY
  // ============================================================

  void spawnEnemy(
  double width,
  double height,
) {
  const edge = 50.0;

  // ALWAYS spawn from above the screen.
  final x = random.nextDouble() * width;
  final y = -edge;

  enemies.add(
    Enemy(
      x: x,
      y: y,
      speed: 1.2 + random.nextDouble() * 1.8,
      size: 45 + random.nextDouble() * 20,
    ),
  );
}

  // ============================================================
  // FIND NEAREST ENEMY
  // ============================================================

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

  // ============================================================
  // SHOOT
  // ============================================================

  void shoot() {
    if (!mounted) return;

    final target = findNearestEnemy(
      spaceshipX,
      spaceshipY,
    );

    // Don't fire if there are no enemies.
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

    setState(() {});
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            // Keep spaceship at the bottom.
            spaceshipX = width / 2;
            spaceshipY = height - 110;

            return Stack(
              children: [

                // ==================================================
                // SPACE BACKGROUND
                // ==================================================

                Container(
                  width: width,
                  height: height,
                  color: const Color(0xFF050816),
                ),

                // ==================================================
                // SCORE
                // ==================================================

                Positioned(
                  top: 20,
                  left: 20,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Text(
                      'SCORE  $score',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // ENEMIES
                // ==================================================

                ...enemies.map(
                  (enemy) {
                    return Positioned(
                      left: enemy.x - enemy.size / 2,
                      top: enemy.y - enemy.size / 2,

                      child: SizedBox(
                        width: enemy.size,
                        height: enemy.size,

                        child: CustomPaint(
                          painter: EnemyPainter(),
                        ),
                      ),
                    );
                  },
                ),

                // ==================================================
                // BULLETS
                // ==================================================

                ...bullets.map(
                  (bullet) {
                    return Positioned(
                      left: bullet.x - 8,
                      top: bullet.y - 8,

                      child: Container(
                        width: 16,
                        height: 16,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.cyanAccent,

                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent
                                  .withOpacity(0.8),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // ==================================================
                // BIG SPACESHIP
                // ==================================================

                Positioned(
                  left: spaceshipX - 45,
                  top: spaceshipY - 45,

                  child: SizedBox(
                    width: 90,
                    height: 90,

                    child: CustomPaint(
                      painter: SpaceshipPainter(),
                    ),
                  ),
                ),

                // ==================================================
                // SHOOT BUTTON
                // ==================================================

                Positioned(
                  right: 25,
                  bottom: 25,

                  child: GestureDetector(
                    onTap: shoot,

                    child: Container(
                      width: 90,
                      height: 90,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        color: Colors.redAccent,

                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent
                                .withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),

                      child: const Center(
                        child: Icon(
                          Icons.gps_fixed,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // SHOOT LABEL
                // ==================================================

                Positioned(
                  right: 40,
                  bottom: 5,

                  child: const Text(
                    'SHOOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// SPACESHIP PAINTER
// ============================================================

class SpaceshipPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;

    // --------------------------------------------------------
    // Main body
    // --------------------------------------------------------

    paint.color = Colors.blueAccent;

    final body = Path();

    body.moveTo(centerX, 5);
    body.lineTo(size.width - 10, size.height - 15);
    body.lineTo(centerX, size.height - 30);
    body.lineTo(10, size.height - 15);
    body.close();

    canvas.drawPath(body, paint);

    // --------------------------------------------------------
    // Cockpit
    // --------------------------------------------------------

    paint.color = Colors.cyanAccent;

    canvas.drawCircle(
      Offset(centerX, size.height * 0.38),
      13,
      paint,
    );

    // --------------------------------------------------------
    // Left wing
    // --------------------------------------------------------

    paint.color = Colors.blue.shade700;

    final leftWing = Path();

    leftWing.moveTo(30, 55);
    leftWing.lineTo(5, 78);
    leftWing.lineTo(32, 72);
    leftWing.close();

    canvas.drawPath(
      leftWing,
      paint,
    );

    // --------------------------------------------------------
    // Right wing
    // --------------------------------------------------------

    final rightWing = Path();

    rightWing.moveTo(size.width - 30, 55);
    rightWing.lineTo(size.width - 5, 78);
    rightWing.lineTo(size.width - 32, 72);
    rightWing.close();

    canvas.drawPath(
      rightWing,
      paint,
    );

    // --------------------------------------------------------
    // Engine
    // --------------------------------------------------------

    paint.color = Colors.orangeAccent;

    canvas.drawCircle(
      Offset(centerX, size.height - 8),
      9,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// ============================================================
// ENEMY PAINTER
// ============================================================

class EnemyPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // --------------------------------------------------------
    // Enemy body
    // --------------------------------------------------------

    paint.color = Colors.deepPurpleAccent;

    canvas.drawCircle(
      Offset(centerX, centerY),
      size.width * 0.38,
      paint,
    );

    // --------------------------------------------------------
    // Outer ring
    // --------------------------------------------------------

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.purpleAccent;

    canvas.drawCircle(
      Offset(centerX, centerY),
      size.width * 0.43,
      paint,
    );

    // --------------------------------------------------------
    // Eye
    // --------------------------------------------------------

    paint
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent;

    canvas.drawCircle(
      Offset(centerX, centerY),
      size.width * 0.12,
      paint,
    );

    // --------------------------------------------------------
    // Eye glow
    // --------------------------------------------------------

    paint.color = Colors.orangeAccent;

    canvas.drawCircle(
      Offset(centerX, centerY),
      size.width * 0.05,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}
