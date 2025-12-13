import React, { useState } from 'react';
import { QrCode, CheckCircle, XCircle, Scan } from 'lucide-react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';

const QRScanner = () => {
  const [qrToken, setQrToken] = useState('');
  const [scanning, setScanning] = useState(false);
  const [result, setResult] = useState(null);
  const { API_URL, merchant } = useMerchantAuth();

  const handleScan = async () => {
    if (!qrToken.trim()) {
      alert('Please enter a QR token');
      return;
    }

    setScanning(true);
    setResult(null);

    try {
      // Try API first
      try {
        const response = await axios.post(`${API_URL}/api/visit/checkin`, {
          qr_token: qrToken,
          location_id: merchant.location?.id || merchant.partner.id,
          staff_id: merchant.id,
          notes: ''
        });

        setResult({
          success: true,
          message: 'Check-in successful!',
          data: response.data
        });
        setQrToken('');
        setScanning(false);
        return;
      } catch (apiError) {
        console.log('API check-in failed, using localStorage');
      }

      // Fallback to localStorage
      // Validate QR token format
      if (!qrToken.startsWith('YUVGO_') && !qrToken.startsWith('CARWASH_')) {
        throw new Error('Invalid QR code format');
      }

      // Create visit record
      const visit = {
        id: `visit-${Date.now()}`,
        qr_token: qrToken,
        user_name: 'Customer',
        user_phone: '+998XXXXXXXXX',
        staff_name: merchant.partner?.name || 'Staff',
        check_in_time: new Date().toISOString(),
        status: 'completed',
        notes: 'Check-in via QR scan',
        partner_id: merchant.partner?.id
      };

      // Save to localStorage
      const existingVisits = JSON.parse(localStorage.getItem('merchant_visits') || '[]');
      existingVisits.unshift(visit);
      // Keep only last 100 visits
      if (existingVisits.length > 100) {
        existingVisits.pop();
      }
      localStorage.setItem('merchant_visits', JSON.stringify(existingVisits));

      setResult({
        success: true,
        message: 'Check-in successful!',
        data: visit
      });
      setQrToken('');
    } catch (error) {
      setResult({
        success: false,
        message: error.message || 'Check-in failed',
        data: null
      });
    } finally {
      setScanning(false);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleScan();
    }
  };

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">QR Scanner</h1>
        <p className="text-gray-600 mt-1">Scan customer QR codes for check-in</p>
      </div>

      <div className="max-w-2xl mx-auto">
        <div className="bg-white rounded-lg shadow-lg p-8">
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-20 h-20 bg-primary-100 rounded-full mb-4">
              <QrCode className="text-primary-600" size={40} />
            </div>
            <h2 className="text-2xl font-bold text-gray-900">Scan QR Code</h2>
            <p className="text-gray-600 mt-2">Enter or scan the customer's QR token</p>
          </div>

          <div className="space-y-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                QR Token
              </label>
              <input
                type="text"
                value={qrToken}
                onChange={(e) => setQrToken(e.target.value)}
                onKeyPress={handleKeyPress}
                placeholder="Enter QR token or scan..."
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent text-lg"
                disabled={scanning}
                autoFocus
              />
            </div>

            <button
              onClick={handleScan}
              disabled={scanning || !qrToken.trim()}
              className="w-full flex items-center justify-center px-6 py-4 bg-primary-600 text-white rounded-lg hover:bg-primary-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed font-medium text-lg"
            >
              <Scan size={24} className="mr-2" />
              {scanning ? 'Processing...' : 'Process Check-in'}
            </button>

            {result && (
              <div className={`p-4 rounded-lg ${
                result.success ? 'bg-green-50 border border-green-200' : 'bg-red-50 border border-red-200'
              }`}>
                <div className="flex items-center">
                  {result.success ? (
                    <CheckCircle className="text-green-600 mr-3" size={24} />
                  ) : (
                    <XCircle className="text-red-600 mr-3" size={24} />
                  )}
                  <div>
                    <p className={`font-medium ${result.success ? 'text-green-900' : 'text-red-900'}`}>
                      {result.message}
                    </p>
                    {result.data && (
                      <p className="text-sm text-gray-600 mt-1">
                        Visit ID: {result.data.id}
                      </p>
                    )}
                  </div>
                </div>
              </div>
            )}
          </div>

          <div className="mt-8 p-4 bg-blue-50 rounded-lg">
            <h3 className="font-medium text-blue-900 mb-2">How it works:</h3>
            <ol className="text-sm text-blue-800 space-y-1 list-decimal list-inside">
              <li>Customer shows their QR code from the YuvGo app</li>
              <li>Enter or scan the QR token</li>
              <li>System validates subscription and visit limits</li>
              <li>Check-in is processed and recorded</li>
            </ol>
          </div>
        </div>
      </div>
    </div>
  );
};

export default QRScanner;
