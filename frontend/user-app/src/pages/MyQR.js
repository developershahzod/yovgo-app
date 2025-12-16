import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { AlertCircle, CheckCircle, Sparkles, Clock, RefreshCw } from 'lucide-react';
import QRCode from 'qrcode.react';
import axios from 'axios';
import BottomNav from '../components/BottomNav';

const MyQR = () => {
  const { user } = useAuth();
  const [qrData, setQrData] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [timeLeft, setTimeLeft] = useState(0);

  useEffect(() => {
    // Check for existing QR code
    const existingQR = localStorage.getItem('current_qr');
    if (existingQR) {
      const qr = JSON.parse(existingQR);
      const generatedAt = new Date(qr.generated_at);
      const now = new Date();
      const elapsed = Math.floor((now - generatedAt) / 1000);
      const remaining = qr.expires_in - elapsed;
      
      if (remaining > 0) {
        setQrData(qr);
        setTimeLeft(remaining);
      } else {
        localStorage.removeItem('current_qr');
      }
    }
  }, []);

  useEffect(() => {
    if (timeLeft > 0) {
      const timer = setInterval(() => {
        setTimeLeft(prev => {
          if (prev <= 1) {
            localStorage.removeItem('current_qr');
            setQrData(null);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
      return () => clearInterval(timer);
    }
  }, [timeLeft]);

  const generateQR = async () => {
    setLoading(true);
    setError('');
    
    try {
      const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';
      
      // Check if user has active subscription
      const subscription = localStorage.getItem('active_subscription');
      if (!subscription) {
        setError('You need an active subscription to generate QR code. Please subscribe first.');
        setLoading(false);
        return;
      }
      
      const subData = JSON.parse(subscription);
      
      // Check if subscription is still valid
      const endDate = new Date(subData.end_date);
      if (endDate < new Date()) {
        setError('Your subscription has expired. Please renew to continue.');
        setLoading(false);
        return;
      }
      
      // Check if user has visits remaining
      if (subData.visits_remaining <= 0 && !subData.is_unlimited) {
        setError('You have used all your visits for this period. Please upgrade or wait for renewal.');
        setLoading(false);
        return;
      }
      
      // Generate QR code data
      const qrToken = `YUVGO_${user.id}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
      const qrCodeData = {
        qr_token: qrToken,
        user_id: user.id,
        user_name: user.full_name,
        user_phone: user.phone_number,
        user_email: user.email,
        subscription_id: subData.id,
        visits_remaining: subData.visits_remaining,
        expires_in: 120, // 2 minutes
        generated_at: new Date().toISOString()
      };
      
      // Store QR data in localStorage for both User App and Merchant Dashboard
      localStorage.setItem('current_qr', JSON.stringify(qrCodeData));
      
      // Also store in a shared location that Merchant Dashboard can access
      // This simulates a shared database
      const sharedQRData = {
        ...qrCodeData,
        available_for_scan: true
      };
      localStorage.setItem(`qr_${qrToken}`, JSON.stringify(sharedQRData));
      
      // Try to register QR with API (optional, fallback to localStorage)
      try {
        const token = localStorage.getItem('token');
        if (token) {
          await axios.post(
            `${API_URL}/api/visit/qr/generate`,
            {},
            {
              headers: {
                'Authorization': `Bearer ${token}`
              }
            }
          );
        }
      } catch (apiError) {
        console.log('API QR generation failed, using localStorage fallback');
      }
      
      setQrData(qrCodeData);
      setTimeLeft(120); // 2 minutes
      
    } catch (error) {
      setError(error.response?.data?.detail || 'Failed to generate QR code');
    } finally {
      setLoading(false);
    }
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-br from-primary-500 to-primary-700 text-white p-6 rounded-b-3xl shadow-lg">
        <h1 className="text-2xl font-bold mb-2">My QR Code</h1>
        <p className="text-primary-100">Show this to the car wash staff</p>
      </div>

      <div className="px-6 py-8">
        {error && (
          <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-xl flex items-start space-x-3">
            <AlertCircle className="text-red-600 flex-shrink-0 mt-0.5" size={20} />
            <div>
              <p className="text-red-900 font-medium text-sm">Error</p>
              <p className="text-red-700 text-sm mt-1">{error}</p>
            </div>
          </div>
        )}

        {loading ? (
          <div className="flex flex-col items-center justify-center py-12">
            <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600 mb-4"></div>
            <p className="text-gray-600">Generating QR code...</p>
          </div>
        ) : qrData ? (
          <div className="bg-white rounded-3xl shadow-xl p-8">
            {/* Subscription Info */}
            {qrData.visits_remaining && (
              <div className="bg-gradient-to-r from-primary-50 to-purple-50 rounded-xl p-4 mb-6">
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-gray-600">Visits Remaining</p>
                    <p className="text-2xl font-bold text-primary-600">{qrData.visits_remaining}</p>
                  </div>
                  <Sparkles className="text-primary-600" size={32} />
                </div>
              </div>
            )}
            
            {/* Timer */}
            <div className="text-center mb-6">
              <div className={`inline-flex items-center space-x-2 px-4 py-2 rounded-full ${
                timeLeft > 60 ? 'bg-green-100 text-green-700' : 
                timeLeft > 30 ? 'bg-yellow-100 text-yellow-700' : 
                'bg-red-100 text-red-700'
              }`}>
                <Clock size={16} />
                <span className="font-semibold">{formatTime(timeLeft)}</span>
              </div>
              <p className="text-gray-600 text-sm mt-2">
                {timeLeft > 0 ? 'Time remaining' : 'Expired'}
              </p>
            </div>

            {/* QR Code */}
            <div className="flex justify-center mb-6">
              <div className="p-6 bg-white border-4 border-primary-600 rounded-2xl">
                <QRCode
                  value={qrData.qr_token}
                  size={240}
                  level="H"
                  includeMargin={false}
                />
              </div>
            </div>

            {/* Instructions */}
            <div className="bg-blue-50 rounded-xl p-4 mb-6">
              <div className="flex items-start space-x-3">
                <CheckCircle className="text-blue-600 flex-shrink-0 mt-0.5" size={20} />
                <div>
                  <p className="text-blue-900 font-medium text-sm mb-2">
                    How to use:
                  </p>
                  <ol className="text-blue-700 text-sm space-y-1 list-decimal list-inside">
                    <li>Drive to any partner car wash</li>
                    <li>Show this QR code to the staff</li>
                    <li>They will scan it to check you in</li>
                    <li>Enjoy your car wash!</li>
                  </ol>
                </div>
              </div>
            </div>

            {/* Refresh Button */}
            <button
              onClick={generateQR}
              disabled={loading || timeLeft > 60}
              className="w-full bg-primary-600 text-white py-3 px-4 rounded-xl font-semibold flex items-center justify-center space-x-2 hover:bg-primary-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <RefreshCw size={20} />
              <span>Generate New QR Code</span>
            </button>

            {timeLeft > 60 && (
              <p className="text-center text-gray-500 text-xs mt-3">
                You can generate a new code when this one expires
              </p>
            )}
          </div>
        ) : (
          <div className="bg-white rounded-3xl shadow-xl p-8 text-center">
            <AlertCircle className="mx-auto text-gray-300 mb-4" size={64} />
            <p className="text-gray-600 mb-6">No QR code generated yet</p>
            <button
              onClick={generateQR}
              className="bg-primary-600 text-white py-3 px-6 rounded-xl font-semibold hover:bg-primary-700 transition-colors"
            >
              Generate QR Code
            </button>
          </div>
        )}

        {/* Info Card */}
        <div className="mt-6 bg-gradient-to-br from-purple-50 to-pink-50 rounded-2xl p-6">
          <p className="text-purple-900 font-medium mb-2">💡 Did you know?</p>
          <p className="text-purple-700 text-sm">
            Each QR code is valid for 2 minutes and can only be used once for security. 
            There's a 4-hour cooldown between washes to prevent abuse.
          </p>
        </div>
      </div>
      <BottomNav />
    </div>
  );
};

export default MyQR;
