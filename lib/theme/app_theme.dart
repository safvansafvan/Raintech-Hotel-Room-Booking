import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color navy = Color(0xFF123B5D);
  static const Color teal = Color(0xFF17877D);
  static const Color background = Color(0xFFF4F7F9);
  static const Color ink = Color(0xFF14212B);
  static const Color mutedInk = Color(0xFF51606D);
  static const Color border = Color(0xFFE1E7EB);

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
          color: ink,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(color: ink, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(color: mutedInk, height: 1.45),
        bodySmall: TextStyle(color: mutedInk),
        labelLarge: TextStyle(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: Color(0xFFE6EBEF), space: 1),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        headerBackgroundColor: navy,
        headerForegroundColor: Colors.white,
        todayBorder: const BorderSide(color: teal),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: navy,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      focusColor: teal.withValues(alpha: 0.16),
      hoverColor: navy.withValues(alpha: 0.05),
    );
  }
}
