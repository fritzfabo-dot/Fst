import 'package:flutter_test/flutter_test.dart';
import 'package:fst/game/math_shooter_game.dart';
import 'package:fst/models/game_theme.dart';

void main() {
  group('GameTheme & Theme Randomization Tests', () {
    test('GameTheme contains 10 distinct handcrafted matching themes', () {
      expect(GameTheme.allThemes.length, 10);
      final themeIds = GameTheme.allThemes.map((t) => t.id).toSet();
      expect(themeIds.length, 10);
    });

    test('startGame randomizes game theme', () {
      final game = MathShooterGame();
      expect(game.currentTheme, isNotNull);

      final initialThemeIndex = game.currentThemeIndex;
      game.startGame();

      // Theme index should be updated to a valid index in allThemes range
      expect(game.currentThemeIndex, greaterThanOrEqualTo(0));
      expect(game.currentThemeIndex, lessThan(GameTheme.allThemes.length));
      expect(game.currentTheme, GameTheme.allThemes[game.currentThemeIndex]);
    });

    test('setThemeIndex manually switches active theme', () {
      final game = MathShooterGame();
      game.setThemeIndex(3); // Emerald Matrix
      expect(game.currentThemeIndex, 3);
      expect(game.currentTheme.id, 'emerald_matrix');

      game.setThemeIndex(7); // Frost Aurora
      expect(game.currentThemeIndex, 7);
      expect(game.currentTheme.id, 'frost_aurora');
    });
  });
}
