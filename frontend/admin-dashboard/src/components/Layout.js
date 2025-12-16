import React, { useState } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Separator } from './ui/separator';
import { Badge } from './ui/badge';
import {
  LayoutDashboard,
  Users,
  Building2,
  CreditCard,
  Receipt,
  BarChart3,
  Shield,
  Tag,
  FileText,
  LogOut,
  Menu,
  X,
  ChevronRight,
  Bell,
  Settings,
  Search,
} from 'lucide-react';

const Layout = () => {
  const { user, logout, hasPermission } = useAuth();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(true);

  const navigation = [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard, permission: null },
    { name: 'Users', href: '/users', icon: Users, permission: 'users.read' },
    { name: 'Partners', href: '/partners', icon: Building2, permission: 'partners.read' },
    { name: 'Subscriptions', href: '/subscriptions', icon: CreditCard, permission: 'subscriptions.read' },
    { name: 'Payments', href: '/payments', icon: Receipt, permission: 'payments.read' },
    { name: 'Analytics', href: '/analytics', icon: BarChart3, permission: 'analytics.read' },
    { name: 'Admins', href: '/admins', icon: Shield, permission: 'admins.read' },
    { name: 'Promotions', href: '/promotions', icon: Tag, permission: 'promotions.read' },
    { name: 'Audit Logs', href: '/audit-logs', icon: FileText, permission: 'audit.read' },
  ];

  const filteredNavigation = navigation.filter(
    (item) => !item.permission || hasPermission(item.permission)
  );

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Sidebar */}
      <div
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-white border-r border-gray-200 transform transition-transform duration-300 ease-in-out ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        {/* Logo */}
        <div className="flex items-center justify-between h-16 px-6 border-b border-gray-200">
          <div className="flex items-center gap-3">
            <img 
              src="/logo.png" 
              alt="YuvGo Logo" 
              className="w-10 h-10 rounded-lg"
            />
            <div>
              <h1 className="text-lg font-bold text-yuvgo-navy">YuvGo</h1>
              <p className="text-xs text-gray-500">Admin Panel</p>
            </div>
          </div>
          <button
            onClick={() => setSidebarOpen(false)}
            className="text-gray-400 hover:text-gray-600 lg:hidden"
          >
            <X size={20} />
          </button>
        </div>

        {/* Navigation */}
        <nav className="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
          {filteredNavigation.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.href;

            return (
              <Link
                key={item.name}
                to={item.href}
                className={`group flex items-center justify-between px-3 py-2.5 rounded-lg transition-all ${
                  isActive
                    ? 'bg-primary text-primary-foreground shadow-sm'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
              >
                <div className="flex items-center gap-3">
                  <Icon size={18} className={isActive ? '' : 'text-gray-500 group-hover:text-gray-700'} />
                  <span className="text-sm font-medium">{item.name}</span>
                </div>
                {isActive && <ChevronRight size={16} />}
              </Link>
            );
          })}
        </nav>

        <Separator />

        {/* User Profile */}
        <div className="p-4">
          <div className="flex items-center gap-3 p-3 rounded-lg bg-gray-50 border border-gray-200">
            <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary to-primary/80 flex items-center justify-center">
              <span className="text-white font-semibold text-sm">
                {user?.email?.charAt(0).toUpperCase()}
              </span>
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-gray-900 truncate">{user?.email}</p>
              <Badge variant="secondary" className="text-xs mt-1">
                {user?.role}
              </Badge>
            </div>
            <button
              onClick={logout}
              className="p-2 text-gray-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
              title="Logout"
            >
              <LogOut size={16} />
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div
        className={`transition-all duration-300 ${
          sidebarOpen ? 'lg:ml-64' : 'ml-0'
        }`}
      >
        {/* Top Bar */}
        <div className="sticky top-0 z-40 bg-white border-b border-gray-200">
          <div className="flex items-center justify-between h-16 px-6">
            <div className="flex items-center gap-4">
              <button
                onClick={() => setSidebarOpen(!sidebarOpen)}
                className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <Menu size={20} />
              </button>
              
              {/* Search Bar */}
              <div className="hidden md:flex items-center gap-2 px-3 py-2 bg-gray-50 border border-gray-200 rounded-lg w-64">
                <Search size={16} className="text-gray-400" />
                <input
                  type="text"
                  placeholder="Search..."
                  className="bg-transparent border-none outline-none text-sm w-full"
                />
              </div>
            </div>

            <div className="flex items-center gap-3">
              {/* Notifications */}
              <button className="relative p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors">
                <Bell size={20} />
                <span className="absolute top-1 right-1 w-2 h-2 bg-red-500 rounded-full"></span>
              </button>

              {/* Settings */}
              <button className="p-2 text-gray-600 hover:text-gray-900 hover:bg-gray-100 rounded-lg transition-colors">
                <Settings size={20} />
              </button>

              {/* User Info */}
              <div className="hidden lg:flex items-center gap-2 pl-3 border-l border-gray-200">
                <div className="text-right">
                  <p className="text-sm font-medium text-gray-900">{user?.email}</p>
                  <p className="text-xs text-gray-500 capitalize">{user?.role}</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Page Content */}
        <main className="p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default Layout;
