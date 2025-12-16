# 📱 Flutter Installation & Setup Guide

## 🔧 Установка Flutter

### Вариант 1: Homebrew (Рекомендуется для macOS)

```bash
# Установка Flutter
brew install --cask flutter

# Проверка установки
flutter doctor

# Принять лицензии Android
flutter doctor --android-licenses
```

### Вариант 2: Ручная установка

1. **Скачать Flutter SDK:**
   ```bash
   cd ~/development
   git clone https://github.com/flutter/flutter.git -b stable
   ```

2. **Добавить в PATH:**
   ```bash
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Проверить:**
   ```bash
   flutter doctor
   ```

---

## ⏳ Текущий статус

```bash
# Установка Flutter через Homebrew запущена...
# Это займет 5-10 минут
```

**Команда выполняется:**
```bash
brew install --cask flutter
```

---

## 📋 После установки Flutter

### 1. Проверить установку

```bash
flutter doctor
```

**Должно показать:**
```
✓ Flutter (Channel stable, 3.x.x)
✓ Android toolchain
✓ Xcode
✓ Chrome
```

### 2. Создать Flutter проект

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
./create_flutter_app.sh
```

### 3. Запустить приложение

```bash
cd flutter_app
flutter run
```

---

## 🛠️ Устранение проблем

### Проблема: Flutter не найден после установки

**Решение:**
```bash
# Перезагрузить терминал
source ~/.zshrc

# Или добавить в PATH вручную
export PATH="$PATH:/Applications/Flutter/flutter/bin"
```

### Проблема: Android licenses

**Решение:**
```bash
flutter doctor --android-licenses
# Нажать 'y' для всех лицензий
```

### Проблема: Xcode не настроен

**Решение:**
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

---

## ✅ Проверка готовности

Выполните команду:
```bash
flutter doctor -v
```

**Все должно быть ✓:**
- ✓ Flutter SDK
- ✓ Android toolchain
- ✓ Xcode
- ✓ VS Code / Android Studio
- ✓ Connected device

---

## 🚀 Быстрый старт после установки

```bash
# 1. Перейти в директорию проекта
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi

# 2. Создать Flutter app
./create_flutter_app.sh

# 3. Перейти в flutter_app
cd flutter_app

# 4. Запустить на iOS
flutter run -d ios

# Или на Android
flutter run -d android

# Или в браузере
flutter run -d chrome
```

---

## 📱 Альтернатива: React Native

Если Flutter установка не работает, можно использовать React Native:

```bash
# Установить React Native CLI
npm install -g react-native-cli

# Создать проект
npx react-native init YuvGoApp

# Запустить
cd YuvGoApp
npx react-native run-ios
```

---

## ⏰ Ожидание установки

**Текущий процесс:**
- ⏳ Установка Flutter через Homebrew
- ⏳ Скачивание SDK (~1-2 GB)
- ⏳ Настройка окружения

**Примерное время:** 5-10 минут

**После завершения:**
```bash
flutter doctor
./create_flutter_app.sh
```

---

**Автор:** Cascade AI  
**Дата:** 16 декабря 2024
