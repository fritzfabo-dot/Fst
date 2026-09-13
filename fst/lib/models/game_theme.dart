import 'package:flutter/material.dart';

class GameTheme {
  final String id;
  final String name;
  final String description;

  // Background & Core Colors
  final Color backgroundColor;
  final Color surfaceColor;
  final Color cardColor;

  // Accents
  final Color primaryColor; // Primary neon highlight (lasers, target lock, active keys)
  final Color secondaryColor; // Secondary neon accent (dreadnoughts, combos, error flash)
  final Color accentColor; // Golden / tertiary accent

  // Starfield & Nebula
  final List<Color> nebulaGradient1;
  final List<Color> nebulaGradient2;

  // Spaceship Aesthetics
  final List<Color> shipHullGradient;
  final List<Color> cockpitGradient;
  final Color shipTrimColor;

  // Laser Bullets
  final List<Color> bulletGradient;
  final Color bulletGlow;

  // HUD & UI Elements
  final Color hudBorderColor;
  final Color keyboardBorder;

  const GameTheme({
    required this.id,
    required this.name,
    required this.description,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.cardColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.nebulaGradient1,
    required this.nebulaGradient2,
    required this.shipHullGradient,
    required this.cockpitGradient,
    required this.shipTrimColor,
    required this.bulletGradient,
    required this.bulletGlow,
    required this.hudBorderColor,
    required this.keyboardBorder,
  });

  static const GameTheme cyberpunkNeon = GameTheme(
    id: 'cyberpunk_neon',
    name: 'Cyberpunk Neon',
    description: 'Neon cyan & magenta glowing in obsidian deep space',
    backgroundColor: Color(0xFF030712),
    surfaceColor: Color(0xFF0F172A),
    cardColor: Color(0xFF0B1021),
    primaryColor: Color(0xFF00F0FF),
    secondaryColor: Color(0xFFFF0055),
    accentColor: Color(0xFFFFB700),
    nebulaGradient1: [Color(0xFF9D00FF), Color(0xFF00F0FF), Colors.transparent],
    nebulaGradient2: [Color(0xFFFF0055), Color(0xFF1A0B2E), Colors.transparent],
    shipHullGradient: [Color(0xFFE2E8F0), Color(0xFF1E293B), Color(0xFF0F172A)],
    cockpitGradient: [Color(0xFF00F0FF), Color(0xFF0077FF), Color(0xFF001A4D)],
    shipTrimColor: Color(0xFF00F0FF),
    bulletGradient: [Colors.white, Color(0xFF00F0FF), Color(0xFF0055FF)],
    bulletGlow: Color(0xFF00F0FF),
    hudBorderColor: Color(0xFF00F0FF),
    keyboardBorder: Color(0xFF3B82F6),
  );

  static const GameTheme deepCosmos = GameTheme(
    id: 'deep_cosmos',
    name: 'Deep Cosmos',
    description: 'Deep cosmic violet and electric teal aurora',
    backgroundColor: Color(0xFF090514),
    surfaceColor: Color(0xFF160D2E),
    cardColor: Color(0xFF100924),
    primaryColor: Color(0xFF00E5FF),
    secondaryColor: Color(0xFFA855F7),
    accentColor: Color(0xFFF43F5E),
    nebulaGradient1: [Color(0xFF8B5CF6), Color(0xFF06B6D4), Colors.transparent],
    nebulaGradient2: [Color(0xFFD946EF), Color(0xFF1E1B4B), Colors.transparent],
    shipHullGradient: [Color(0xFFF1F5F9), Color(0xFF312E81), Color(0xFF1E1B4B)],
    cockpitGradient: [Color(0xFF38BDF8), Color(0xFF6366F1), Color(0xFF311B92)],
    shipTrimColor: Color(0xFF38BDF8),
    bulletGradient: [Colors.white, Color(0xFF38BDF8), Color(0xFF6366F1)],
    bulletGlow: Color(0xFF38BDF8),
    hudBorderColor: Color(0xFFA855F7),
    keyboardBorder: Color(0xFF8B5CF6),
  );

  static const GameTheme solarGold = GameTheme(
    id: 'solar_gold',
    name: 'Solar Gold',
    description: 'Blazing golden solar flares & fiery amber',
    backgroundColor: Color(0xFF0F0A02),
    surfaceColor: Color(0xFF241505),
    cardColor: Color(0xFF1A0E03),
    primaryColor: Color(0xFFFFB700),
    secondaryColor: Color(0xFFFF3D00),
    accentColor: Color(0xFFFFEA00),
    nebulaGradient1: [Color(0xFFFF8F00), Color(0xFFFFD600), Colors.transparent],
    nebulaGradient2: [Color(0xFFDD2C00), Color(0xFF3E2723), Colors.transparent],
    shipHullGradient: [Color(0xFFFFF8E1), Color(0xFF5D4037), Color(0xFF3E2723)],
    cockpitGradient: [Color(0xFFFFEA00), Color(0xFFFF9100), Color(0xFFBF360C)],
    shipTrimColor: Color(0xFFFFD600),
    bulletGradient: [Colors.white, Color(0xFFFFEA00), Color(0xFFFF6D00)],
    bulletGlow: Color(0xFFFFD600),
    hudBorderColor: Color(0xFFFFB700),
    keyboardBorder: Color(0xFFFF8F00),
  );

  static const GameTheme emeraldMatrix = GameTheme(
    id: 'emerald_matrix',
    name: 'Emerald Matrix',
    description: 'Cybernetic emerald matrix green and radiant lime',
    backgroundColor: Color(0xFF020F0A),
    surfaceColor: Color(0xFF06291C),
    cardColor: Color(0xFF041C13),
    primaryColor: Color(0xFF00FF9D),
    secondaryColor: Color(0xFF00E676),
    accentColor: Color(0xFFAEEA00),
    nebulaGradient1: [Color(0xFF00E676), Color(0xFF1DE9B6), Colors.transparent],
    nebulaGradient2: [Color(0xFF76FF03), Color(0xFF004D40), Colors.transparent],
    shipHullGradient: [Color(0xFFE8F5E9), Color(0xFF1B5E20), Color(0xFF0A2E16)],
    cockpitGradient: [Color(0xFF00FF9D), Color(0xFF00B0FF), Color(0xFF004D40)],
    shipTrimColor: Color(0xFF00FF9D),
    bulletGradient: [Colors.white, Color(0xFF00FF9D), Color(0xFF00C853)],
    bulletGlow: Color(0xFF00FF9D),
    hudBorderColor: Color(0xFF00FF9D),
    keyboardBorder: Color(0xFF00E676),
  );

  static const GameTheme sunsetRetrowave = GameTheme(
    id: 'sunset_retrowave',
    name: 'Sunset Retrowave',
    description: 'Vaporwave synth sunset with hot pink & orange glow',
    backgroundColor: Color(0xFF120310),
    surfaceColor: Color(0xFF2A0926),
    cardColor: Color(0xFF1E061B),
    primaryColor: Color(0xFFFF2A85),
    secondaryColor: Color(0xFFFF7A00),
    accentColor: Color(0xFFFFD600),
    nebulaGradient1: [Color(0xFFFF007A), Color(0xFFFF9900), Colors.transparent],
    nebulaGradient2: [Color(0xFF9900FF), Color(0xFF330033), Colors.transparent],
    shipHullGradient: [Color(0xFFFDE8F3), Color(0xFF5B0E4D), Color(0xFF2B0325)],
    cockpitGradient: [Color(0xFFFF5252), Color(0xFFFF007A), Color(0xFF4A148C)],
    shipTrimColor: Color(0xFFFF2A85),
    bulletGradient: [Colors.white, Color(0xFFFF2A85), Color(0xFFFF7A00)],
    bulletGlow: Color(0xFFFF2A85),
    hudBorderColor: Color(0xFFFF2A85),
    keyboardBorder: Color(0xFFFF7A00),
  );

  static const GameTheme toxicAcid = GameTheme(
    id: 'toxic_acid',
    name: 'Toxic Acid',
    description: 'Radioactive toxic yellow and neon venom green',
    backgroundColor: Color(0xFF0B0F03),
    surfaceColor: Color(0xFF1B2607),
    cardColor: Color(0xFF131B05),
    primaryColor: Color(0xFFCCFF00),
    secondaryColor: Color(0xFF00FF66),
    accentColor: Color(0xFFFFD600),
    nebulaGradient1: [Color(0xFFCCFF00), Color(0xFF00FF66), Colors.transparent],
    nebulaGradient2: [Color(0xFFAEEA00), Color(0xFF1A3300), Colors.transparent],
    shipHullGradient: [Color(0xFFF4F8E8), Color(0xFF334E00), Color(0xFF1A2B00)],
    cockpitGradient: [Color(0xFFCCFF00), Color(0xFF76FF03), Color(0xFF1B5E20)],
    shipTrimColor: Color(0xFFCCFF00),
    bulletGradient: [Colors.white, Color(0xFFCCFF00), Color(0xFF00FF66)],
    bulletGlow: Color(0xFFCCFF00),
    hudBorderColor: Color(0xFFCCFF00),
    keyboardBorder: Color(0xFF76FF03),
  );

  static const GameTheme volcanicInferno = GameTheme(
    id: 'volcanic_inferno',
    name: 'Volcanic Inferno',
    description: 'Molten magma scarlet & fiery volcanic ember',
    backgroundColor: Color(0xFF0F0303),
    surfaceColor: Color(0xFF290808),
    cardColor: Color(0xFF1D0505),
    primaryColor: Color(0xFFFF1744),
    secondaryColor: Color(0xFFFF9100),
    accentColor: Color(0xFFFFEA00),
    nebulaGradient1: [Color(0xFFFF1744), Color(0xFFFF5252), Colors.transparent],
    nebulaGradient2: [Color(0xFFD50000), Color(0xFF3E0000), Colors.transparent],
    shipHullGradient: [Color(0xFFFFEBEE), Color(0xFF4A0000), Color(0xFF210000)],
    cockpitGradient: [Color(0xFFFF5252), Color(0xFFFF1744), Color(0xFF880E4F)],
    shipTrimColor: Color(0xFFFF1744),
    bulletGradient: [Colors.white, Color(0xFFFF1744), Color(0xFFFF9100)],
    bulletGlow: Color(0xFFFF1744),
    hudBorderColor: Color(0xFFFF1744),
    keyboardBorder: Color(0xFFFF5252),
  );

  static const GameTheme frostAurora = GameTheme(
    id: 'frost_aurora',
    name: 'Frost Aurora',
    description: 'Glacial arctic ice cyan & luminescent aurora turquoise',
    backgroundColor: Color(0xFF020C12),
    surfaceColor: Color(0xFF061E2B),
    cardColor: Color(0xFF04151F),
    primaryColor: Color(0xFF00F5FF),
    secondaryColor: Color(0xFF00E5FF),
    accentColor: Color(0xFFE0F7FA),
    nebulaGradient1: [Color(0xFF00F5FF), Color(0xFF80DEEA), Colors.transparent],
    nebulaGradient2: [Color(0xFF00838F), Color(0xFF002733), Colors.transparent],
    shipHullGradient: [Color(0xFFE0F7FA), Color(0xFF006064), Color(0xFF00363A)],
    cockpitGradient: [Color(0xFF80DEEA), Color(0xFF00E5FF), Color(0xFF004D40)],
    shipTrimColor: Color(0xFF00F5FF),
    bulletGradient: [Colors.white, Color(0xFF00F5FF), Color(0xFF00B0FF)],
    bulletGlow: Color(0xFF00F5FF),
    hudBorderColor: Color(0xFF00F5FF),
    keyboardBorder: Color(0xFF4DD0E1),
  );

  static const GameTheme amethystVoid = GameTheme(
    id: 'amethyst_void',
    name: 'Amethyst Void',
    description: 'Mystic royal amethyst & glowing lavender pulse',
    backgroundColor: Color(0xFF0B0314),
    surfaceColor: Color(0xFF1E0A33),
    cardColor: Color(0xFF150724),
    primaryColor: Color(0xFFD8B4FE),
    secondaryColor: Color(0xFFC084FC),
    accentColor: Color(0xFFF472B6),
    nebulaGradient1: [Color(0xFFC084FC), Color(0xFFA855F7), Colors.transparent],
    nebulaGradient2: [Color(0xFF6B21A8), Color(0xFF1E1B4B), Colors.transparent],
    shipHullGradient: [Color(0xFFFAF5FF), Color(0xFF581C87), Color(0xFF2E1065)],
    cockpitGradient: [Color(0xFFE9D5FF), Color(0xFFC084FC), Color(0xFF4C1D95)],
    shipTrimColor: Color(0xFFD8B4FE),
    bulletGradient: [Colors.white, Color(0xFFD8B4FE), Color(0xFFA855F7)],
    bulletGlow: Color(0xFFD8B4FE),
    hudBorderColor: Color(0xFFC084FC),
    keyboardBorder: Color(0xFFA855F7),
  );

  static const GameTheme hyperCrimson = GameTheme(
    id: 'hyper_crimson',
    name: 'Hyper Crimson',
    description: 'Hyperdrive ruby red & metallic titanium accents',
    backgroundColor: Color(0xFF0A0204),
    surfaceColor: Color(0xFF24060E),
    cardColor: Color(0xFF180409),
    primaryColor: Color(0xFFFF0033),
    secondaryColor: Color(0xFFFF5252),
    accentColor: Color(0xFFFFD700),
    nebulaGradient1: [Color(0xFFFF0033), Color(0xFFFF4081), Colors.transparent],
    nebulaGradient2: [Color(0xFF880E4F), Color(0xFF1A0006), Colors.transparent],
    shipHullGradient: [Color(0xFFFFF0F5), Color(0xFF5C061C), Color(0xFF28020A)],
    cockpitGradient: [Color(0xFFFF4081), Color(0xFFFF0033), Color(0xFF4A0010)],
    shipTrimColor: Color(0xFFFF0033),
    bulletGradient: [Colors.white, Color(0xFFFF0033), Color(0xFFFF4081)],
    bulletGlow: Color(0xFFFF0033),
    hudBorderColor: Color(0xFFFF0033),
    keyboardBorder: Color(0xFFFF4081),
  );

  static const List<GameTheme> allThemes = [
    cyberpunkNeon,
    deepCosmos,
    solarGold,
    emeraldMatrix,
    sunsetRetrowave,
    toxicAcid,
    volcanicInferno,
    frostAurora,
    amethystVoid,
    hyperCrimson,
  ];
}
