import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF082030),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: 'InstrumentSans',

      // Disable ripple effects and highlights globally in light mode
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF011f4b),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      fontFamily: 'InstrumentSans',

      // Disable ripple effects and highlights globally in dark mode
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
