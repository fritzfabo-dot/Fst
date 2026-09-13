import 'package:flutter/material.dart';

import '../game/math_shooter_game.dart';
import '../models/game_theme.dart';
import '../services/app_utils.dart';
import '../services/audio_service.dart';

class SettingsOverlay extends StatelessWidget {
  final MathShooterGame game;
  final GameAudioService audio;
  final VoidCallback onClose;
  final VoidCallback onToggleMusic;
  final VoidCallback onToggleSfx;
  final VoidCallback? onQuit;
  final VoidCallback? onThemeChanged;

  const SettingsOverlay({
    super.key,
    required this.game,
    required this.audio,
    required this.onClose,
    required this.onToggleMusic,
    required this.onToggleSfx,
    this.onQuit,
    this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 380 || screenSize.height < 650;
    final theme = game.currentTheme;

    final dialogWidth = (screenSize.width * 0.88).clamp(280.0, 440.0);
    final outerPadding = isSmallScreen ? 12.0 : 20.0;
    final innerPadding = isSmallScreen ? 16.0 : 24.0;

    final isPaused = game.status == GameStatus.paused;

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
                color: theme.surfaceColor.withValues(alpha: 0.96),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gear / Tune Header Icon
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.primaryColor.withValues(alpha: 0.12),
                      border: Border.all(color: theme.primaryColor),
                    ),
                    child: Icon(
                      Icons.palette_rounded,
                      size: isSmallScreen ? 36 : 48,
                      color: theme.primaryColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Title Text
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'PARAMÈTRES DU JEU',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Game Paused Status Badge (If opened during active gameplay)
                  if (isPaused)
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.accentColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.accentColor,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pause_circle_filled_rounded,
                            size: 14,
                            color: theme.accentColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'JEU EN PAUSE',
                            style: TextStyle(
                              color: theme.accentColor,
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(height: 12),

                  // Setting 1: Theme Switcher Row
                  _buildThemeSelectorRow(
                    context: context,
                    theme: theme,
                    isSmallScreen: isSmallScreen,
                    onNextTheme: () {
                      final nextIndex = (game.currentThemeIndex + 1) % GameTheme.allThemes.length;
                      game.setThemeIndex(nextIndex);
                      if (onThemeChanged != null) onThemeChanged!();
                    },
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Setting 2: Ambiance Music Mute
                  _buildAudioToggleRow(
                    context: context,
                    theme: theme,
                    title: 'MUSIQUE D\'AMBIANCE',
                    subtitle: 'Bande sonore & thèmes musicaux',
                    icon: audio.isMusicMuted
                        ? Icons.music_off_rounded
                        : Icons.music_note_rounded,
                    isMuted: audio.isMusicMuted,
                    onToggle: onToggleMusic,
                    isSmallScreen: isSmallScreen,
                  ),

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Setting 3: Sound Effects Mute
                  _buildAudioToggleRow(
                    context: context,
                    theme: theme,
                    title: 'EFFETS SONORES',
                    subtitle: 'Bruitages de tir, explosions & impacts',
                    icon: audio.isSfxMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    isMuted: audio.isSfxMuted,
                    onToggle: onToggleSfx,
                    isSmallScreen: isSmallScreen,
                  ),

                  SizedBox(height: isSmallScreen ? 18 : 24),

                  // Action Close / Resume Button
                  ElevatedButton(
                    onPressed: onClose,
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
                          Icon(
                            isPaused ? Icons.play_arrow_rounded : Icons.check_circle_outline_rounded,
                            size: isSmallScreen ? 24 : 28,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isPaused ? 'REPRENDRE LA MISSION' : 'FERMER',
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

                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Quit Game Button
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelectorRow({
    required BuildContext context,
    required GameTheme theme,
    required bool isSmallScreen,
    required VoidCallback onNextTheme,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onNextTheme,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withValues(alpha: 0.15),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: theme.primaryColor,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THÈME GRAPHIQUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      theme.name.toUpperCase(),
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: isSmallScreen ? 10 : 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.primaryColor, width: 1.2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'CHANGER',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: isSmallScreen ? 10 : 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: theme.primaryColor,
                      size: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioToggleRow({
    required BuildContext context,
    required GameTheme theme,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isMuted,
    required VoidCallback onToggle,
    required bool isSmallScreen,
  }) {
    final activeColor = theme.primaryColor;
    final inactiveColor = theme.secondaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 10 : 12,
          ),
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isMuted ? inactiveColor.withValues(alpha: 0.5) : activeColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isMuted ? inactiveColor : activeColor).withValues(alpha: 0.15),
                ),
                child: Icon(
                  icon,
                  color: isMuted ? inactiveColor : activeColor,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isMuted
                      ? inactiveColor.withValues(alpha: 0.2)
                      : activeColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isMuted ? inactiveColor : activeColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isMuted ? inactiveColor : activeColor,
                        boxShadow: [
                          BoxShadow(
                            color: isMuted ? inactiveColor : activeColor,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isMuted ? 'COUPÉ' : 'ACTIF',
                      style: TextStyle(
                        color: isMuted ? inactiveColor : activeColor,
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
