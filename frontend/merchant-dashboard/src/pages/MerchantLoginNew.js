import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { 
  Store, Phone, Lock, Eye, EyeOff, AlertCircle, 
  QrCode, TrendingUp, Users, Zap, Shield, Sparkles 
} from 'lucide-react';

const MerchantLoginNew = () => {
  const [phoneNumber, setPhoneNumber] = useState('');
  const [pinCode, setPinCode] = useState('');
  const [showPin, setShowPin] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useMerchantAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const result = await login(phoneNumber, pinCode);

    if (result.success) {
      navigate('/dashboard');
    } else {
      setError(result.error);
    }

    setLoading(false);
  };


  return (
    <div className="min-h-screen bg-[#FAFAFA] relative overflow-hidden">

      <div className="relative z-10 min-h-screen flex">
        {/* Left Side - Branding */}
        <div className="hidden lg:flex lg:w-1/2 bg-white p-12 flex-col justify-between relative overflow-hidden border-r border-gray-200">
          
          <div className="relative z-10">
            {/* Logo */}
            <div className="flex items-center gap-4 mb-16">
              <img 
                src="/logo.png" 
                alt="YuvGo Logo" 
                className="w-16 h-16 rounded-2xl"
              />
              <div>
                <h1 className="text-3xl font-black text-gray-900">YuvGo</h1>
                <p className="text-gray-600 text-sm">Портал партнера</p>
              </div>
            </div>

            {/* Main Heading */}
            <div className="flex items-center justify-center h-full">
              <div className="text-center">
                <h2 className="text-6xl font-black text-gray-900 mb-4">
                  YuvGo
                </h2>
                <p className="text-2xl text-gray-600">
                  Портал партнера
                </p>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="relative z-10">
            <p className="text-gray-400 text-xs text-center">© 2025 YuvGo. Все права защищены.</p>
          </div>
        </div>

        {/* Right Side - Login Form */}
        <div className="w-full lg:w-1/2 flex items-center justify-center p-8">
          <div className="w-full max-w-md">
            {/* Mobile Logo */}
            <div className="lg:hidden flex flex-col items-center mb-8">
              <img 
                src="/logo.png" 
                alt="YuvGo Logo" 
                className="w-20 h-20 rounded-2xl mb-4"
              />
              <h1 className="text-3xl font-black text-gray-900">YuvGo</h1>
              <p className="text-gray-600">Портал партнера</p>
            </div>

            {/* Form Card */}
            <div className="bg-white rounded-lg p-8 border border-gray-200">
              <div className="mb-8">
                <h2 className="text-3xl font-black text-gray-900 mb-2">
                  С возвращением! 👋
                </h2>
                <p className="text-gray-600">
                  Войдите для доступа к панели партнера
                </p>
              </div>

              {error && (
                <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-2xl flex items-start gap-3 animate-shake">
                  <AlertCircle className="text-red-600 flex-shrink-0 mt-0.5" size={20} />
                  <div>
                    <p className="text-sm font-medium text-red-900">Ошибка входа</p>
                    <p className="text-sm text-red-700 mt-1">{error}</p>
                  </div>
                </div>
              )}

              <form onSubmit={handleSubmit} className="space-y-5">
                {/* Phone Field */}
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Номер телефона
                  </label>
                  <div className="relative">
                    <div className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">
                      <Phone size={20} />
                    </div>
                    <input
                      type="tel"
                      value={phoneNumber}
                      onChange={(e) => setPhoneNumber(e.target.value)}
                      className="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-2xl focus:border-emerald-500 focus:ring-4 focus:ring-emerald-500/10 transition-all outline-none text-gray-900 placeholder-gray-400"
                      placeholder="+998901234567"
                      required
                    />
                  </div>
                </div>

                {/* PIN Field */}
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    PIN код
                  </label>
                  <div className="relative">
                    <div className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">
                      <Lock size={20} />
                    </div>
                    <input
                      type={showPin ? 'text' : 'password'}
                      value={pinCode}
                      onChange={(e) => setPinCode(e.target.value)}
                      className="w-full pl-12 pr-12 py-4 border-2 border-gray-200 rounded-2xl focus:border-emerald-500 focus:ring-4 focus:ring-emerald-500/10 transition-all outline-none text-gray-900 placeholder-gray-400 font-mono text-lg tracking-widest"
                      placeholder="••••••"
                      maxLength="6"
                      required
                    />
                    <button
                      type="button"
                      onClick={() => setShowPin(!showPin)}
                      className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors"
                    >
                      {showPin ? <EyeOff size={20} /> : <Eye size={20} />}
                    </button>
                  </div>
                </div>

                {/* Remember */}
                <div className="flex items-center justify-between">
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      className="w-4 h-4 rounded border-gray-300 text-emerald-600 focus:ring-emerald-500"
                    />
                    <span className="text-sm text-gray-600">Запомнить меня</span>
                  </label>
                </div>

                {/* Submit Button */}
                <button
                  type="submit"
                  disabled={loading}
                  className="w-full bg-gray-900 text-white py-4 rounded-lg font-bold text-lg active:scale-[0.98] transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {loading ? (
                    <span className="flex items-center justify-center gap-2">
                      <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                      Вход...
                    </span>
                  ) : (
                    'Войти в систему'
                  )}
                </button>
              </form>

              {/* Quick Login Hint */}
              <div className="mt-6 p-4 bg-blue-50 rounded-lg border border-blue-100">
                <p className="text-xs text-blue-800 text-center">
                  <strong>Тестовый доступ:</strong> +998901111111 / 123456
                </p>
              </div>
            </div>

            {/* Additional Info */}
            <div className="mt-6 text-center text-sm text-gray-500">
              <p>Защищено с помощью шифрования</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MerchantLoginNew;
