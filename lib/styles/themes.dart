import 'package:flutter/material.dart';
import 'package:flutter_herodex_3000/styles/colors.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get appTheme {
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
