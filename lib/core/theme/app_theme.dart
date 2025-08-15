import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.accent,
        onPrimary: AppColors.onPrimary,
        onSecondary: AppColors.onSecondary,
        onSurface: AppColors.secondary,
        onError: AppColors.surface,
        brightness: Brightness.light,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.cardColor,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.dancingScript(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.onPrimary,
          fontStyle: FontStyle.italic,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        // Display styles for large headings
        displayLarge: GoogleFonts.dancingScript(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
          letterSpacing: -0.5,
          fontStyle: FontStyle.italic,
        ),
        displayMedium: GoogleFonts.dancingScript(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
          letterSpacing: -0.25,
          fontStyle: FontStyle.italic,
        ),
        displaySmall: GoogleFonts.dancingScript(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),

        // Headline styles
        headlineLarge: GoogleFonts.dancingScript(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        headlineMedium: GoogleFonts.dancingScript(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        headlineSmall: GoogleFonts.dancingScript(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),

        // Title styles
        titleLarge: GoogleFonts.dancingScript(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        titleMedium: GoogleFonts.dancingScript(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        titleSmall: GoogleFonts.dancingScript(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),

        // Body styles - using a more readable font for body text
        bodyLarge: GoogleFonts.lora(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        bodyMedium: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        bodySmall: GoogleFonts.lora(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.secondary.withValues(alpha: 0.7),
          fontStyle: FontStyle.italic,
        ),

        // Label styles
        labelLarge: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        labelMedium: GoogleFonts.lora(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary,
          fontStyle: FontStyle.italic,
        ),
        labelSmall: GoogleFonts.lora(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary.withValues(alpha: 0.7),
          fontStyle: FontStyle.italic,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.accent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        labelStyle: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.secondary.withValues(alpha: 0.7),
          fontStyle: FontStyle.italic,
        ),
        hintStyle: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.secondary.withValues(alpha: 0.5),
          fontStyle: FontStyle.italic,
        ),
        errorStyle: GoogleFonts.lora(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.accent,
          fontStyle: FontStyle.italic,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.dancingScript(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.dancingScript(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.dancingScript(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.secondary,
        contentTextStyle: GoogleFonts.lora(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.onSecondary,
          fontStyle: FontStyle.italic,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: AppColors.primary, size: 24),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // Custom text styles for specific use cases
  static TextStyle get authTitleStyle => GoogleFonts.dancingScript(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
    letterSpacing: -0.5,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get authSubtitleStyle => GoogleFonts.lora(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.secondary.withValues(alpha: 0.7),
    height: 1.5,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get buttonTextStyle => GoogleFonts.dancingScript(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get linkTextStyle => GoogleFonts.dancingScript(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontStyle: FontStyle.italic,
  );

  // Additional girlish font styles
  static TextStyle get girlishHeadingStyle => GoogleFonts.greatVibes(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
    letterSpacing: 1.0,
  );

  static TextStyle get girlishSubheadingStyle => GoogleFonts.greatVibes(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary,
    letterSpacing: 0.5,
  );

  static TextStyle get elegantBodyStyle => GoogleFonts.playfairDisplay(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.secondary,
    fontStyle: FontStyle.italic,
    height: 1.6,
  );
}
