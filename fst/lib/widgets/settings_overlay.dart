import 'package:flutter/material.dart';

import '../game/math_shooter_game.dart';
import '../services/app_utils.dart';
import '../services/audio_service.dart';

class SettingsOverlay extends StatelessWidget {
  final MathShooterGame game;
  final GameAudioService audio;
  final VoidCallback onClose;
  final VoidCallback onToggleMusic;
  final VoidCallback onToggleSfx;
  final VoidCallback? onQuit;

  const SettingsOverlay({
    super.key,
    required this.game,
    required this.audio,
    required this.onClose,
    required this.onToggleMusic,
    required this.onToggleSfx,
    this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 380 || screenSize.height < 650;

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
                color: const Color(0xFF0F172A).withValues(alpha: 0.96),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF00F0FF),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.35),
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
                      color: const Color(0xFF00F0FF).withValues(alpha: 0.12),
                      border: Border.all(color: const Color(0xFF00F0FF)),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      size: isSmallScreen ? 36 : 48,
                      color: const Color(0xFF00F0FF),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 10 : 14),

                  // Title Text
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'PARAMÈTRES DU JEU',
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

                  // Game Paused Status Badge (If opened during active gameplay)
                  if (isPaused)
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB700).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFFB700),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.pause_circle_filled_rounded,
                            size: 14,
                            color: Color(0xFFFFB700),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'JEU EN PAUSE',
                            style: TextStyle(
                              color: const Color(0xFFFFB700),
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

                  // Setting 1: Ambiance Music Mute (FIRST Control)
                  _buildAudioToggleRow(
                    context: context,
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

                  // Setting 2: Sound Effects Mute (SECOND Control)
                  _buildAudioToggleRow(
                    context: context,
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
                      backgroundColor: const Color(0xFF00F0FF),
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
                      foregroundColor: const Color(0xFFFF0055),
                      side: BorderSide(
                        color: const Color(0xFFFF0055).withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      minimumSize: Size(double.infinity, isSmallScreen ? 42 : 48),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: const Color(0xFF030712).withValues(alpha: 0.8),
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

  Widget _buildAudioToggleRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isMuted,
    required VoidCallback onToggle,
    required bool isSmallScreen,
  }) {
    final activeColor = const Color(0xFF00F0FF);
    final inactiveColor = const Color(0xFFFF0055);

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
            color: const Color(0xFF030712),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isMuted ? inactiveColor.withValues(alpha: 0.5) : activeColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Icon Container
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

              // Titles
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
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: isSmallScreen ? 9 : 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Toggle Switch Button
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
