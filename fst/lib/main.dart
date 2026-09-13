import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'game/math_shooter_game.dart';
import 'painters/enemy_painter.dart';
import 'painters/particle_painter.dart';
import 'painters/spaceship_painter.dart';
import 'painters/starfield_painter.dart';
import 'services/app_utils.dart';
import 'services/audio_service.dart';
import 'widgets/arcade_hud.dart';
import 'widgets/game_overlays.dart';
import 'widgets/settings_overlay.dart';
import 'widgets/tactical_keyboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spaceship+ Keyboard Shooter',
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
  final FocusNode _focusNode = FocusNode();
  final GameAudioService _audio = GameAudioService();

  String answerInput = '';
  bool isFlashError = false;
  bool isSettingsOpen = false;

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

      final clampedDt = dt.clamp(0.001, 0.05);
      updateGame(clampedDt);
    });

    _ticker.start();

    // Start menu/game-over ambient music immediately
    _audio.play(AmbientTrack.menuAndGameOver);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _focusNode.dispose();
    _audio.dispose();
    super.dispose();
  }

  void openSettings() {
    setState(() {
      if (game.status == GameStatus.playing) {
        game.pauseGame();
      }
      isSettingsOpen = true;
    });
  }

  void closeSettings() {
    setState(() {
      if (game.status == GameStatus.paused) {
        game.resumeGame();
      }
      isSettingsOpen = false;
    });
    _focusNode.requestFocus();
  }

  void toggleSettings() {
    if (isSettingsOpen) {
      closeSettings();
    } else {
      openSettings();
    }
  }

  void toggleMusicMute() {
    setState(() {
      _audio.toggleMusicMute();
    });
  }

  void toggleSfxMute() {
    setState(() {
      _audio.toggleSfxMute();
    });
  }

  void updateGame(double dt) {
    if (!mounted) return;
    final mediaQuery = MediaQuery.of(context);
    final totalWidth = mediaQuery.size.width;

    final isCompact = mediaQuery.size.width < 380 || mediaQuery.size.height < 650;
    final keyboardHeight = isCompact ? 205.0 : 240.0;
    final safeAreaVertical = mediaQuery.padding.top + mediaQuery.padding.bottom;

    final arenaHeight = (mediaQuery.size.height - keyboardHeight - safeAreaVertical).clamp(180.0, 1400.0);

    game.update(
      dt: dt,
      width: totalWidth,
      height: arenaHeight,
    );

    // Drain and play one-shot sound effects emitted this frame
    for (final event in game.pendingSoundEvents) {
      switch (event) {
        case SoundEvent.enemyDestroyed:
          _audio.playSfx('sound/EnemyDestroyed.mp3');
        case SoundEvent.combo:
          _audio.playSfx('sound/combo.wav');
        case SoundEvent.shieldImpact:
          _audio.playSfx('sound/shieldimpact.mp3');
        case SoundEvent.error:
          _audio.playSfx('sound/error.mp3');
      }
    }
    game.pendingSoundEvents.clear();

    // Switch ambient music based on game status
    switch (game.status) {
      case GameStatus.playing:
        _audio.play(AmbientTrack.gameplay);
      case GameStatus.menu:
      case GameStatus.gameOver:
        _audio.play(AmbientTrack.menuAndGameOver);
      case GameStatus.paused:
        // Keep ambient music playing while paused
        break;
    }

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
      isSettingsOpen = false;
      game.startGame();
    });
    _focusNode.requestFocus();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.escape ||
        event.logicalKey == LogicalKeyboardKey.keyP) {
      toggleSettings();
      return;
    }

    if (isSettingsOpen) return;
    if (game.status != GameStatus.playing) return;

    final keyLabel = event.logicalKey.keyLabel;

    if (RegExp(r'^[0-9]$').hasMatch(keyLabel)) {
      onAnswerChanged(answerInput + keyLabel);
    } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (answerInput.isNotEmpty) {
        onAnswerChanged(answerInput.substring(0, answerInput.length - 1));
      }
    } else if (event.logicalKey == LogicalKeyboardKey.delete) {
      onAnswerChanged('');
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      shoot();
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetedEnemy = game.getTargetForInput(answerInput);
    final theme = game.currentTheme;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Main Space Combat Arena
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(game.shakeX, game.shakeY),
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          // Cosmic Parallax Starfield & Nebula
                          Positioned.fill(
                            child: CustomPaint(
                              painter: StarFieldPainter(
                                totalTime: game.totalTime,
                                comboMultiplier: game.comboMultiplier,
                                theme: theme,
                              ),
                            ),
                          ),

                          // Explosions & Plasma Particle Effects
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: ParticlePainter(
                                  particles: game.particles,
                                ),
                              ),
                            ),
                          ),

                          // Alien Enemies
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
                                      type: enemy.type,
                                      rotation: enemy.rotation,
                                      theme: theme,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Plasma Lasers & Missiles
                          ...game.bullets.map(
                            (bullet) {
                              return Positioned(
                                left: bullet.x - 7,
                                top: bullet.y - 12,
                                child: Container(
                                  width: 14,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: theme.bulletGradient,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.bulletGlow.withValues(alpha: 0.9),
                                        blurRadius: 14,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Player Spaceship Interceptor
                          Positioned(
                            left: game.spaceshipX - 45,
                            top: game.spaceshipY - 45,
                            child: SizedBox(
                              width: 90,
                              height: 90,
                              child: CustomPaint(
                                painter: SpaceshipPainter(
                                  totalTime: game.totalTime,
                                  theme: theme,
                                ),
                              ),
                            ),
                          ),

                          // Floating Damage & Combat Score Texts
                          ...game.floatingTexts.map((ft) {
                            return Positioned(
                              left: ft.x - 40,
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
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: ft.color.withValues(alpha: 0.8),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          // Top Flight Cockpit HUD
                          Positioned(
                            top: 8,
                            left: 0,
                            right: 0,
                            child: ArcadeHUD(
                              score: game.score,
                              highScore: game.highScore,
                              lives: game.lives,
                              maxLives: game.maxLives,
                              comboMultiplier: game.comboMultiplier,
                              comboCount: game.comboCount,
                              theme: theme,
                              onOpenSettings: toggleSettings,
                            ),
                          ),

                          // Start Screen Overlay
                          if (game.status == GameStatus.menu)
                            StartMenuOverlay(
                              game: game,
                              onStart: startGame,
                              onOpenSettings: toggleSettings,
                            ),

                          // Game Over Overlay
                          if (game.status == GameStatus.gameOver)
                            GameOverOverlay(
                              game: game,
                              onRestart: startGame,
                              onOpenSettings: toggleSettings,
                              onQuit: quitGame,
                            ),

                          // Settings Modal Overlay
                          if (isSettingsOpen)
                            SettingsOverlay(
                              game: game,
                              audio: _audio,
                              onClose: closeSettings,
                              onToggleMusic: toggleMusicMute,
                              onToggleSfx: toggleSfxMute,
                              onQuit: quitGame,
                              onThemeChanged: () => setState(() {}),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 2. Tactical Firing Console Keyboard (Bottom Panel)
              TacticalKeyboard(
                input: answerInput,
                onChanged: onAnswerChanged,
                onShoot: shoot,
                targetedEnemy: targetedEnemy,
                isFlashError: isFlashError,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}