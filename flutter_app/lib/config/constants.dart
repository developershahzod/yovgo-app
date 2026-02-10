import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'https://app.yuvgo.uz';
  
  // Auth
  static const String register = '/api/user/auth/register';
  static const String login = '/api/user/auth/login';
  static const String verifyOtp = '/api/user/auth/verify-otp';
  static const String me = '/api/user/me';
  
  // Users
  static const String users = '/api/user/users';
  static const String vehicles = '/api/user/vehicles';
  static const String savedCarWashes = '/api/user/saved';
  
  // Subscriptions
  static const String plans = '/api/subscription/plans';
  static const String subscriptions = '/api/subscription/subscriptions';
  static const String subscriptionStatus = '/api/subscription/subscriptions/status';
  
  // Partners (Car Washes)
  static const String partners = '/api/partner/partners';
  static const String locations = '/api/partner/locations';
  
  // Visits
  static const String visits = '/api/visit/visits';
  static const String visitStats = '/api/visit/visits/stats';
  static const String qrValidate = '/api/visit/qr/validate';
  static const String qrScan = '/api/visit/qr/scan';
  
  // Notifications
  static const String notifications = '/api/notification/notifications';
  
  // Payment
  static const String createPayment = '/api/payment/ipakyuli/create-payment';
  static const String paymentStatus = '/api/payment/ipakyuli/status';
  static const String contracts = '/api/payment/ipakyuli/contracts';
  
  // Weather
  static const String weather = '/api/weather';
}

class AppColors {
  // YuvGo brand colors - Cyan/Turquoise theme (matching design)
  static const primary = Color(0xFF00BCD4); // Bright cyan/turquoise
  static const primaryLight = Color(0xFF4DD0E1); // Light cyan
  static const primaryDark = Color(0xFF0097A7); // Dark cyan
  static const accent = Color(0xFF9C27B0); // Purple accent
  
  // Background colors
  static const background = Color(0xFFF5F5F7); // Light gray background
  static const cardBackground = Color(0xFFFFFFFF); // White cards
  
  // Text colors
  static const text = Color(0xFF1F1F1F); // Almost black
  static const textLight = Color(0xFF757575); // Medium gray
  static const textMuted = Color(0xFFBDBDBD); // Light gray
  
  // UI colors
  static const border = Color(0xFFEEEEEE); // Very light border
  static const success = Color(0xFF4CAF50); // Green
  static const successLight = Color(0xFFE8F5E9); // Light green background
  static const error = Color(0xFFF44336); // Red
  static const warning = Color(0xFFFF9800); // Orange
  static const iconGray = Color(0xFF9E9E9E); // Icon gray
  static const shadow = Color(0x1A000000); // Subtle shadow
  
  // Special colors
  static const darkButton = Color(0xFF1F2937); // Dark navy button
  static const activeGreen = Color(0xFF10B981); // Active status green
  static const activeGreenBg = Color(0xFFD1FAE5); // Active status background
  
  // Gradient colors
  static const gradientStart = Color(0xFF00BCD4);
  static const gradientEnd = Color(0xFF9C27B0);
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
