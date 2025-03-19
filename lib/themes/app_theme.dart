import 'package:flutter/material.dart';

class AppTheme {

  static const List<Color> subtleColors = [
    Color(0xFF80CBC4), // Teal 200 (light teal)
    Color(0xFFB0BEC5), // Blue Grey 200 (soft grey-blue)
    Color(0xFFCE93D8), // Purple 200 (muted purple)
    Color(0xFFA5D6A7), // Green 200 (gentle green)
    Color(0xFFFFCC80), // Orange 200 (soft peach)
    Color(0xFFF8BBD0), // Pink 100 (light pink)
    Color(0xFFBBDEFB), // Blue 100 (pale blue)
    Color(0xFFE6EE9C), // Lime 200 (subtle lime)
  ];

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.teal.shade600,
    scaffoldBackgroundColor: Colors.grey.shade100,
    colorScheme: ColorScheme.light(
      primary: Colors.teal.shade600,
      secondary: Colors.teal.shade200,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
    ),
    cardColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
      titleLarge: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade200,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.black87),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        elevation: WidgetStatePropertyAll(4),
      ),
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.teal.shade400,
    scaffoldBackgroundColor: Colors.grey.shade900,
    colorScheme: ColorScheme.dark(
      primary: Colors.teal.shade400,
      secondary: Colors.teal.shade700,
      surface: Colors.grey.shade800,
      onPrimary: Colors.white,
      onSurface: Colors.white70,
    ),
    cardColor: Colors.grey.shade800,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white60, fontSize: 14),
      titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade400,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade700,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.teal.shade400, width: 2),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: Colors.white70),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade800),
        elevation: WidgetStatePropertyAll(4),
      ),
    ),
  );
}