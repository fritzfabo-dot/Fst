import 'package:flutter/material.dart';

import '../game/math_shooter_game.dart';
import '../services/app_utils.dart';

class StartMenuOverlay extends StatelessWidget {
  final MathShooterGame game;
  final VoidCallback onStart;
  final VoidCallback? onOpenSettings;

  const StartMenuOverlay({
    super.key,
    required this.game,
    required this.onStart,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 380 || screenSize.height < 650;
    final theme = game.currentTheme;

    final dialogWidth = (screenSize.width * 0.88).clamp(260.0, 420.0);
    final outerPadding = isSmallScreen ? 12.0 : 20.0;
    final innerPadding = isSmallScreen ? 16.0 : 24.0;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.88),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(outerPadding),
            child: Container(
              width: dialogWidth,
              padding: EdgeInsets.all(innerPadding),
              decoration: BoxDecoration(
                color: theme.surfaceColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: theme.primaryColor,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  if (onOpenSettings != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: onOpenSettings,
                        icon: Icon(Icons.tune_rounded, color: theme.primaryColor),
                        tooltip: 'Paramètres',
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated Rocket Title Icon
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.primaryColor.withValues(alpha: 0.12),
                          border: Border.all(color: theme.primaryColor),
                        ),
                        child: Icon(
                          Icons.rocket_launch,
                          size: isSmallScreen ? 42 : 56,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 18),

                      // Title Text
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'SPACESHIP+ KEYBOARD',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'TACTICAL MATH ARCADE SHOOTER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: isSmallScreen ? 10 : 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 14 : 18),

                      // Instructions Box
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text(
                          'Saisissez le résultat exact des équations pour verrouiller les vaisseaux ennemis et tirez avec le canon plasma !',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 14 : 20),

                      if (game.highScore > 0) ...[
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'RECORD PERSONNEL: ${game.highScore} PTS',
                            style: TextStyle(
                              color: theme.accentColor,
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 14 : 18),
                      ],

                      // Launch Action Button
                      ElevatedButton(
                        onPressed: onStart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.black,
                          minimumSize: Size(double.infinity, isSmallScreen ? 46 : 52),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow_rounded, size: isSmallScreen ? 24 : 28),
                              const SizedBox(width: 6),
                              Text(
                                'LANCER LA MISSION',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameOverOverlay extends StatelessWidget {
  final MathShooterGame game;
  final VoidCallback onRestart;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onQuit;

  const GameOverOverlay({
    super.key,
    required this.game,
    required this.onRestart,
    this.onOpenSettings,
    this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 380 || screenSize.height < 650;
    final theme = game.currentTheme;

    final dialogWidth = (screenSize.width * 0.88).clamp(260.0, 420.0);
    final outerPadding = isSmallScreen ? 12.0 : 20.0;
    final innerPadding = isSmallScreen ? 16.0 : 24.0;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.90),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(outerPadding),
            child: Container(
              width: dialogWidth,
              padding: EdgeInsets.all(innerPadding),
              decoration: BoxDecoration(
                color: theme.surfaceColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: theme.secondaryColor,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.secondaryColor.withValues(alpha: 0.35),
                    blurRadius: 25,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  if (onOpenSettings != null)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: onOpenSettings,
                        icon: Icon(Icons.tune_rounded, color: theme.secondaryColor),
                        tooltip: 'Paramètres',
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.report_problem_rounded,
                        size: isSmallScreen ? 46 : 56,
                        color: theme.secondaryColor,
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'MISSION ÉCHOUÉE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.secondaryColor,
                            fontSize: isSmallScreen ? 22 : 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          'BOUCLIERS DU VAISSEAU ÉPUISÉS',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 14 : 20),

                      // Stats Grid Recap
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          children: [
                            _buildStatRow('SCORE FINAL', '${game.score}', theme.primaryColor, isSmallScreen),
                            Divider(color: Colors.white12, height: isSmallScreen ? 12 : 16),
                            _buildStatRow('MEILLEUR SCORE', '${game.highScore}', theme.accentColor, isSmallScreen),
                            Divider(color: Colors.white12, height: isSmallScreen ? 12 : 16),
                            _buildStatRow('MAX COMBO', 'x${game.maxCombo}', theme.secondaryColor, isSmallScreen),
                            Divider(color: Colors.white12, height: isSmallScreen ? 12 : 16),
                            _buildStatRow('PRÉCISION', '${game.accuracy.toStringAsFixed(0)}%', Colors.white, isSmallScreen),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 16 : 22),

                      ElevatedButton(
                        onPressed: onRestart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.secondaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, isSmallScreen ? 46 : 52),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.replay_rounded, size: isSmallScreen ? 22 : 26),
                              const SizedBox(width: 6),
                              Text(
                                'RECOMMENCER',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),

                      OutlinedButton(
                        onPressed: onQuit ?? quitGame,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.secondaryColor,
                          side: BorderSide(
                            color: theme.secondaryColor.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                          minimumSize: Size(double.infinity, isSmallScreen ? 42 : 48),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: theme.backgroundColor.withValues(alpha: 0.8),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.power_settings_new_rounded, size: isSmallScreen ? 20 : 24),
                              const SizedBox(width: 6),
                              Text(
                                'QUITTER LE JEU',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 13 : 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: isSmallScreen ? 11 : 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
