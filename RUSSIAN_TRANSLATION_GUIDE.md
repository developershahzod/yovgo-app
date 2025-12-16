# YuvGo - Полный перевод на русский язык

## ✅ Статус: Система локализации создана

**Дата:** 15 декабря 2024  
**Версия:** 1.0.0

---

## 📁 Созданные файлы переводов

### 1. Admin Dashboard
```
frontend/admin-dashboard/src/locales/ru.json
```

**Разделы:**
- ✅ common - Общие фразы
- ✅ auth - Авторизация
- ✅ navigation - Навигация
- ✅ dashboard - Панель управления
- ✅ users - Пользователи
- ✅ partners - Партнеры
- ✅ subscriptions - Подписки
- ✅ payments - Платежи
- ✅ analytics - Аналитика
- ✅ messages - Сообщения

### 2. Merchant Dashboard
```
frontend/merchant-dashboard/src/locales/ru.json
```

**Разделы:**
- ✅ common - Общие фразы
- ✅ auth - Авторизация
- ✅ navigation - Навигация
- ✅ dashboard - Панель управления
- ✅ qrScanner - Сканер QR
- ✅ visitHistory - История визитов
- ✅ earnings - Доходы
- ✅ clients - Клиенты
- ✅ messages - Сообщения

### 3. User App
```
frontend/user-app/src/locales/ru.json
frontend/user-app/src/utils/i18n.js
```

**Разделы:**
- ✅ common - Общие фразы
- ✅ auth - Авторизация
- ✅ welcome - Экран приветствия
- ✅ navigation - Навигация
- ✅ home - Главная
- ✅ qr - QR код
- ✅ subscriptions - Подписки
- ✅ map - Карта
- ✅ profile - Профиль
- ✅ messages - Сообщения

---

## 🔧 Утилита i18n

### User App - i18n.js

```javascript
import translations from '../locales/ru.json';

export const t = (key) => {
  const keys = key.split('.');
  let value = translations;
  
  for (const k of keys) {
    if (value && typeof value === 'object') {
      value = value[k];
    } else {
      return key;
    }
  }
  
  return value || key;
};
```

### Использование

```javascript
import { t } from '../utils/i18n';

// В компоненте
<h1>{t('welcome.title')}</h1>
<p>{t('welcome.subtitle')}</p>
<button>{t('auth.signIn')}</button>
```

---

## 📝 Примеры переводов

### Welcome Screen

**Английский:**
```javascript
title: "YuvGo"
subtitle: "Your Car Wash Subscription"
unlimitedWashes: "Unlimited Washes"
```

**Русский:**
```javascript
title: "YuvGo"
subtitle: "Ваша подписка на автомойку"
unlimitedWashes: "Безлимитные мойки"
```

### Home Screen

**Английский:**
```javascript
welcomeBack: "Welcome back"
activePlan: "Active Plan"
visitsLeft: "Visits Left"
```

**Русский:**
```javascript
welcomeBack: "С возвращением"
activePlan: "Активный план"
visitsLeft: "Осталось визитов"
```

### QR Screen

**Английский:**
```javascript
title: "My QR Code"
generateQR: "Generate QR Code"
timeRemaining: "Time remaining"
```

**Русский:**
```javascript
title: "Мой QR код"
generateQR: "Сгенерировать QR код"
timeRemaining: "Осталось времени"
```

---

## 🎯 Обновленные компоненты

### User App

#### Welcome.js
```javascript
import { t } from '../utils/i18n';

// Использование
<h1>{t('welcome.title')}</h1>
<p>{t('welcome.subtitle')}</p>
<button>{t('auth.getStarted')}</button>
<span>{t('welcome.secure')}</span>
```

#### HomeNew.js
```javascript
import { t } from '../utils/i18n';

// Использование
<h1>{t('home.welcomeBack')}</h1>
<p>{t('home.activePlan')}</p>
<span>{t('home.visitsLeft')}</span>
```

---

## 🔄 Как добавить переводы в другие компоненты

### Шаг 1: Импортировать утилиту

```javascript
import { t } from '../utils/i18n';
```

### Шаг 2: Заменить текст

**До:**
```javascript
<h1>Welcome back</h1>
<button>Sign In</button>
<p>Loading...</p>
```

**После:**
```javascript
<h1>{t('home.welcomeBack')}</h1>
<button>{t('auth.signIn')}</button>
<p>{t('common.loading')}</p>
```

### Шаг 3: Добавить перевод в ru.json

```json
{
  "home": {
    "welcomeBack": "С возвращением"
  },
  "auth": {
    "signIn": "Войти"
  },
  "common": {
    "loading": "Загрузка..."
  }
}
```

---

## 📋 Полный список переводов

### Общие фразы (common)

| Английский | Русский |
|-----------|---------|
| Welcome | Добро пожаловать |
| Loading... | Загрузка... |
| Save | Сохранить |
| Cancel | Отмена |
| Delete | Удалить |
| Edit | Редактировать |
| Create | Создать |
| Update | Обновить |
| Search | Поиск |
| Filter | Фильтр |
| Export | Экспорт |
| Refresh | Обновить |
| Back | Назад |
| Next | Далее |
| Close | Закрыть |
| Yes | Да |
| No | Нет |
| Active | Активный |
| Inactive | Неактивный |

### Авторизация (auth)

| Английский | Русский |
|-----------|---------|
| Login | Вход |
| Logout | Выход |
| Sign In | Войти |
| Sign Up | Зарегистрироваться |
| Email | Email |
| Password | Пароль |
| Phone Number | Номер телефона |
| Full Name | Полное имя |
| Welcome Back | С возвращением |
| Get Started | Начать |

### Навигация (navigation)

| Английский | Русский |
|-----------|---------|
| Home | Главная |
| Dashboard | Панель управления |
| Users | Пользователи |
| Partners | Партнеры |
| Subscriptions | Подписки |
| Payments | Платежи |
| Analytics | Аналитика |
| Profile | Профиль |
| Settings | Настройки |

### QR функции

| Английский | Русский |
|-----------|---------|
| My QR Code | Мой QR код |
| Generate QR | Сгенерировать QR |
| QR Scanner | Сканер QR |
| Scan QR Code | Сканировать QR код |
| Time Remaining | Осталось времени |
| Expired | Истек |
| Invalid QR | Неверный QR |

### Подписки

| Английский | Русский |
|-----------|---------|
| Active Plan | Активный план |
| Choose Plan | Выбрать план |
| Subscribe | Подписаться |
| Upgrade | Улучшить |
| Unlimited | Безлимитный |
| Visits Left | Осталось визитов |
| Days Left | Осталось дней |
| Per Month | в месяц |

---

## 🚀 Следующие шаги

### Для полного перевода нужно:

1. **Создать i18n утилиты для Admin и Merchant Dashboard**
   ```bash
   cp frontend/user-app/src/utils/i18n.js frontend/admin-dashboard/src/utils/
   cp frontend/user-app/src/utils/i18n.js frontend/merchant-dashboard/src/utils/
   ```

2. **Обновить все компоненты**
   - Login страницы
   - Dashboard
   - Таблицы
   - Формы
   - Кнопки
   - Сообщения об ошибках

3. **Добавить переключатель языка**
   ```javascript
   // Компонент LanguageSwitcher
   const [lang, setLang] = useState('ru');
   
   <select onChange={(e) => setLang(e.target.value)}>
     <option value="ru">Русский</option>
     <option value="en">English</option>
   </select>
   ```

4. **Создать английские переводы**
   ```
   frontend/*/src/locales/en.json
   ```

---

## 📖 Структура файла переводов

```json
{
  "раздел": {
    "ключ": "значение",
    "вложенный": {
      "ключ": "значение"
    }
  }
}
```

### Пример:

```json
{
  "auth": {
    "login": "Вход",
    "fields": {
      "email": "Email",
      "password": "Пароль"
    },
    "buttons": {
      "signIn": "Войти",
      "signUp": "Зарегистрироваться"
    }
  }
}
```

### Использование:

```javascript
t('auth.login')           // "Вход"
t('auth.fields.email')    // "Email"
t('auth.buttons.signIn')  // "Войти"
```

---

## ✅ Checklist

### User App
- [x] Создан ru.json
- [x] Создана утилита i18n.js
- [x] Обновлен Welcome.js
- [x] Обновлен HomeNew.js
- [ ] Обновить Login.js
- [ ] Обновить Register.js
- [ ] Обновить MyQR.js
- [ ] Обновить Subscriptions.js
- [ ] Обновить Profile.js
- [ ] Обновить Map.js
- [ ] Обновить BottomNav.js

### Merchant Dashboard
- [x] Создан ru.json
- [ ] Создать i18n.js
- [ ] Обновить MerchantLogin.js
- [ ] Обновить Dashboard.js
- [ ] Обновить QRScanner.js
- [ ] Обновить VisitHistory.js
- [ ] Обновить Earnings.js
- [ ] Обновить Clients.js

### Admin Dashboard
- [x] Создан ru.json
- [ ] Создать i18n.js
- [ ] Обновить Login.js
- [ ] Обновить Dashboard.js
- [ ] Обновить Users.js
- [ ] Обновить Partners.js
- [ ] Обновить Subscriptions.js
- [ ] Обновить Payments.js
- [ ] Обновить Analytics.js

---

## 💡 Советы

### 1. Группировка переводов
Группируйте переводы логически:
```json
{
  "buttons": {
    "save": "Сохранить",
    "cancel": "Отмена"
  },
  "labels": {
    "name": "Имя",
    "email": "Email"
  }
}
```

### 2. Переиспользование
Используйте общие переводы:
```json
{
  "common": {
    "save": "Сохранить",
    "cancel": "Отмена"
  }
}
```

### 3. Плюрализация
Для множественного числа:
```json
{
  "visits": {
    "one": "визит",
    "few": "визита",
    "many": "визитов"
  }
}
```

### 4. Параметры
Для динамических значений:
```javascript
// В будущем можно добавить
t('welcome.greeting', { name: user.name })
// "Привет, {name}!"
```

---

## 🎉 Результат

**Создана полная система локализации:**
- ✅ Файлы переводов для всех приложений
- ✅ Утилита i18n для User App
- ✅ Примеры использования
- ✅ Документация
- ✅ Обновлены Welcome и Home страницы

**Готово к дальнейшему переводу всех компонентов!**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024  
**Версия:** 1.0.0
