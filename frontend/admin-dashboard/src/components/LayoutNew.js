import React, { useState, useEffect } from 'react';
import { Outlet, Link, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import axios from 'axios';
import {
  LayoutDashboard, Users, Building2, CreditCard, Receipt,
  BarChart3, Shield, Tag, FileText, LogOut, Menu, X,
  Bell, Settings, Search, ChevronDown, Sparkles, MapPin, Car, MessageSquare,
  UserPlus, Plus, Send, RefreshCw
} from 'lucide-react';

const LayoutNew = () => {
  const { user, logout, hasPermission, API_URL } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showQuickActions, setShowQuickActions] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [notifLoading, setNotifLoading] = useState(false);

  const fetchNotifications = async () => {
    setNotifLoading(true);
    try {
      const items = [];
      try {
        const subsRes = await axios.get(`${API_URL}/api/subscription/subscriptions/all?limit=5`);
        const subs = Array.isArray(subsRes.data) ? subsRes.data : [];
        const pending = subs.filter(s => s.status === 'pending');
        pending.forEach(s => items.push({
          id: `sub-${s.id}`, type: 'subscription', icon: CreditCard,
          title: `Obuna tasdiqlash kutilmoqda`,
          desc: `${s.user?.full_name || s.user?.phone_number || 'Foydalanuvchi'} — ${s.plan?.name || 'Tarif'}`,
          time: s.created_at, color: 'text-yellow-600 bg-yellow-100',
          link: '/subscriptions'
        }));
      } catch (e) {}
      try {
        const payRes = await axios.get(`${API_URL}/api/mobile/payments/all?limit=10`);
        const payments = payRes.data?.payments || [];
        const failedPay = payments.filter(p => p.status === 'failed').slice(0, 3);
        const pendingPay = payments.filter(p => p.status === 'pending').slice(0, 3);
        failedPay.forEach(p => items.push({
          id: `pay-${p.id}`, type: 'payment', icon: Receipt,
          title: `To'lov muvaffaqiyatsiz`,
          desc: `${p.user_name || ''} — ${Number(p.amount).toLocaleString()} UZS`,
          time: p.created_at, color: 'text-red-600 bg-red-100',
          link: '/payments'
        }));
        pendingPay.forEach(p => items.push({
          id: `pay-${p.id}`, type: 'payment', icon: Receipt,
          title: `To'lov kutilmoqda`,
          desc: `${p.user_name || ''} — ${Number(p.amount).toLocaleString()} UZS`,
          time: p.created_at, color: 'text-orange-600 bg-orange-100',
          link: '/payments'
        }));
      } catch (e) {}
      items.sort((a, b) => new Date(b.time || 0) - new Date(a.time || 0));
      setNotifications(items.slice(0, 10));
    } catch (e) { console.error(e); }
    finally { setNotifLoading(false); }
  };

  useEffect(() => { fetchNotifications(); }, []);

  const quickActions = [
    { name: 'Yangi tarif yaratish', icon: Plus, link: '/subscriptions', color: 'text-blue-600' },
    { name: 'Foydalanuvchilar', icon: Users, link: '/users', color: 'text-green-600' },
    { name: 'To\'lovlar', icon: Receipt, link: '/payments', color: 'text-purple-600' },
    { name: 'Obunalar', icon: CreditCard, link: '/subscriptions', color: 'text-orange-600' },
    { name: 'Xabar yuborish', icon: Send, link: '/notifications', color: 'text-cyan-600' },
    { name: 'Hamkorlar', icon: Building2, link: '/partners', color: 'text-indigo-600' },
  ];

  const navigation = [
    { name: 'Панель управления', href: '/dashboard', icon: LayoutDashboard, permission: null },
    { name: 'Пользователи (Илова)', href: '/users', icon: Users, permission: 'users.read' },
    { name: 'Партнеры (Автомойки)', href: '/partners', icon: Building2, permission: 'partners.read' },
    { name: 'Карта локаций', href: '/locations-map', icon: MapPin, permission: 'partners.read' },
    { name: 'Посещения моек', href: '/visits', icon: Car, permission: 'analytics.read' },
    { name: 'Автомобили', href: '/vehicles', icon: Car, permission: 'users.read' },
    { name: 'Подписки', href: '/subscriptions', icon: CreditCard, permission: 'subscriptions.read' },
    { name: 'Платежи', href: '/payments', icon: Receipt, permission: 'payments.read' },
    { name: 'Аналитика', href: '/analytics', icon: BarChart3, permission: 'analytics.read' },
    { name: 'Отчеты', href: '/reports', icon: FileText, permission: 'analytics.read' },
    { name: 'Администраторы', href: '/admins', icon: Shield, permission: 'admins.read' },
    { name: 'Уведомления', href: '/notifications', icon: Bell, permission: 'users.read' },
    { name: 'Акции', href: '/promotions', icon: Tag, permission: 'promotions.read' },
    { name: 'Настройки', href: '/settings', icon: Settings, permission: 'settings.read' },
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
              <div className="relative">
                <button
                  onClick={() => { setShowNotifications(!showNotifications); setShowQuickActions(false); fetchNotifications(); }}
                  className="relative p-2 rounded-xl hover:bg-gray-100 transition-colors"
                >
                  <Bell size={20} className="text-gray-600" />
                  {notifications.length > 0 && (
                    <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
                  )}
                </button>
                {showNotifications && (
                  <div className="absolute right-0 top-full mt-2 w-96 bg-white rounded-xl shadow-xl border border-gray-200 z-50 overflow-hidden">
                    <div className="flex items-center justify-between px-4 py-3 border-b border-gray-100 bg-gray-50">
                      <span className="text-sm font-bold text-gray-900">Bildirishnomalar</span>
                      <button onClick={() => fetchNotifications()} className="text-gray-400 hover:text-gray-600"><RefreshCw size={14} /></button>
                    </div>
                    <div className="max-h-80 overflow-y-auto">
                      {notifLoading ? (
                        <div className="flex justify-center py-6"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-gray-400"></div></div>
                      ) : notifications.length === 0 ? (
                        <div className="text-center py-8 text-gray-400 text-sm">Yangi bildirishnomalar yo'q</div>
                      ) : (
                        notifications.map(n => {
                          const Icon = n.icon;
                          return (
                            <button
                              key={n.id}
                              onClick={() => { navigate(n.link); setShowNotifications(false); }}
                              className="w-full flex items-start gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left border-b border-gray-50 last:border-0"
                            >
                              <div className={`p-2 rounded-lg ${n.color} flex-shrink-0`}><Icon size={14} /></div>
                              <div className="flex-1 min-w-0">
                                <p className="text-sm font-medium text-gray-900 truncate">{n.title}</p>
                                <p className="text-xs text-gray-500 truncate">{n.desc}</p>
                                {n.time && <p className="text-xs text-gray-400 mt-1">{new Date(n.time).toLocaleString()}</p>}
                              </div>
                            </button>
                          );
                        })
                      )}
                    </div>
                    <div className="border-t border-gray-100 px-4 py-2 bg-gray-50">
                      <button onClick={() => { navigate('/payments'); setShowNotifications(false); }} className="text-xs text-blue-600 hover:text-blue-800 font-medium">Barcha to'lovlarni ko'rish</button>
                    </div>
                  </div>
                )}
              </div>

              {/* Quick Actions */}
              <div className="relative">
                <button
                  onClick={() => { setShowQuickActions(!showQuickActions); setShowNotifications(false); }}
                  className="hidden md:flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-yuvgo-cyan to-yuvgo-dark text-white rounded-xl hover:shadow-lg transition-all"
                >
                  <Sparkles size={16} />
                  <span className="text-sm font-semibold">Tez amallar</span>
                </button>
                {showQuickActions && (
                  <div className="absolute right-0 top-full mt-2 w-56 bg-white rounded-xl shadow-xl border border-gray-200 z-50 overflow-hidden">
                    <div className="px-4 py-3 border-b border-gray-100 bg-gray-50">
                      <span className="text-sm font-bold text-gray-900">Tez amallar</span>
                    </div>
                    {quickActions.map(a => {
                      const Icon = a.icon;
                      return (
                        <button
                          key={a.name}
                          onClick={() => { navigate(a.link); setShowQuickActions(false); }}
                          className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left"
                        >
                          <Icon size={16} className={a.color} />
                          <span className="text-sm font-medium text-gray-700">{a.name}</span>
                        </button>
                      );
                    })}
                  </div>
                )}
              </div>
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
