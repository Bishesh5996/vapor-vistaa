import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.deepPurple,
    primaryColor: const Color(0xFF6C47FF), // Deep purple
    scaffoldBackgroundColor: const Color(0xFFF5F6FA), // Light background
    fontFamily: 'Opensans Regular',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6C47FF),
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF26E5A6),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6C47FF),
        side: const BorderSide(color: Color(0xFF6C47FF)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6C47FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF26E5A6), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFF6C47FF)),
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(
      secondary: const Color(0xFF26E5A6),
    ),
  );
}