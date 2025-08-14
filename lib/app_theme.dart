import 'package:flutter/material.dart';

class AppTheme {
  static ElevatedButtonThemeData _sharedElevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: 'InstrumentSans',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
      ),
    );
  }

  static TextButtonThemeData _sharedTextButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        foregroundColor: colorScheme.primary,
        // backgroundColor: colorScheme.secondaryContainer.withValues(alpha: .2),
      ),
    );
  }

  static ChipThemeData _sharedChipTheme() {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  static SnackBarThemeData _sharedSnackBarData(ColorScheme colorScheme) {
    return SnackBarThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      behavior: SnackBarBehavior.floating,
      insetPadding: EdgeInsets.all(16),
      backgroundColor: colorScheme.onSurface,
      actionTextColor: colorScheme.surface,
    );
  }

  static InputDecorationTheme _sharedInputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      fillColor: colorScheme.surfaceContainer,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 2.0,
        ),
      ),
    );
  }


  static DialogThemeData _sharedDialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.secondaryContainer,
        ),
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'InstrumentSans',
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'InstrumentSans',
        fontSize: 14,
        color: colorScheme.onSurface,
      ),
      barrierColor: Colors.black.withValues(alpha: .8),
      actionsPadding: EdgeInsetsGeometry.only(left: 24, right: 24, bottom: 24),
    );
  }

  static TabBarThemeData _sharedTabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      labelColor: colorScheme.onSurface,
      unselectedLabelColor: colorScheme.secondary,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        fontFamily: 'InstrumentSans',
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 18,
        fontFamily: 'InstrumentSans',
      ),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: colorScheme.onSurface,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          return colorScheme.surface;
        },
      ),
      dividerColor: Colors.transparent,
    );
  }


  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF082030),
      brightness: Brightness.light,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'InstrumentSans',

      // Disable ripple effects and highlights globally in light mode
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,

      elevatedButtonTheme: _sharedElevatedButtonTheme(colorScheme),
      textButtonTheme: _sharedTextButtonTheme(colorScheme),
      chipTheme: _sharedChipTheme(),
      dialogTheme: _sharedDialogTheme(colorScheme),
      snackBarTheme: _sharedSnackBarData(colorScheme),
      inputDecorationTheme: _sharedInputDecorationTheme(colorScheme),
      tabBarTheme: _sharedTabBarTheme(colorScheme),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF011f4b),
      brightness: Brightness.dark,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'InstrumentSans',

      // Disable ripple effects and highlights globally in dark mode
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,


      elevatedButtonTheme: _sharedElevatedButtonTheme(colorScheme),
      textButtonTheme: _sharedTextButtonTheme(colorScheme),
      chipTheme: _sharedChipTheme(),
      dialogTheme: _sharedDialogTheme(colorScheme),
      snackBarTheme: _sharedSnackBarData(colorScheme),
      inputDecorationTheme: _sharedInputDecorationTheme(colorScheme),
      tabBarTheme: _sharedTabBarTheme(colorScheme),
    );
  }
}
