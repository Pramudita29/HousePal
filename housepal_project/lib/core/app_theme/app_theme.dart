import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    fontFamily: 'Poppins', // Set Poppins as the default font
    primaryColor: const Color(0xFF459D7A), // Accent color for buttons, etc.
    scaffoldBackgroundColor: Colors.white, // Background color for the app
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white, // AppBar background color
      elevation: 0, // Remove shadow from the AppBar
      iconTheme: IconThemeData(color: Colors.black), // AppBar icons color
      titleTextStyle: TextStyle(
        color: Colors.black, // AppBar title text color
        fontWeight: FontWeight.bold,
        fontSize: 20, // AppBar title font size
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, // Large font for headlines or key titles
        fontWeight: FontWeight.bold,
        color: Colors.black, // Using black for primary text
      ),
      displayMedium: TextStyle(
        fontSize: 24, // Medium-sized text for sub-headings
        fontWeight: FontWeight.bold,
        color: Colors.black, // Keeping color consistent
      ),
      bodyLarge: TextStyle(
        fontSize: 16, // Regular body text size
        color: Colors.black, // Regular black for body text
      ),
      bodyMedium: TextStyle(
        fontSize: 14, // Text for less important details
        color: Colors.black, // Regular black
      ),
      titleMedium: TextStyle(
        fontSize: 18, // Title font size for smaller headings
        fontWeight: FontWeight.w500,
        color: Colors.black, // Regular black
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF459D7A), // Button background color
      textTheme: ButtonTextTheme.primary, // Button text color
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Button text color
        backgroundColor: const Color(0xFF459D7A), // Button background color
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF459D7A),
        side: const BorderSide(color: Color(0xFF459D7A)), // Border color
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color(0xFF459D7A)), // Focused border color
      ),
      labelStyle: TextStyle(
        color: Colors.black, // Label text color for inputs
      ),
      hintStyle: TextStyle(
        color: Colors.black45, // Light gray for hint text
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF459D7A), // Secondary color for accent
    ),
  );
}
