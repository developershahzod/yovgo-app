import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { 
  Sparkles, QrCode, Calendar, TrendingUp, 
  MapPin, ChevronRight, Bell, Settings,
  Zap, Award, Clock, Star
} from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { t } from '../utils/i18n';
import { formatUZS } from '../utils/currency';

const HomeNew = () => {
  const { user, API_URL } = useAuth();
  const navigate = useNavigate();
  const [subscription, setSubscription] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      const localSub = localStorage.getItem('active_subscription');
      if (localSub) {
        const parsedSub = JSON.parse(localSub);
        const endDate = new Date(parsedSub.end_date);
        if (endDate > new Date() && parsedSub.visits_remaining > 0) {
          setSubscription(parsedSub);
        }
      }
    } catch (error) {
      console.error('Failed to fetch data:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark">
        <div className="text-center">
          <div className="animate-spin rounded-full h-16 w-16 border-4 border-white border-t-transparent mx-auto mb-4"></div>
          <p className="text-white font-medium">Loading...</p>
        </div>
      </div>
    );
  }

  const quickActions = [
    { 
      icon: QrCode, 
      label: 'Сканер QR', 
      path: '/qr',
      color: 'text-blue-500',
      bg: 'bg-blue-50',
      description: 'Сканировать код'
    },
    { 
      icon: MapPin, 
      label: 'Найти мойку', 
      path: '/map',
      color: 'text-green-500',
      bg: 'bg-green-50',
      description: 'Рядом с вами'
    },
    { 
      icon: Calendar, 
      label: 'История', 
      path: '/profile',
      color: 'text-purple-500',
      bg: 'bg-purple-50',
      description: 'Мои визиты'
    },
    { 
      icon: Sparkles, 
      label: 'Улучшить', 
      path: '/subscriptions',
      color: 'text-orange-500',
      bg: 'bg-orange-50',
      description: 'Больше визитов'
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      {/* Header with Gradient */}
      <div className="bg-white text-gray-900 relative overflow-hidden border-b border-gray-100">

        <div className="relative z-10 px-6 pt-12 pb-8">
          {/* Top Bar */}
          <div className="flex items-center justify-between mb-8">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-gray-100 flex items-center justify-center">
                <span className="text-xl font-bold text-yuvgo-cyan">
                  {user?.full_name?.charAt(0) || 'U'}
                </span>
              </div>
              <div>
                <p className="text-gray-500 text-sm">С возвращением,</p>
                <h1 className="text-xl font-bold text-gray-900">{user?.full_name || 'User'}</h1>
              </div>
            </div>
            <div className="flex gap-2">
              <button className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center hover:bg-gray-200 transition-all">
                <Bell size={20} className="text-gray-600" />
              </button>
              <button 
                onClick={() => navigate('/profile')}
                className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center hover:bg-gray-200 transition-all"
              >
                <Settings size={20} className="text-gray-600" />
              </button>
            </div>
          </div>

          {/* Subscription Card */}
          {subscription ? (
            <div className="bg-white rounded-3xl p-6 border border-gray-100">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <div className="w-10 h-10 rounded-full bg-yellow-50 flex items-center justify-center">
                    <Sparkles size={20} className="text-yellow-500" />
                  </div>
                  <div>
                    <p className="font-bold text-lg text-gray-900">Активный план</p>
                    <p className="text-gray-500 text-sm">{subscription.plan_name || 'Premium'}</p>
                  </div>
                </div>
                <div className="px-3 py-1 rounded-full bg-green-50">
                  <span className="text-xs font-bold text-green-600">АКТИВНО</span>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-center gap-2 mb-1">
                    <Zap size={16} className="text-yellow-500" />
                    <p className="text-gray-500 text-xs">Осталось визитов</p>
                  </div>
                  <p className="text-3xl font-black text-gray-900">{subscription.visits_remaining || 0}</p>
                </div>
                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-center gap-2 mb-1">
                    <Clock size={16} className="text-blue-500" />
                    <p className="text-gray-500 text-xs">Осталось дней</p>
                  </div>
                  <p className="text-3xl font-black text-gray-900">
                    {Math.ceil((new Date(subscription.end_date) - new Date()) / (1000 * 60 * 60 * 24))}
                  </p>
                </div>
              </div>

              <button 
                onClick={() => navigate('/qr')}
                className="w-full mt-4 bg-yuvgo-cyan text-white py-3 rounded-2xl font-bold flex items-center justify-center gap-2 active:scale-95 transition-transform"
              >
                <QrCode size={20} />
                <span>Сканировать QR код</span>
                <ChevronRight size={20} />
              </button>
            </div>
          ) : (
            <div className="bg-white rounded-3xl p-6 border border-gray-100 text-center">
              <Award size={48} className="mx-auto mb-3 text-gray-300" />
              <p className="text-lg font-bold mb-2 text-gray-900">Нет активного плана</p>
              <p className="text-gray-500 text-sm mb-4">Подпишитесь, чтобы начать!</p>
              <button 
                onClick={() => navigate('/subscriptions')}
                className="bg-yuvgo-cyan text-white px-6 py-3 rounded-2xl font-bold active:scale-95 transition-transform"
              >
                Посмотреть планы
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Quick Actions */}
      <div className="px-6 mt-6">
        <div className="bg-white rounded-3xl p-6 border border-gray-100">
          <h2 className="text-lg font-bold text-gray-900 mb-4">Быстрые действия</h2>
          <div className="grid grid-cols-2 gap-3">
            {quickActions.map((action, index) => {
              const Icon = action.icon;
              return (
                <button
                  key={index}
                  onClick={() => navigate(action.path)}
                  className="bg-white border border-gray-100 rounded-2xl p-4 active:scale-95 transition-all"
                >
                  <div className={`w-12 h-12 rounded-xl ${action.bg} flex items-center justify-center mb-3`}>
                    <Icon size={24} className={action.color} />
                  </div>
                  <p className="font-bold text-gray-900 text-sm">{action.label}</p>
                  <p className="text-gray-500 text-xs">{action.description}</p>
                </button>
              );
            })}
          </div>
        </div>
      </div>

      {/* Stats Section */}
      <div className="px-6 mt-6">
        <div className="bg-white rounded-3xl p-6 border border-gray-100">
          <div className="flex items-center gap-3 mb-4">
            <TrendingUp size={24} className="text-yuvgo-cyan" />
            <h2 className="text-lg font-bold text-gray-900">Ваша статистика</h2>
          </div>
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center">
              <p className="text-3xl font-black text-gray-900">12</p>
              <p className="text-gray-500 text-xs mt-1">Всего моек</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-black text-gray-900">{formatUZS(600000)}</p>
              <p className="text-gray-500 text-xs mt-1">Сэкономлено</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-black text-gray-900">3</p>
              <p className="text-gray-500 text-xs mt-1">Локации</p>
            </div>
          </div>
        </div>
      </div>

      {/* Tips Card */}
      <div className="px-6 mt-6 mb-6">
        <div className="bg-blue-50 rounded-3xl p-6 border border-blue-100">
          <div className="flex items-start gap-3">
            <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
              <Sparkles size={20} className="text-blue-500" />
            </div>
            <div>
              <p className="font-bold mb-1 text-blue-900">💡 Совет</p>
              <p className="text-blue-700 text-sm">
                Отсканируйте QR код на автомойке для быстрой регистрации визита!
              </p>
            </div>
          </div>
        </div>
      </div>

      <BottomNav />
    </div>
  );
};

export default HomeNew;
