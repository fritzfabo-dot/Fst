import 'package:flutter/material.dart';

import '../models/enemy.dart';
import '../models/game_theme.dart';

class TacticalKeyboard extends StatefulWidget {
  const TacticalKeyboard({
    super.key,
    required this.input,
    required this.onChanged,
    required this.onShoot,
    required this.targetedEnemy,
    this.isFlashError = false,
    this.theme = GameTheme.cyberpunkNeon,
  });

  final String input;
  final ValueChanged<String> onChanged;
  final VoidCallback onShoot;
  final Enemy? targetedEnemy;
  final bool isFlashError;
  final GameTheme theme;

  @override
  State<TacticalKeyboard> createState() => _TacticalKeyboardState();
}

class _TacticalKeyboardState extends State<TacticalKeyboard> {
  String? pressedKey;

  void _onKeyPress(String digit) {
    setState(() => pressedKey = digit);
    widget.onChanged(widget.input + digit);
    _resetPress();
  }

  void _onBackspace() {
    setState(() => pressedKey = 'BACK');
    if (widget.input.isNotEmpty) {
      widget.onChanged(widget.input.substring(0, widget.input.length - 1));
    }
    _resetPress();
  }

  void _onClear() {
    setState(() => pressedKey = 'CLEAR');
    if (widget.input.isNotEmpty) {
      widget.onChanged('');
    }
    _resetPress();
  }

  void _resetPress() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() => pressedKey = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 380 || screenSize.height < 650;
    final hasTarget = widget.targetedEnemy != null;
    final theme = widget.theme;

    final fireButtonWidth = isCompact ? 76.0 : 92.0;
    final fireButtonHeight = isCompact ? 128.0 : 144.0;
    final keyHeight = isCompact ? 38.0 : 44.0;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 620),
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 10,
        vertical: isCompact ? 4 : 6,
      ),
      padding: EdgeInsets.all(isCompact ? 6 : 10),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(isCompact ? 16 : 20),
        border: Border.all(
          color: widget.isFlashError
              ? theme.secondaryColor
              : (hasTarget ? theme.primaryColor : theme.keyboardBorder.withValues(alpha: 0.4)),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isFlashError
                ? theme.secondaryColor.withValues(alpha: 0.4)
                : (hasTarget ? theme.primaryColor.withValues(alpha: 0.25) : Colors.black54),
            blurRadius: 18,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Holographic Target Lock Screen Display
          Container(
            width: double.infinity,
            height: isCompact ? 40 : 46,
            margin: EdgeInsets.only(bottom: isCompact ? 6 : 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasTarget ? theme.primaryColor : theme.surfaceColor,
                width: 1.5,
              ),
              boxShadow: [
                if (hasTarget)
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
              ],
            ),
            child: Row(
              children: [
                // Target Lock Status Badge
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: hasTarget
                          ? theme.primaryColor.withValues(alpha: 0.15)
                          : theme.surfaceColor,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: hasTarget ? theme.primaryColor : Colors.white24,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          hasTarget ? Icons.gps_fixed : Icons.radar,
                          size: 13,
                          color: hasTarget ? theme.primaryColor : Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              hasTarget
                                  ? 'CIBLE: ${widget.targetedEnemy!.problem.expression}'
                                  : (widget.input.isNotEmpty ? 'RECHERCHE...' : 'CIBLE EN ATTENTE'),
                              style: TextStyle(
                                color: hasTarget ? theme.primaryColor : Colors.white60,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Typed Input Value Display
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.input.isEmpty ? '0' : widget.input,
                    style: TextStyle(
                      color: widget.isFlashError
                          ? theme.secondaryColor
                          : (hasTarget ? theme.primaryColor : Colors.white),
                      fontSize: isCompact ? 20 : 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: hasTarget ? theme.primaryColor : theme.keyboardBorder,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Keyboard Keys & Fire Button Layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Numpad Grid
              Expanded(
                child: Column(
                  children: [
                    // Row 1: 1, 2, 3, 4, 5
                    Row(
                      children: ['1', '2', '3', '4', '5'].map((digit) {
                        return _buildArcadeKey(
                          label: digit,
                          onTap: () => _onKeyPress(digit),
                          isPressed: pressedKey == digit,
                          height: keyHeight,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: isCompact ? 4 : 5),
                    // Row 2: 6, 7, 8, 9, 0
                    Row(
                      children: ['6', '7', '8', '9', '0'].map((digit) {
                        return _buildArcadeKey(
                          label: digit,
                          onTap: () => _onKeyPress(digit),
                          isPressed: pressedKey == digit,
                          height: keyHeight,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: isCompact ? 4 : 5),
                    // Row 3: Backspace & Clear Actions
                    Row(
                      children: [
                        _buildArcadeKey(
                          label: '⌫ EFFACER',
                          onTap: _onBackspace,
                          isPressed: pressedKey == 'BACK',
                          color: theme.keyboardBorder,
                          flex: 2,
                          height: keyHeight,
                        ),
                        _buildArcadeKey(
                          label: 'C RESET',
                          onTap: _onClear,
                          isPressed: pressedKey == 'CLEAR',
                          color: theme.secondaryColor,
                          flex: 1,
                          height: keyHeight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: isCompact ? 6 : 8),

              // 3. Massive Arcade Laser Fire Switch Button ("ENGAGE LASER")
              GestureDetector(
                onTap: widget.onShoot,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: fireButtonWidth,
                  height: fireButtonHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: widget.isFlashError
                          ? [theme.secondaryColor, theme.secondaryColor.withValues(alpha: 0.6)]
                          : (hasTarget
                              ? [theme.primaryColor, theme.primaryColor.withValues(alpha: 0.6)]
                              : [theme.surfaceColor, theme.backgroundColor]),
                    ),
                    borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
                    border: Border.all(
                      color: widget.isFlashError
                          ? theme.secondaryColor
                          : (hasTarget ? Colors.white : theme.surfaceColor),
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.isFlashError
                            ? theme.secondaryColor.withValues(alpha: 0.6)
                            : (hasTarget ? theme.primaryColor.withValues(alpha: 0.6) : Colors.transparent),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: hasTarget ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.local_fire_department,
                          color: widget.isFlashError || hasTarget ? Colors.black : Colors.white38,
                          size: isCompact ? 30 : 36,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'TIRER',
                          style: TextStyle(
                            color: widget.isFlashError || hasTarget ? Colors.black : Colors.white60,
                            fontSize: isCompact ? 13 : 15,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'LASER',
                          style: TextStyle(
                            color: widget.isFlashError || hasTarget ? Colors.black87 : Colors.white38,
                            fontSize: isCompact ? 9 : 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
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
    );
  }

  Widget _buildArcadeKey({
    required String label,
    required VoidCallback onTap,
    required bool isPressed,
    required double height,
    Color? color,
    int flex = 1,
  }) {
    final keyColor = color ?? widget.theme.surfaceColor;

    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: GestureDetector(
          onTapDown: (_) => onTap(),
          child: AnimatedScale(
            scale: isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isPressed
                      ? [keyColor.withValues(alpha: 0.8), keyColor]
                      : [keyColor.withValues(alpha: 0.9), keyColor.withValues(alpha: 0.4)],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isPressed ? Colors.white : keyColor.withValues(alpha: 0.6),
                  width: 1.2,
                ),
                boxShadow: [
                  if (isPressed)
                    BoxShadow(
                      color: (color ?? widget.theme.primaryColor).withValues(alpha: 0.5),
                      blurRadius: 6,
                    ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
