import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF00A3E0);
  static const Color primaryDark = Color(0xFF0077B6);
  static const Color primaryLight = Color(0xFF4FC3F7);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF1A1A2E);
  static const Color secondaryLight = Color(0xFF16213E);
  
  // Accent Colors
  static const Color accent = Color(0xFFFFD700);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentOrange = Color(0xFFFF9800);
  
  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1A1A2E);
  static const Color backgroundCard = Color(0xFFFFFFFF);
  
  // Surface Colors
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color surfaceDark = Color(0xFF2D2D44);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF111827);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);
  
  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color borderDark = Color(0xFFD1D5DB);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00A3E0), Color(0xFF0077B6)],
  );
  
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00A3E0), Color(0xFF0052CC)],
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
  );
  
  // Weather Rating Colors
  static const Color ratingExcellent = Color(0xFF10B981);
  static const Color ratingGood = Color(0xFF84CC16);
  static const Color ratingFair = Color(0xFFFBBF24);
  static const Color ratingPoor = Color(0xFFF97316);
  static const Color ratingBad = Color(0xFFEF4444);
  
  // Category Colors
  static const Color categoryPremium = Color(0xFF8B5CF6);
  static const Color categoryStandard = Color(0xFF3B82F6);
  static const Color categoryExpress = Color(0xFF10B981);
  static const Color categorySelf = Color(0xFFF59E0B);
  
  // Shadow
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  
  // Divider
  static const Color divider = Color(0xFFE5E7EB);
  
  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
  
  // Shimmer
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  
  // Bottom Navigation
  static const Color navActive = Color(0xFF00A3E0);
  static const Color navInactive = Color(0xFF9CA3AF);
  
  // QR Scanner
  static const Color qrFrame = Color(0xFF00A3E0);
  static const Color qrBackground = Color(0xFF000000);
}
