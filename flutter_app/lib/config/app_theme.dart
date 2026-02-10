import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Exact colors from Figma/React prototype
  static const Color primaryCyan = Color(0xFF00BFFE);
  static const Color darkNavy = Color(0xFF03142A);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color textPrimary = Color(0xFF0A0C13);
  static const Color textSecondary = Color(0xFF646D79);
  static const Color textTertiary = Color(0xFF8F96A0);
  static const Color yellow = Color(0xFFFFD600);
  static const Color green = Color(0xFF5CCC27);
  static const Color red = Color(0xFFFC3E3E);
  static const Color orange = Color(0xFFFC941A);
  static const Color blue = Color(0xFF1D99F2);
  static const Color lightGray = Color(0xFFF0F4F9);
  static const Color cardBg = Color(0xFFF2F2F2);
  static const Color borderGray = Color(0xFFD9DDE3);
  static const Color overlayDark = Color(0x99000000);
  static const Color premiumGold = Color(0xFFFFD600);
  
  // Additional exact colors from React prototype
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x0A000000);
  static const Color lightCyan = Color(0xFFE5F9FF);
  static const Color lightGreen = Color(0xFFEEFFE7);
  static const Color lightRed = Color(0xFFFFEBEB);
  static const Color premiumCardBg = Color(0xFFFFEEEA);

  static TextStyle mulish({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.mulish(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryCyan,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: primaryCyan,
        secondary: darkNavy,
        surface: white,
        error: red,
      ),
      fontFamily: GoogleFonts.mulish().fontFamily,
      textTheme: GoogleFonts.mulishTextTheme().copyWith(
        displayLarge: GoogleFonts.mulish(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.mulish(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.mulish(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.mulish(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.mulish(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.mulish(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.mulish(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.mulish(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
        labelLarge: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.mulish(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkNavy,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.mulish(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryCyan, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.mulish(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textTertiary,
        ),
      ),
    );
  }

  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      );

  static List<BoxShadow> get cardShadows => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 6,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  static BoxShadow get buttonShadow => BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: const Offset(0, 2),
      );
}
