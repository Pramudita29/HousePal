import 'package:flutter/material.dart';
import 'package:housepal_project/app/constants/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static const primaryColor = Color(0xFF459D7A); // Example: your primary color

  static getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      // Change the theme according to the user preference
      colorScheme: isDarkMode
          ? const ColorScheme.dark(
              primary: ThemeConstant.darkPrimaryColor,
            )
          : const ColorScheme.light(
              primary: Color(0xFF459D7A), // Accent color
            ),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: 'Poppins', // Set Poppins as the default font
      useMaterial3: true,

      // Change app bar color
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white, // AppBar background color
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black, // AppBar title text color
          fontSize: 20,
        ),
      ),

      // Change elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF459D7A), // Button background color
          textStyle: const TextStyle(
            fontSize: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Change text field theme
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(
          fontSize: 20,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF459D7A), // Focused border color
          ),
        ),
      ),

      // Circular progress bar theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF459D7A), // Progress bar color
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF459D7A), // Bottom nav selected item color
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
