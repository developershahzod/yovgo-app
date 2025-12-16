# Admin Dashboard - Locations Map Page

## ✅ Статус: Карта локаций создана в Admin Dashboard

**Дата:** 15 декабря 2024  
**Версия:** 1.0.0

---

## 🗺️ Что создано

### 1. **Новая страница - Карта локаций**

**Файл:** `src/pages/LocationsMap.js`

**Функционал:**
- ✅ Отображение всех автомоек
- ✅ Статистика (Всего, Активные, Неактивные)
- ✅ Поиск по названию, адресу, городу
- ✅ Фильтры (Все, Активные, Неактивные)
- ✅ Карточки локаций с деталями
- ✅ Интеграция с Google Maps
- ✅ Модальное окно с полной информацией

### 2. **Добавлено в навигацию**

**Расположение:** После "Партнеры"

```
📍 Карта локаций
- Иконка: MapPin
- Путь: /locations-map
- Права: partners.read
```

---

## 📊 Структура страницы

### Stats Cards

```
┌─────────────────────────────────────────┐
│  [📦] Всего локаций        15          │
│  [✓] Активные              12          │
│  [✗] Неактивные            3           │
└─────────────────────────────────────────┘
```

### Search & Filters

```
┌─────────────────────────────────────────┐
│  🔍 Поиск по названию, адресу...        │
│  [Все (15)] [Активные (12)] [Неактивные (3)] │
└─────────────────────────────────────────┘
```

### Location Cards Grid

```
┌──────────────┬──────────────┬──────────────┐
│  [Logo]      │  [Logo]      │  [Logo]      │
│  Premium     │  Deluxe      │  Express     │
│  Ташкент     │  Ташкент     │  Ташкент     │
│  📍 Адрес    │  📍 Адрес    │  📍 Адрес    │
│  📞 Телефон  │  📞 Телефон  │  📞 Телефон  │
│  🧭 Координаты│  🧭 Координаты│  🧭 Координаты│
│  [Карта] [👁]│  [Карта] [👁]│  [Карта] [👁]│
└──────────────┴──────────────┴──────────────┘
```

---

## 🎨 Компоненты

### Stats Card

```jsx
<div className="bg-white rounded-2xl p-6 border border-gray-100">
  <div className="w-12 h-12 rounded-xl bg-blue-50">
    <Building2 className="text-blue-500" />
  </div>
  <p className="text-gray-600 text-sm">Всего локаций</p>
  <p className="text-3xl font-black">{stats.total}</p>
</div>
```

### Search Bar

```jsx
<div className="relative">
  <Search className="absolute left-3 top-1/2" />
  <input
    type="text"
    value={searchQuery}
    onChange={(e) => setSearchQuery(e.target.value)}
    placeholder="Поиск по названию, адресу, городу..."
    className="w-full pl-10 pr-4 py-3 border-2 rounded-xl"
  />
</div>
```

### Filter Buttons

```jsx
<button
  onClick={() => setFilterStatus('all')}
  className={filterStatus === 'all' 
    ? 'bg-yuvgo-cyan text-white' 
    : 'bg-gray-100 text-gray-700'
  }
>
  Все ({stats.total})
</button>
```

### Location Card

```jsx
<div className="bg-white rounded-2xl p-6 border border-gray-100">
  {/* Header */}
  <div className="flex items-center gap-3">
    <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark">
      <Building2 className="text-white" />
    </div>
    <div>
      <h3 className="font-bold">{partner.name}</h3>
      <p className="text-sm text-gray-500">{partner.city}</p>
    </div>
    <span className={partner.is_active ? 'bg-green-50' : 'bg-red-50'}>
      {partner.is_active ? 'Активно' : 'Неактивно'}
    </span>
  </div>

  {/* Info */}
  <div className="space-y-3">
    <div className="flex items-start gap-2">
      <MapPin size={16} />
      <span>{partner.address}</span>
    </div>
    <div className="flex items-center gap-2">
      <Phone size={16} />
      <span>{partner.phone}</span>
    </div>
    <div className="flex items-center gap-2">
      <Navigation size={16} />
      <span>{lat}, {lng}</span>
    </div>
  </div>

  {/* Actions */}
  <div className="flex gap-2">
    <button onClick={() => openInGoogleMaps(partner)}>
      <Navigation /> Карта
    </button>
    <button onClick={() => setSelectedPartner(partner)}>
      <Eye />
    </button>
  </div>
</div>
```

---

## 🔧 Функционал

### 1. Fetch Partners

```javascript
const fetchPartners = async () => {
  const response = await axios.get(`${API_URL}/api/partner/partners`);
  const data = response.data;
  
  setPartners(data);
  
  // Calculate stats
  const active = data.filter(p => p.is_active).length;
  setStats({
    total: data.length,
    active: active,
    inactive: data.length - active
  });
};
```

### 2. Search & Filter

```javascript
const filterPartners = () => {
  let filtered = [...partners];

  // Search
  if (searchQuery) {
    filtered = filtered.filter(p =>
      p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.address?.toLowerCase().includes(searchQuery.toLowerCase()) ||
      p.city?.toLowerCase().includes(searchQuery.toLowerCase())
    );
  }

  // Status filter
  if (filterStatus === 'active') {
    filtered = filtered.filter(p => p.is_active);
  } else if (filterStatus === 'inactive') {
    filtered = filtered.filter(p => !p.is_active);
  }

  setFilteredPartners(filtered);
};
```

### 3. Google Maps Integration

```javascript
const openInGoogleMaps = (partner) => {
  const lat = partner.latitude || 41.2995;
  const lng = partner.longitude || 69.2401;
  window.open(`https://www.google.com/maps?q=${lat},${lng}`, '_blank');
};
```

### 4. Details Modal

```javascript
{selectedPartner && (
  <div className="fixed inset-0 bg-black/50 z-50">
    <div className="bg-white rounded-3xl max-w-2xl">
      {/* Header */}
      <h2>Детали локации</h2>
      
      {/* Info Cards */}
      <div className="space-y-3">
        <div className="bg-gray-50 rounded-2xl p-4">
          <MapPin /> Адрес
          <p>{selectedPartner.address}</p>
        </div>
        <div className="bg-gray-50 rounded-2xl p-4">
          <Phone /> Телефон
          <p>{selectedPartner.phone}</p>
        </div>
        <div className="bg-gray-50 rounded-2xl p-4">
          <Navigation /> Координаты
          <p>Широта: {selectedPartner.latitude}</p>
          <p>Долгота: {selectedPartner.longitude}</p>
        </div>
      </div>
      
      {/* Actions */}
      <button onClick={() => openInGoogleMaps(selectedPartner)}>
        Открыть в Google Maps
      </button>
    </div>
  </div>
)}
```

---

## 📱 Responsive Design

### Grid Layout

```css
/* Desktop: 3 columns */
grid-cols-1 lg:grid-cols-2 xl:grid-cols-3

/* Tablet: 2 columns */
md:grid-cols-2

/* Mobile: 1 column */
grid-cols-1
```

### Search & Filters

```css
/* Desktop: Row */
flex-col md:flex-row

/* Mobile: Column */
flex-col
```

---

## 🎯 Использование

### Открыть страницу

```
1. Войти в Admin Dashboard
2. Нажать "Карта локаций" в sidebar
3. Или перейти на /locations-map
```

### Поиск локации

```
1. Ввести название в поиск
2. Результаты фильтруются автоматически
```

### Фильтр по статусу

```
1. Нажать "Активные" - показать только активные
2. Нажать "Неактивные" - показать только неактивные
3. Нажать "Все" - показать все
```

### Открыть на карте

```
1. Найти локацию
2. Нажать кнопку "Карта"
3. Откроется Google Maps с точкой
```

### Просмотр деталей

```
1. Нажать на карточку или кнопку 👁
2. Откроется модальное окно
3. Просмотреть полную информацию
```

---

## 📊 Данные

### Partner Object

```javascript
{
  id: "partner123",
  name: "Premium Car Wash",
  address: "Ташкент, ул. Амира Темура 123",
  city: "Ташкент",
  latitude: 41.299500,
  longitude: 69.240100,
  phone: "+998 90 123 45 67",
  is_active: true,
  description: "Премиум автомойка",
  logo_url: "https://..."
}
```

### Stats Object

```javascript
{
  total: 15,
  active: 12,
  inactive: 3
}
```

---

## ✅ Checklist

### Страница
- [x] Создана LocationsMap.js
- [x] Добавлен роут в App.js
- [x] Добавлена в навигацию
- [x] Права доступа (partners.read)

### Функционал
- [x] Fetch partners
- [x] Статистика
- [x] Поиск
- [x] Фильтры
- [x] Google Maps интеграция
- [x] Details modal

### UI Components
- [x] Stats cards
- [x] Search bar
- [x] Filter buttons
- [x] Location cards
- [x] Details modal
- [x] Loading state
- [x] Empty state

---

## 🚀 Следующие шаги

### Улучшения

1. **Добавить редактирование**
   ```javascript
   const editLocation = (partner) => {
     navigate(`/partners/${partner.id}/edit`);
   };
   ```

2. **Добавить удаление**
   ```javascript
   const deleteLocation = async (partnerId) => {
     await axios.delete(`${API_URL}/api/partner/partners/${partnerId}`);
     fetchPartners();
   };
   ```

3. **Добавить создание**
   ```javascript
   const createLocation = () => {
     navigate('/partners/create');
   };
   ```

4. **Экспорт данных**
   ```javascript
   const exportToCSV = () => {
     // Export partners to CSV
   };
   ```

---

## 🎉 Результат

**Admin Dashboard теперь имеет:**
- ✅ Страницу "Карта локаций"
- ✅ Отображение всех автомоек
- ✅ Статистику
- ✅ Поиск и фильтры
- ✅ Google Maps интеграцию
- ✅ Детальную информацию
- ✅ Современный дизайн
- ✅ Responsive layout

**Готово к использованию! 🗺️**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024  
**Версия:** 1.0.0
