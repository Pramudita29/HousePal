import 'package:flutter/material.dart';
import 'package:housepal_project/app/constants/theme_constant.dart';

class AppTheme {
  AppTheme._();

  static ThemeData getApplicationTheme({required bool isDarkMode}) {
    final Color primaryColor = isDarkMode
        ? ThemeConstant.darkPrimaryColor
        : ThemeConstant.lightPrimaryColor;

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: isDarkMode
          ? ThemeConstant.darkBackgroundColor
          : ThemeConstant.lightBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode
            ? ThemeConstant.darkAppBarColor
            : ThemeConstant.lightAppBarColor,
        foregroundColor: isDarkMode
            ? ThemeConstant.darkTextColor
            : ThemeConstant.lightTextColor,
        titleTextStyle: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 24,
        ),
        displaySmall: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkSecondaryTextColor
              : ThemeConstant.lightSecondaryTextColor,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: isDarkMode
              ? ThemeConstant.darkTextColor
              : ThemeConstant.lightTextColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green, // Matches your 0xFF459D7A approximately
      ).copyWith(
        primary: primaryColor,
        secondary: primaryColor,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        onPrimary: isDarkMode
            ? ThemeConstant.darkTextColor
            : ThemeConstant.lightTextColor,
        onSurface: isDarkMode
            ? ThemeConstant.darkTextColor
            : ThemeConstant.lightTextColor,
      ),
      // Customize ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return Colors.white; // Always white text for ElevatedButton
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return primaryColor; // Use the primary color for the button background
            },
          ),
        ),
      ),
    );
  }
}
