import React, { useState } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import {
  LayoutDashboard, Users, Building2, CreditCard, Receipt,
  BarChart3, Shield, Tag, FileText, LogOut, Menu, X,
  Bell, Settings, Search, ChevronDown, Sparkles, MapPin
} from 'lucide-react';

const LayoutNew = () => {
  const { user, logout, hasPermission } = useAuth();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [userMenuOpen, setUserMenuOpen] = useState(false);

  const navigation = [
    { name: 'Панель управления', href: '/dashboard', icon: LayoutDashboard, permission: null },
    { name: 'Пользователи', href: '/users', icon: Users, permission: 'users.read' },
    { name: 'Партнеры', href: '/partners', icon: Building2, permission: 'partners.read' },
    { name: 'Карта локаций', href: '/locations-map', icon: MapPin, permission: 'partners.read' },
    { name: 'Подписки', href: '/subscriptions', icon: CreditCard, permission: 'subscriptions.read' },
    { name: 'Платежи', href: '/payments', icon: Receipt, permission: 'payments.read' },
    { name: 'Аналитика', href: '/analytics', icon: BarChart3, permission: 'analytics.read' },
    { name: 'Администраторы', href: '/admins', icon: Shield, permission: 'admins.read' },
    { name: 'Акции', href: '/promotions', icon: Tag, permission: 'promotions.read' },
    { name: 'Журнал аудита', href: '/audit-logs', icon: FileText, permission: 'audit.read' },
  ];

  const filteredNavigation = navigation.filter(
    (item) => !item.permission || hasPermission(item.permission)
  );

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
              <p className="text-xs text-gray-500">Admin Panel</p>
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
          {filteredNavigation.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.href;

            return (
              <Link
                key={item.name}
                to={item.href}
                className={`flex items-center gap-3 px-3 py-2 rounded-md transition-colors text-sm font-medium ${
                  isActive
                    ? 'bg-gray-100 text-gray-900'
                    : 'text-gray-600 hover:bg-gray-50'
                }`}
              >
                <Icon size={18} />
                <span className={`text-sm font-semibold ${isActive ? 'text-gray-900' : 'text-gray-700'}`}>
                  {item.name}
                </span>
                {isActive && (
                  <div className="ml-auto w-1.5 h-1.5 rounded-full bg-gray-900"></div>
                )}
              </Link>
            );
          })}
        </nav>

        {/* User Profile Section */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-gray-100">
          <div className="relative">
            <button
              onClick={() => setUserMenuOpen(!userMenuOpen)}
              className="flex items-center gap-3 p-3 rounded-md hover:bg-gray-50 transition-colors cursor-pointer"
            >
              <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-700 font-bold text-sm">
                {user?.full_name?.charAt(0) || 'A'}
              </div>
              <div className="flex-1 text-left">
                <p className="text-sm font-bold text-gray-900">{user?.full_name || 'Admin'}</p>
                <p className="text-xs text-gray-500">{user?.email || 'admin@yuvgo.uz'}</p>
              </div>
              <ChevronDown 
                size={16} 
                className={`text-gray-400 transition-transform ${userMenuOpen ? 'rotate-180' : ''}`}
              />
            </button>

            {userMenuOpen && (
              <div className="absolute bottom-full left-0 right-0 mb-2 bg-white rounded-md shadow-md border border-gray-100 overflow-hidden">
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
            <div className="flex items-center gap-4">
              <button
                onClick={() => setSidebarOpen(!sidebarOpen)}
                className="lg:hidden p-2 rounded-md hover:bg-gray-100 transition-colors"
              >
                <Menu size={20} className="text-gray-700" />
              </button>

              {/* Search Bar */}
              <div className="hidden md:flex items-center gap-2 bg-gray-100 rounded-md px-4 py-2 w-96">
                <Search size={18} className="text-gray-400" />
                <input
                  type="text"
                  placeholder="Поиск..."
                  className="bg-transparent border-none outline-none text-sm text-gray-700 placeholder-gray-400 w-full"
                />
              </div>
            </div>

            <div className="flex items-center gap-3">
              {/* Notifications */}
              <button className="relative p-2 rounded-xl hover:bg-gray-100 transition-colors">
                <Bell size={20} className="text-gray-600" />
                <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
              </button>

              {/* Quick Actions */}
              <button className="hidden md:flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-yuvgo-cyan to-yuvgo-dark text-white rounded-xl hover:shadow-lg transition-all">
                <Sparkles size={16} />
                <span className="text-sm font-semibold">Быстрые действия</span>
              </button>
            </div>
          </div>
        </header>

        {/* Page Content */}
        <main className="p-6">
          <Outlet />
        </main>
      </div>

      {/* Mobile Overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}
    </div>
  );
};

export default LayoutNew;
