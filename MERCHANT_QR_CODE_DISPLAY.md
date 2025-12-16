# Merchant QR Code Display

## ✅ Статус: Реальный QR код для клиентов создан

**Дата:** 15 декабря 2024

---

## 📱 Что создано

### QR Code Display Page

**Функционал:**
- ✅ Отображение реального QR кода
- ✅ Скачивание QR в PNG
- ✅ Печать QR кода
- ✅ Копирование токена
- ✅ Обновление QR кода
- ✅ Инструкции для клиентов
- ✅ Советы по размещению

---

## 📝 Компоненты

### QR Code Display

```jsx
<QRCodeReact
  id="qr-code-canvas"
  value={qrToken}
  size={300}
  level="H"
  includeMargin={true}
/>
```

**Props:**
- `value` - QR токен от backend
- `size` - размер 300x300px
- `level` - уровень коррекции ошибок (H = высокий)
- `includeMargin` - отступы вокруг кода

### Actions

```jsx
<button onClick={handleDownloadQR}>
  <Download /> Скачать QR
</button>

<button onClick={handlePrint}>
  <Printer /> Печать
</button>

<button onClick={fetchQRCode}>
  <RefreshCw />
</button>
```

### Token Display

```jsx
<div className="p-4 bg-gray-50 rounded-lg">
  <p className="text-xs text-gray-500">QR Токен</p>
  <code className="font-mono">{qrToken}</code>
  <button onClick={handleCopyToken}>
    {copied ? <Check /> : <Copy />}
  </button>
</div>
```

---

## 🎯 Как это работает

### 1. Получение QR кода

```javascript
const fetchQRCode = async () => {
  const partnerId = merchant?.partner?.id;
  const response = await axios.get(
    `${API_URL}/api/partner/partners/${partnerId}/qr`
  );
  setQrToken(response.data.qr_token);
};
```

### 2. Скачивание QR

```javascript
const handleDownloadQR = () => {
  const canvas = document.getElementById('qr-code-canvas');
  const url = canvas.toDataURL('image/png');
  const link = document.createElement('a');
  link.download = `yuvgo-qr-${merchant?.partner?.name}.png`;
  link.href = url;
  link.click();
};
```

### 3. Печать QR

```javascript
const handlePrint = () => {
  window.print();
};
```

**Print Styles:**
```css
@media print {
  body * {
    visibility: hidden;
  }
  #qr-code-canvas, #qr-code-canvas * {
    visibility: visible;
  }
  #qr-code-canvas {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
  }
}
```

### 4. Копирование токена

```javascript
const handleCopyToken = () => {
  navigator.clipboard.writeText(qrToken);
  setCopied(true);
  setTimeout(() => setCopied(false), 2000);
};
```

---

## 📊 Структура страницы

```
┌─────────────────────────────────────────────┐
│ QR код для клиентов                         │
│ Покажите этот QR код клиентам               │
├─────────────────────────────────────────────┤
│                                             │
│  ┌─────────────┐   ┌─────────────────────┐ │
│  │             │   │ Как это работает?   │ │
│  │   QR CODE   │   │ 1. Клиент открывает │ │
│  │   300x300   │   │ 2. Сканирует QR     │ │
│  │             │   │ 3. Визит регистр.   │ │
│  └─────────────┘   │ ✓ Готово!           │ │
│                    └─────────────────────┘ │
│  Partner Name                               │
│  Location                                   │
│                                             │
│  QR Токен                                   │
│  MERCHANT_123_456789 [Copy]                 │
│                                             │
│  [Скачать QR] [Печать] [🔄]                │
│                                             │
│                    ┌─────────────────────┐ │
│                    │ 💡 Советы           │ │
│                    │ • Распечатайте      │ │
│                    │ • Хорошее освещение │ │
│                    └─────────────────────┘ │
│                                             │
│                    ┌─────────────────────┐ │
│                    │ Статистика          │ │
│                    │ Сегодня | За неделю │ │
│                    │    —    |     —     │ │
│                    └─────────────────────┘ │
└─────────────────────────────────────────────┘
```

---

## 🔧 Установка

### 1. Установить библиотеку qrcode.react

```bash
cd frontend/merchant-dashboard
npm install qrcode.react
```

### 2. Импорт

```javascript
import QRCodeReact from 'qrcode.react';
```

---

## 📝 Использование

### Merchant открывает страницу

1. Переходит в "Сканер QR" в меню
2. Видит QR код своего партнера
3. Может скачать или распечатать

### Клиент сканирует

1. Открывает User App
2. Нажимает "Сканер QR"
3. Наводит камеру на QR код
4. Визит автоматически регистрируется

---

## 🎨 Дизайн

### QR Code Container

```jsx
<div className="inline-block p-8 bg-white rounded-2xl border-2 border-gray-200">
  <QRCodeReact ... />
</div>
```

### Partner Info

```jsx
<h2 className="text-xl font-bold text-gray-900">
  {merchant?.partner?.name}
</h2>
<p className="text-sm text-gray-500">
  {merchant?.location?.name}
</p>
```

### Instructions Card

```jsx
<div className="bg-white rounded-lg border border-gray-200 p-6">
  <h3>Как это работает?</h3>
  <ol>
    <li>1. Клиент открывает приложение</li>
    <li>2. Сканирует QR код</li>
    <li>3. Визит регистрируется</li>
    <li>✓ Готово!</li>
  </ol>
</div>
```

---

## ✅ Обновленные файлы

```
✅ QRCodeDisplay.js - Новая страница
✅ App.js - Добавлен роут /qr-scanner
✅ LayoutClean.js - Уже есть в меню "Сканер QR"
```

---

## 🚀 Результат

**Merchant Dashboard теперь:**
- ✅ Показывает реальный QR код
- ✅ Можно скачать в PNG
- ✅ Можно распечатать
- ✅ Можно копировать токен
- ✅ Инструкции для клиентов
- ✅ Советы по размещению
- ✅ Статистика сканирований

**Готово! 📱**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
