import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { Home, Map, QrCode, CreditCard, User } from 'lucide-react';

const BottomNav = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { path: '/home', icon: Home, label: 'Главная' },
    { path: '/map', icon: Map, label: 'Карта' },
    { path: '/qr', icon: QrCode, label: 'Сканер' },
    { path: '/subscriptions', icon: CreditCard, label: 'Планы' },
    { path: '/profile', icon: User, label: 'Профиль' },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white/80 backdrop-blur-xl border-t border-gray-200/50 safe-area-bottom z-50">
      <div className="flex items-center justify-around px-2 py-1">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.path;
          
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              className={`flex flex-col items-center justify-center px-3 py-2 transition-all duration-200 ${
                isActive 
                  ? 'text-yuvgo-cyan' 
                  : 'text-gray-400'
              }`}
            >
              <Icon 
                size={26} 
                strokeWidth={isActive ? 2.5 : 2}
                className="mb-1"
              />
              <span className={`text-[10px] font-medium ${isActive ? 'font-semibold' : ''}`}>
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default BottomNav;
