# QR Camera Scanner - User App

## ✅ Статус: Камера для сканирования QR добавлена

**Дата:** 15 декабря 2024

---

## 📷 Новый функционал

### Что добавлено

**Сканирование через камеру:**
- ✅ Доступ к камере устройства
- ✅ Автоматическое распознавание QR кода
- ✅ Real-time сканирование
- ✅ Визуальная рамка для наведения
- ✅ Ручной ввод как альтернатива

---

## 🔧 Установка

### 1. Установить библиотеку jsQR

```bash
cd frontend/user-app
npm install jsqr
```

### 2. Обновить App.js

```javascript
import QRScannerUser from './pages/QRScannerCamera';
```

---

## 📝 Компоненты

### Camera View

```jsx
<div className="bg-white rounded-2xl overflow-hidden">
  <div className="relative">
    {/* Video Stream */}
    <video
      ref={videoRef}
      autoPlay
      playsInline
      className="w-full h-96 object-cover"
    />
    
    {/* Scanning Overlay */}
    <div className="absolute inset-0 flex items-center justify-center">
      <div className="w-64 h-64 border-4 border-white rounded-2xl relative">
        {/* Corner Markers */}
        <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-yuvgo-cyan"></div>
        <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-yuvgo-cyan"></div>
        <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-yuvgo-cyan"></div>
        <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-yuvgo-cyan"></div>
      </div>
    </div>
    
    {/* Close Button */}
    <button onClick={stopCamera}>
      <X />
    </button>
  </div>
  
  <div className="p-4 bg-gray-50 text-center">
    <p>Наведите камеру на QR код</p>
  </div>
</div>
```

### Camera Button

```jsx
<button onClick={startCamera}>
  <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark">
    <Camera size={32} className="text-white" />
  </div>
  <div>
    <h3>Сканировать камерой</h3>
    <p>Откройте камеру для сканирования</p>
  </div>
</button>
```

### Manual Input

```jsx
<div className="bg-white rounded-2xl p-6">
  <div className="flex items-center gap-3">
    <QrCode />
    <div>
      <h3>Ввести вручную</h3>
      <p>Введите код с автомойки</p>
    </div>
  </div>
  
  <input
    type="text"
    value={qrToken}
    onChange={(e) => setQrToken(e.target.value)}
    placeholder="MERCHANT_123_456789"
  />
  
  <button onClick={handleScan}>
    Зарегистрировать визит
  </button>
</div>
```

---

## 🎯 Функционал

### 1. Запуск камеры

```javascript
const startCamera = async () => {
  const stream = await navigator.mediaDevices.getUserMedia({
    video: { facingMode: 'environment' }
  });
  
  videoRef.current.srcObject = stream;
  streamRef.current = stream;
  setCameraActive(true);
  
  // Start scanning
  scanIntervalRef.current = setInterval(() => {
    scanQRCode();
  }, 500);
};
```

### 2. Сканирование QR

```javascript
const scanQRCode = () => {
  const video = videoRef.current;
  const canvas = canvasRef.current;
  const context = canvas.getContext('2d');

  if (video.readyState === video.HAVE_ENOUGH_DATA) {
    canvas.height = video.videoHeight;
    canvas.width = video.videoWidth;
    context.drawImage(video, 0, 0, canvas.width, canvas.height);
    
    const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
    const code = jsQR(imageData.data, imageData.width, imageData.height);

    if (code) {
      setQrToken(code.data);
      stopCamera();
      handleScan(code.data);
    }
  }
};
```

### 3. Остановка камеры

```javascript
const stopCamera = () => {
  if (streamRef.current) {
    streamRef.current.getTracks().forEach(track => track.stop());
    streamRef.current = null;
  }
  if (scanIntervalRef.current) {
    clearInterval(scanIntervalRef.current);
    scanIntervalRef.current = null;
  }
  setCameraActive(false);
};
```

### 4. Обработка сканирования

```javascript
const handleScan = async (token) => {
  // Проверка подписки
  const subscription = localStorage.getItem('active_subscription');
  
  // Отправка на backend
  const response = await axios.post(`${API_URL}/api/visit/user-checkin`, {
    qr_token: token,
    user_id: user.id
  });
  
  // Обновление подписки
  subData.visits_remaining -= 1;
  localStorage.setItem('active_subscription', JSON.stringify(subData));
  
  // Редирект на главную
  setTimeout(() => navigate('/home'), 2000);
};
```

---

## 📊 Структура

```
┌─────────────────────────────┐
│ [←] Сканер QR               │
│     Отсканируйте код        │
├─────────────────────────────┤
│ [📷] Сканировать камерой    │
│      Откройте камеру        │
├─────────────────────────────┤
│ [QR] Ввести вручную         │
│      Введите код            │
│      [___________________]  │
│      [Зарегистрировать]     │
├─────────────────────────────┤
│ 💡 Как это работает?        │
│    1. Нажмите кнопку        │
│    2. Наведите камеру       │
│    3. Дождитесь сканирования│
└─────────────────────────────┘
```

### Camera Active

```
┌─────────────────────────────┐
│ [Video Stream]              │
│   ┌───────────────┐         │
│   │   [QR Frame]  │         │
│   └───────────────┘         │
│              [X]            │
├─────────────────────────────┤
│ Наведите камеру на QR код   │
└─────────────────────────────┘
```

---

## 🎨 Визуальные элементы

### Scanning Frame

```jsx
<div className="w-64 h-64 border-4 border-white rounded-2xl relative">
  {/* Top Left */}
  <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-yuvgo-cyan rounded-tl-2xl"></div>
  
  {/* Top Right */}
  <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-yuvgo-cyan rounded-tr-2xl"></div>
  
  {/* Bottom Left */}
  <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-yuvgo-cyan rounded-bl-2xl"></div>
  
  {/* Bottom Right */}
  <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-yuvgo-cyan rounded-br-2xl"></div>
</div>
```

---

## ⚙️ Настройки камеры

### Использование задней камеры

```javascript
const stream = await navigator.mediaDevices.getUserMedia({
  video: { facingMode: 'environment' }  // Задняя камера
});
```

### Частота сканирования

```javascript
setInterval(() => {
  scanQRCode();
}, 500);  // Каждые 500ms
```

---

## 🔒 Разрешения

### Запрос доступа к камере

```javascript
try {
  const stream = await navigator.mediaDevices.getUserMedia({
    video: { facingMode: 'environment' }
  });
} catch (err) {
  setError('Не удалось получить доступ к камере');
}
```

### Очистка ресурсов

```javascript
useEffect(() => {
  return () => {
    stopCamera();  // Cleanup on unmount
  };
}, []);
```

---

## ✅ Обновленные файлы

```
✅ QRScannerCamera.js - Новый сканер с камерой
✅ App.js - Обновлен роут
✅ package.json - Добавлена зависимость jsqr
```

---

## 📦 Зависимости

```json
{
  "dependencies": {
    "jsqr": "^1.4.0"
  }
}
```

---

## 🚀 Результат

**QR Scanner теперь:**
- ✅ Использует камеру для сканирования
- ✅ Автоматическое распознавание
- ✅ Визуальная рамка для наведения
- ✅ Ручной ввод как альтернатива
- ✅ Автоматическая остановка камеры
- ✅ Очистка ресурсов
- ✅ Обработка ошибок

**Готово! 📷**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
