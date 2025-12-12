import React from 'react';
import { useAuth } from '../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { User, Phone, Mail, Car, CreditCard, LogOut, ChevronRight } from 'lucide-react';

const Profile = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/welcome');
  };

  const menuItems = [
    { icon: Car, label: 'My Vehicles', action: () => {} },
    { icon: CreditCard, label: 'Payment Methods', action: () => {} },
    { icon: Mail, label: 'Notifications', action: () => {} },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-br from-primary-500 to-primary-700 text-white p-6 rounded-b-3xl shadow-lg">
        <div className="flex flex-col items-center">
          <div className="w-24 h-24 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center mb-4 border-4 border-white/30">
            <User size={48} />
          </div>
          <h1 className="text-2xl font-bold">{user?.full_name || 'User'}</h1>
          <p className="text-primary-100 mt-1">{user?.phone_number}</p>
        </div>
      </div>

      {/* Profile Info */}
      <div className="px-6 py-6">
        <div className="bg-white rounded-2xl shadow-sm p-6 mb-6">
          <h2 className="text-lg font-bold text-gray-900 mb-4">Account Information</h2>
          
          <div className="space-y-4">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                <User className="text-primary-600" size={20} />
              </div>
              <div>
                <p className="text-gray-500 text-xs">Full Name</p>
                <p className="text-gray-900 font-medium">{user?.full_name || 'Not set'}</p>
              </div>
            </div>

            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center">
                <Phone className="text-green-600" size={20} />
              </div>
              <div>
                <p className="text-gray-500 text-xs">Phone Number</p>
                <p className="text-gray-900 font-medium">{user?.phone_number}</p>
              </div>
            </div>

            {user?.email && (
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                  <Mail className="text-blue-600" size={20} />
                </div>
                <div>
                  <p className="text-gray-500 text-xs">Email</p>
                  <p className="text-gray-900 font-medium">{user.email}</p>
                </div>
              </div>
            )}
          </div>
        </div>

        {/* Menu Items */}
        <div className="bg-white rounded-2xl shadow-sm overflow-hidden mb-6">
          {menuItems.map((item, index) => {
            const Icon = item.icon;
            return (
              <button
                key={index}
                onClick={item.action}
                className="w-full flex items-center justify-between p-4 hover:bg-gray-50 transition-colors border-b last:border-b-0"
              >
                <div className="flex items-center space-x-3">
                  <Icon className="text-gray-600" size={20} />
                  <span className="text-gray-900 font-medium">{item.label}</span>
                </div>
                <ChevronRight className="text-gray-400" size={20} />
              </button>
            );
          })}
        </div>

        {/* Logout Button */}
        <button
          onClick={handleLogout}
          className="w-full bg-red-50 text-red-600 py-4 px-6 rounded-2xl font-semibold flex items-center justify-center space-x-2 hover:bg-red-100 transition-colors"
        >
          <LogOut size={20} />
          <span>Log Out</span>
        </button>

        {/* App Info */}
        <div className="mt-6 text-center">
          <p className="text-gray-500 text-sm">YuvGo v1.0.0</p>
          <p className="text-gray-400 text-xs mt-1">© 2024 YuvGo. All rights reserved.</p>
        </div>
      </div>
    </div>
  );
};

export default Profile;
