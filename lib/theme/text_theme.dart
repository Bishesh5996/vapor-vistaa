import 'package:flutter/material.dart';

class CustomTextTheme {
  static TextTheme get openSans => const TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),

    titleLarge: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    titleSmall: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),

    labelLarge: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      fontStyle: FontStyle.italic,
    ),
    labelMedium: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 12,
      fontStyle: FontStyle.italic,
    ),
    labelSmall: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 10,
      fontStyle: FontStyle.italic,
    ),
  );
}
