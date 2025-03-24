import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const lightPrimary = Color(0xFF2196F3); // Blue
  static const lightBackground = Color(0xFFFFFFFF); // White
  static const lightSurface = Color(0xFFF5F5F5); // Light Grey
  static const lightText = Color(0xFF1A1A1A); // Near Black
  static const lightSecondaryText = Color(0xFF757575); // Grey

  // Dark Theme Colors
  static const darkPrimary = Color(0xFF64B5F6); // Light Blue
  static const darkBackground = Color(0xFF121212); // Dark Grey
  static const darkSurface = Color(0xFF1E1E1E); // Slightly lighter Dark Grey
  static const darkText = Color(0xFFFFFFFF); // White
  static const darkSecondaryText = Color(0xFFB3B3B3); // Light Grey
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightPrimary.withOpacity(0.8),
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      onBackground: AppColors.lightText,
      onSurface: AppColors.lightText,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightText),
      titleTextStyle: TextStyle(
        color: AppColors.lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightText),
      bodyMedium: TextStyle(color: AppColors.lightText),
      titleMedium: TextStyle(color: AppColors.lightSecondaryText),
    ),
    iconTheme: IconThemeData(
      color: AppColors.lightText,
    ),
    cardTheme: CardTheme(
      color: AppColors.lightBackground,
      elevation: 2,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkPrimary.withOpacity(0.8),
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onBackground: AppColors.darkText,
      onSurface: AppColors.darkText,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkText),
      titleTextStyle: TextStyle(
        color: AppColors.darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText),
      titleMedium: TextStyle(color: AppColors.darkSecondaryText),
    ),
    iconTheme: IconThemeData(
      color: AppColors.darkText,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 2,
    ),
  );
}
