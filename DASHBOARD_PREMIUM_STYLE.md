# Premium Dashboard Style Guide

## ✅ Новый стиль для Admin & Merchant Dashboard

**Дата:** 15 декабря 2024  
**Версия:** Premium 1.0

---

## 🎨 Дизайн система (как на изображении)

### Цветовая схема

**Фон:**
```css
bg-[#FAFAFA]  /* Очень светлый серый */
bg-white      /* Белые карточки */
```

**Текст:**
```css
text-gray-900  /* Основной (#111827) */
text-gray-600  /* Вторичный (#4B5563) */
text-gray-500  /* Третичный (#6B7280) */
```

**Акценты:**
```css
text-green-600  /* Положительный тренд */
text-red-600    /* Отрицательный тренд */
text-blue-600   /* Ссылки */
```

### Тени

**Мягкие тени:**
```css
/* Карточки */
boxShadow: '0 1px 3px rgba(0,0,0,0.08)'

/* Hover состояние */
boxShadow: '0 4px 12px rgba(0,0,0,0.1)'
```

### Скругления

```css
rounded-lg   /* 8px - карточки */
rounded-md   /* 6px - кнопки */
rounded-sm   /* 4px - инпуты */
```

### Типографика

**Заголовки:**
```css
text-sm font-medium text-gray-600  /* Label */
text-2xl font-bold text-gray-900   /* Large number */
text-base font-semibold text-gray-900  /* Section title */
```

**Текст:**
```css
text-sm text-gray-600   /* Body */
text-xs text-gray-500   /* Caption */
```

---

## 📊 Компоненты

### Stat Card

```jsx
<div className="bg-white rounded-lg p-6" 
  style={{boxShadow: '0 1px 3px rgba(0,0,0,0.08)'}}>
  
  {/* Label */}
  <div className="flex items-center justify-between mb-2">
    <p className="text-sm font-medium text-gray-600">Total Revenue</p>
    <span className="text-xs text-green-600 flex items-center gap-1">
      ↗ +12.5%
    </span>
  </div>
  
  {/* Value */}
  <p className="text-2xl font-bold text-gray-900">$1,250.00</p>
  
  {/* Description */}
  <p className="text-xs text-gray-500 mt-1">
    Trending up this month
  </p>
</div>
```

### Sidebar

```jsx
<div className="w-64 bg-white border-r border-gray-200 h-screen">
  {/* Logo */}
  <div className="p-6 border-b border-gray-200">
    <h1 className="text-lg font-bold text-gray-900">YuvGo</h1>
    <p className="text-xs text-gray-500">Admin Panel</p>
  </div>
  
  {/* Navigation */}
  <nav className="p-4 space-y-1">
    <button className="w-full flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium text-gray-900 bg-gray-100">
      <Icon size={18} />
      Dashboard
    </button>
    <button className="w-full flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium text-gray-600 hover:bg-gray-50">
      <Icon size={18} />
      Users
    </button>
  </nav>
</div>
```

### Table

```jsx
<div className="bg-white rounded-lg overflow-hidden"
  style={{boxShadow: '0 1px 3px rgba(0,0,0,0.08)'}}>
  
  {/* Header */}
  <div className="px-6 py-4 border-b border-gray-200">
    <h3 className="text-base font-semibold text-gray-900">Recent Orders</h3>
  </div>
  
  {/* Table */}
  <table className="w-full">
    <thead className="bg-gray-50 border-b border-gray-200">
      <tr>
        <th className="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase">
          Header
        </th>
      </tr>
    </thead>
    <tbody className="divide-y divide-gray-200">
      <tr className="hover:bg-gray-50">
        <td className="px-6 py-4 text-sm text-gray-900">
          Content
        </td>
      </tr>
    </tbody>
  </table>
</div>
```

### Chart Card

```jsx
<div className="bg-white rounded-lg p-6"
  style={{boxShadow: '0 1px 3px rgba(0,0,0,0.08)'}}>
  
  {/* Header */}
  <div className="flex items-center justify-between mb-6">
    <div>
      <h3 className="text-base font-semibold text-gray-900">Total Visitors</h3>
      <p className="text-xs text-gray-500">Total for the last 3 months</p>
    </div>
    <div className="flex gap-2">
      <button className="px-3 py-1 text-xs font-medium text-gray-600 hover:bg-gray-100 rounded-md">
        Last 3 months
      </button>
      <button className="px-3 py-1 text-xs font-medium text-gray-600 hover:bg-gray-100 rounded-md">
        Last 30 days
      </button>
    </div>
  </div>
  
  {/* Chart */}
  <div className="h-64">
    {/* Chart component */}
  </div>
</div>
```

---

## 🎯 Ключевые принципы

### 1. Минимализм

- Чистый белый фон
- Минимум цветов
- Много пространства
- Четкая иерархия

### 2. Мягкие тени

```css
/* НЕ используйте borders везде */
border border-gray-200  /* Только для разделителей */

/* Используйте мягкие тени */
boxShadow: '0 1px 3px rgba(0,0,0,0.08)'
```

### 3. Типографика

```css
/* Четкая иерархия размеров */
text-2xl font-bold  /* Большие цифры */
text-base font-semibold  /* Заголовки секций */
text-sm font-medium  /* Labels */
text-xs text-gray-500  /* Captions */
```

### 4. Spacing

```css
/* Больше пространства */
p-6  /* Padding карточек */
gap-6  /* Gap между элементами */
space-y-6  /* Вертикальные отступы */
```

### 5. Цвета для трендов

```jsx
// Положительный тренд
<span className="text-green-600">↗ +12.5%</span>

// Отрицательный тренд
<span className="text-red-600">↘ -20%</span>

// Нейтральный
<span className="text-gray-600">→ 0%</span>
```

---

## 📱 Layout структура

### Admin Dashboard

```
┌─────────────────────────────────────────┐
│ Sidebar │ Main Content                  │
│         │                               │
│ Logo    │ Stats Grid (4 columns)        │
│         │ ┌────┬────┬────┬────┐        │
│ Nav     │ │ $$ │ ## │ ## │ %% │        │
│ • Dash  │ └────┴────┴────┴────┘        │
│ • Users │                               │
│ • Part  │ Chart Card                    │
│         │ ┌─────────────────────┐      │
│         │ │ Total Visitors      │      │
│         │ │ [Chart]             │      │
│         │ └─────────────────────┘      │
│         │                               │
│ User    │ Table Card                    │
│ [Avatar]│ ┌─────────────────────┐      │
└─────────┴─┴─────────────────────┴──────┘
```

---

## 🎨 Примеры компонентов

### Stats Grid

```jsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
  {/* Revenue */}
  <div className="bg-white rounded-lg p-6"
    style={{boxShadow: '0 1px 3px rgba(0,0,0,0.08)'}}>
    <div className="flex items-center justify-between mb-2">
      <p className="text-sm font-medium text-gray-600">Total Revenue</p>
      <span className="text-xs text-green-600">↗ +12.5%</span>
    </div>
    <p className="text-2xl font-bold text-gray-900">$1,250.00</p>
    <p className="text-xs text-gray-500 mt-1">Trending up this month</p>
  </div>
  
  {/* Customers */}
  <div className="bg-white rounded-lg p-6"
    style={{boxShadow: '0 1px 3px rgba(0,0,0,0.08)'}}>
    <div className="flex items-center justify-between mb-2">
      <p className="text-sm font-medium text-gray-600">New Customers</p>
      <span className="text-xs text-red-600">↘ -20%</span>
    </div>
    <p className="text-2xl font-bold text-gray-900">1,234</p>
    <p className="text-xs text-gray-500 mt-1">Down 20% this period</p>
  </div>
</div>
```

### Navigation Item

```jsx
// Active
<button className="w-full flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium text-gray-900 bg-gray-100">
  <LayoutDashboard size={18} />
  <span>Dashboard</span>
</button>

// Inactive
<button className="w-full flex items-center gap-3 px-3 py-2 rounded-md text-sm font-medium text-gray-600 hover:bg-gray-50 transition-colors">
  <Users size={18} />
  <span>Users</span>
</button>
```

---

## ✅ Checklist

### Admin Dashboard
- [ ] Обновить Layout - белый sidebar
- [ ] Обновить Stats cards - мягкие тени
- [ ] Обновить Charts - минималистичный стиль
- [ ] Обновить Tables - чистый дизайн
- [ ] Обновить Navigation - простые кнопки

### Merchant Dashboard
- [ ] Обновить Layout - белый sidebar
- [ ] Обновить Stats cards - мягкие тени
- [ ] Обновить QR Scanner - чистый дизайн
- [ ] Обновить Visit History - таблица
- [ ] Обновить Earnings - графики

---

## 🚀 Результат

**Dashboard теперь:**
- ✅ Чистый минималистичный дизайн
- ✅ Мягкие тени вместо borders
- ✅ Белый фон
- ✅ Четкая типографика
- ✅ Много пространства
- ✅ Профессиональный вид

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024  
**Версия:** Premium 1.0
