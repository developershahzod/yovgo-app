import React, { useState } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
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
    <div className="min-h-screen bg-gray-100">
      {/* Sidebar */}
      <div
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-white shadow-lg transform transition-transform duration-300 ease-in-out ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex items-center justify-between h-16 px-6 bg-primary-600">
          <h1 className="text-xl font-bold text-white">YuvGo Admin</h1>
          <button
            onClick={() => setSidebarOpen(false)}
            className="text-white lg:hidden"
          >
            <X size={24} />
          </button>
        </div>

        <nav className="mt-6 px-3">
          {filteredNavigation.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.href;

            return (
              <Link
                key={item.name}
                to={item.href}
                className={`flex items-center px-4 py-3 mb-2 rounded-lg transition-colors ${
                  isActive
                    ? 'bg-primary-50 text-primary-600'
                    : 'text-gray-700 hover:bg-gray-100'
                }`}
              >
                <Icon size={20} className="mr-3" />
                <span className="font-medium">{item.name}</span>
              </Link>
            );
          })}
        </nav>

        <div className="absolute bottom-0 w-full p-4 border-t">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-900">{user?.email}</p>
              <p className="text-xs text-gray-500 capitalize">{user?.role}</p>
            </div>
            <button
              onClick={logout}
              className="p-2 text-gray-600 hover:text-red-600 transition-colors"
              title="Logout"
            >
              <LogOut size={20} />
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
        <div className="bg-white shadow-sm">
          <div className="flex items-center justify-between h-16 px-6">
            <button
              onClick={() => setSidebarOpen(!sidebarOpen)}
              className="text-gray-600 hover:text-gray-900"
            >
              <Menu size={24} />
            </button>

            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-600">
                Welcome, <span className="font-medium">{user?.email}</span>
              </span>
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
