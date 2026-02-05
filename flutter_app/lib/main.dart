import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/app_theme.dart';
import 'services/api_service.dart';
import 'l10n/app_localizations.dart';
import 'l10n/language_provider.dart';
import 'screens/splash/splash_screen_fixed.dart';
import 'screens/onboarding/onboarding_screen_fixed.dart';
import 'screens/main_navigation_fixed.dart';
import 'screens/car_wash/car_wash_detail_screen_new.dart';
import 'screens/search/search_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/notifications/notifications_screen_pixel_perfect.dart';
import 'screens/home/home_screen_fixed.dart';
import 'screens/qr/qr_scanner_screen_fixed.dart';
import 'screens/subscriptions/subscription_screen_fixed.dart';
import 'screens/profile/profile_screen_fixed.dart';
import 'screens/saved/saved_screen_pixel_perfect.dart';
import 'screens/profile/payment_cards_screen.dart';
import 'screens/profile/cars_screen.dart';
import 'screens/profile/settings_screen.dart';
import 'screens/subscriptions/my_subscription_screen.dart';
import 'screens/subscriptions/subscription_plans_screen.dart';
import 'screens/subscriptions/subscription_detail_screen.dart';
import 'screens/weather/weather_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API service
  ApiService.initialize();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          title: 'YuvGO',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: languageProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingScreenFixed(),
            '/main': (context) => const MainNavigationFixed(initialIndex: 0),
            '/home': (context) => const MainNavigationFixed(initialIndex: 0),
            '/map': (context) => const MainNavigationFixed(initialIndex: 1),
            '/qr': (context) => const MainNavigationFixed(initialIndex: 2),
            '/subscriptions': (context) => const MainNavigationFixed(initialIndex: 3),
            '/profile': (context) => const MainNavigationFixed(initialIndex: 4),
            '/car-wash-detail': (context) => CarWashDetailScreenNew(),
            '/search': (context) => const SearchScreen(),
            '/checkout': (context) => const CheckoutScreen(),
            '/notifications': (context) => const NotificationsScreenPixelPerfect(),
            '/saved': (context) => const SavedScreenPixelPerfect(),
            '/payment-cards': (context) => const PaymentCardsScreen(),
            '/cars': (context) => const CarsScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/my-subscription': (context) => const MySubscriptionScreen(),
            '/subscription-plans': (context) => const SubscriptionPlansScreen(),
            '/subscription-detail': (context) => const SubscriptionDetailScreen(),
            '/weather': (context) => const WeatherScreen(),
          },
        );
      },
    );
  }
}
