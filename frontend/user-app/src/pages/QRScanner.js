import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Camera, AlertCircle, CheckCircle, Sparkles, CreditCard, Calendar, Award, Scan, X } from 'lucide-react';
import { Html5QrcodeScanner } from 'html5-qrcode';

const QRScanner = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [subscription, setSubscription] = useState(null);
  const [manualCode, setManualCode] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [scanning, setScanning] = useState(false);
  const scannerRef = useRef(null);
  const qrScannerRef = useRef(null);

  useEffect(() => {
    loadSubscription();
    return () => {
      // Cleanup scanner on unmount
      if (qrScannerRef.current) {
        qrScannerRef.current.clear().catch(console.error);
      }
    };
  }, []);

  const loadSubscription = () => {
    const subData = localStorage.getItem('active_subscription');
    if (subData) {
      setSubscription(JSON.parse(subData));
    }
  };

  const startScanning = () => {
    if (!subscription) {
      setError('You need an active subscription first!');
      return;
    }

    setScanning(true);
    setError('');
    setSuccess('');

    // Initialize scanner
    setTimeout(() => {
      if (scannerRef.current && !qrScannerRef.current) {
        qrScannerRef.current = new Html5QrcodeScanner(
          "qr-reader",
          { 
            fps: 10,
            qrbox: { width: 250, height: 250 },
            aspectRatio: 1.0
          },
          false
        );

        qrScannerRef.current.render(onScanSuccess, onScanError);
      }
    }, 100);
  };

  const stopScanning = () => {
    if (qrScannerRef.current) {
      qrScannerRef.current.clear().catch(console.error);
      qrScannerRef.current = null;
    }
    setScanning(false);
  };

  const onScanSuccess = (decodedText, decodedResult) => {
    console.log(`QR Code detected: ${decodedText}`);
    handleQRCode(decodedText);
    stopScanning();
  };

  const onScanError = (error) => {
    // Ignore errors during scanning
    console.warn(`QR Scan error: ${error}`);
  };

  const handleQRCode = (code) => {
    setError('');
    setSuccess('');

    if (!subscription) {
      setError('You need an active subscription first!');
      return;
    }

    // Check if subscription is still valid
    const endDate = new Date(subscription.end_date);
    const now = new Date();
    if (endDate < now) {
      setError('Your subscription has expired. Please renew to continue.');
      localStorage.removeItem('active_subscription');
      setSubscription(null);
      return;
    }

    // Check if visits remaining
    if (subscription.visits_remaining <= 0) {
      setError('No visits remaining. Please purchase a new subscription.');
      return;
    }

    // Validate QR code format
    if (code.startsWith('CARWASH_') || code.startsWith('YUVGO_PARTNER_')) {
      // Extract partner info if available
      let partnerInfo = '';
      let partnerId = '';
      if (code.startsWith('YUVGO_PARTNER_')) {
        const parts = code.split('_');
        partnerId = parts[2] || 'unknown';
        partnerInfo = ` at partner location`;
      }

      // Create visit record for merchant dashboard
      const visit = {
        id: `visit-${Date.now()}`,
        qr_token: code,
        user_name: user?.full_name || 'Customer',
        user_phone: user?.phone_number || '+998XXXXXXXXX',
        staff_name: 'Self Check-in',
        check_in_time: new Date().toISOString(),
        status: 'completed',
        notes: 'User self check-in via QR scan',
        partner_id: partnerId
      };

      // Save visit to merchant_visits localStorage
      const existingVisits = JSON.parse(localStorage.getItem('merchant_visits') || '[]');
      existingVisits.unshift(visit);
      // Keep only last 100 visits
      if (existingVisits.length > 100) {
        existingVisits.pop();
      }
      localStorage.setItem('merchant_visits', JSON.stringify(existingVisits));

      // Deduct a visit from subscription
      const updatedSub = {
        ...subscription,
        visits_remaining: subscription.visits_remaining - 1,
        visits_used: (subscription.visits_used || 0) + 1,
        last_visit: new Date().toISOString()
      };
      
      localStorage.setItem('active_subscription', JSON.stringify(updatedSub));
      setSubscription(updatedSub);
      
      setSuccess(`✅ Check-in successful${partnerInfo}! Enjoy your car wash! (${updatedSub.visits_remaining} visits remaining)`);
      
      setTimeout(() => setSuccess(''), 5000);
    } else {
      setError('Invalid QR code. Please scan a valid YuvGo partner QR code.');
    }
  };

  const handleManualSubmit = (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (!manualCode.trim()) {
      setError('Please enter a QR code');
      return;
    }

    handleQRCode(manualCode);
    setManualCode('');
  };

  const daysRemaining = subscription ? Math.ceil((new Date(subscription.end_date) - new Date()) / (1000 * 60 * 60 * 24)) : 0;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-br from-primary-500 to-primary-700 text-white p-6 rounded-b-3xl shadow-lg">
        <h1 className="text-2xl font-bold mb-2">Scan QR Code</h1>
        <p className="text-primary-100">Scan at the car wash to check in</p>
      </div>

      <div className="px-6 py-8 space-y-6">
        {/* Subscription Status */}
        {subscription ? (
          <div className="bg-white rounded-3xl shadow-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-bold text-gray-900">Active Subscription</h2>
              <div className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm font-medium">
                Active
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="bg-gradient-to-br from-blue-50 to-purple-50 rounded-xl p-4">
                <div className="flex items-center gap-2 text-gray-600 mb-2">
                  <Sparkles size={16} />
                  <span className="text-sm">Visits Left</span>
                </div>
                <p className="text-3xl font-bold text-primary-600">
                  {subscription.visits_remaining}
                </p>
              </div>

              <div className="bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl p-4">
                <div className="flex items-center gap-2 text-gray-600 mb-2">
                  <Calendar size={16} />
                  <span className="text-sm">Days Left</span>
                </div>
                <p className="text-3xl font-bold text-green-600">
                  {daysRemaining}
                </p>
              </div>
            </div>

            <div className="mt-4 pt-4 border-t border-gray-200">
              <div className="flex items-center justify-between text-sm">
                <span className="text-gray-600">Valid until</span>
                <span className="font-medium text-gray-900">
                  {new Date(subscription.end_date).toLocaleDateString()}
                </span>
              </div>
            </div>
          </div>
        ) : (
          <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
            <div className="flex items-start gap-3">
              <AlertCircle className="text-yellow-600 flex-shrink-0 mt-0.5" size={20} />
              <div className="flex-1">
                <p className="text-yellow-900 font-medium text-sm">No Active Subscription</p>
                <p className="text-yellow-700 text-sm mt-1 mb-3">
                  Please subscribe to a plan to use car wash services.
                </p>
                <button
                  onClick={() => navigate('/subscriptions')}
                  className="bg-primary-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-primary-700 transition-colors"
                >
                  View Plans
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Success Message */}
        {success && (
          <div className="bg-green-50 border border-green-200 rounded-xl p-4">
            <div className="flex items-start gap-3">
              <CheckCircle className="text-green-600 flex-shrink-0 mt-0.5" size={20} />
              <div>
                <p className="text-green-900 font-medium text-sm">Success!</p>
                <p className="text-green-700 text-sm mt-1">{success}</p>
              </div>
            </div>
          </div>
        )}

        {/* Error Message */}
        {error && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-4">
            <div className="flex items-start gap-3">
              <AlertCircle className="text-red-600 flex-shrink-0 mt-0.5" size={20} />
              <div>
                <p className="text-red-900 font-medium text-sm">Error</p>
                <p className="text-red-700 text-sm mt-1">{error}</p>
              </div>
            </div>
          </div>
        )}

        {/* QR Scanner */}
        <div className="bg-white rounded-3xl shadow-xl p-8">
          <div className="text-center mb-6">
            <div className="inline-flex items-center justify-center w-20 h-20 bg-primary-100 rounded-full mb-4">
              <Camera className="text-primary-600" size={40} />
            </div>
            <h3 className="text-xl font-bold text-gray-900 mb-2">Scan QR Code</h3>
            <p className="text-gray-600 text-sm">
              Point your camera at the QR code displayed at the car wash
            </p>
          </div>

          {/* Manual QR Code Input */}
          <div className="mb-6">
            <form onSubmit={handleManualSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Enter QR Code
                </label>
                <input
                  type="text"
                  value={manualCode}
                  onChange={(e) => setManualCode(e.target.value)}
                  placeholder="YUVGO_PARTNER_..."
                  disabled={!subscription}
                  className="w-full px-4 py-3 border-2 border-gray-300 rounded-xl focus:ring-2 focus:ring-primary-500 focus:border-transparent disabled:opacity-50 disabled:cursor-not-allowed"
                />
              </div>
              <button
                type="submit"
                disabled={!subscription || !manualCode.trim()}
                className="w-full py-4 bg-gradient-to-r from-primary-500 to-primary-600 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Check In
              </button>
            </form>
            {!subscription && (
              <p className="text-center text-sm text-red-600 mt-2">
                Please purchase a subscription first
              </p>
            )}
          </div>

          {/* Camera Scanner (if available) */}
          {!scanning ? (
            <div className="mb-6 pt-6 border-t">
              <button
                onClick={startScanning}
                disabled={!subscription}
                className="w-full py-3 bg-gray-100 text-gray-700 rounded-xl font-medium hover:bg-gray-200 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                <Camera size={20} />
                Or Use Camera Scanner
              </button>
            </div>
          ) : (
            <div className="mb-6">
              <div 
                id="qr-reader" 
                ref={scannerRef}
                className="rounded-2xl overflow-hidden"
              ></div>
              <button
                onClick={stopScanning}
                className="w-full mt-4 py-3 bg-red-500 text-white rounded-xl font-semibold hover:bg-red-600 transition-colors flex items-center justify-center gap-2"
              >
                <X size={20} />
                Stop Scanning
              </button>
            </div>
          )}

          {/* Manual Entry */}
          <div className="border-t border-gray-200 pt-6">
            <p className="text-center text-sm text-gray-600 mb-4">
              Or enter the code manually
            </p>
            <form onSubmit={handleManualSubmit} className="space-y-4">
              <input
                type="text"
                value={manualCode}
                onChange={(e) => setManualCode(e.target.value.toUpperCase())}
                placeholder="CARWASH_XXXXX"
                className="w-full px-4 py-3 border border-gray-300 rounded-xl text-center font-mono text-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                disabled={!subscription}
              />
              <button
                type="submit"
                disabled={!subscription || !manualCode.trim()}
                className="w-full bg-primary-600 text-white py-3 px-4 rounded-xl font-semibold hover:bg-primary-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Submit Code
              </button>
            </form>
          </div>
        </div>

        {/* Instructions */}
        <div className="bg-blue-50 rounded-2xl p-6">
          <div className="flex items-start gap-3">
            <CheckCircle className="text-blue-600 flex-shrink-0 mt-0.5" size={20} />
            <div>
              <p className="text-blue-900 font-medium mb-2">How to use:</p>
              <ol className="text-blue-700 text-sm space-y-2 list-decimal list-inside">
                <li>Drive to any partner car wash</li>
                <li>Find the QR code at the entrance</li>
                <li>Scan it with this app or enter the code manually</li>
                <li>Wait for confirmation</li>
                <li>Enjoy your car wash!</li>
              </ol>
            </div>
          </div>
        </div>

        {/* No Subscription CTA */}
        {!subscription && (
          <div className="bg-gradient-to-br from-primary-500 to-primary-700 rounded-2xl p-6 text-white">
            <div className="flex items-start gap-3 mb-4">
              <Award className="flex-shrink-0 mt-0.5" size={24} />
              <div>
                <h3 className="font-bold text-lg mb-1">Get Started Today!</h3>
                <p className="text-primary-100 text-sm">
                  Subscribe to a plan and start enjoying unlimited car washes
                </p>
              </div>
            </div>
            <button
              onClick={() => window.location.href = '/subscriptions'}
              className="w-full bg-white text-primary-600 py-3 px-4 rounded-xl font-semibold hover:bg-primary-50 transition-colors"
            >
              View Plans
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

export default QRScanner;
