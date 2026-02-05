import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../i18n';
import { 
  Shield, Mail, Lock, Eye, EyeOff, AlertCircle, 
  Sparkles, TrendingUp, Users, BarChart3, Zap, Globe 
} from 'lucide-react';

const LoginNew = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showLangMenu, setShowLangMenu] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();
  const { t, language, setLanguage, languages } = useLanguage();

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
      {/* Language Switcher - Top Right */}
      <div className="absolute top-4 right-4 z-50">
        <div className="relative">
          <button
            onClick={() => setShowLangMenu(!showLangMenu)}
            className="flex items-center gap-2 px-3 py-2 bg-white border border-gray-200 rounded-lg hover:bg-gray-50 transition-colors"
          >
            <Globe size={18} className="text-gray-600" />
            <span className="text-sm font-medium text-gray-700">
              {languages[language]?.flag} {languages[language]?.nativeName}
            </span>
          </button>
          {showLangMenu && (
            <div className="absolute right-0 mt-2 w-48 bg-white border border-gray-200 rounded-lg shadow-lg overflow-hidden">
              {Object.values(languages).map((lang) => (
                <button
                  key={lang.code}
                  onClick={() => {
                    setLanguage(lang.code);
                    setShowLangMenu(false);
                  }}
                  className={`w-full flex items-center gap-3 px-4 py-3 text-sm text-left hover:bg-gray-50 transition-colors ${
                    language === lang.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                  }`}
                >
                  <span className="text-lg">{lang.flag}</span>
                  <span className="font-medium">{lang.nativeName}</span>
                  {language === lang.code && <span className="ml-auto text-blue-600">✓</span>}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

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
                <p className="text-gray-600 text-sm">{t('auth.adminPanel')}</p>
              </div>
            </div>

            {/* Main Heading */}
            <div className="flex items-center justify-center h-full">
              <div className="text-center">
                <h2 className="text-6xl font-black text-gray-900 mb-4">
                  YuvGo
                </h2>
                <p className="text-2xl text-gray-600">
                  {t('auth.adminPanel')}
                </p>
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="relative z-10">
            <p className="text-gray-400 text-xs text-center">© 2026 YuvGo. {t('auth.allRightsReserved')}</p>
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
              <p className="text-gray-600">{t('auth.adminPanel')}</p>
            </div>

            {/* Form Card */}
            <div className="bg-white rounded-lg p-8 border border-gray-200">
              <div className="mb-8">
                <h2 className="text-3xl font-black text-gray-900 mb-2">
                  {t('auth.welcomeBack')} 👋
                </h2>
                <p className="text-gray-600">
                  {t('auth.loginToContinue')}
                </p>
              </div>

              {error && (
                <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-2xl flex items-start gap-3 animate-shake">
                  <AlertCircle className="text-red-600 flex-shrink-0 mt-0.5" size={20} />
                  <div>
                    <p className="text-sm font-medium text-red-900">{t('auth.loginError')}</p>
                    <p className="text-sm text-red-700 mt-1">{error}</p>
                  </div>
                </div>
              )}

              <form onSubmit={handleSubmit} className="space-y-5">
                {/* Email Field */}
                <div>
                  <label className="block text-sm font-bold text-gray-700 mb-2">
                    {t('auth.email')}
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
                    {t('auth.password')}
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
                    <span className="text-sm text-gray-600">{t('auth.rememberMe')}</span>
                  </label>
                  <button
                    type="button"
                    className="text-sm font-medium text-yuvgo-cyan hover:text-yuvgo-dark transition-colors"
                  >
                    {t('auth.forgotPassword')}
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
                      {t('auth.loggingIn')}
                    </span>
                  ) : (
                    t('auth.loginButton')
                  )}
                </button>
              </form>

            </div>

            {/* Additional Info */}
            <div className="mt-6 text-center text-sm text-gray-500">
              <p>{t('auth.securedWith')}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginNew;
