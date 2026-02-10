import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { ArrowLeft, Phone, ShieldCheck, Loader2 } from 'lucide-react';

const Login = () => {
  const [step, setStep] = useState('phone'); // 'phone' | 'code'
  const [phoneNumber, setPhoneNumber] = useState('+998');
  const [code, setCode] = useState(['', '', '', '', '']);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [countdown, setCountdown] = useState(0);
  const { sendSmsCode, verifySmsCode, API_URL } = useAuth();
  const navigate = useNavigate();
  const codeRefs = useRef([]);

  useEffect(() => {
    if (countdown > 0) {
      const timer = setTimeout(() => setCountdown(countdown - 1), 1000);
      return () => clearTimeout(timer);
    }
  }, [countdown]);

  const handleSendCode = async (e) => {
    e.preventDefault();
    setError('');
    
    const cleaned = phoneNumber.replace(/\s/g, '');
    if (cleaned.length < 12) {
      setError('Telefon raqamni to\'liq kiriting');
      return;
    }

    setLoading(true);
    const result = await sendSmsCode(cleaned);
    setLoading(false);

    if (result.success) {
      setStep('code');
      setCountdown(60);
      setTimeout(() => codeRefs.current[0]?.focus(), 100);
    } else {
      setError(result.error);
    }
  };

  const handleCodeChange = (index, value) => {
    if (value.length > 1) {
      // Handle paste
      const digits = value.replace(/\D/g, '').slice(0, 5);
      const newCode = [...code];
      digits.split('').forEach((d, i) => {
        if (index + i < 5) newCode[index + i] = d;
      });
      setCode(newCode);
      const nextIdx = Math.min(index + digits.length, 4);
      codeRefs.current[nextIdx]?.focus();
      
      // Auto-submit if all filled
      if (newCode.every(c => c !== '')) {
        handleVerifyCode(newCode.join(''));
      }
      return;
    }

    const newCode = [...code];
    newCode[index] = value.replace(/\D/g, '');
    setCode(newCode);

    if (value && index < 4) {
      codeRefs.current[index + 1]?.focus();
    }

    // Auto-submit when all 5 digits entered
    if (newCode.every(c => c !== '')) {
      handleVerifyCode(newCode.join(''));
    }
  };

  const handleCodeKeyDown = (index, e) => {
    if (e.key === 'Backspace' && !code[index] && index > 0) {
      codeRefs.current[index - 1]?.focus();
    }
  };

  const handleVerifyCode = async (codeStr) => {
    setError('');
    setLoading(true);

    const cleaned = phoneNumber.replace(/\s/g, '');
    const result = await verifySmsCode(cleaned, codeStr);

    if (result.success) {
      // Clear old subscription data for safety
      try {
        const subCheck = await fetch(`${API_URL}/api/subscription/subscriptions/status`, {
          headers: { 'Authorization': `Bearer ${result.token}` }
        });
        if (!subCheck.ok) {
          localStorage.removeItem('active_subscription');
          localStorage.removeItem('current_qr');
        }
      } catch (err) {
        console.log('Could not check subscription status');
      }
      navigate('/home');
    } else {
      setError(result.error);
      setCode(['', '', '', '', '']);
      codeRefs.current[0]?.focus();
    }

    setLoading(false);
  };

  const handleResend = async () => {
    if (countdown > 0) return;
    setError('');
    setLoading(true);
    const cleaned = phoneNumber.replace(/\s/g, '');
    const result = await sendSmsCode(cleaned);
    setLoading(false);
    if (result.success) {
      setCountdown(60);
      setCode(['', '', '', '', '']);
    } else {
      setError(result.error);
    }
  };

  const formatPhone = (value) => {
    const digits = value.replace(/\D/g, '');
    if (digits.length <= 3) return '+' + digits;
    if (digits.length <= 5) return '+' + digits.slice(0, 3) + ' ' + digits.slice(3);
    if (digits.length <= 8) return '+' + digits.slice(0, 3) + ' ' + digits.slice(3, 5) + ' ' + digits.slice(5);
    return '+' + digits.slice(0, 3) + ' ' + digits.slice(3, 5) + ' ' + digits.slice(5, 8) + ' ' + digits.slice(8, 12);
  };

  const handlePhoneChange = (e) => {
    const raw = e.target.value.replace(/\D/g, '');
    if (raw.length <= 12) {
      setPhoneNumber(formatPhone(raw));
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex flex-col">
      <div className="p-6">
        <button
          onClick={() => step === 'code' ? setStep('phone') : navigate('/welcome')}
          className="text-white flex items-center space-x-2"
        >
          <ArrowLeft size={24} />
          <span>Orqaga</span>
        </button>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-6 pb-12">
        <div className="w-full max-w-md">
          {/* Logo */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center mb-4">
              <img 
                src="/logo.png" 
                alt="YuvGo Logo" 
                className="w-20 h-20 rounded-2xl shadow-lg"
              />
            </div>

            {step === 'phone' ? (
              <>
                <div className="inline-flex items-center justify-center w-16 h-16 bg-white/20 backdrop-blur-sm rounded-full mb-4">
                  <Phone className="text-white" size={28} />
                </div>
                <h1 className="text-3xl font-bold text-white mb-2">Kirish</h1>
                <p className="text-white/70">Telefon raqamingizni kiriting</p>
              </>
            ) : (
              <>
                <div className="inline-flex items-center justify-center w-16 h-16 bg-white/20 backdrop-blur-sm rounded-full mb-4">
                  <ShieldCheck className="text-white" size={28} />
                </div>
                <h1 className="text-3xl font-bold text-white mb-2">Tasdiqlash</h1>
                <p className="text-white/70">
                  <span className="font-medium text-white">{phoneNumber}</span> raqamiga kod yuborildi
                </p>
              </>
            )}
          </div>

          {error && (
            <div className="mb-4 p-4 bg-red-500/20 backdrop-blur-sm border border-red-400/30 rounded-xl">
              <p className="text-white text-sm text-center">{error}</p>
            </div>
          )}

          {step === 'phone' ? (
            <form onSubmit={handleSendCode} className="space-y-5">
              <div>
                <label className="block text-white/80 font-medium mb-2 text-sm">
                  Telefon raqam
                </label>
                <div className="relative">
                  <Phone className="absolute left-4 top-1/2 transform -translate-y-1/2 text-white/40" size={20} />
                  <input
                    type="tel"
                    value={phoneNumber}
                    onChange={handlePhoneChange}
                    className="w-full pl-12 pr-4 py-4 bg-white/10 backdrop-blur-sm border border-white/20 rounded-2xl text-white placeholder-white/30 focus:outline-none focus:ring-2 focus:ring-white/40 text-lg tracking-wide"
                    placeholder="+998 90 123 4567"
                    required
                    autoFocus
                  />
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full bg-white text-gray-900 py-4 px-6 rounded-2xl font-semibold text-lg shadow-xl hover:bg-gray-100 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                {loading ? (
                  <>
                    <Loader2 size={20} className="animate-spin" />
                    Yuborilmoqda...
                  </>
                ) : (
                  'SMS kod olish'
                )}
              </button>

              <p className="text-center text-white/50 text-xs mt-4">
                Davom etish orqali siz foydalanish shartlariga rozilik bildirasiz
              </p>
            </form>
          ) : (
            <div className="space-y-6">
              {/* Code input */}
              <div>
                <label className="block text-white/80 font-medium mb-3 text-sm text-center">
                  5 xonali kodni kiriting
                </label>
                <div className="flex justify-center gap-3">
                  {code.map((digit, index) => (
                    <input
                      key={index}
                      ref={el => codeRefs.current[index] = el}
                      type="text"
                      inputMode="numeric"
                      maxLength={5}
                      value={digit}
                      onChange={(e) => handleCodeChange(index, e.target.value)}
                      onKeyDown={(e) => handleCodeKeyDown(index, e)}
                      className="w-14 h-16 text-center text-2xl font-bold bg-white/10 backdrop-blur-sm border-2 border-white/20 rounded-2xl text-white focus:outline-none focus:ring-2 focus:ring-white/50 focus:border-white/50 transition-all"
                    />
                  ))}
                </div>
              </div>

              {loading && (
                <div className="flex items-center justify-center gap-2 text-white/70">
                  <Loader2 size={18} className="animate-spin" />
                  <span className="text-sm">Tekshirilmoqda...</span>
                </div>
              )}

              {/* Resend */}
              <div className="text-center">
                {countdown > 0 ? (
                  <p className="text-white/50 text-sm">
                    Qayta yuborish: <span className="font-semibold text-white/80">{countdown}s</span>
                  </p>
                ) : (
                  <button
                    onClick={handleResend}
                    disabled={loading}
                    className="text-white font-semibold text-sm underline underline-offset-4 hover:text-white/80 transition-colors"
                  >
                    Kodni qayta yuborish
                  </button>
                )}
              </div>

              {/* Change number */}
              <button
                onClick={() => { setStep('phone'); setCode(['', '', '', '', '']); setError(''); }}
                className="w-full text-center text-white/60 text-sm hover:text-white/80 transition-colors"
              >
                Raqamni o'zgartirish
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default Login;
