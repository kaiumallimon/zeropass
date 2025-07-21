import 'package:flutter/material.dart';

class AppTheme {
  static final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB), // Blue
    onPrimary: Colors.white,
    secondary: Color(0xFF6B7280), // Gray
    onSecondary: Colors.white,
    background: Color(0xFFF9FAFB), // Light background
    onBackground: Color(0xFF111827), // Dark text
    surface: Color(0xFFFFFFFF), // Card & inputs
    onSurface: Color(0xFF111827), // Text on surface
    error: Color(0xFFEF4444), // Red
    onError: Colors.white,
  );

  static final lightTheme = ThemeData(
    colorScheme: lightColorScheme,
    useMaterial3: true,
    fontFamily: 'Sora',
    scaffoldBackgroundColor: lightColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: lightColorScheme.surface,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );

  // Dark color scheme
  static final darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF60A5FA), // Light Blue
    onPrimary: Color(0xFF1E3A8A), // Dark Blue
    secondary: Color(0xFFD1D5DB), // Light Gray
    onSecondary: Colors.black,
    background: Color(0xFF1F2937), // Dark Gray background
    onBackground: Colors.white,
    surface: Color(0xFF374151), // Dark surface (cards, inputs)
    onSurface: Colors.white,
    error: Color(0xFFF87171), // Soft Red
    onError: Colors.black,
  );

  // Dark theme data
  static final darkTheme = ThemeData(
    colorScheme: darkColorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: darkColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.primary,
      foregroundColor: darkColorScheme.onPrimary,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: darkColorScheme.surface,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
  );
}
