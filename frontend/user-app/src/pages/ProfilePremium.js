import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { 
  User, Phone, Mail, Calendar, LogOut, ChevronRight,
  Settings, Bell, Shield, HelpCircle, Star, History
} from 'lucide-react';
import BottomNav from '../components/BottomNav';

const ProfilePremium = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [subscription, setSubscription] = useState(null);

  useEffect(() => {
    const subData = localStorage.getItem('active_subscription');
    if (subData) {
      setSubscription(JSON.parse(subData));
    }
  }, []);

  const handleLogout = () => {
    logout();
    navigate('/welcome');
  };

  const menuSections = [
    {
      title: 'Аккаунт',
      items: [
        { icon: User, label: 'Личная информация', action: () => {}, color: 'blue' },
        { icon: Bell, label: 'Уведомления', action: () => {}, color: 'purple' },
        { icon: Shield, label: 'Безопасность', action: () => {}, color: 'green' },
      ]
    },
    {
      title: 'Подписка',
      items: [
        { icon: Star, label: 'Моя подписка', action: () => navigate('/subscriptions'), color: 'yellow' },
        { icon: History, label: 'История визитов', action: () => {}, color: 'indigo' },
      ]
    },
    {
      title: 'Поддержка',
      items: [
        { icon: HelpCircle, label: 'Помощь', action: () => {}, color: 'orange' },
        { icon: Settings, label: 'Настройки', action: () => {}, color: 'gray' },
      ]
    }
  ];

  return (
    <div className="min-h-screen bg-[#F5F5F7] pb-24">
      {/* Header */}
      <div className="bg-white px-6 pt-12 pb-8">
        <div className="flex flex-col items-center">
          {/* Avatar */}
          <div className="w-24 h-24 rounded-full bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center text-white text-3xl font-bold mb-4">
            {user?.full_name?.charAt(0) || 'U'}
          </div>
          
          {/* User Info */}
          <h1 className="text-2xl font-bold text-gray-900">{user?.full_name || 'Пользователь'}</h1>
          <p className="text-gray-500 mt-1">{user?.phone_number}</p>
          
          {/* Subscription Badge */}
          {subscription && (
            <div className="mt-4 px-4 py-2 bg-gradient-to-r from-yellow-50 to-orange-50 rounded-full border border-yellow-200">
              <p className="text-sm font-semibold text-yellow-700">
                ⭐ {subscription.plan_name}
              </p>
            </div>
          )}
        </div>
      </div>

      {/* Stats */}
      {subscription && (
        <div className="px-6 py-4">
          <div className="bg-white rounded-2xl p-4 border border-gray-200">
            <div className="grid grid-cols-3 gap-4">
              <div className="text-center">
                <p className="text-2xl font-black text-gray-900">{subscription.visits_remaining || 0}</p>
                <p className="text-xs text-gray-500 mt-1">Осталось</p>
              </div>
              <div className="text-center border-l border-r border-gray-200">
                <p className="text-2xl font-black text-gray-900">{subscription.visits_used || 0}</p>
                <p className="text-xs text-gray-500 mt-1">Использовано</p>
              </div>
              <div className="text-center">
                <p className="text-2xl font-black text-gray-900">
                  {Math.ceil((new Date(subscription.end_date) - new Date()) / (1000 * 60 * 60 * 24))}
                </p>
                <p className="text-xs text-gray-500 mt-1">Дней</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Account Info */}
      <div className="px-6 py-4">
        <div className="bg-white rounded-2xl p-6 border border-gray-200">
          <h2 className="text-base font-bold text-gray-900 mb-4">Информация об аккаунте</h2>
          
          <div className="space-y-4">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-blue-50 flex items-center justify-center">
                <User size={20} className="text-blue-500" />
              </div>
              <div className="flex-1">
                <p className="text-xs text-gray-500">Полное имя</p>
                <p className="text-sm font-semibold text-gray-900">{user?.full_name || 'Не указано'}</p>
              </div>
            </div>

            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-green-50 flex items-center justify-center">
                <Phone size={20} className="text-green-500" />
              </div>
              <div className="flex-1">
                <p className="text-xs text-gray-500">Телефон</p>
                <p className="text-sm font-semibold text-gray-900">{user?.phone_number}</p>
              </div>
            </div>

            {user?.email && (
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-full bg-purple-50 flex items-center justify-center">
                  <Mail size={20} className="text-purple-500" />
                </div>
                <div className="flex-1">
                  <p className="text-xs text-gray-500">Email</p>
                  <p className="text-sm font-semibold text-gray-900">{user.email}</p>
                </div>
              </div>
            )}

            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-orange-50 flex items-center justify-center">
                <Calendar size={20} className="text-orange-500" />
              </div>
              <div className="flex-1">
                <p className="text-xs text-gray-500">Дата регистрации</p>
                <p className="text-sm font-semibold text-gray-900">
                  {new Date(user?.created_at || Date.now()).toLocaleDateString('ru-RU')}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Menu Sections */}
      <div className="px-6 py-4 space-y-4">
        {menuSections.map((section, sectionIndex) => (
          <div key={sectionIndex}>
            <h3 className="text-sm font-bold text-gray-500 mb-2 px-2">{section.title}</h3>
            <div className="bg-white rounded-2xl overflow-hidden border border-gray-200">
              {section.items.map((item, itemIndex) => {
                const Icon = item.icon;
                const colorClasses = {
                  blue: 'bg-blue-50 text-blue-500',
                  purple: 'bg-purple-50 text-purple-500',
                  green: 'bg-green-50 text-green-500',
                  yellow: 'bg-yellow-50 text-yellow-500',
                  indigo: 'bg-indigo-50 text-indigo-500',
                  orange: 'bg-orange-50 text-orange-500',
                  gray: 'bg-gray-100 text-gray-600'
                };
                
                return (
                  <button
                    key={itemIndex}
                    onClick={item.action}
                    className={`w-full flex items-center justify-between p-4 hover:bg-gray-50 transition-colors ${
                      itemIndex !== section.items.length - 1 ? 'border-b border-gray-100' : ''
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <div className={`w-10 h-10 rounded-full flex items-center justify-center ${colorClasses[item.color]}`}>
                        <Icon size={20} />
                      </div>
                      <span className="text-sm font-medium text-gray-900">{item.label}</span>
                    </div>
                    <ChevronRight size={18} className="text-gray-400" />
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      {/* Logout Button */}
      <div className="px-6 py-4">
        <button
          onClick={handleLogout}
          className="w-full bg-red-50 text-red-600 py-4 rounded-2xl font-bold flex items-center justify-center gap-2 hover:bg-red-100 transition-colors"
        >
          <LogOut size={20} />
          <span>Выйти из аккаунта</span>
        </button>
      </div>

      <BottomNav />
    </div>
  );
};

export default ProfilePremium;
