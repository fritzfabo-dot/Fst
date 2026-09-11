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

    final isExtraLivesActive = lives > 3;
    final isCritical = lives == 1;

    final healthBorderColor = isExtraLivesActive
        ? const Color(0xFF00FF9D)
        : (isCritical ? const Color(0xFFFF0033) : const Color(0xFFFF0055));

    final healthGlowColor = isExtraLivesActive
        ? const Color(0xFF00FF9D).withValues(alpha: 0.45)
        : (isCritical
            ? const Color(0xFFFF0033).withValues(alpha: 0.6)
            : const Color(0xFFFF0055).withValues(alpha: 0.25));

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

            // 3. Shield & Health Pods Card (Dynamic & Responsive)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 8 : 12,
                vertical: isSmallScreen ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: healthBorderColor,
                  width: isExtraLivesActive ? 2.0 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: healthGlowColor,
                    blurRadius: isExtraLivesActive ? 12 : 8,
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: lives <= 5
                    ? Row(
                        key: ValueKey('shield_pods_$lives'),
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          lives,
                          (index) {
                            final isExtraLife = index >= 3;
                            final iconColor = isExtraLife
                                ? const Color(0xFF00FF9D)
                                : const Color(0xFFFF0055);

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Icon(
                                Icons.shield,
                                color: iconColor,
                                size: isSmallScreen ? 17 : 20,
                              ),
                            );
                          },
                        ),
                      )
                    : Row(
                        key: const ValueKey('shield_badge_count'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shield,
                            color: const Color(0xFF00FF9D),
                            size: isSmallScreen ? 18 : 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'x$lives',
                            style: TextStyle(
                              color: const Color(0xFF00FF9D),
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00FF9D).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF00FF9D).withValues(alpha: 0.6),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '+${lives - 3}',
                              style: TextStyle(
                                color: const Color(0xFF00FF9D),
                                fontSize: isSmallScreen ? 10 : 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
