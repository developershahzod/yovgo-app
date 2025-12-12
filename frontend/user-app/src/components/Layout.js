import React from 'react';
import { Outlet, NavLink } from 'react-router-dom';
import { Home, Map, CreditCard, QrCode, User } from 'lucide-react';

const Layout = () => {
  const navItems = [
    { path: '/home', icon: Home, label: 'Home' },
    { path: '/map', icon: Map, label: 'Map' },
    { path: '/subscriptions', icon: CreditCard, label: 'Plans' },
    { path: '/qr', icon: QrCode, label: 'My QR' },
    { path: '/profile', icon: User, label: 'Profile' },
  ];

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      {/* Main Content */}
      <main className="pb-4">
        <Outlet />
      </main>

      {/* Bottom Navigation */}
      <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 safe-area-bottom">
        <div className="flex justify-around items-center h-16">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <NavLink
                key={item.path}
                to={item.path}
                className={({ isActive }) =>
                  `flex flex-col items-center justify-center flex-1 h-full transition-colors ${
                    isActive
                      ? 'text-primary-600'
                      : 'text-gray-500 hover:text-gray-700'
                  }`
                }
              >
                <Icon size={24} />
                <span className="text-xs mt-1">{item.label}</span>
              </NavLink>
            );
          })}
        </div>
      </nav>
    </div>
  );
};

export default Layout;
