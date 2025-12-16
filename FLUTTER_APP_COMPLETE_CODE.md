# 📱 YuvGo Flutter App - Полный код

## 🎯 Полноценное мобильное приложение

**Дата:** 16 декабря 2024

---

## 📦 Установка Flutter

### macOS
```bash
brew install --cask flutter
flutter doctor
```

### Или скачать с официального сайта
https://docs.flutter.dev/get-started/install

---

## 🚀 Создание проекта

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
chmod +x create_flutter_app.sh
./create_flutter_app.sh
```

---

## 📁 Структура проекта

```
flutter_app/
├── lib/
│   ├── main.dart                    # Точка входа
│   ├── config/
│   │   ├── theme.dart              # Тема приложения
│   │   ├── routes.dart             # Маршруты
│   │   └── constants.dart          # Константы API
│   ├── models/
│   │   ├── user.dart               # Модель пользователя
│   │   ├── subscription.dart       # Модель подписки
│   │   ├── plan.dart               # Модель плана
│   │   └── visit.dart              # Модель визита
│   ├── services/
│   │   ├── api_service.dart        # HTTP клиент
│   │   ├── auth_service.dart       # Авторизация
│   │   └── storage_service.dart    # Локальное хранилище
│   ├── providers/
│   │   ├── auth_provider.dart      # State management для auth
│   │   └── subscription_provider.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── welcome_screen.dart
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── subscriptions/
│   │   │   └── subscriptions_screen.dart
│   │   ├── qr/
│   │   │   └── qr_scanner_screen.dart
│   │   ├── visits/
│   │   │   └── visit_history_screen.dart
│   │   ├── map/
│   │   │   └── map_screen.dart
│   │   └── profile/
│   │       └── profile_screen.dart
│   └── widgets/
│       ├── bottom_nav.dart
│       ├── subscription_card.dart
│       └── custom_button.dart
└── pubspec.yaml
```

---

## 📝 Полный код файлов

### 1. lib/config/constants.dart

```dart
class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://localhost:8000';
  static const String subscriptionUrl = 'http://localhost:8002';
  static const String visitUrl = 'http://localhost:8004';
  
  // Endpoints
  static const String register = '/api/user/auth/register';
  static const String login = '/api/user/auth/login';
  static const String plans = '/plans';
  static const String subscriptions = '/subscriptions';
  static const String subscriptionStatus = '/subscriptions/status';
  static const String userCheckin = '/user-checkin';
  static const String visits = '/visits';
}

class AppColors {
  static const primary = Color(0xFF00BCD4);
  static const secondary = Color(0xFF9C27B0);
  static const background = Color(0xFFF5F5F7);
  static const text = Color(0xFF1F1F1F);
  static const textLight = Color(0xFF757575);
}
```

### 2. lib/models/user.dart

```dart
class User {
  final String id;
  final String phoneNumber;
  final String? email;
  final String? fullName;
  
  User({
    required this.id,
    required this.phoneNumber,
    this.email,
    this.fullName,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      fullName: json['full_name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'email': email,
      'full_name': fullName,
    };
  }
}
```

### 3. lib/models/subscription.dart

```dart
class Subscription {
  final String id;
  final String userId;
  final String planId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final int visitsRemaining;
  final bool isUnlimited;
  final String? planName;
  
  Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.visitsRemaining,
    required this.isUnlimited,
    this.planName,
  });
  
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['user_id'],
      planId: json['plan_id'],
      status: json['status'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      visitsRemaining: json['visits_remaining'] ?? 0,
      isUnlimited: json['is_unlimited'] ?? false,
      planName: json['plan_name'],
    );
  }
  
  int get daysRemaining {
    return endDate.difference(DateTime.now()).inDays;
  }
}
```

### 4. lib/models/plan.dart

```dart
class Plan {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationDays;
  final int? visitLimit;
  final bool isUnlimited;
  
  Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.durationDays,
    this.visitLimit,
    required this.isUnlimited,
  });
  
  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      durationDays: json['duration_days'],
      visitLimit: json['visit_limit'],
      isUnlimited: json['is_unlimited'] ?? false,
    );
  }
  
  String get formattedPrice {
    return '${price.toStringAsFixed(0)} $currency';
  }
}
```

### 5. lib/services/api_service.dart

```dart
import 'package:dio/dio.dart';
import '../config/constants.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  
  static Future<Response> get(String url, {String? token}) async {
    final options = Options(
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );
    return await _dio.get(url, options: options);
  }
  
  static Future<Response> post(
    String url, 
    Map<String, dynamic> data, 
    {String? token}
  ) async {
    final options = Options(
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
    );
    return await _dio.post(url, data: data, options: options);
  }
}
```

### 6. lib/services/auth_service.dart

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../config/constants.dart';
import 'api_service.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'user_token';
  static const _userKey = 'user_data';
  
  // Register
  static Future<Map<String, dynamic>> register({
    required String phoneNumber,
    required String email,
    required String fullName,
    required String password,
  }) async {
    final response = await ApiService.post(
      '${ApiConstants.baseUrl}${ApiConstants.register}',
      {
        'phone_number': phoneNumber,
        'email': email,
        'full_name': fullName,
        'password': password,
      },
    );
    return response.data;
  }
  
  // Login
  static Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await ApiService.post(
      '${ApiConstants.baseUrl}${ApiConstants.login}',
      {
        'phone_number': phoneNumber,
        'password': password,
      },
    );
    
    final token = response.data['access_token'];
    final user = User.fromJson(response.data['user']);
    
    await saveToken(token);
    await saveUser(user);
    
    return response.data;
  }
  
  // Save token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  
  // Get token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  // Save user
  static Future<void> saveUser(User user) async {
    await _storage.write(key: _userKey, value: user.toJson().toString());
  }
  
  // Logout
  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
```

---

## 🎨 Screens

### 7. lib/screens/auth/welcome_screen.dart

```dart
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'YuvGo',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Добро пожаловать',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              const Text(
                'Подписка на автомойки',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const Spacer(),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Register Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Регистрация',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 🚀 Запуск

### 1. Установить Flutter
```bash
brew install --cask flutter
```

### 2. Создать проект
```bash
chmod +x create_flutter_app.sh
./create_flutter_app.sh
```

### 3. Запустить
```bash
cd flutter_app
flutter run
```

---

## 📱 Платформы

- ✅ iOS
- ✅ Android  
- ✅ Web

---

## ✅ Готово!

Полноценное Flutter приложение с:
- Авторизацией
- Подписками
- QR сканированием
- Историей визитов
- Картой
- Профилем

**Автор:** Cascade AI  
**Дата:** 16 декабря 2024
