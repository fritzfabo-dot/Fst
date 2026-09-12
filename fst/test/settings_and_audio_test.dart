import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fst/game/math_shooter_game.dart';
import 'package:fst/services/audio_service.dart';
import 'package:fst/widgets/game_overlays.dart';
import 'package:fst/widgets/settings_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (MethodCall methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => 1,
    );
  });

  group('GameAudioService Mute Controls', () {
    test('music mute state toggles correctly', () {
      final audio = GameAudioService();
      expect(audio.isMusicMuted, false);

      audio.setSfxMuted(true);
      expect(audio.isSfxMuted, true);

      audio.toggleSfxMute();
      expect(audio.isSfxMuted, false);

      audio.dispose();
    });
  });

  group('MathShooterGame Pause / Resume Logic', () {
    test('pauseGame transitions from playing to paused state', () {
      final game = MathShooterGame();
      game.startGame();

      expect(game.status, GameStatus.playing);

      game.pauseGame();
      expect(game.status, GameStatus.paused);
    });

    test('update does not advance gameplay while paused', () {
      final game = MathShooterGame();
      game.startGame();

      // Spawn initial state
      game.update(dt: 0.1, width: 400, height: 600);
      game.pauseGame();

      final enemyCountBefore = game.enemies.length;
      final totalTimeBefore = game.totalTime;

      // Update while paused
      game.update(dt: 1.0, width: 400, height: 600);

      expect(game.enemies.length, enemyCountBefore);
      expect(game.totalTime, totalTimeBefore + 1.0);
      expect(game.status, GameStatus.paused);

      // Resume
      game.resumeGame();
      expect(game.status, GameStatus.playing);
    });

    test('shoot returns false while paused', () {
      final game = MathShooterGame();
      game.startGame();
      game.pauseGame();

      final success = game.shoot('4');
      expect(success, false);
    });
  });

  group('SettingsOverlay Widget Tests', () {
    testWidgets('renders ambiance music toggle first and SFX toggle second', (tester) async {
      final game = MathShooterGame();
      final audio = GameAudioService();

      bool musicToggled = false;
      bool sfxToggled = false;
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                SettingsOverlay(
                  game: game,
                  audio: audio,
                  onClose: () => closed = true,
                  onToggleMusic: () => musicToggled = true,
                  onToggleSfx: () => sfxToggled = true,
                ),
              ],
            ),
          ),
        ),
      );

      // Verify Title and Controls presence
      expect(find.text('PARAMÈTRES DU JEU'), findsOneWidget);
      expect(find.text('MUSIQUE D\'AMBIANCE'), findsOneWidget);
      expect(find.text('EFFETS SONORES'), findsOneWidget);

      await tester.tap(find.text('MUSIQUE D\'AMBIANCE'));
      await tester.pump();
      expect(musicToggled, true);

      await tester.tap(find.text('EFFETS SONORES'));
      await tester.pump();
      expect(sfxToggled, true);

      // Verify button tap
      await tester.tap(find.text('FERMER'));
      await tester.pump();
      expect(closed, true);

      audio.dispose();
    });

    testWidgets('renders QUITTER LE JEU button and triggers onQuit callback', (tester) async {
      final game = MathShooterGame();
      final audio = GameAudioService();
      bool quitTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                SettingsOverlay(
                  game: game,
                  audio: audio,
                  onClose: () {},
                  onToggleMusic: () {},
                  onToggleSfx: () {},
                  onQuit: () => quitTriggered = true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('QUITTER LE JEU'), findsOneWidget);
      await tester.tap(find.text('QUITTER LE JEU'));
      await tester.pump();
      expect(quitTriggered, true);

      audio.dispose();
    });
  });

  group('GameOverOverlay Widget Tests', () {
    testWidgets('renders QUITTER LE JEU button and triggers onQuit callback', (tester) async {
      final game = MathShooterGame();
      bool quitTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                GameOverOverlay(
                  game: game,
                  onRestart: () {},
                  onQuit: () => quitTriggered = true,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('MISSION ÉCHOUÉE'), findsOneWidget);
      expect(find.text('RECOMMENCER'), findsOneWidget);
      expect(find.text('QUITTER LE JEU'), findsOneWidget);

      await tester.tap(find.text('QUITTER LE JEU'));
      await tester.pump();
      expect(quitTriggered, true);
    });
  });
}

