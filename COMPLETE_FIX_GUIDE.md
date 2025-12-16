# Complete Fix Guide - QR Scanning

## ✅ Полное решение проблемы с QR сканированием

**Дата:** 15 декабря 2024

---

## 🔍 Проблема

При сканировании QR кода выходит ошибка:
```
No active subscription
```

**QR Token:**
```
MERCHANT_452f6116-fb1e-43ce-b9b8-1060cfdaa6b3_1765803829
```

---

## ✅ Решение (Пошагово)

### Шаг 1: Регистрация

**Откройте:**
```
http://localhost:3003/register
```

**Заполните:**
- Имя: Test User
- Телефон: +998901234567
- Email: test@example.com (опционально)

**Нажмите:** "Зарегистрироваться"

### Шаг 2: Вход

**Откройте:**
```
http://localhost:3003/login
```

**Введите:**
- Телефон: +998901234567

**Нажмите:** "Войти"

### Шаг 3: Выбор плана

**Откройте:**
```
http://localhost:3003/subscriptions
```

**Выберите любой план:**
- Базовый (10 визитов)
- Стандарт (20 визитов)  
- Премиум (безлимит)

**Нажмите:** "Выбрать план"

**Должно быть:**
- ✅ Подписка создана
- ✅ Редирект на главную
- ✅ Карточка подписки отображается

### Шаг 4: QR Сканирование

**Откройте:**
```
http://localhost:3003/qr
```

**Введите QR код:**
```
MERCHANT_452f6116-fb1e-43ce-b9b8-1060cfdaa6b3_1765803829
```

**Нажмите:** "Подтвердить"

**Должно быть:**
```
✅ Check-in successful
Visits remaining: 9
```

---

## 🔧 Если не работает

### Вариант 1: Создать подписку через SQL

**1. Подключитесь к БД:**
```bash
docker-compose exec postgres psql -U yuvgo -d yuvgo_db
```

**2. Найдите user_id:**
```sql
SELECT id, phone_number, full_name FROM users WHERE phone_number = '+998901234567';
```

**3. Создайте подписку (замените USER_ID):**
```sql
INSERT INTO subscriptions (
    id, user_id, plan_id, status,
    start_date, end_date, visits_remaining, is_unlimited,
    auto_renew, created_at, updated_at
) VALUES (
    gen_random_uuid(),
    'YOUR_USER_ID_HERE',  -- ЗАМЕНИТЕ!
    'basic-plan',
    'active',
    NOW(),
    NOW() + INTERVAL '30 days',
    10,
    false,
    true,
    NOW(),
    NOW()
);
```

**4. Проверьте:**
```sql
SELECT 
    s.id, u.phone_number, s.status, s.visits_remaining
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE u.phone_number = '+998901234567';
```

**5. Выйдите:**
```sql
\q
```

### Вариант 2: Через API

**1. Получите токен:**
```bash
curl -X POST http://localhost:8000/api/user/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+998901234567"}'
```

**Ответ:**
```json
{
  "access_token": "eyJ...",
  "user": { "id": "...", ... }
}
```

**2. Создайте подписку:**
```bash
curl -X POST http://localhost:8002/api/subscription/subscriptions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "plan_id": "basic-plan",
    "auto_renew": true
  }'
```

**Ответ:**
```json
{
  "id": "...",
  "status": "active",
  "visits_remaining": 10
}
```

---

## 📋 Проверка

### 1. Проверьте пользователя

```bash
docker-compose exec postgres psql -U yuvgo -d yuvgo_db -c \
  "SELECT id, phone_number, full_name FROM users WHERE phone_number = '+998901234567';"
```

**Должно показать:**
```
id                  | phone_number    | full_name
--------------------+-----------------+-----------
123e4567-e89b-...   | +998901234567   | Test User
```

### 2. Проверьте подписку

```bash
docker-compose exec postgres psql -U yuvgo -d yuvgo_db -c \
  "SELECT s.id, s.status, s.visits_remaining FROM subscriptions s 
   JOIN users u ON s.user_id = u.id 
   WHERE u.phone_number = '+998901234567' AND s.status = 'active';"
```

**Должно показать:**
```
id                  | status | visits_remaining
--------------------+--------+-----------------
123e4567-e89b-...   | active | 10
```

### 3. Попробуйте QR

```
http://localhost:3003/qr
```

**Введите:**
```
MERCHANT_452f6116-fb1e-43ce-b9b8-1060cfdaa6b3_1765803829
```

**Должно быть:**
```
✅ Check-in successful
```

---

## 🐛 Troubleshooting

### Ошибка: "User not found"

**Причина:** Пользователь не зарегистрирован

**Решение:**
1. Зарегистрируйтесь: `http://localhost:3003/register`
2. Проверьте в БД: `SELECT * FROM users;`

### Ошибка: "No active subscription"

**Причина:** Подписка не создана или неактивна

**Решение:**
1. Выберите план: `http://localhost:3003/subscriptions`
2. Проверьте в БД: `SELECT * FROM subscriptions WHERE status = 'active';`
3. Если нет - создайте через SQL (см. выше)

### Ошибка: "Invalid merchant QR code"

**Причина:** Неправильный формат QR кода

**Решение:**
- QR должен начинаться с `MERCHANT_`
- Формат: `MERCHANT_{partner_id}_{timestamp}`

### Ошибка: "No visits remaining"

**Причина:** Закончились визиты

**Решение:**
1. Проверьте: `SELECT visits_remaining FROM subscriptions WHERE status = 'active';`
2. Обновите: `UPDATE subscriptions SET visits_remaining = 10 WHERE status = 'active';`

---

## ✅ Итоговый чеклист

- [ ] Пользователь зарегистрирован
- [ ] Пользователь вошел в систему
- [ ] Токен сохранен в localStorage
- [ ] План подписки выбран
- [ ] Подписка создана в БД со статусом 'active'
- [ ] visits_remaining > 0
- [ ] QR код в правильном формате
- [ ] Backend сервисы запущены
- [ ] QR сканирование работает ✅

---

## 📞 Быстрая помощь

**Если ничего не помогает:**

1. **Очистите все:**
   ```bash
   docker-compose down -v
   docker-compose up -d --build
   ```

2. **Зарегистрируйтесь заново**

3. **Создайте подписку через SQL**

4. **Попробуйте QR снова**

---

**Готово! ✅**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
