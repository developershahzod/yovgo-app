import React, { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { QrCode, Camera, AlertCircle, CheckCircle, Scan } from 'lucide-react';
import axios from 'axios';
import BottomNav from '../components/BottomNav';

const QRScannerUser = () => {
  const { user, API_URL } = useAuth();
  const [qrToken, setQrToken] = useState('');
  const [scanning, setScanning] = useState(false);
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');

  const handleScan = async () => {
    if (!qrToken.trim()) {
      setError('Введите QR токен');
      return;
    }

    setScanning(true);
    setError('');
    setResult(null);

    try {
      // Проверяем подписку
      const subscription = localStorage.getItem('active_subscription');
      if (!subscription) {
        setError('У вас нет активной подписки');
        setScanning(false);
        return;
      }

      const subData = JSON.parse(subscription);
      
      // Проверяем лимиты
      if (subData.visits_remaining <= 0 && !subData.is_unlimited) {
        setError('У вас закончились визиты');
        setScanning(false);
        return;
      }

      // Отправляем запрос на check-in
      const response = await axios.post(`${API_URL}/api/visit/user-checkin`, {
        qr_token: qrToken,
        user_id: user.id
      });

      setResult({
        success: true,
        message: 'Регистрация успешна!',
        data: response.data
      });

      // Обновляем подписку
      subData.visits_remaining -= 1;
      localStorage.setItem('active_subscription', JSON.stringify(subData));

      setQrToken('');
    } catch (err) {
      setError(err.response?.data?.detail || 'Ошибка регистрации');
    } finally {
      setScanning(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      {/* Header */}
      <div className="bg-white border-b border-gray-100 px-6 py-4">
        <h1 className="text-2xl font-bold text-gray-900">Сканер QR</h1>
        <p className="text-gray-600 text-sm mt-1">Отсканируйте QR код на автомойке</p>
      </div>

      <div className="px-6 py-6 space-y-6">
        {/* Scanner Card */}
        <div className="bg-white rounded-3xl p-6 border border-gray-100">
          <div className="flex items-center gap-3 mb-6">
            <div className="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center">
              <QrCode size={24} className="text-blue-500" />
            </div>
            <div>
              <h2 className="font-bold text-gray-900">Сканировать QR код</h2>
              <p className="text-gray-500 text-sm">Введите код с автомойки</p>
            </div>
          </div>

          {/* QR Input */}
          <div className="mb-4">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              QR Токен
            </label>
            <div className="relative">
              <input
                type="text"
                value={qrToken}
                onChange={(e) => setQrToken(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleScan()}
                className="w-full px-4 py-4 border-2 border-gray-200 rounded-2xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none text-gray-900 placeholder-gray-400"
                placeholder="Введите QR токен..."
                disabled={scanning}
              />
              <div className="absolute right-4 top-1/2 transform -translate-y-1/2">
                <Scan size={20} className="text-gray-400" />
              </div>
            </div>
          </div>

          {/* Scan Button */}
          <button
            onClick={handleScan}
            disabled={scanning || !qrToken.trim()}
            className="w-full bg-yuvgo-cyan text-white py-4 rounded-2xl font-bold flex items-center justify-center gap-2 active:scale-95 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {scanning ? (
              <>
                <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                <span>Обработка...</span>
              </>
            ) : (
              <>
                <Camera size={20} />
                <span>Зарегистрировать визит</span>
              </>
            )}
          </button>
        </div>

        {/* Result Messages */}
        {result && result.success && (
          <div className="bg-green-50 border border-green-200 rounded-2xl p-4 flex items-start gap-3 animate-fade-in">
            <CheckCircle className="text-green-600 flex-shrink-0 mt-0.5" size={20} />
            <div>
              <p className="text-sm font-semibold text-green-900">{result.message}</p>
              <p className="text-sm text-green-700 mt-1">
                Визит зарегистрирован успешно!
              </p>
            </div>
          </div>
        )}

        {error && (
          <div className="bg-red-50 border border-red-200 rounded-2xl p-4 flex items-start gap-3 animate-fade-in">
            <AlertCircle className="text-red-600 flex-shrink-0 mt-0.5" size={20} />
            <div>
              <p className="text-sm font-semibold text-red-900">Ошибка</p>
              <p className="text-sm text-red-700 mt-1">{error}</p>
            </div>
          </div>
        )}

        {/* Instructions */}
        <div className="bg-blue-50 rounded-2xl p-6 border border-blue-100">
          <h3 className="font-bold text-blue-900 mb-3">📱 Как использовать:</h3>
          <ol className="space-y-2 text-sm text-blue-700">
            <li className="flex items-start gap-2">
              <span className="font-bold">1.</span>
              <span>Приезжайте на партнерскую автомойку</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold">2.</span>
              <span>Попросите сотрудника показать QR код автомойки</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold">3.</span>
              <span>Введите код в поле выше или отсканируйте камерой</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold">4.</span>
              <span>Нажмите "Зарегистрировать визит"</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="font-bold">5.</span>
              <span>Наслаждайтесь мойкой!</span>
            </li>
          </ol>
        </div>

        {/* Info Card */}
        <div className="bg-white rounded-2xl p-6 border border-gray-100">
          <p className="text-gray-600 text-sm mb-2">💡 <strong>Важно:</strong></p>
          <p className="text-gray-600 text-sm">
            Каждая автомойка имеет уникальный QR код. Сканируйте код на месте для регистрации визита.
            Один визит будет вычтен из вашей подписки.
          </p>
        </div>
      </div>

      <BottomNav />
    </div>
  );
};

export default QRScannerUser;
