import 'package:flutter/material.dart';
import 'package:student_management/app/constant/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      // change the theme according to the user preference
      colorScheme: isDarkMode
          ? const ColorScheme.dark(primary: ThemeConstant.darkPrimaryColor)
          : const ColorScheme.light(primary: ThemeConstant.primaryColor),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: 'Montserrat',
      useMaterial3: true,

      // Change app bar color
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 171, 208, 172),
        centerTitle: true,
        titleTextStyle: TextStyle(color: Color.fromARGB(255, 234, 102, 102), fontSize: 20),
      ),

      // Scaffold theme
      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,

      // Change elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 76, 119, 175),
          textStyle: const TextStyle(fontSize: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Change text field theme
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 20),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeConstant.primaryColor),
        ),
      ),
      // Circular progress bar theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeConstant.primaryColor,
      ),
      //Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 171, 208, 172),
        selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.black, size: 30),
        
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
