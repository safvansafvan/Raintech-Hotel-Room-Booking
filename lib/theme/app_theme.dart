import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color navy = Color(0xFF123B5D);
  static const Color teal = Color(0xFF17877D);
  static const Color background = Color(0xFFF4F7F9);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: navy,
      brightness: Brightness.light,
      primary: navy,
      secondary: teal,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: Color(0xFF14212B),
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          color: Color(0xFF14212B),
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: Color(0xFF14212B),
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: Color(0xFF51606D), height: 1.45),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFFE1E7EB)),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE6EBEF), space: 1),
    );
  }
}
