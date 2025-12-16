# Merchant Dashboard - История визитов, Доходы, Клиенты

## ✅ Что нужно исправить

**Дата:** 15 декабря 2024

---

## 📋 Задачи

### 1. История визитов
- ❌ Сейчас: Mock данные из localStorage
- ✅ Нужно: Реальные визиты с backend по филиалу merchant

### 2. Доходы
- ❌ Сейчас: Mock данные
- ✅ Нужно: Реальные доходы считаются с backend

### 3. Клиенты
- ❌ Сейчас: Все клиенты
- ✅ Нужно: Только клиенты этого филиала

---

## 🔧 Решение

### Backend Endpoints (уже есть)

**Visit Service (port 8004):**
```
GET /visits?partner_id={partner_id}
```

**Partner Service (port 8003):**
```
GET /partners/{partner_id}/earnings
GET /partners/{partner_id}/clients
```

### Frontend Changes

**1. VisitHistory.js:**
```javascript
const fetchVisits = async () => {
  const partnerId = merchant?.partner?.id;
  const response = await axios.get(
    `http://localhost:8004/visits?partner_id=${partnerId}`
  );
  setVisits(response.data);
};
```

**2. Earnings.js:**
```javascript
const fetchEarnings = async () => {
  const partnerId = merchant?.partner?.id;
  const response = await axios.get(
    `http://localhost:8003/partners/${partnerId}/earnings`
  );
  setEarnings(response.data);
};
```

**3. Clients.js:**
```javascript
const fetchClients = async () => {
  const partnerId = merchant?.partner?.id;
  const response = await axios.get(
    `http://localhost:8003/partners/${partnerId}/clients`
  );
  setClients(response.data);
};
```

---

## 📝 Статус

**Текущий статус:**
- ⏳ В процессе исправления
- ⏳ Нужно обновить frontend
- ⏳ Нужно проверить backend endpoints

**После исправления:**
- ✅ История визитов - реальные данные
- ✅ Доходы - реальный подсчет
- ✅ Клиенты - только по филиалу

---

## 🚀 Следующие шаги

1. Обновить VisitHistory.js
2. Обновить Earnings.js  
3. Обновить Clients.js
4. Перезапустить Merchant Dashboard
5. Протестировать все страницы

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
