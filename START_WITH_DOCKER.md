# Start Project with Docker

## 🐳 Запуск проекта в Docker

**Дата:** 15 декабря 2024

---

## 📋 Предварительные требования

### 1. Запустите Docker Desktop

**Важно:** Docker daemon должен быть запущен!

**Проверка:**
```bash
docker ps
```

Если ошибка "Cannot connect to Docker daemon":
- Откройте Docker Desktop
- Дождитесь полного запуска (зеленый индикатор)

---

## 🚀 Запуск проекта

### Шаг 1: Остановите локальные процессы

```bash
./stop_all_services.sh
```

### Шаг 2: Запустите Docker Compose

```bash
docker-compose up -d --build
```

**Флаги:**
- `-d` - detached mode (в фоне)
- `--build` - пересобрать образы

### Шаг 3: Проверьте статус

```bash
docker-compose ps
```

---

## 📱 Доступ к приложениям

### Frontend

```
Admin Dashboard:    http://localhost:3000
Merchant Dashboard: http://localhost:3001
User App:           http://localhost:3003
```

### Backend API

```
User Service:         http://localhost:8000
Admin Service:        http://localhost:8001
Subscription Service: http://localhost:8002
Partner Service:      http://localhost:8003
```

### API Documentation

```
User Service:         http://localhost:8000/docs
Admin Service:        http://localhost:8001/docs
Subscription Service: http://localhost:8002/docs
Partner Service:      http://localhost:8003/docs
```

---

## 📋 Полезные команды

### Просмотр логов

**Все сервисы:**
```bash
docker-compose logs -f
```

**Конкретный сервис:**
```bash
docker-compose logs -f user_service
docker-compose logs -f admin_dashboard
```

### Перезапуск

**Все сервисы:**
```bash
docker-compose restart
```

**Конкретный сервис:**
```bash
docker-compose restart user_service
```

### Остановка

**Все сервисы:**
```bash
docker-compose down
```

**С удалением volumes:**
```bash
docker-compose down -v
```

### Пересборка

**Пересобрать и запустить:**
```bash
docker-compose up -d --build
```

**Пересобрать без кеша:**
```bash
docker-compose build --no-cache
docker-compose up -d
```

---

## 🔧 Управление контейнерами

### Список контейнеров

```bash
docker-compose ps
```

### Зайти в контейнер

```bash
docker-compose exec user_service bash
docker-compose exec admin_dashboard sh
```

### Просмотр ресурсов

```bash
docker stats
```

---

## 🐛 Решение проблем

### Docker daemon не запущен

**Ошибка:**
```
Cannot connect to the Docker daemon
```

**Решение:**
1. Откройте Docker Desktop
2. Дождитесь запуска
3. Проверьте: `docker ps`

### Порты заняты

**Ошибка:**
```
Bind for 0.0.0.0:3000 failed: port is already allocated
```

**Решение:**
```bash
# Остановите локальные процессы
./stop_all_services.sh

# Или убейте процесс на порту
lsof -ti:3000 | xargs kill -9
```

### Контейнер не запускается

**Проверьте логи:**
```bash
docker-compose logs user_service
```

**Пересоберите:**
```bash
docker-compose down
docker-compose up -d --build
```

### Очистка Docker

**Удалить все:**
```bash
docker-compose down -v
docker system prune -a
```

---

## 📊 Мониторинг

### Статус всех контейнеров

```bash
docker-compose ps
```

### Использование ресурсов

```bash
docker stats
```

### Логи в реальном времени

```bash
docker-compose logs -f --tail=100
```

---

## 🔄 Обновление кода

### После изменения кода

**Backend (Python):**
```bash
docker-compose restart user_service
```

**Frontend (React):**
- Hot reload работает автоматически
- Если нет: `docker-compose restart admin_dashboard`

### После изменения зависимостей

```bash
docker-compose up -d --build
```

---

## ✅ Проверка работы

### 1. Проверьте контейнеры

```bash
docker-compose ps
```

Все должны быть в статусе "Up"

### 2. Откройте браузер

```
http://localhost:3000
```

### 3. Проверьте API

```
http://localhost:8001/docs
```

---

## 🛑 Остановка проекта

### Остановить (сохранить данные)

```bash
docker-compose stop
```

### Остановить и удалить контейнеры

```bash
docker-compose down
```

### Полная очистка

```bash
docker-compose down -v
docker system prune -a
```

---

## 📝 Структура docker-compose.yml

```yaml
services:
  # Backend Services
  user_service:       port 8000
  admin_service:      port 8001
  subscription_service: port 8002
  partner_service:    port 8003
  
  # Frontend Apps
  admin_dashboard:    port 3000
  merchant_dashboard: port 3001
  user_app:          port 3003
  
  # Database
  postgres:          port 5432
```

---

## ✅ Готово!

**Проект запущен в Docker:**
- ✅ Все сервисы в контейнерах
- ✅ Изолированная среда
- ✅ Легко управлять
- ✅ Логи доступны

**Откройте http://localhost:3000 и начните работу!**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
