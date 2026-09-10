import 'dart:async';

import 'package:flutter/material.dart';

import 'game/math_shooter_game.dart';
import 'painters/enemy_painter.dart';
import 'painters/spaceship_painter.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SpaceshipGame(),
    ),
  );
}

class SpaceshipGame extends StatefulWidget {
  const SpaceshipGame({super.key});

  @override
  State<SpaceshipGame> createState() => _SpaceshipGameState();
}

class _SpaceshipGameState extends State<SpaceshipGame> {
  Timer? gameTimer;

  final MathShooterGame game = MathShooterGame();

  @override
  void initState() {
    super.initState();

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

  void updateGame() {
    final size = MediaQuery.of(context).size;

    game.update(
      width: size.width,
      height: size.height,
    );

    setState(() {});
  }

  void shoot() {
    game.shoot();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return Stack(
              children: [
                // Background
                Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF050A18),
                        Color(0xFF0B1026),
                      ],
                    ),
                  ),
                ),

                // Stars
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: StarFieldPainter(),
                    ),
                  ),
                ),

                // Score
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'SCORE: ${game.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                // Enemies
                ...game.enemies.map(
                  (enemy) {
                    return Positioned(
                      left: enemy.x - enemy.size / 2,
                      top: enemy.y - enemy.size / 2,
                      child: SizedBox(
                        width: enemy.size,
                        height: enemy.size,
                        child: CustomPaint(
                          painter: EnemyPainter(
                            problem: enemy.problem,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Bullets
                ...game.bullets.map(
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
                              color: Colors.cyanAccent.withOpacity(0.8),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Spaceship
                Positioned(
                  left: game.spaceshipX - 45,
                  top: game.spaceshipY - 45,
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: CustomPaint(
                      painter: SpaceshipPainter(),
                    ),
                  ),
                ),

                // Shoot button
                Positioned(
                  bottom: 25,
                  right: 25,
                  child: GestureDetector(
                    onTap: shoot,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
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

class StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7);

    final stars = [
      const Offset(30, 80),
      const Offset(90, 150),
      const Offset(160, 60),
      const Offset(230, 120),
      const Offset(310, 45),
      const Offset(380, 180),
      const Offset(450, 90),
      const Offset(520, 150),
      const Offset(600, 70),
      const Offset(680, 200),
      const Offset(750, 110),
      const Offset(820, 55),
    ];

    for (final star in stars) {
      if (star.dx < size.width && star.dy < size.height) {
        canvas.drawCircle(
          star,
          1.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}