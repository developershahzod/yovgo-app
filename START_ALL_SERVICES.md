# Start All Services - YuvGo Project

## ✅ Статус: Все сервисы запускаются

**Дата:** 15 декабря 2024

---

## 🚀 Запуск всех сервисов

### Команда

```bash
./start_all_services.sh
```

### Что запускается

**Backend Services:**
- ✅ User Service (port 8000)
- ✅ Admin Service (port 8001)
- ✅ Subscription Service (port 8002)
- ✅ Partner Service (port 8003)

**Frontend Applications:**
- ✅ Admin Dashboard (port 3000)
- ✅ Merchant Dashboard (port 3001)
- ✅ User App (port 3003)

---

## 📱 URLs

### Frontend

```
Admin Dashboard:    http://localhost:3000
Merchant Dashboard: http://localhost:3001
User App:           http://localhost:3003
```

### Backend

```
User Service:         http://localhost:8000
Admin Service:        http://localhost:8001
Subscription Service: http://localhost:8002
Partner Service:      http://localhost:8003
```

### API Docs

```
User Service:         http://localhost:8000/docs
Admin Service:        http://localhost:8001/docs
Subscription Service: http://localhost:8002/docs
Partner Service:      http://localhost:8003/docs
```

---

## 📋 Логи

### Просмотр всех логов

```bash
tail -f logs/*.log
```

### Отдельные логи

```bash
# Backend
tail -f logs/user-service.log
tail -f logs/admin-service.log
tail -f logs/subscription-service.log
tail -f logs/partner-service.log

# Frontend
tail -f logs/admin-dashboard.log
tail -f logs/merchant-dashboard.log
tail -f logs/user-app.log
```

---

## 🛑 Остановка всех сервисов

### Команда

```bash
./stop_all_services.sh
```

### Что останавливается

- ✓ Все backend сервисы (8000-8003)
- ✓ Все frontend приложения (3000, 3001, 3003)

---

## 🔧 Ручной запуск

### Backend Service

```bash
cd backend/services/user
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Frontend App

```bash
cd frontend/admin-dashboard
PORT=3000 npm start
```

---

## ✅ Проверка

### 1. Откройте браузер

```
http://localhost:3000
```

### 2. Проверьте логи

```bash
tail -f logs/admin-dashboard.log
```

### 3. Проверьте backend

```
http://localhost:8001/docs
```

---

## 📝 Тестовые данные

### Admin Login

```
Email: admin@yuvgo.uz
Password: Admin@123
```

### Merchant Login

```
Phone: +998901111111
PIN: 123456
```

### User Login

```
Phone: +998901234567
Password: password123
```

---

## 🔄 Перезапуск

### Остановить и запустить снова

```bash
./stop_all_services.sh
./start_all_services.sh
```

### Перезапустить только frontend

```bash
# Остановить
lsof -ti:3000 | xargs kill -9
lsof -ti:3001 | xargs kill -9
lsof -ti:3003 | xargs kill -9

# Запустить
cd frontend/admin-dashboard && PORT=3000 npm start &
cd frontend/merchant-dashboard && PORT=3001 npm start &
cd frontend/user-app && PORT=3003 npm start &
```

---

## ✅ Результат

**Все сервисы запущены:**
- ✅ 4 Backend сервиса
- ✅ 3 Frontend приложения
- ✅ Логи в папке logs/
- ✅ Готово к использованию

**Откройте http://localhost:3000 и начните работу!**

---

**Готово! 🚀**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
