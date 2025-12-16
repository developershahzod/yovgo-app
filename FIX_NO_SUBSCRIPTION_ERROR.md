# Fix "No active subscription" Error

## ❌ Проблема

При сканировании QR кода merchant'а выходит ошибка:
```
No active subscription
```

**QR Token:**
```
MERCHANT_452f6116-fb1e-43ce-b9b8-1060cfdaa6b3_1765803131
```

---

## 🔍 Причина

У пользователя нет активной подписки в базе данных.

**Проверка в коде:**
```python
# backend/services/visit/main.py:401-408
subscription = db.query(Subscription).filter(
    Subscription.user_id == request.user_id,
    Subscription.status == "active",
    Subscription.end_date > datetime.utcnow()
).first()

if not subscription:
    raise HTTPException(status_code=400, detail="No active subscription")
```

---

## ✅ Решение

### Вариант 1: Купить подписку через UI

1. **Откройте User App:**
   ```
   http://localhost:3003
   ```

2. **Перейдите в "Подписки":**
   - Нажмите на иконку подписок в нижнем меню

3. **Выберите план:**
   - Базовый (10 визитов)
   - Стандарт (20 визитов)
   - Премиум (безлимит)

4. **Оплатите:**
   - Нажмите "Выбрать план"
   - Подтвердите оплату

5. **Проверьте:**
   - Вернитесь на главную
   - Должна появиться активная подписка

### Вариант 2: Добавить через SQL (для тестирования)

**Подключитесь к базе данных:**

```bash
# Если Docker
docker exec -it yuvgo_postgres psql -U yuvgo_user -d yuvgo_db

# Если локально
psql -h localhost -U yuvgo_user -d yuvgo_db
```

**Найдите user_id:**

```sql
SELECT id, full_name, phone_number 
FROM users 
WHERE phone_number = '+998901234567';
```

**Создайте подписку:**

```sql
INSERT INTO subscriptions (
    id,
    user_id,
    plan_id,
    status,
    start_date,
    end_date,
    visits_remaining,
    is_unlimited
) VALUES (
    gen_random_uuid(),
    'YOUR_USER_ID_HERE',  -- Замените на реальный user_id
    'test-plan',
    'active',
    NOW(),
    NOW() + INTERVAL '30 days',
    10,
    false
);
```

**Проверьте:**

```sql
SELECT * FROM subscriptions WHERE user_id = 'YOUR_USER_ID_HERE';
```

### Вариант 3: Через API (Postman/curl)

**1. Получите токен пользователя:**

```bash
curl -X POST http://localhost:8000/api/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "+998901234567",
    "password": "password123"
  }'
```

**2. Создайте подписку:**

```bash
curl -X POST http://localhost:8002/api/subscription/subscriptions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "plan_id": "basic-plan",
    "payment_method": "card"
  }'
```

---

## 📝 Проверка подписки

### Через UI

1. Откройте User App: `http://localhost:3003`
2. На главной странице должна быть карточка подписки:
   ```
   Активная подписка
   Осталось визитов: 10
   ```

### Через API

```bash
curl -X GET http://localhost:8002/api/subscription/my-subscription \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Ответ должен быть:**
```json
{
  "id": "...",
  "status": "active",
  "visits_remaining": 10,
  "end_date": "2025-01-15T..."
}
```

### Через SQL

```sql
SELECT 
    u.full_name,
    u.phone_number,
    s.status,
    s.visits_remaining,
    s.end_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE u.phone_number = '+998901234567'
  AND s.status = 'active';
```

---

## 🧪 Тестирование QR сканирования

### После добавления подписки:

1. **Откройте User App:**
   ```
   http://localhost:3003
   ```

2. **Перейдите в QR Scanner:**
   - Нажмите на иконку QR в нижнем меню

3. **Отсканируйте QR код:**
   - Или введите токен вручную:
   ```
   MERCHANT_452f6116-fb1e-43ce-b9b8-1060cfdaa6b3_1765803131
   ```

4. **Должен быть успех:**
   ```
   ✅ Check-in successful
   Visits remaining: 9
   ```

---

## 🔧 Структура подписки

### Таблица subscriptions

```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id),
    plan_id VARCHAR,
    status VARCHAR,           -- 'active', 'expired', 'cancelled'
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    visits_remaining INTEGER,
    is_unlimited BOOLEAN
);
```

### Статусы

- **active** - подписка активна
- **expired** - срок истек
- **cancelled** - отменена пользователем

### Проверки

1. `status = 'active'`
2. `end_date > NOW()`
3. `visits_remaining > 0` (если не unlimited)

---

## ✅ Результат

**После добавления подписки:**
- ✅ Пользователь может сканировать QR
- ✅ Визиты регистрируются
- ✅ Счетчик визитов уменьшается
- ✅ Нет ошибки "No active subscription"

---

## 📋 Тестовые данные

### Пользователь

```
Phone: +998901234567
Password: password123
```

### Подписка (для SQL)

```sql
-- 10 визитов, 30 дней
visits_remaining: 10
end_date: NOW() + 30 days
status: 'active'
```

---

**Готово! ✅**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
