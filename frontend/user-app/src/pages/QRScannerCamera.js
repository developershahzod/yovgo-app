import React, { useState, useEffect, useRef } from 'react';
import { useAuth } from '../context/AuthContext';
import { QrCode, Camera, AlertCircle, CheckCircle, X, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import BottomNav from '../components/BottomNav';
import jsQR from 'jsqr';

const QRScannerCamera = () => {
  const { user, API_URL } = useAuth();
  const navigate = useNavigate();
  const [qrToken, setQrToken] = useState('');
  const [scanning, setScanning] = useState(false);
  const [cameraActive, setCameraActive] = useState(false);
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  
  const videoRef = useRef(null);
  const canvasRef = useRef(null);
  const streamRef = useRef(null);
  const scanIntervalRef = useRef(null);

  useEffect(() => {
    return () => {
      stopCamera();
    };
  }, []);

  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'environment' }
      });
      
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        streamRef.current = stream;
        setCameraActive(true);
        
        // Start scanning
        scanIntervalRef.current = setInterval(() => {
          scanQRCode();
        }, 500);
      }
    } catch (err) {
      setError('Не удалось получить доступ к камере');
      console.error('Camera error:', err);
    }
  };

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

  const scanQRCode = () => {
    if (!videoRef.current || !canvasRef.current) return;

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

  const handleScan = async (token = qrToken) => {
    if (!token.trim()) {
      setError('Введите QR токен');
      return;
    }

    setScanning(true);
    setError('');
    setResult(null);

    try {
      const subscription = localStorage.getItem('active_subscription');
      if (!subscription) {
        setError('У вас нет активной подписки');
        setScanning(false);
        return;
      }

      const subData = JSON.parse(subscription);
      
      if (subData.visits_remaining <= 0 && !subData.is_unlimited) {
        setError('У вас закончились визиты');
        setScanning(false);
        return;
      }

      // Visit Service на порту 8004
      const VISIT_API = 'http://localhost:8004';
      const response = await axios.post(`${VISIT_API}/user-checkin`, {
        qr_token: token,
        user_id: user.id
      });

      setResult({
        success: true,
        message: 'Регистрация успешна!',
        data: response.data
      });

      // Обновляем visits_remaining из ответа backend
      if (response.data.visits_remaining !== undefined) {
        subData.visits_remaining = response.data.visits_remaining;
      } else {
        subData.visits_remaining -= 1;
      }
      localStorage.setItem('active_subscription', JSON.stringify(subData));

      setQrToken('');
      
      setTimeout(() => {
        navigate('/home');
      }, 2000);
    } catch (err) {
      setError(err.response?.data?.detail || 'Ошибка регистрации');
    } finally {
      setScanning(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F5F5F7] pb-24">
      {/* Header */}
      <div className="bg-white px-6 py-4 border-b border-gray-200">
        <div className="flex items-center gap-4">
          <button 
            onClick={() => navigate('/home')}
            className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center"
          >
            <ArrowLeft size={20} className="text-gray-700" />
          </button>
          <div>
            <h1 className="text-xl font-bold text-gray-900">Сканер QR</h1>
            <p className="text-sm text-gray-500">Отсканируйте код на автомойке</p>
          </div>
        </div>
      </div>

      <div className="px-6 py-6 space-y-4">
        {/* Camera View */}
        {cameraActive ? (
          <div className="bg-white rounded-2xl overflow-hidden border border-gray-200">
            <div className="relative">
              <video
                ref={videoRef}
                autoPlay
                playsInline
                className="w-full h-96 object-cover"
              />
              <canvas ref={canvasRef} className="hidden" />
              
              {/* Scanning Overlay */}
              <div className="absolute inset-0 flex items-center justify-center">
                <div className="w-64 h-64 border-4 border-white rounded-2xl relative">
                  <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-yuvgo-cyan rounded-tl-2xl"></div>
                  <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-yuvgo-cyan rounded-tr-2xl"></div>
                  <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-yuvgo-cyan rounded-bl-2xl"></div>
                  <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-yuvgo-cyan rounded-br-2xl"></div>
                </div>
              </div>
              
              {/* Close Button */}
              <button
                onClick={stopCamera}
                className="absolute top-4 right-4 w-10 h-10 rounded-full bg-black/50 backdrop-blur-sm flex items-center justify-center"
              >
                <X size={20} className="text-white" />
              </button>
            </div>
            
            <div className="p-4 bg-gray-50 text-center">
              <p className="text-sm text-gray-600">Наведите камеру на QR код</p>
            </div>
          </div>
        ) : (
          <>
            {/* Camera Button */}
            <button
              onClick={startCamera}
              className="w-full bg-white rounded-2xl p-6 flex items-center gap-4 active:scale-95 transition-transform border border-gray-200"
            >
              <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center">
                <Camera size={32} className="text-white" />
              </div>
              <div className="flex-1 text-left">
                <h3 className="text-lg font-bold text-gray-900">Сканировать камерой</h3>
                <p className="text-sm text-gray-500">Откройте камеру для сканирования</p>
              </div>
            </button>

            {/* Manual Input */}
            <div className="bg-white rounded-2xl p-6 border border-gray-200">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center">
                  <QrCode size={24} className="text-blue-500" />
                </div>
                <div>
                  <h3 className="font-bold text-gray-900">Ввести вручную</h3>
                  <p className="text-sm text-gray-500">Введите код с автомойки</p>
                </div>
              </div>

              <input
                type="text"
                value={qrToken}
                onChange={(e) => setQrToken(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleScan()}
                className="w-full px-4 py-4 border-2 border-gray-200 rounded-xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none text-gray-900 placeholder-gray-400 mb-4"
                placeholder="MERCHANT_123_456789"
                disabled={scanning}
              />

              <button
                onClick={() => handleScan()}
                disabled={scanning || !qrToken}
                className="w-full bg-gray-900 text-white py-4 rounded-xl font-bold disabled:opacity-50 disabled:cursor-not-allowed active:scale-95 transition-all"
              >
                {scanning ? (
                  <span className="flex items-center justify-center gap-2">
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    Обработка...
                  </span>
                ) : (
                  'Зарегистрировать визит'
                )}
              </button>
            </div>
          </>
        )}

        {/* Error Message */}
        {error && (
          <div className="bg-red-50 border border-red-200 rounded-2xl p-4 flex items-start gap-3">
            <AlertCircle size={20} className="text-red-500 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-semibold text-red-900">Ошибка</p>
              <p className="text-sm text-red-700">{error}</p>
            </div>
          </div>
        )}

        {/* Success Message */}
        {result?.success && (
          <div className="bg-green-50 border border-green-200 rounded-2xl p-4 flex items-start gap-3">
            <CheckCircle size={20} className="text-green-500 flex-shrink-0 mt-0.5" />
            <div>
              <p className="font-semibold text-green-900">Успешно!</p>
              <p className="text-sm text-green-700">{result.message}</p>
              <p className="text-xs text-green-600 mt-1">Осталось визитов: {result.data?.visits_remaining}</p>
            </div>
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default QRScannerCamera;
