import React, { useState, useEffect } from 'react';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { QrCode, Download, Printer, RefreshCw, Copy, Check } from 'lucide-react';
import { QRCodeCanvas } from 'qrcode.react';
import axios from 'axios';

const QRCodeDisplay = () => {
  const { merchant, API_URL } = useMerchantAuth();
  const [qrToken, setQrToken] = useState('');
  const [loading, setLoading] = useState(true);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    console.log('Merchant data:', merchant);
    fetchQRCode();
  }, [merchant]);

  const fetchQRCode = async () => {
    setLoading(true);
    try {
      const partnerId = merchant?.partner?.id || merchant?.partner_id;
      
      if (!partnerId) {
        console.error('No partner ID found');
        // Generate demo token if no partner ID
        const demoToken = `MERCHANT_DEMO_${Date.now()}`;
        setQrToken(demoToken);
        setLoading(false);
        return;
      }
      
      console.log('Fetching QR for partner:', partnerId);
      const response = await axios.get(`${API_URL}/api/partner/partners/${partnerId}/qr`);
      console.log('QR Response:', response.data);
      setQrToken(response.data.qr_token);
    } catch (error) {
      console.error('Error fetching QR code:', error);
      // Fallback to demo token on error
      const fallbackToken = `MERCHANT_${merchant?.partner?.id || 'DEMO'}_${Date.now()}`;
      setQrToken(fallbackToken);
    } finally {
      setLoading(false);
    }
  };

  const handleCopyToken = () => {
    navigator.clipboard.writeText(qrToken);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleDownloadQR = () => {
    const canvas = document.getElementById('qr-code-canvas');
    if (canvas) {
      const url = canvas.toDataURL('image/png');
      const link = document.createElement('a');
      link.download = `yuvgo-qr-${merchant?.partner?.name || 'merchant'}.png`;
      link.href = url;
      link.click();
    }
  };

  const handlePrint = () => {
    window.print();
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-gray-200 border-t-gray-900 rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-500">Загрузка QR кода...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">QR код для клиентов</h1>
        <p className="text-sm text-gray-500 mt-1">
          Покажите этот QR код клиентам для регистрации визита
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* QR Code Display */}
        <div className="bg-white rounded-lg border border-gray-200 p-8">
          <div className="text-center">
            <div className="inline-block p-8 bg-white rounded-2xl border-2 border-gray-200">
              <QRCodeCanvas
                id="qr-code-canvas"
                value={qrToken || 'MERCHANT_DEMO_TOKEN'}
                size={300}
                level="H"
                includeMargin={true}
              />
            </div>

            {/* Partner Info */}
            <div className="mt-6">
              <h2 className="text-xl font-bold text-gray-900">
                {merchant?.partner?.name || 'YuvGo Partner'}
              </h2>
              {merchant?.location && (
                <p className="text-sm text-gray-500 mt-1">{merchant.location.name}</p>
              )}
            </div>

            {/* Token */}
            <div className="mt-6 p-4 bg-gray-50 rounded-lg">
              <p className="text-xs text-gray-500 mb-2">QR Токен</p>
              <div className="flex items-center justify-center gap-2">
                <code className="text-sm font-mono text-gray-900 break-all">
                  {qrToken}
                </code>
                <button
                  onClick={handleCopyToken}
                  className="p-2 text-gray-600 hover:bg-gray-100 rounded-md transition-colors"
                  title="Копировать"
                >
                  {copied ? (
                    <Check size={16} className="text-green-600" />
                  ) : (
                    <Copy size={16} />
                  )}
                </button>
              </div>
            </div>

            {/* Actions */}
            <div className="mt-6 flex flex-col sm:flex-row gap-3">
              <button
                onClick={handleDownloadQR}
                className="flex-1 flex items-center justify-center gap-2 px-4 py-3 bg-gray-900 text-white rounded-lg hover:bg-gray-800 transition-colors"
              >
                <Download size={20} />
                <span>Скачать QR</span>
              </button>
              <button
                onClick={handlePrint}
                className="flex-1 flex items-center justify-center gap-2 px-4 py-3 bg-white text-gray-900 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <Printer size={20} />
                <span>Печать</span>
              </button>
              <button
                onClick={fetchQRCode}
                className="flex items-center justify-center gap-2 px-4 py-3 bg-white text-gray-900 border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <RefreshCw size={20} />
              </button>
            </div>
          </div>
        </div>

        {/* Instructions */}
        <div className="space-y-6">
          {/* How it works */}
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center">
                <QrCode size={24} className="text-blue-500" />
              </div>
              <h3 className="text-lg font-bold text-gray-900">Как это работает?</h3>
            </div>

            <ol className="space-y-3">
              <li className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-gray-900 text-white flex items-center justify-center text-sm font-bold flex-shrink-0">
                  1
                </div>
                <div>
                  <p className="font-semibold text-gray-900">Клиент открывает приложение</p>
                  <p className="text-sm text-gray-600">Пользователь запускает YuvGo на своем телефоне</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-gray-900 text-white flex items-center justify-center text-sm font-bold flex-shrink-0">
                  2
                </div>
                <div>
                  <p className="font-semibold text-gray-900">Сканирует QR код</p>
                  <p className="text-sm text-gray-600">Наводит камеру на этот QR код</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-gray-900 text-white flex items-center justify-center text-sm font-bold flex-shrink-0">
                  3
                </div>
                <div>
                  <p className="font-semibold text-gray-900">Визит регистрируется</p>
                  <p className="text-sm text-gray-600">Система автоматически записывает визит</p>
                </div>
              </li>
              <li className="flex items-start gap-3">
                <div className="w-6 h-6 rounded-full bg-green-600 text-white flex items-center justify-center text-sm font-bold flex-shrink-0">
                  ✓
                </div>
                <div>
                  <p className="font-semibold text-gray-900">Готово!</p>
                  <p className="text-sm text-gray-600">Клиент может начать мойку</p>
                </div>
              </li>
            </ol>
          </div>

          {/* Tips */}
          <div className="bg-blue-50 rounded-lg border border-blue-100 p-6">
            <h3 className="font-bold text-blue-900 mb-3">💡 Советы</h3>
            <ul className="space-y-2 text-sm text-blue-700">
              <li>• Распечатайте QR код и разместите на видном месте</li>
              <li>• Убедитесь, что код хорошо освещен</li>
              <li>• Держите код чистым и неповрежденным</li>
              <li>• Можно разместить несколько копий в разных местах</li>
            </ul>
          </div>

          {/* Stats */}
          <div className="bg-white rounded-lg border border-gray-200 p-6">
            <h3 className="font-bold text-gray-900 mb-4">Статистика сканирований</h3>
            <div className="grid grid-cols-2 gap-4">
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <p className="text-2xl font-black text-gray-900">—</p>
                <p className="text-xs text-gray-500 mt-1">Сегодня</p>
              </div>
              <div className="text-center p-4 bg-gray-50 rounded-lg">
                <p className="text-2xl font-black text-gray-900">—</p>
                <p className="text-xs text-gray-500 mt-1">За неделю</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Print Styles */}
      <style>{`
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
      `}</style>
    </div>
  );
};

export default QRCodeDisplay;
