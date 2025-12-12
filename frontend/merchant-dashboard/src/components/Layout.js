import React, { useState } from 'react';
import { Outlet, Link, useLocation } from 'react-router-dom';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import {
  LayoutDashboard,
  QrCode,
  Users,
  DollarSign,
  Activity,
  FileText,
  LogOut,
  Menu,
  X,
  Building2,
} from 'lucide-react';

const Layout = () => {
  const { merchant, logout } = useMerchantAuth();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(true);

  const navigation = [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    { name: 'QR Scanner', href: '/scanner', icon: QrCode },
    { name: 'Clients', href: '/clients', icon: Users },
    { name: 'Earnings', href: '/earnings', icon: DollarSign },
    { name: 'Visit History', href: '/visits', icon: Activity },
    { name: 'QR Templates', href: '/qr-templates', icon: FileText },
  ];

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Sidebar */}
      <div
        className={`fixed inset-y-0 left-0 z-50 w-64 bg-white shadow-lg transform transition-transform duration-300 ease-in-out ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex items-center justify-between h-16 px-6 bg-primary-600">
          <div className="flex items-center">
            <Building2 className="text-white mr-2" size={24} />
            <h1 className="text-lg font-bold text-white">YuvGo Merchant</h1>
          </div>
          <button
            onClick={() => setSidebarOpen(false)}
            className="text-white lg:hidden"
          >
            <X size={24} />
          </button>
        </div>

        <nav className="mt-6 px-3">
          {navigation.map((item) => {
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
          <div className="mb-3 p-3 bg-gray-50 rounded-lg">
            <p className="text-xs text-gray-500 mb-1">Partner</p>
            <p className="text-sm font-medium text-gray-900">{merchant?.partner?.name}</p>
            {merchant?.location && (
              <p className="text-xs text-gray-600 mt-1">{merchant.location.name}</p>
            )}
          </div>
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-900">{merchant?.name}</p>
              <p className="text-xs text-gray-500 capitalize">{merchant?.role}</p>
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
                Welcome, <span className="font-medium">{merchant?.name}</span>
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
