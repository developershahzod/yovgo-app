import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { 
  Shield, Mail, Lock, Eye, EyeOff, AlertCircle, 
  Sparkles, TrendingUp, Users, BarChart3, Zap 
} from 'lucide-react';

const LoginNew = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const result = await login(email, password);

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
        {/* Left Side - Branding & Features */}
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
                <p className="text-gray-600 text-sm">Панель администратора</p>
              </div>
            </div>

            {/* Main Heading */}
            <div className="flex items-center justify-center h-full">
              <div className="text-center">
                <h2 className="text-6xl font-black text-gray-900 mb-4">
                  YuvGo
                </h2>
                <p className="text-2xl text-gray-600">
                  Панель администратора
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
              <h1 className="text-3xl font-black text-yuvgo-navy">YuvGo</h1>
              <p className="text-gray-600">Панель администратора</p>
            </div>

            {/* Form Card */}
            <div className="bg-white rounded-lg p-8 border border-gray-200">
              <div className="mb-8">
                <h2 className="text-3xl font-black text-gray-900 mb-2">
                  С возвращением! 👋
                </h2>
                <p className="text-gray-600">
                  Войдите, чтобы продолжить управление
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
                {/* Email Field */}
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Email адрес
                  </label>
                  <div className="relative">
                    <div className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">
                      <Mail size={20} />
                    </div>
                    <input
                      type="email"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      className="w-full pl-12 pr-4 py-4 border-2 border-gray-200 rounded-2xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none text-gray-900 placeholder-gray-400"
                      placeholder="admin@yuvgo.uz"
                      required
                    />
                  </div>
                </div>

                {/* Password Field */}
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    Пароль
                  </label>
                  <div className="relative">
                    <div className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">
                      <Lock size={20} />
                    </div>
                    <input
                      type={showPassword ? 'text' : 'password'}
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      className="w-full pl-12 pr-12 py-4 border-2 border-gray-200 rounded-2xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none text-gray-900 placeholder-gray-400"
                      placeholder="••••••••"
                      required
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 transition-colors"
                    >
                      {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                    </button>
                  </div>
                </div>

                {/* Remember & Forgot */}
                <div className="flex items-center justify-between">
                  <label className="flex items-center gap-2 cursor-pointer">
                    <input
                      type="checkbox"
                      className="w-4 h-4 rounded border-gray-300 text-yuvgo-cyan focus:ring-yuvgo-cyan"
                    />
                    <span className="text-sm text-gray-600">Запомнить меня</span>
                  </label>
                  <button
                    type="button"
                    className="text-sm font-medium text-yuvgo-cyan hover:text-yuvgo-dark transition-colors"
                  >
                    Забыли пароль?
                  </button>
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
              <div className="mt-6 p-4 bg-blue-50 rounded-2xl border border-blue-100">
                <p className="text-xs text-blue-800 text-center">
                  <strong>Тестовый доступ:</strong> admin@yuvgo.uz / Admin@123
                </p>
              </div>
            </div>

            {/* Additional Info */}
            <div className="mt-6 text-center text-sm text-gray-500">
              <p>Защищено с помощью шифрования и двухфакторной аутентификации</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginNew;
