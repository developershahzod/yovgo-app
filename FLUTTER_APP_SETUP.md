# Flutter App Setup Guide

## 📱 YuvGo Flutter App

Полноценное мобильное приложение для пользователей на Flutter.

---

## 🎯 Функционал

### ✅ Основные возможности
- Регистрация и авторизация
- Выбор и управление подписками
- QR сканирование для регистрации визитов
- История визитов
- Карта автомоек
- Профиль пользователя
- Уведомления

### 🎨 UI/UX
- Современный дизайн в стиле iOS
- Анимации и переходы
- Темная/светлая тема
- Русский язык

---

## 📦 Структура проекта

```
flutter_app/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── theme.dart
│   │   └── routes.dart
│   ├── models/
│   │   ├── user.dart
│   │   ├── subscription.dart
│   │   └── visit.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── storage_service.dart
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
│       └── subscription_card.dart
├── pubspec.yaml
└── README.md
```

---

## 🔧 Установка

### 1. Создать Flutter проект

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
flutter create flutter_app
cd flutter_app
```

### 2. Добавить зависимости в pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  qr_code_scanner: ^1.0.1
  google_maps_flutter: ^2.5.0
  intl: ^0.18.1
  flutter_secure_storage: ^9.0.0
```

### 3. Установить зависимости

```bash
flutter pub get
```

---

## 🚀 Запуск

### iOS Simulator
```bash
flutter run -d ios
```

### Android Emulator
```bash
flutter run -d android
```

---

## 📝 API Endpoints

```
Base URL: http://localhost:8000

Auth:
- POST /api/user/auth/register
- POST /api/user/auth/login

Subscriptions:
- GET http://localhost:8002/plans
- POST http://localhost:8002/subscriptions
- GET http://localhost:8002/subscriptions/status

Visits:
- POST http://localhost:8004/user-checkin
- GET http://localhost:8004/visits?user_id={id}
```

---

## ✅ Готово!

После создания всех файлов запустите:

```bash
cd flutter_app
flutter run
```

**Автор:** Cascade AI  
**Дата:** 16 декабря 2024
