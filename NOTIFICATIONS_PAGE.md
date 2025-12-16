# Notifications Page - User App

## ✅ Статус: Страница уведомлений создана

**Дата:** 15 декабря 2024

---

## 📱 Что создано

### Notifications Page

**Функционал:**
- ✅ Список уведомлений
- ✅ Непрочитанные уведомления
- ✅ Отметить как прочитанное
- ✅ Отметить все как прочитанные
- ✅ Удалить уведомление
- ✅ Очистить все
- ✅ Типы уведомлений (success, info, warning, error)
- ✅ Время "назад"
- ✅ Empty state

---

## 📝 Компоненты

### Header

```jsx
<div className="bg-white px-6 py-4 border-b border-gray-200">
  <div className="flex items-center justify-between">
    <div className="flex items-center gap-4">
      <button onClick={() => navigate('/home')}>
        <ArrowLeft />
      </button>
      <div>
        <h1>Уведомления</h1>
        {unreadCount > 0 && (
          <p>{unreadCount} непрочитанных</p>
        )}
      </div>
    </div>
    
    <div className="flex gap-2">
      <button onClick={markAllAsRead}>Прочитать все</button>
      <button onClick={clearAll}>Очистить</button>
    </div>
  </div>
</div>
```

### Notification Card

```jsx
<div className={`bg-white rounded-2xl p-4 border ${
  notification.read 
    ? 'border-gray-200' 
    : 'border-blue-200 bg-blue-50/30'
}`}>
  <div className="flex items-start gap-3">
    {/* Icon */}
    <div className="w-10 h-10 rounded-full bg-green-50">
      <Check className="text-green-500" />
    </div>
    
    {/* Content */}
    <div className="flex-1">
      <div className="flex items-start justify-between">
        <h3>{notification.title}</h3>
        {!notification.read && (
          <div className="w-2 h-2 rounded-full bg-blue-500"></div>
        )}
      </div>
      <p>{notification.message}</p>
      
      {/* Actions */}
      <div className="flex items-center justify-between">
        <p>{getTimeAgo(notification.timestamp)}</p>
        <div className="flex gap-2">
          {!notification.read && (
            <button onClick={() => markAsRead(notification.id)}>
              Прочитано
            </button>
          )}
          <button onClick={() => deleteNotification(notification.id)}>
            <Trash2 />
          </button>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Empty State

```jsx
<div className="bg-white rounded-2xl p-12 text-center border border-gray-200">
  <div className="w-16 h-16 rounded-full bg-gray-100 mx-auto mb-4">
    <Bell className="text-gray-400" />
  </div>
  <h3>Нет уведомлений</h3>
  <p>Здесь будут отображаться ваши уведомления</p>
</div>
```

---

## 🎯 Функционал

### 1. Типы уведомлений

```javascript
const getNotificationIcon = (type) => {
  switch (type) {
    case 'success':
      return <Check className="text-green-500" />;
    case 'warning':
      return <Bell className="text-yellow-500" />;
    case 'error':
      return <X className="text-red-500" />;
    default:
      return <Bell className="text-blue-500" />;
  }
};
```

### 2. Время "назад"

```javascript
const getTimeAgo = (timestamp) => {
  const now = new Date();
  const time = new Date(timestamp);
  const diff = Math.floor((now - time) / 1000);

  if (diff < 60) return 'Только что';
  if (diff < 3600) return `${Math.floor(diff / 60)} мин назад`;
  if (diff < 86400) return `${Math.floor(diff / 3600)} ч назад`;
  return `${Math.floor(diff / 86400)} дн назад`;
};
```

### 3. Отметить как прочитанное

```javascript
const markAsRead = (id) => {
  const updated = notifications.map(n => 
    n.id === id ? { ...n, read: true } : n
  );
  setNotifications(updated);
  localStorage.setItem('notifications', JSON.stringify(updated));
};
```

### 4. Отметить все

```javascript
const markAllAsRead = () => {
  const updated = notifications.map(n => ({ ...n, read: true }));
  setNotifications(updated);
  localStorage.setItem('notifications', JSON.stringify(updated));
};
```

### 5. Удалить уведомление

```javascript
const deleteNotification = (id) => {
  const updated = notifications.filter(n => n.id !== id);
  setNotifications(updated);
  localStorage.setItem('notifications', JSON.stringify(updated));
};
```

### 6. Очистить все

```javascript
const clearAll = () => {
  setNotifications([]);
  localStorage.removeItem('notifications');
};
```

---

## 📊 Структура уведомления

```javascript
{
  id: 1,
  type: 'success',  // success, info, warning, error
  title: 'Визит зарегистрирован',
  message: 'Ваш визит на Premium Car Wash успешно зарегистрирован',
  timestamp: '2024-12-15T12:00:00Z',
  read: false
}
```

---

## 🎨 Типы и цвета

### Success

```jsx
<div className="bg-green-50">
  <Check className="text-green-500" />
</div>
```

### Info

```jsx
<div className="bg-blue-50">
  <Bell className="text-blue-500" />
</div>
```

### Warning

```jsx
<div className="bg-yellow-50">
  <Bell className="text-yellow-500" />
</div>
```

### Error

```jsx
<div className="bg-red-50">
  <X className="text-red-500" />
</div>
```

---

## 🔔 Навигация

### Из Home Page

```jsx
<button onClick={() => navigate('/notifications')}>
  <Bell />
  <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full"></span>
</button>
```

---

## ✅ Обновленные файлы

```
✅ Notifications.js - Новая страница
✅ App.js - Добавлен роут /notifications
✅ HomePremium.js - Кнопка Bell ведет на /notifications
```

---

## 🚀 Результат

**Notifications Page:**
- ✅ Список уведомлений
- ✅ Непрочитанные выделены
- ✅ Отметить как прочитанное
- ✅ Удалить уведомление
- ✅ Очистить все
- ✅ Типы уведомлений
- ✅ Время "назад"
- ✅ Empty state

**Готово! 🔔**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
