# 📱 YuvGo Flutter App

Мобильное приложение для пользователей YuvGo - сервиса подписок на автомойки.

---

## ⏳ Статус установки Flutter

**Текущий процесс:**
```
✓ Скачивание Flutter SDK - 100%
⏳ Установка Flutter...
```

**Команда выполняется:**
```bash
brew install --cask flutter
```

---

## 🚀 После установки Flutter

### 1. Проверить установку

```bash
flutter doctor
```

### 2. Создать проект

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
./create_flutter_app.sh
```

### 3. Запустить

```bash
cd flutter_app
flutter run
```

---

## 📱 Функционал приложения

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
- Плавные анимации и переходы
- Поддержка темной/светлой темы
- Русский язык интерфейса

---

## 🔌 API Integration

### Backend Services
- **User Service:** `http://localhost:8000`
- **Subscription Service:** `http://localhost:8002`
- **Visit Service:** `http://localhost:8004`

### Endpoints
```
Auth:
- POST /api/user/auth/register
- POST /api/user/auth/login

Subscriptions:
- GET /plans
- POST /subscriptions
- GET /subscriptions/status

Visits:
- POST /user-checkin
- GET /visits?user_id={id}
```

---

## 📦 Зависимости

```yaml
dependencies:
  # UI
  cupertino_icons: ^1.0.6
  google_fonts: ^6.1.0
  
  # State Management
  provider: ^6.1.1
  
  # HTTP & API
  http: ^1.1.0
  dio: ^5.4.0
  
  # Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0
  
  # QR Code
  qr_code_scanner: ^1.0.1
  qr_flutter: ^4.1.0
  
  # Maps
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
```

---

## 🛠️ Разработка

### Запуск на разных платформах

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Web Browser
flutter run -d chrome
```

### Сборка для продакшена

```bash
# iOS
flutter build ios

# Android
flutter build apk

# Web
flutter build web
```

---

## 📁 Структура проекта

```
lib/
├── main.dart                    # Точка входа
├── config/
│   ├── theme.dart              # Тема приложения
│   ├── routes.dart             # Маршруты
│   └── constants.dart          # Константы API
├── models/
│   ├── user.dart               # Модель пользователя
│   ├── subscription.dart       # Модель подписки
│   ├── plan.dart               # Модель плана
│   └── visit.dart              # Модель визита
├── services/
│   ├── api_service.dart        # HTTP клиент
│   ├── auth_service.dart       # Авторизация
│   └── storage_service.dart    # Локальное хранилище
├── providers/
│   ├── auth_provider.dart      # State management
│   └── subscription_provider.dart
├── screens/
│   ├── auth/
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── subscriptions/
│   │   └── subscriptions_screen.dart
│   ├── qr/
│   │   └── qr_scanner_screen.dart
│   ├── visits/
│   │   └── visit_history_screen.dart
│   ├── map/
│   │   └── map_screen.dart
│   └── profile/
│       └── profile_screen.dart
└── widgets/
    ├── bottom_nav.dart
    ├── subscription_card.dart
    └── custom_button.dart
```

---

## 📚 Документация

- **Полный код:** `FLUTTER_APP_COMPLETE_CODE.md`
- **Установка:** `FLUTTER_INSTALLATION_GUIDE.md`
- **Setup:** `FLUTTER_APP_SETUP.md`

---

## ✅ Готово к запуску!

После завершения установки Flutter:

```bash
./create_flutter_app.sh
cd flutter_app
flutter run
```

---

**Автор:** Cascade AI  
**Дата:** 16 декабря 2024  
**Версия:** 1.0.0
