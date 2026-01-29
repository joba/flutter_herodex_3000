import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get darkTheme {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.appBackground,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        color: AppColors.primary,
        fontWeight: FontWeight.w300,
      ),
      bodyLarge: GoogleFonts.inter(color: AppColors.textPrimary),
      bodyMedium: GoogleFonts.inter(color: AppColors.textPrimary),
      displayMedium: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 16,
      ),
      titleLarge: GoogleFonts.inter(color: Colors.grey[50]),
      titleMedium: GoogleFonts.inter(color: Colors.grey[50]),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size.fromHeight(48), // Full width + 48px height
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    useMaterial3: true,
  );
}

ThemeData get lightTheme {
  return ThemeData(
    scaffoldBackgroundColor: Colors.grey[200],
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: Colors.red[700]!,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black87,
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.inter(
        color: AppColors.primary,
        fontWeight: FontWeight.w300,
      ),
      bodyLarge: GoogleFonts.inter(color: Colors.black87),
      bodyMedium: GoogleFonts.inter(color: Colors.black87),
      displayMedium: GoogleFonts.inter(color: Colors.grey[50], fontSize: 16),
      titleLarge: GoogleFonts.inter(color: Colors.grey[50]),
      titleMedium: GoogleFonts.inter(color: Colors.black87),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    ),
    useMaterial3: true,
  );
}
