# Premium Style Guide - User App

## ✅ Новый дизайн в стиле премиум приложений

**Дата:** 15 декабря 2024  
**Версия:** Premium 1.0

---

## 🎨 Дизайн система

### Цветовая схема

**Фон:**
```css
bg-[#F5F5F7]  /* Светло-серый фон (как iOS) */
```

**Карточки:**
```css
bg-white  /* Белые карточки */
```

**Акценты:**
```css
#00BCD4  /* Cyan - QR Scanner */
#4CAF50  /* Green - Map */
#9C27B0  /* Purple - History */
#FF9800  /* Orange - Plans */
```

**Текст:**
```css
text-gray-900  /* Основной текст */
text-gray-500  /* Вторичный текст */
text-gray-700  /* Средний текст */
```

### Тени (Box Shadows)

**Мягкие тени вместо borders:**

```css
/* Легкая тень для кнопок */
boxShadow: '0 2px 8px rgba(0,0,0,0.08)'

/* Средняя тень для карточек */
boxShadow: '0 4px 16px rgba(0,0,0,0.06)'

/* Легкая тень для акцентов */
boxShadow: '0 2px 8px rgba(0,0,0,0.04)'
```

### Скругления (Border Radius)

```css
rounded-full   /* Круглые кнопки */
rounded-2xl    /* Средние элементы (16px) */
rounded-3xl    /* Большие карточки (24px) */
```

---

## 📱 Компоненты

### Header

```jsx
<div className="bg-white px-6 pt-12 pb-6">
  {/* Menu Button */}
  <button className="w-12 h-12 rounded-full bg-white" 
    style={{boxShadow: '0 2px 8px rgba(0,0,0,0.08)'}}>
    <Menu />
  </button>
  
  {/* Title */}
  <div className="text-center">
    <h1 className="text-base font-semibold">YuvGo</h1>
    <p className="text-xs text-gray-500">Premium</p>
  </div>
  
  {/* Notification */}
  <button className="w-12 h-12 rounded-full bg-white relative"
    style={{boxShadow: '0 2px 8px rgba(0,0,0,0.08)'}}>
    <Bell />
    <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full"></span>
  </button>
</div>
```

### Subscription Card

```jsx
<div className="bg-white rounded-3xl p-6" 
  style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}>
  
  {/* Header */}
  <div className="flex items-center justify-between mb-6">
    <div className="flex items-center gap-3">
      <div className="w-12 h-12 rounded-2xl bg-yellow-50">
        <Sparkles className="text-yellow-500" />
      </div>
      <div>
        <p className="text-sm text-gray-500">Активный план</p>
        <h3 className="text-lg font-bold text-gray-900">Premium</h3>
      </div>
    </div>
    <div className="px-4 py-2 rounded-full bg-green-50">
      <span className="text-xs font-bold text-green-600">АКТИВНО</span>
    </div>
  </div>
  
  {/* Stats */}
  <div className="grid grid-cols-2 gap-3 mb-6">
    <div className="bg-gray-50 rounded-2xl p-4">
      <div className="flex items-center gap-2 mb-2">
        <Zap className="text-yellow-500" />
        <p className="text-xs text-gray-500">Осталось визитов</p>
      </div>
      <p className="text-3xl font-black text-gray-900">5</p>
    </div>
  </div>
  
  {/* Button */}
  <button className="w-full bg-gray-900 text-white py-4 rounded-2xl font-bold">
    Сканировать QR код
  </button>
</div>
```

### Quick Actions

```jsx
<div className="bg-white rounded-3xl p-6"
  style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}>
  
  <h3 className="text-base font-bold text-gray-900 mb-4">
    Быстрые действия
  </h3>
  
  <div className="grid grid-cols-4 gap-3">
    {actions.map(action => (
      <button className="flex flex-col items-center gap-2 p-3 rounded-2xl">
        <div 
          className="w-14 h-14 rounded-2xl flex items-center justify-center"
          style={{
            backgroundColor: `${action.color}15`,
            boxShadow: '0 2px 8px rgba(0,0,0,0.04)'
          }}
        >
          <Icon style={{color: action.color}} />
        </div>
        <span className="text-xs font-medium text-gray-700">
          {action.label}
        </span>
      </button>
    ))}
  </div>
</div>
```

### Stats Card

```jsx
<div className="bg-white rounded-3xl p-6"
  style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}>
  
  <h3 className="text-base font-bold text-gray-900 mb-4">
    Ваша статистика
  </h3>
  
  <div className="grid grid-cols-3 gap-4">
    <div className="text-center">
      <p className="text-2xl font-black text-gray-900">12</p>
      <p className="text-xs text-gray-500 mt-1">Всего моек</p>
    </div>
  </div>
</div>
```

### Tip Card

```jsx
<div className="bg-blue-50 rounded-3xl p-6"
  style={{boxShadow: '0 4px 16px rgba(0,0,0,0.04)'}}>
  
  <div className="flex items-start gap-3">
    <div className="w-10 h-10 rounded-full bg-blue-100">
      <Sparkles className="text-blue-500" />
    </div>
    <div>
      <p className="font-bold text-blue-900 mb-1">💡 Совет</p>
      <p className="text-sm text-blue-700">
        Отсканируйте QR код на автомойке для быстрой регистрации!
      </p>
    </div>
  </div>
</div>
```

---

## 🎯 Ключевые принципы

### 1. Мягкие тени вместо borders

**НЕ используйте:**
```css
border border-gray-100
border-2 border-gray-200
```

**Используйте:**
```css
style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}
```

### 2. Светлый фон

**Фон страницы:**
```css
bg-[#F5F5F7]  /* Светло-серый */
```

**Карточки:**
```css
bg-white  /* Белые */
```

### 3. Скругленные углы

**Все элементы скруглены:**
```css
rounded-2xl  /* 16px */
rounded-3xl  /* 24px */
rounded-full /* Круглые */
```

### 4. Цветные акценты

**Иконки в цветных контейнерах:**
```jsx
<div 
  className="w-14 h-14 rounded-2xl"
  style={{backgroundColor: '#00BCD415'}}  /* 15% opacity */
>
  <Icon style={{color: '#00BCD4'}} />
</div>
```

### 5. Типографика

**Заголовки:**
```css
text-base font-bold text-gray-900  /* H3 */
text-lg font-bold text-gray-900    /* H2 */
```

**Текст:**
```css
text-sm text-gray-500   /* Вторичный */
text-xs text-gray-500   /* Мелкий */
```

**Цифры:**
```css
text-3xl font-black text-gray-900  /* Большие */
text-2xl font-black text-gray-900  /* Средние */
```

---

## 📊 Сравнение

### Старый стиль

```jsx
<div className="bg-white rounded-2xl p-6 border border-gray-100">
  <h3 className="text-lg font-bold text-gray-900">Заголовок</h3>
</div>
```

### Новый стиль (Premium)

```jsx
<div className="bg-white rounded-3xl p-6"
  style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}>
  <h3 className="text-base font-bold text-gray-900">Заголовок</h3>
</div>
```

---

## 🎨 Цветовая палитра

### Основные цвета

```css
/* Фон */
#F5F5F7  /* Светло-серый */
#FFFFFF  /* Белый */

/* Текст */
#1F2937  /* Gray-900 */
#6B7280  /* Gray-500 */
#374151  /* Gray-700 */

/* Акценты */
#00BCD4  /* Cyan */
#4CAF50  /* Green */
#9C27B0  /* Purple */
#FF9800  /* Orange */
#2196F3  /* Blue */

/* Статусы */
#10B981  /* Success */
#EF4444  /* Error */
#F59E0B  /* Warning */
```

### Использование

```jsx
// Cyan accent
<div style={{backgroundColor: '#00BCD415'}}>
  <Icon style={{color: '#00BCD4'}} />
</div>

// Green accent
<div style={{backgroundColor: '#4CAF5015'}}>
  <Icon style={{color: '#4CAF50'}} />
</div>
```

---

## ✅ Checklist

### Обновленные элементы

- [x] Фон страницы - #F5F5F7
- [x] Карточки - белые с мягкими тенями
- [x] Кнопки - rounded-2xl с тенями
- [x] Иконки - цветные в светлых контейнерах
- [x] Текст - gray-900/500/700
- [x] Скругления - rounded-2xl/3xl
- [x] Тени вместо borders

### Новые компоненты

- [x] HomePremium.js - Главная страница
- [ ] MapPremium.js - Карта
- [ ] QRScannerPremium.js - Сканер
- [ ] SubscriptionsPremium.js - Подписки
- [ ] ProfilePremium.js - Профиль

---

## 🚀 Результат

**User App теперь имеет:**
- ✅ Премиум дизайн
- ✅ Мягкие тени
- ✅ Светлая тема
- ✅ Скругленные элементы
- ✅ Цветные акценты
- ✅ Чистый минимализм
- ✅ iOS-подобный стиль

**Готово к использованию! 🎨**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024  
**Версия:** Premium 1.0
