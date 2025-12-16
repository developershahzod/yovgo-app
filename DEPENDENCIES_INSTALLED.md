# Dependencies Installed

## ✅ Статус: Все зависимости установлены

**Дата:** 15 декабря 2024

---

## 📦 Установленные пакеты

### User App

**jsqr** - для сканирования QR кодов через камеру

```bash
cd frontend/user-app
npm install jsqr
```

**Использование:**
```javascript
import jsQR from 'jsqr';

const code = jsQR(imageData.data, imageData.width, imageData.height);
if (code) {
  console.log('QR Code found:', code.data);
}
```

**Где используется:**
- `src/pages/QRScannerCamera.js`

---

### Merchant Dashboard

**qrcode.react** - для отображения QR кодов

```bash
cd frontend/merchant-dashboard
npm install qrcode.react
```

**Использование:**
```javascript
import QRCodeReact from 'qrcode.react';

<QRCodeReact
  value={qrToken}
  size={300}
  level="H"
  includeMargin={true}
/>
```

**Где используется:**
- `src/pages/QRCodeDisplay.js`

---

## ✅ Результат

**Ошибки исправлены:**
- ✅ `Cannot find module 'jsqr'` - исправлено
- ✅ User App QR Scanner работает
- ✅ Merchant Dashboard QR Display работает

---

## 🔧 Если нужно переустановить

### User App

```bash
cd frontend/user-app
npm install jsqr
```

### Merchant Dashboard

```bash
cd frontend/merchant-dashboard
npm install qrcode.react
```

---

**Готово! 📦**

---

**Автор:** Cascade AI  
**Дата:** 15 декабря 2024
