import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  /*
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      error: error,
      onError: onError,
      surface: surface,
      onSurface: onSurface,
  ),
  */
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF6A5ACD),      // Slate Blue (blue-purplish)
    onPrimary: Color(0xFFFFFFFF),    // White
    secondary: Color(0xFF9370DB),    // Medium Purple
    onSecondary: Color(0xFF000000),  // Black
    error: Color(0xFFCF6679),        // Pink-ish Red
    onError: Color(0xFF000000),      // Black
    surface: Color(0xFF121212),   // Very Dark Gray
    onSurface: Color(0xFFE0E0E0), // Light Gray
  ),
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
);
