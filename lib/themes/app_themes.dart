import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF4A766E);
  static const Color secondary = Color(0xFF00161B);
  static const Color accent = Color(0xFFA8BFBD);
  static const Color background = Color(0xFFF2F3F4);
  static const Color surface = Color(0xFFE1F5FF);
  static const Color text = Color(0xFF00161B);
  static const Color textLight = Color(0xFF6E7B7F);
  static const Color neutral = Color(0xFFBDC3C7);
  static const Color cream = Color(0xFFDCD6C1);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF4A766E);
  static const Color darkSecondary = Color(0xFF1E2D40);
  static const Color darkAccent = Color(0xFF8FA9A7);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE1E1E1);
  static const Color darkTextLight = Color(0xFFB0B0B0);
  static const Color darkNeutral = Color(0xFF404040);
}

class AppThemes {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.text,
    ),
    scaffoldBackgroundColor: AppColors.background,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.poppins(color: AppColors.primary),
      hintStyle: GoogleFonts.poppins(color: AppColors.textLight),
      prefixIconColor: AppColors.primary,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.neutral),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.text),
      bodyMedium: GoogleFonts.poppins(color: AppColors.text),
      titleLarge: GoogleFonts.poppins(color: AppColors.text),
      titleMedium: GoogleFonts.poppins(color: AppColors.text),
      titleSmall: GoogleFonts.poppins(color: AppColors.textLight),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.darkText,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.poppins(color: AppColors.darkPrimary),
      hintStyle: GoogleFonts.poppins(color: AppColors.darkTextLight),
      prefixIconColor: AppColors.darkPrimary,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkPrimary),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.darkNeutral),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.darkPrimary,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.darkText),
      bodyMedium: GoogleFonts.poppins(color: AppColors.darkText),
      titleLarge: GoogleFonts.poppins(color: AppColors.darkText),
      titleMedium: GoogleFonts.poppins(color: AppColors.darkText),
      titleSmall: GoogleFonts.poppins(color: AppColors.darkTextLight),
    ),
    cardTheme: CardTheme(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
