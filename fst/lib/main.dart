import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'game/math_shooter_game.dart';
import 'painters/enemy_painter.dart';
import 'painters/particle_painter.dart';
import 'painters/spaceship_painter.dart';
import 'widgets/math_keyboard.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpaceshipGameWidget(),
    ),
  );
}

class SpaceshipGameWidget extends StatefulWidget {
  const SpaceshipGameWidget({super.key});

  @override
  State<SpaceshipGameWidget> createState() => _SpaceshipGameWidgetState();
}

class _SpaceshipGameWidgetState extends State<SpaceshipGameWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastFrameTime = Duration.zero;

  final MathShooterGame game = MathShooterGame();
  String answerInput = '';

  bool isFlashError = false;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      if (_lastFrameTime == Duration.zero) {
        _lastFrameTime = elapsed;
        return;
      }

      final dt = (elapsed - _lastFrameTime).inMicroseconds / 1000000.0;
      _lastFrameTime = elapsed;

      // Limiter dt pour éviter les énormes sauts de temps lors de freezes
      final clampedDt = dt.clamp(0.001, 0.05);

      updateGame(clampedDt);
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void updateGame(double dt) {
    // Calculer les dimensions de l'arène de jeu (au-dessus du clavier)
    final mediaQuery = MediaQuery.of(context);
    final totalWidth = mediaQuery.size.width;

    // L'arène prend toute la hauteur moins la hauteur du clavier ancré (environ 200px) et padding
    final arenaHeight = (mediaQuery.size.height - 210).clamp(200.0, 1000.0);

    game.update(
      dt: dt,
      width: totalWidth,
      height: arenaHeight,
    );

    setState(() {});
  }

  void onAnswerChanged(String value) {
    setState(() {
      answerInput = value;
    });
  }

  void shoot() {
    if (game.status != GameStatus.playing) return;

    if (answerInput.isEmpty) return;

    final success = game.shoot(answerInput);

    // Auto-reset du clavier après chaque tir
    setState(() {
      answerInput = '';
      if (!success) {
        isFlashError = true;
      }
    });

    if (!success) {
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted) {
          setState(() {
            isFlashError = false;
          });
        }
      });
    }
  }

  void startGame() {
    setState(() {
      answerInput = '';
      game.startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final targetedEnemy = game.getTargetForInput(answerInput);

    return Scaffold(
      backgroundColor: const Color(0xFF050A18),
      body: SafeArea(
        child: Column(
          children: [
            // Arène de jeu principale
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;

                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      // Arrière-plan spatial
                      Container(
                        width: width,
                        height: height,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF040814),
                              Color(0xFF0B1228),
                            ],
                          ),
                        ),
                      ),

                      // Étoiles de fond
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: StarFieldPainter(),
                          ),
                        ),
                      ),

                      // Particules d'explosion
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: ParticlePainter(
                              particles: game.particles,
                            ),
                          ),
                        ),
                      ),

                      // Ennemis
                      ...game.enemies.map(
                        (enemy) {
                          final isTargeted = targetedEnemy == enemy;
                          return Positioned(
                            left: enemy.x - enemy.size / 2,
                            top: enemy.y - enemy.size / 2,
                            child: SizedBox(
                              width: enemy.size,
                              height: enemy.size,
                              child: CustomPaint(
                                painter: EnemyPainter(
                                  problem: enemy.problem,
                                  isTargeted: isTargeted,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Projectiles
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

                      // Vaisseau Spatial
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

                      // Textes flottants (+10, -1 HP)
                      ...game.floatingTexts.map((ft) {
                        return Positioned(
                          left: ft.x - 30,
                          top: ft.y,
                          child: IgnorePointer(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 100),
                              opacity: (ft.life / ft.maxLife).clamp(0.0, 1.0),
                              child: Text(
                                ft.text,
                                style: TextStyle(
                                  color: ft.color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(
                                      color: ft.color.withOpacity(0.8),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      // HUD : Score & Vies (En haut de l'arène)
                      Positioned(
                        top: 15,
                        left: 15,
                        right: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Compteur de Score
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'SCORE: ${game.score}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),

                            // Vies / Boucliers
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.redAccent.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: List.generate(
                                  game.maxLives,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: Icon(
                                      index < game.lives
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: index < game.lives
                                          ? Colors.redAccent
                                          : Colors.white30,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Overlay Menu Principal
                      if (game.status == GameStatus.menu)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black87,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.rocket_launch,
                                  size: 80,
                                  color: Colors.cyanAccent,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'FST MATH SHOOTER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Calculez vite et détruisez les envahisseurs !',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: startGame,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.cyanAccent,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 36,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'COMMENCER LA PARTIE',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Overlay Game Over
                      if (game.status == GameStatus.gameOver)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black87,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 80,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(height: 15),
                                const Text(
                                  'GAME OVER',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Score Final: ${game.score}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Meilleur Score: ${game.highScore}',
                                  style: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                ElevatedButton(
                                  onPressed: startGame,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'REJOUER',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Panneau de contrôle du Clavier Ancré en Bas (Bottom Dock)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF080D1F),
                border: Border(
                  top: BorderSide(
                    color: isFlashError
                        ? Colors.redAccent
                        : Colors.cyanAccent.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Clavier numérique
                  Expanded(
                    child: MathKeyboard(
                      input: answerInput,
                      onChanged: onAnswerChanged,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Bouton de Tir
                  GestureDetector(
                    onTap: shoot,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 72,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isFlashError
                            ? Colors.red
                            : (targetedEnemy != null
                                ? Colors.cyanAccent
                                : Colors.cyanAccent.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isFlashError
                                ? Colors.red.withOpacity(0.8)
                                : Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.flash_on,
                          color: isFlashError ? Colors.white : Colors.black,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.6);

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
        canvas.drawCircle(star, 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}