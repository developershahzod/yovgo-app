import React, { useState } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import {
  LayoutDashboard, QrCode, Users, DollarSign, Activity,
  LogOut, Menu, X, Building2, ChevronDown, Settings, BarChart3
} from 'lucide-react';

const LayoutClean = () => {
  const { merchant, logout } = useMerchantAuth();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [userMenuOpen, setUserMenuOpen] = useState(false);

  const navigation = [
    { name: 'Панель управления', href: '/dashboard', icon: LayoutDashboard },
    { name: 'Сканер QR', href: '/qr-scanner', icon: QrCode },
    { name: 'История визитов', href: '/visits', icon: Activity },
    { name: 'Доходы', href: '/earnings', icon: DollarSign },
    { name: 'Клиенты', href: '/clients', icon: Users },
    { name: 'Аналитика', href: '/analytics', icon: BarChart3 },
    { name: 'Филиалы', href: '/branches', icon: Building2 },
    { name: 'Настройки', href: '/settings', icon: Settings },
  ];

  return (
    <div className="min-h-screen bg-[#FAFAFA]">
      {/* Sidebar */}
      <div
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-gray-200 transform transition-all duration-300 ease-in-out lg:translate-x-0 ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {/* Logo Section */}
        <div className="h-16 px-6 flex items-center justify-between border-b border-gray-200">
          <div className="flex items-center gap-3">
            <img 
              src="/logo.png" 
              alt="YuvGo Logo" 
              className="w-10 h-10 rounded-lg"
            />
            <div>
              <h1 className="text-lg font-bold text-gray-900">YuvGo</h1>
              <p className="text-xs text-gray-500">Merchant Panel</p>
            </div>
          </div>
          <button
            onClick={() => setSidebarOpen(false)}
            className="lg:hidden text-gray-400 hover:text-gray-600 transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        {/* Navigation */}
        <nav className="flex-1 overflow-y-auto p-4 space-y-1">
          {navigation.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.href;

            return (
              <Link
                key={item.name}
                to={item.href}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-xl transition-all text-sm font-medium ${
                  isActive
                    ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <Icon size={18} />
                <span className={`text-sm font-semibold ${isActive ? 'text-gray-900' : 'text-gray-700'}`}>
                  {item.name}
                </span>
                {isActive && (
                  <div className="ml-auto w-1.5 h-1.5 rounded-full bg-emerald-500"></div>
                )}
              </Link>
            );
          })}
        </nav>

        {/* User Profile Section */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-200">
          {/* Partner Info */}
          <div className="mb-3 p-3 bg-gray-50 rounded-lg">
            <p className="text-xs text-gray-500 mb-1">Партнер</p>
            <p className="text-sm font-semibold text-gray-900">{merchant?.partner?.name || 'Partner'}</p>
            {merchant?.location && (
              <p className="text-xs text-gray-600 mt-1">{merchant.location.name}</p>
            )}
          </div>

          <div className="relative">
            <button
              onClick={() => setUserMenuOpen(!userMenuOpen)}
              className="flex items-center gap-3 p-3 rounded-md hover:bg-gray-50 transition-colors cursor-pointer w-full"
            >
              <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-700 font-bold text-sm">
                {merchant?.name?.charAt(0) || 'M'}
              </div>
              <div className="flex-1 text-left">
                <p className="text-sm font-bold text-gray-900">{merchant?.name || 'Merchant'}</p>
                <p className="text-xs text-gray-500 capitalize">{merchant?.role || 'staff'}</p>
              </div>
              <ChevronDown 
                size={16} 
                className={`text-gray-400 transition-transform ${userMenuOpen ? 'rotate-180' : ''}`}
              />
            </button>

            {userMenuOpen && (
              <div className="absolute bottom-full left-0 right-0 mb-2 bg-white rounded-md border border-gray-200 overflow-hidden">
                <Link
                  to="/settings"
                  className="flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors"
                >
                  <Settings size={16} className="text-gray-400" />
                  <span className="text-sm font-medium text-gray-700">Настройки</span>
                </Link>
                <button
                  onClick={logout}
                  className="w-full flex items-center gap-3 px-4 py-3 hover:bg-red-50 transition-colors text-left"
                >
                  <LogOut size={16} className="text-red-500" />
                  <span className="text-sm font-medium text-red-600">Выйти</span>
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="flex-1 transition-all duration-300 lg:ml-64">
        {/* Top Header */}
        <header className="sticky top-0 z-40 bg-white border-b border-gray-200">
          <div className="flex items-center justify-between px-6 py-4">
            <button
              onClick={() => setSidebarOpen(!sidebarOpen)}
              className="lg:hidden p-2 rounded-md hover:bg-gray-100 transition-colors"
            >
              <Menu size={20} className="text-gray-700" />
            </button>

            <div className="flex items-center gap-4 ml-auto">
              <div className="text-right">
                <p className="text-sm font-semibold text-gray-900">{merchant?.partner?.name}</p>
                <p className="text-xs text-gray-500">{merchant?.location?.name}</p>
              </div>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default LayoutClean;
