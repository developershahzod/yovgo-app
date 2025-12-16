import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'http://localhost:8000';
  static const String subscriptionUrl = 'http://localhost:8002';
  static const String visitUrl = 'http://localhost:8004';
  
  static const String register = '/api/user/auth/register';
  static const String login = '/api/user/auth/login';
  static const String plans = '/plans';
  static const String subscriptions = '/subscriptions';
  static const String subscriptionStatus = '/subscriptions/status';
  static const String userCheckin = '/user-checkin';
  static const String visits = '/visits';
}

class AppColors {
  // YuvGo brand colors - Cyan/Turquoise theme
  static const primary = Color(0xFF00BCD4); // Bright cyan from logo
  static const primaryLight = Color(0xFF62EFFF); // Light cyan
  static const primaryDark = Color(0xFF008BA3); // Dark cyan
  static const accent = Color(0xFF00E5FF); // Bright turquoise accent
  
  // Background colors
  static const background = Color(0xFFF5F9FA); // Very light cyan tint
  static const cardBackground = Color(0xFFFFFFFF); // White cards
  
  // Text colors
  static const text = Color(0xFF1A1A1A); // Dark text
  static const textLight = Color(0xFF757575); // Gray text
  static const textMuted = Color(0xFF9E9E9E); // Muted gray
  
  // UI colors
  static const border = Color(0xFFE0E0E0); // Light border
  static const success = Color(0xFF4CAF50); // Green
  static const error = Color(0xFFF44336); // Red
  static const warning = Color(0xFFFF9800); // Orange
  static const iconGray = Color(0xFF616161); // Icon gray
  static const shadow = Color(0x1A000000); // Subtle shadow
  
  // Gradient colors for premium look
  static const gradientStart = Color(0xFF00BCD4);
  static const gradientEnd = Color(0xFF00E5FF);
}

class AppStrings {
  // App info
  static const appName = 'YuvGo';
  static const appTagline = 'Бесплатные мойки по подписке';
  static const appDescription = 'Подписка на автомойки';
  
  // Welcome screen
  static const welcome = 'Добро пожаловать в YuvGo!';
  static const welcomeSubtitle = 'Мойте машину бесплатно по подписке';
  
  // Features
  static const unlimitedWashes = 'Безлимитные мойки';
  static const easySubscription = 'Простая подписка';
  static const qrCheckIn = 'QR отметка';
}
