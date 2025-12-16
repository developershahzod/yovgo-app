import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import axios from 'axios';
import { 
  Sparkles, QrCode, MapPin, Calendar, 
  Bell, Menu, ChevronRight, Zap, Clock
} from 'lucide-react';
import BottomNav from '../components/BottomNav';
import { formatUZS } from '../utils/currency';

const HomePremium = () => {
  const { user, logout, API_URL } = useAuth();
  const navigate = useNavigate();
  const [subscription, setSubscription] = useState(null);
  const [showMenu, setShowMenu] = useState(false);

  useEffect(() => {
    try {
      const token = localStorage.getItem('user_token');
      if (!token) return;

      // Получаем подписку с backend (Subscription Service на порту 8002)
      const SUBSCRIPTION_API = 'http://localhost:8002';
      const response = axios.get(
        `${SUBSCRIPTION_API}/subscriptions/status`,
        {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        }
      );

      response.then((response) => {
        console.log('Subscription from backend:', response.data);
        if (response.data && response.data.status === 'active') {
          setSubscription(response.data);
          // Сохраняем в localStorage для UI
          localStorage.setItem('active_subscription', JSON.stringify(response.data));
        } else {
          setSubscription(null);
          localStorage.removeItem('active_subscription');
        }
      }).catch((error) => {
        console.error('Failed to fetch subscription:', error);
        // Fallback to localStorage
        const subData = localStorage.getItem('active_subscription');
        if (subData) {
          const sub = JSON.parse(subData);
          setSubscription(sub);
        }
      });
    } catch (error) {
      console.error('Failed to fetch subscription:', error);
      // Fallback to localStorage
      const subData = localStorage.getItem('active_subscription');
      if (subData) {
        const sub = JSON.parse(subData);
        setSubscription(sub);
      }
    }
  }, []);

  const quickActions = [
    { 
      icon: QrCode, 
      label: 'Сканер QR', 
      path: '/qr',
      color: '#00BCD4'
    },
    { 
      icon: Calendar, 
      label: 'История визитов', 
      path: '/visits',
      color: '#9C27B0'
    },
    { 
      icon: MapPin, 
      label: 'Карта', 
      path: '/map',
      color: '#4CAF50'
    },
    { 
      icon: Calendar, 
      label: 'История', 
      path: '/profile',
      color: '#9C27B0'
    },
    { 
      icon: Sparkles, 
      label: 'Планы', 
      path: '/subscriptions',
      color: '#FF9800'
    },
  ];

  return (
    <div className="min-h-screen bg-[#F5F5F7] pb-24">
      {/* Header */}
      <div className="bg-white px-6 pt-12 pb-6">
        <div className="flex items-center justify-between mb-6">
          <button 
            onClick={() => setShowMenu(!showMenu)}
            className="w-12 h-12 rounded-full bg-white flex items-center justify-center border border-gray-200"
          >
            <Menu size={20} className="text-gray-700" />
          </button>
          
          <div className="text-center">
            <h1 className="text-base font-semibold text-gray-900">YuvGo</h1>
            <p className="text-xs text-gray-500">Premium</p>
          </div>
          
          <button 
            onClick={() => navigate('/notifications')}
            className="w-12 h-12 rounded-full bg-white flex items-center justify-center relative border border-gray-200"
          >
            <Bell size={20} className="text-gray-700" />
            <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full"></span>
          </button>
        </div>

      </div>

      {/* Main Content */}
      <div className="px-6 py-6 space-y-4">
        {/* Subscription Card */}
        {subscription ? (
          <div className="bg-white rounded-3xl p-6 border border-gray-200">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-2xl bg-yellow-50 flex items-center justify-center">
                  <Sparkles size={24} className="text-yellow-500" />
                </div>
                <div>
                  <p className="text-sm text-gray-500">Активный план</p>
                  <h3 className="text-lg font-bold text-gray-900">{subscription.plan_name || 'Premium'}</h3>
                </div>
              </div>
              <div className="px-4 py-2 rounded-full bg-green-50">
                <span className="text-xs font-bold text-green-600">АКТИВНО</span>
              </div>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-2 gap-3 mb-6">
              <div className="bg-gray-50 rounded-2xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <Zap size={16} className="text-yellow-500" />
                  <p className="text-xs text-gray-500">Осталось визитов</p>
                </div>
                <p className="text-3xl font-black text-gray-900">{subscription.visits_remaining || 0}</p>
              </div>
              <div className="bg-gray-50 rounded-2xl p-4">
                <div className="flex items-center gap-2 mb-2">
                  <Clock size={16} className="text-blue-500" />
                  <p className="text-xs text-gray-500">Осталось дней</p>
                </div>
                <p className="text-3xl font-black text-gray-900">
                  {Math.ceil((new Date(subscription.end_date) - new Date()) / (1000 * 60 * 60 * 24))}
                </p>
              </div>
            </div>

            {/* Action Button */}
            <button
              onClick={() => navigate('/qr')}
              className="w-full bg-gray-900 text-white py-4 rounded-2xl font-bold flex items-center justify-center gap-2 active:scale-95 transition-transform"
            >
              <QrCode size={20} />
              <span>Сканировать QR код</span>
              <ChevronRight size={20} />
            </button>
          </div>
        ) : (
          <div className="bg-white rounded-3xl p-8 text-center border border-gray-200">
            <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-4">
              <Sparkles size={32} className="text-gray-400" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-2">Нет активного плана</h3>
            <p className="text-sm text-gray-500 mb-6">Подпишитесь, чтобы начать!</p>
            <button
              onClick={() => navigate('/subscriptions')}
              className="bg-gray-900 text-white px-8 py-3 rounded-2xl font-bold active:scale-95 transition-transform"
            >
              Посмотреть планы
            </button>
          </div>
        )}

        {/* Quick Actions */}
        <div className="bg-white rounded-3xl p-6" style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}>
          <h3 className="text-base font-bold text-gray-900 mb-4">Быстрые действия</h3>
          <div className="grid grid-cols-4 gap-3">
            {quickActions.map((action, index) => {
              const Icon = action.icon;
              return (
                <button
                  key={index}
                  onClick={() => navigate(action.path)}
                  className="flex flex-col items-center gap-2 p-3 rounded-2xl active:scale-95 transition-transform"
                >
                  <div 
                    className="w-14 h-14 rounded-2xl flex items-center justify-center border border-gray-100"
                    style={{
                      backgroundColor: `${action.color}15`
                    }}
                  >
                    <Icon size={24} style={{color: action.color}} />
                  </div>
                  <span className="text-xs font-medium text-gray-700 text-center">{action.label}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* Stats Card */}
        <div className="bg-white rounded-3xl p-6" style={{boxShadow: '0 4px 16px rgba(0,0,0,0.06)'}}>
          <h3 className="text-base font-bold text-gray-900 mb-4">Ваша статистика</h3>
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center">
              <p className="text-2xl font-black text-gray-900">12</p>
              <p className="text-xs text-gray-500 mt-1">Всего моек</p>
            </div>
            <div className="text-center">
              <p className="text-lg font-black text-gray-900">{formatUZS(600000)}</p>
              <p className="text-xs text-gray-500 mt-1">Сэкономлено</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-black text-gray-900">3</p>
              <p className="text-xs text-gray-500 mt-1">Локации</p>
            </div>
          </div>
        </div>

      </div>

      {/* Side Menu */}
      {showMenu && (
        <div className="fixed inset-0 z-50">
          {/* Overlay */}
          <div 
            className="absolute inset-0 bg-black/50"
            onClick={() => setShowMenu(false)}
          ></div>
          
          {/* Menu Panel */}
          <div className="absolute left-0 top-0 bottom-0 w-80 bg-white animate-slide-in-left">
            {/* Header */}
            <div className="p-6 border-b border-gray-200">
              <div className="flex items-center gap-3 mb-4">
                <div className="w-16 h-16 rounded-full bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center text-white text-2xl font-bold">
                  {user?.full_name?.charAt(0) || 'U'}
                </div>
                <div>
                  <h3 className="text-lg font-bold text-gray-900">{user?.full_name || 'Пользователь'}</h3>
                  <p className="text-sm text-gray-500">{user?.phone_number || user?.email}</p>
                </div>
              </div>
            </div>

            {/* Menu Items */}
            <nav className="p-4 space-y-2">
              <button
                onClick={() => {
                  navigate('/home');
                  setShowMenu(false);
                }}
                className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <QrCode size={20} className="text-gray-600" />
                <span className="text-gray-900 font-medium">Главная</span>
              </button>

              <button
                onClick={() => {
                  navigate('/qr');
                  setShowMenu(false);
                }}
                className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <QrCode size={20} className="text-gray-600" />
                <span className="text-gray-900 font-medium">Сканер QR</span>
              </button>

              <button
                onClick={() => {
                  navigate('/map');
                  setShowMenu(false);
                }}
                className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <MapPin size={20} className="text-gray-600" />
                <span className="text-gray-900 font-medium">Карта автомоек</span>
              </button>

              <button
                onClick={() => {
                  navigate('/subscriptions');
                  setShowMenu(false);
                }}
                className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <Sparkles size={20} className="text-gray-600" />
                <span className="text-gray-900 font-medium">Подписки</span>
              </button>

              <button
                onClick={() => {
                  navigate('/profile');
                  setShowMenu(false);
                }}
                className="w-full flex items-center gap-3 px-4 py-3 rounded-lg hover:bg-gray-50 transition-colors"
              >
                <Calendar size={20} className="text-gray-600" />
                <span className="text-gray-900 font-medium">Профиль</span>
              </button>
            </nav>

            {/* Logout */}
            <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-200">
              <button
                onClick={() => {
                  logout();
                  navigate('/login');
                }}
                className="w-full bg-red-50 text-red-600 py-3 rounded-lg font-bold hover:bg-red-100 transition-colors"
              >
                Выйти
              </button>
            </div>
          </div>
        </div>
      )}

      <BottomNav />
    </div>
  );
};

export default HomePremium;
