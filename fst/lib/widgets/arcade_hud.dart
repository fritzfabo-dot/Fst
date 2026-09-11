import 'package:flutter/material.dart';

class ArcadeHUD extends StatelessWidget {
  final int score;
  final int highScore;
  final int lives;
  final int maxLives;
  final int comboMultiplier;
  final int comboCount;

  const ArcadeHUD({
    super.key,
    required this.score,
    required this.highScore,
    required this.lives,
    required this.maxLives,
    required this.comboMultiplier,
    required this.comboCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 380;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 14,
        vertical: isSmallScreen ? 4 : 8,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Score Badge Card
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 10 : 14,
                vertical: isSmallScreen ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF00F0FF).withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.stars,
                    size: isSmallScreen ? 16 : 18,
                    color: const Color(0xFF00F0FF),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'SCORE: $score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 13 : 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 2. Combo Badge (If Active)
            if (comboMultiplier > 1)
              AnimatedScale(
                scale: 1.0 + (comboMultiplier - 1) * 0.06,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 12,
                    vertical: isSmallScreen ? 5 : 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF0055), Color(0xFFFFB700)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF0055).withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Text(
                    'COMBO x$comboMultiplier!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 11 : 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

            const SizedBox(width: 8),

            // 3. Shield Health Pods Card
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8 : 12,
                vertical: isSmallScreen ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFFF0055).withValues(alpha: 0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF0055).withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  maxLives,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      index < lives ? Icons.shield : Icons.shield_outlined,
                      color: index < lives ? const Color(0xFFFF0055) : Colors.white24,
                      size: isSmallScreen ? 17 : 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
