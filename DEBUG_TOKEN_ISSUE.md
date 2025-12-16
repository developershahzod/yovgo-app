# Debug Token Issue - "Необходимо войти в систему"

## 🔍 Отладка проблемы с токеном

**Дата:** 15 декабря 2024

---

## 📝 Шаги для отладки

### 1. Откройте DevTools

**Нажмите F12 в браузере**

### 2. Войдите в систему

```
http://localhost:3003/login
```

**Введите телефон:** +998901234567

### 3. Проверьте Console

После логина должны быть логи:
```
Page loaded. Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
User: { id: "...", phone_number: "+998901234567", ... }
```

### 4. Проверьте localStorage

**В Console выполните:**
```javascript
console.log('user_token:', localStorage.getItem('user_token'));
console.log('user_data:', localStorage.getItem('user_data'));
console.log('All keys:', Object.keys(localStorage));
```

**Должно быть:**
```
user_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
user_data: "{\"id\":\"...\",\"phone_number\":\"+998901234567\",...}"
All keys: ["user_token", "user_data", ...]
```

### 5. Перейдите в Subscriptions

```
http://localhost:3003/subscriptions
```

**В Console должны быть логи:**
```
Page loaded. Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
User: { id: "...", ... }
```

### 6. Выберите план

**Нажмите "Выбрать план"**

**В Console должны быть логи:**
```
Token from localStorage: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
User from context: { id: "...", ... }
POST http://localhost:8002/api/subscription/subscriptions
```

---

## ❌ Возможные проблемы

### Проблема 1: Токен не сохраняется

**Симптомы:**
```
user_token: null
```

**Причина:** Ошибка при логине

**Решение:**
1. Проверьте Network tab
2. Найдите запрос `/api/user/auth/login`
3. Проверьте Response:
   ```json
   {
     "access_token": "eyJ...",
     "user": { ... }
   }
   ```
4. Если ошибка - проверьте backend

### Проблема 2: Токен удаляется

**Симптомы:**
```
// После логина есть
user_token: "eyJ..."

// На странице subscriptions нет
user_token: null
```

**Причина:** Что-то удаляет токен

**Решение:**
1. Проверьте код в Login.js
2. Проверьте AuthContext
3. Проверьте есть ли `localStorage.removeItem('user_token')`

### Проблема 3: Неправильный ключ

**Симптомы:**
```
All keys: ["token", "user_data"]  // Не "user_token"!
```

**Причина:** Токен сохраняется с другим ключом

**Решение:**
Проверьте в AuthContext:
```javascript
// Должно быть
localStorage.setItem('user_token', access_token);

// Не должно быть
localStorage.setItem('token', access_token);
```

---

## ✅ Правильный flow

### 1. Login

```javascript
// AuthContext.js
const login = async (phoneNumber) => {
  const response = await axios.post(`${API_URL}/api/user/auth/login`, {
    phone_number: phoneNumber
  });
  
  const { access_token, user: userData } = response.data;
  
  // ✅ Сохраняем токен
  localStorage.setItem('user_token', access_token);
  localStorage.setItem('user_data', JSON.stringify(userData));
  
  setUser(userData);
};
```

### 2. Subscriptions Page Load

```javascript
// SubscriptionsPremium.js
useEffect(() => {
  const token = localStorage.getItem('user_token');
  console.log('Token:', token);  // ✅ Должен быть
  
  if (!token) {
    navigate('/login');  // ❌ Редирект если нет
  }
}, []);
```

### 3. Purchase Plan

```javascript
const handlePurchase = async (planId) => {
  const token = localStorage.getItem('user_token');
  console.log('Token:', token);  // ✅ Должен быть
  
  const response = await axios.post(
    `${API_URL}/api/subscription/subscriptions`,
    { plan_id: planId },
    { headers: { 'Authorization': `Bearer ${token}` } }
  );
};
```

---

## 🔧 Временное решение

### Если токен не сохраняется

**Добавьте в Login.js после успешного логина:**

```javascript
const handleSubmit = async (e) => {
  e.preventDefault();
  
  const result = await login(phoneNumber);
  
  if (result.success) {
    // Проверяем что токен сохранился
    const savedToken = localStorage.getItem('user_token');
    console.log('Token saved:', savedToken);
    
    if (!savedToken) {
      console.error('Token not saved!');
      alert('Ошибка сохранения токена. Попробуйте снова.');
      return;
    }
    
    navigate('/home');
  }
};
```

---

## 📋 Чеклист

**Проверьте все пункты:**

- [ ] Логин работает без ошибок
- [ ] В Network tab есть ответ с `access_token`
- [ ] В localStorage есть `user_token`
- [ ] В localStorage есть `user_data`
- [ ] На странице subscriptions токен не null
- [ ] При выборе плана токен передается в headers
- [ ] Backend получает токен и возвращает подписку

---

## 🐛 Если ничего не помогает

### Полная очистка и перезапуск

1. **Очистите localStorage:**
   ```javascript
   localStorage.clear();
   ```

2. **Перезагрузите страницу:**
   ```
   Ctrl+Shift+R (hard reload)
   ```

3. **Войдите снова:**
   ```
   http://localhost:3003/login
   ```

4. **Проверьте токен:**
   ```javascript
   console.log(localStorage.getItem('user_token'));
   ```

5. **Попробуйте выбрать план:**
   ```
   http://localhost:3003/subscriptions
   ```

---

## 📞 Что отправить для помощи

Если проблема не решается, отправьте:

1. **Console logs:**
   - Скриншот Console после логина
   - Скриншот Console на странице subscriptions
   - Скриншот Console при выборе плана

2. **Network logs:**
   - Скриншот запроса `/api/user/auth/login`
   - Скриншот ответа с `access_token`

3. **localStorage:**
   ```javascript
   console.log(JSON.stringify(localStorage));
   ```

---

**Готово! 🔍**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
