import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Sparkles, MapPin, QrCode, Droplets, Zap, Shield, ChevronRight } from 'lucide-react';
import { t } from '../utils/i18n';

const Welcome = () => {
  const navigate = useNavigate();
  const [currentSlide, setCurrentSlide] = useState(0);

  const features = [
    {
      icon: Sparkles,
      title: t('welcome.unlimitedWashes'),
      description: t('welcome.unlimitedDesc'),
      color: 'from-yellow-400 to-orange-500'
    },
    {
      icon: MapPin,
      title: t('welcome.multipleLocations'),
      description: t('welcome.multipleDesc'),
      color: 'from-green-400 to-emerald-500'
    },
    {
      icon: QrCode,
      title: t('welcome.easyCheckIn'),
      description: t('welcome.easyCheckInDesc'),
      color: 'from-blue-400 to-cyan-500'
    }
  ];

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentSlide((prev) => (prev + 1) % features.length);
    }, 3000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-yuvgo-cyan via-yuvgo-dark to-yuvgo-navy relative overflow-hidden">
      {/* Animated Background Circles */}
      <div className="absolute top-0 left-0 w-full h-full overflow-hidden">
        <div className="absolute top-20 -left-20 w-64 h-64 bg-white/5 rounded-full blur-3xl animate-pulse"></div>
        <div className="absolute bottom-20 -right-20 w-80 h-80 bg-white/5 rounded-full blur-3xl animate-pulse" style={{animationDelay: '1s'}}></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-white/3 rounded-full blur-3xl animate-pulse" style={{animationDelay: '2s'}}></div>
      </div>

      <div className="relative z-10 flex flex-col min-h-screen">
        {/* Header */}
        <div className="pt-12 px-6 text-center">
          <div className="inline-flex items-center justify-center mb-6 animate-bounce-slow">
            <div className="relative">
              <div className="absolute inset-0 bg-white/20 rounded-3xl blur-xl"></div>
              <img 
                src="/logo.png" 
                alt="YuvGo Logo" 
                className="relative w-28 h-28 rounded-3xl shadow-2xl"
              />
            </div>
          </div>
          <h1 className="text-6xl font-black text-white mb-3 tracking-tight">
            YuvGo
          </h1>
          <p className="text-lg text-white/80 font-medium">
            {t('welcome.subtitle')}
          </p>
        </div>

        {/* Feature Carousel */}
        <div className="flex-1 flex items-center justify-center px-6 py-8">
          <div className="w-full max-w-md">
            <div className="relative h-80">
              {features.map((feature, index) => {
                const Icon = feature.icon;
                const isActive = index === currentSlide;
                return (
                  <div
                    key={index}
                    className={`absolute inset-0 transition-all duration-500 transform ${
                      isActive ? 'opacity-100 scale-100' : 'opacity-0 scale-95 pointer-events-none'
                    }`}
                  >
                    <div className="bg-white/10 backdrop-blur-xl rounded-3xl p-8 border border-white/20 shadow-2xl h-full flex flex-col items-center justify-center text-center">
                      <div className={`w-24 h-24 rounded-full bg-gradient-to-br ${feature.color} flex items-center justify-center mb-6 shadow-lg`}>
                        <Icon size={48} className="text-white" />
                      </div>
                      <h3 className="text-2xl font-bold text-white mb-3">
                        {feature.title}
                      </h3>
                      <p className="text-white/80 text-lg">
                        {feature.description}
                      </p>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Dots Indicator */}
            <div className="flex justify-center gap-2 mt-6">
              {features.map((_, index) => (
                <button
                  key={index}
                  onClick={() => setCurrentSlide(index)}
                  className={`h-2 rounded-full transition-all duration-300 ${
                    index === currentSlide ? 'w-8 bg-white' : 'w-2 bg-white/40'
                  }`}
                />
              ))}
            </div>
          </div>
        </div>

        {/* CTA Buttons */}
        <div className="px-6 pb-8 space-y-3">
          <button
            onClick={() => navigate('/register')}
            className="w-full bg-white text-yuvgo-navy py-5 px-6 rounded-2xl font-bold text-lg shadow-2xl hover:shadow-white/20 transition-all transform hover:scale-105 active:scale-95 flex items-center justify-center gap-2"
          >
            <span>{t('auth.getStarted')}</span>
            <ChevronRight size={24} className="animate-pulse" />
          </button>
          <button
            onClick={() => navigate('/login')}
            className="w-full bg-white/10 backdrop-blur-md text-white py-5 px-6 rounded-2xl font-bold text-lg border-2 border-white/30 hover:bg-white/20 transition-all transform hover:scale-105 active:scale-95"
          >
            {t('auth.signIn')}
          </button>
          
          {/* Trust Badges */}
          <div className="flex items-center justify-center gap-6 pt-4 text-white/60">
            <div className="flex items-center gap-2">
              <Shield size={16} />
              <span className="text-xs">{t('welcome.secure')}</span>
            </div>
            <div className="flex items-center gap-2">
              <Zap size={16} />
              <span className="text-xs">{t('welcome.fast')}</span>
            </div>
            <div className="flex items-center gap-2">
              <Droplets size={16} />
              <span className="text-xs">{t('welcome.clean')}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Welcome;
