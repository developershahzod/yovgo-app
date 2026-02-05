class AppConstants {
  // App Info
  static const String appName = 'YuvGO';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'http://localhost:8000/api';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Storage Keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_completed';
  static const String themeKey = 'app_theme';
  
  // QR Code
  static const int qrTokenTtlSeconds = 120;
  static const int visitCooldownHours = 4;
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  
  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;
  
  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radiusXxl = 24.0;
  static const double radiusFull = 100.0;
  
  // Icon Sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;
  
  // Image Sizes
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;
  static const double avatarXl = 96.0;
  
  // Card Heights
  static const double cardHeightSm = 80.0;
  static const double cardHeightMd = 120.0;
  static const double cardHeightLg = 160.0;
  
  // Bottom Navigation
  static const double bottomNavHeight = 80.0;
  
  // Map
  static const double defaultLatitude = 41.311081;
  static const double defaultLongitude = 69.240562;
  static const double defaultZoom = 13.0;
}
