# Clean Table Component - Admin Dashboard

## ✅ Новый компонент таблицы

**Дата:** 15 декабря 2024

---

## 📝 Использование

### Импорт

```javascript
import CleanTable, { StatusBadge, UserCell, DateCell, PhoneCell } from '../components/ui/CleanTable';
```

### Пример для Users страницы

```javascript
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import CleanTable, { StatusBadge, UserCell, DateCell, PhoneCell } from '../components/ui/CleanTable';
import { Plus } from 'lucide-react';

const Users = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await axios.get('/api/user/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Error fetching users:', error);
    } finally {
      setLoading(false);
    }
  };

  const columns = [
    {
      header: 'Пользователь',
      accessor: 'full_name',
      render: (row) => (
        <UserCell 
          name={row.full_name} 
          email={row.email}
        />
      )
    },
    {
      header: 'Телефон',
      accessor: 'phone_number',
      render: (row) => <PhoneCell phone={row.phone_number} />
    },
    {
      header: 'Статус',
      accessor: 'is_active',
      render: (row) => (
        <StatusBadge status={row.is_active ? 'active' : 'inactive'} />
      )
    },
    {
      header: 'Дата регистрации',
      accessor: 'created_at',
      render: (row) => <DateCell date={row.created_at} />
    }
  ];

  const handleView = (user) => {
    console.log('View user:', user);
  };

  const handleEdit = (user) => {
    console.log('Edit user:', user);
  };

  const handleDelete = (user) => {
    if (confirm('Вы уверены?')) {
      console.log('Delete user:', user);
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Пользователи</h1>
          <p className="text-sm text-gray-500 mt-1">Управление пользователями платформы</p>
        </div>
        <button className="flex items-center gap-2 px-4 py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors">
          <Plus size={20} />
          <span>Добавить пользователя</span>
        </button>
      </div>

      {/* Table */}
      <CleanTable
        columns={columns}
        data={users}
        loading={loading}
        onView={handleView}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />
    </div>
  );
};

export default Users;
```

---

## 🎨 Компоненты

### CleanTable

**Props:**
- `columns` - массив объектов колонок
- `data` - массив данных
- `loading` - состояние загрузки
- `onView` - функция просмотра
- `onEdit` - функция редактирования
- `onDelete` - функция удаления

### StatusBadge

**Props:**
- `status` - статус (active, inactive, pending, suspended)

**Стили:**
```jsx
<StatusBadge status="active" />
// → Зеленый badge "Активный"

<StatusBadge status="inactive" />
// → Серый badge "Неактивный"
```

### UserCell

**Props:**
- `name` - имя пользователя
- `email` - email
- `avatar` - URL аватара (опционально)

**Пример:**
```jsx
<UserCell 
  name="Shahzod Akhmedov" 
  email="megatesternumber70@gmail.com"
/>
```

### DateCell

**Props:**
- `date` - дата в формате ISO

**Пример:**
```jsx
<DateCell date="2024-12-12T00:00:00Z" />
// → "12.12.2024"
```

### PhoneCell

**Props:**
- `phone` - номер телефона

**Пример:**
```jsx
<PhoneCell phone="+998971025595" />
```

---

## 📊 Структура таблицы

```
┌────────────────────────────────────────────────────────────┐
│ ПОЛЬЗОВАТЕЛЬ    │ ТЕЛЕФОН       │ СТАТУС  │ ДАТА    │ ДЕЙСТВИЯ │
├────────────────────────────────────────────────────────────┤
│ [A] Shahzod     │ +998971025595 │ [Активный] │ 12.12.2024 │ 👁 ✏️ 🗑 │
│     megatestern │               │         │         │          │
├────────────────────────────────────────────────────────────┤
│ [T] Test User 1 │ +998901111111 │ [Активный] │ 12.12.2024 │ 👁 ✏️ 🗑 │
│     user1@test  │               │         │         │          │
└────────────────────────────────────────────────────────────┘
```

---

## 🎨 Стили

### Таблица

```css
/* Container */
bg-white
rounded-lg
border border-gray-200

/* Header */
bg-gray-50
border-b border-gray-200
text-xs font-semibold text-gray-600 uppercase

/* Rows */
hover:bg-gray-50
divide-y divide-gray-200

/* Cells */
px-6 py-4
text-sm text-gray-900
```

### Кнопки действий

```css
/* View */
text-gray-600
hover:bg-gray-100

/* Edit */
text-blue-600
hover:bg-blue-50

/* Delete */
text-red-600
hover:bg-red-50
```

---

## 📝 Примеры для других страниц

### Partners

```javascript
const columns = [
  {
    header: 'Партнер',
    accessor: 'name',
    render: (row) => (
      <UserCell 
        name={row.name} 
        email={row.description}
      />
    )
  },
  {
    header: 'Город',
    accessor: 'city',
    render: (row) => (
      <span className="text-sm text-gray-900">{row.city || '—'}</span>
    )
  },
  {
    header: 'Статус',
    accessor: 'is_active',
    render: (row) => (
      <StatusBadge status={row.is_active ? 'active' : 'inactive'} />
    )
  },
  {
    header: 'Дата создания',
    accessor: 'created_at',
    render: (row) => <DateCell date={row.created_at} />
  }
];
```

### Subscriptions

```javascript
const columns = [
  {
    header: 'Пользователь',
    accessor: 'user',
    render: (row) => (
      <UserCell 
        name={row.user?.full_name} 
        email={row.user?.email}
      />
    )
  },
  {
    header: 'План',
    accessor: 'plan_name',
    render: (row) => (
      <span className="text-sm font-semibold text-gray-900">{row.plan_name}</span>
    )
  },
  {
    header: 'Статус',
    accessor: 'status',
    render: (row) => <StatusBadge status={row.status} />
  },
  {
    header: 'Визиты',
    accessor: 'visits_remaining',
    render: (row) => (
      <span className="text-sm text-gray-900">
        {row.visits_remaining} / {row.visit_limit}
      </span>
    )
  },
  {
    header: 'Окончание',
    accessor: 'end_date',
    render: (row) => <DateCell date={row.end_date} />
  }
];
```

### Payments

```javascript
const columns = [
  {
    header: 'Пользователь',
    accessor: 'user',
    render: (row) => (
      <UserCell 
        name={row.user?.full_name} 
        email={row.user?.email}
      />
    )
  },
  {
    header: 'Сумма',
    accessor: 'amount',
    render: (row) => (
      <span className="text-sm font-semibold text-gray-900">
        {formatUZS(row.amount)}
      </span>
    )
  },
  {
    header: 'Метод',
    accessor: 'payment_method',
    render: (row) => (
      <span className="text-sm text-gray-900">{row.payment_method}</span>
    )
  },
  {
    header: 'Статус',
    accessor: 'status',
    render: (row) => <StatusBadge status={row.status} />
  },
  {
    header: 'Дата',
    accessor: 'created_at',
    render: (row) => <DateCell date={row.created_at} />
  }
];
```

---

## ✅ Результат

**Таблицы теперь:**
- ✅ Чистый минималистичный дизайн
- ✅ Без shadows
- ✅ Только borders
- ✅ Hover эффекты
- ✅ Цветные badges для статусов
- ✅ Иконки действий
- ✅ Responsive
- ✅ Loading состояние
- ✅ Empty состояние

**Готово! 📊**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
