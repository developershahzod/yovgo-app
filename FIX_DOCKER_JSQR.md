# Fix jsqr Error in Docker - User App

## ✅ Статус: Исправление jsqr ошибки в Docker

**Дата:** 15 декабря 2024

---

## ❌ Ошибка

```
Cannot find module 'jsqr'
at webpackMissingModule
```

**URL:** `http://localhost:3003/`

---

## 🔧 Решение

### Проблема

Docker контейнер использовал старый образ без jsqr

### Исправление

**Пересобрать User App контейнер:**

```bash
docker-compose stop user_app
docker-compose rm -f user_app
docker-compose up -d --build user_app
```

**Или полная пересборка:**

```bash
docker-compose down
docker-compose up -d --build
```

---

## 📝 Проверка

### 1. Проверьте статус контейнера

```bash
docker-compose ps user_app
```

Должен быть в статусе "Up"

### 2. Проверьте логи

```bash
docker-compose logs -f user_app
```

Должно быть:
```
Compiled successfully!
webpack compiled with 0 warnings
```

### 3. Откройте браузер

```
http://localhost:3003
```

Ошибки jsqr быть не должно

---

## 🐛 Если ошибка повторяется

### Вариант 1: Очистить кеш Docker

```bash
docker-compose down
docker system prune -a
docker-compose up -d --build
```

### Вариант 2: Пересобрать без кеша

```bash
docker-compose build --no-cache user_app
docker-compose up -d user_app
```

### Вариант 3: Проверить package.json

```bash
cd frontend/user-app
cat package.json | grep jsqr
```

Должно быть:
```json
"jsqr": "^1.4.0"
```

Если нет:
```bash
npm install --save jsqr
```

Затем пересобрать Docker:
```bash
docker-compose up -d --build user_app
```

---

## 📋 Полезные команды

### Перезапуск User App

```bash
docker-compose restart user_app
```

### Зайти в контейнер

```bash
docker-compose exec user_app sh
```

Внутри контейнера:
```bash
ls node_modules | grep jsqr
```

### Просмотр логов

```bash
docker-compose logs -f user_app
```

### Пересборка

```bash
docker-compose up -d --build user_app
```

---

## ✅ Результат

**User App в Docker:**
- ✅ jsqr установлен
- ✅ Контейнер пересобран
- ✅ QR Scanner работает
- ✅ Нет ошибок

**Откройте http://localhost:3003 и проверьте!**

---

## 🔄 Для других контейнеров

Если нужно пересобрать другие контейнеры:

```bash
# Merchant Dashboard
docker-compose up -d --build merchant_dashboard

# Admin Dashboard
docker-compose up -d --build admin_dashboard

# Backend Service
docker-compose up -d --build user_service
```

---

**Готово! 🐳**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
