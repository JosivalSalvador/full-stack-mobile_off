import 'package:flutter/material.dart';

/// Centralizes the app's visual identity: colors, typography, and
/// component defaults, built from a single seed color using Material 3's
/// tonal palette generation.
abstract final class AppTheme {
  static const Color _seedColor = Colors.indigo;

  /// The light theme, used by default unless the device requests dark mode.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      );

  /// The dark theme, used when the device is set to dark mode.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
      );
}
