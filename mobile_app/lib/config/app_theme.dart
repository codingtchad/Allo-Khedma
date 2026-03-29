import 'package:flutter/material.dart';

class AppTheme {
  // Palette de couleurs DaliPro
  static const Color primary = Color(0xFFC96E12);
  static const Color primaryDark = Color(0xFFA5570D);
  static const Color accent = Color(0xFFF3C892);
  static const Color background = Color(0xFFFFF8F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color success = Color(0xFF2E9B57);
  static const Color error = Color(0xFFD64545);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: textSecondary, fontSize: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      iconTheme: IconThemeData(
        color: primary,
        size: 24,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          color: textSecondary,
          fontSize: 12,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
