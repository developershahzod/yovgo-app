import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Users, CreditCard, Activity, DollarSign, TrendingUp, TrendingDown } from 'lucide-react';

const StatCard = ({ title, value, icon: Icon, trend, trendValue }) => (
  <div className="bg-white rounded-lg shadow p-6">
    <div className="flex items-center justify-between">
      <div>
        <p className="text-sm font-medium text-gray-600">{title}</p>
        <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        {trend && (
          <div className="flex items-center mt-2">
            {trend === 'up' ? (
              <TrendingUp size={16} className="text-green-500 mr-1" />
            ) : (
              <TrendingDown size={16} className="text-red-500 mr-1" />
            )}
            <span className={`text-sm ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
              {trendValue}
            </span>
          </div>
        )}
      </div>
      <div className="p-3 bg-primary-100 rounded-full">
        <Icon className="text-primary-600" size={24} />
      </div>
    </div>
  </div>
);

const Dashboard = () => {
  const { API_URL } = useAuth();
  const [analytics, setAnalytics] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchAnalytics();
  }, []);

  const fetchAnalytics = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/admin/analytics/overview?period=month`);
      setAnalytics(response.data);
    } catch (error) {
      console.error('Failed to fetch analytics:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-600 mt-1">Overview of your YuvGo platform</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Total Users"
          value={analytics?.total_users?.toLocaleString() || '0'}
          icon={Users}
          trend="up"
          trendValue="+12%"
        />
        <StatCard
          title="Active Subscriptions"
          value={analytics?.active_subscriptions?.toLocaleString() || '0'}
          icon={CreditCard}
          trend="up"
          trendValue="+8%"
        />
        <StatCard
          title="Total Visits"
          value={analytics?.total_visits?.toLocaleString() || '0'}
          icon={Activity}
          trend="up"
          trendValue="+15%"
        />
        <StatCard
          title="Revenue (UZS)"
          value={`${(analytics?.revenue || 0).toLocaleString()}`}
          icon={DollarSign}
          trend="up"
          trendValue="+20%"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Recent Activity</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between py-3 border-b">
              <div>
                <p className="font-medium text-gray-900">New user registration</p>
                <p className="text-sm text-gray-600">2 minutes ago</p>
              </div>
              <span className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm">
                New
              </span>
            </div>
            <div className="flex items-center justify-between py-3 border-b">
              <div>
                <p className="font-medium text-gray-900">Partner approved</p>
                <p className="text-sm text-gray-600">15 minutes ago</p>
              </div>
              <span className="px-3 py-1 bg-blue-100 text-blue-700 rounded-full text-sm">
                Approved
              </span>
            </div>
            <div className="flex items-center justify-between py-3">
              <div>
                <p className="font-medium text-gray-900">Payment processed</p>
                <p className="text-sm text-gray-600">1 hour ago</p>
              </div>
              <span className="px-3 py-1 bg-purple-100 text-purple-700 rounded-full text-sm">
                Completed
              </span>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
          <div className="grid grid-cols-2 gap-4">
            <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
              <Users className="text-primary-600 mb-2" size={24} />
              <p className="font-medium text-gray-900">Add User</p>
            </button>
            <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
              <Building2 className="text-primary-600 mb-2" size={24} />
              <p className="font-medium text-gray-900">Add Partner</p>
            </button>
            <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
              <Tag className="text-primary-600 mb-2" size={24} />
              <p className="font-medium text-gray-900">Create Promo</p>
            </button>
            <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
              <Shield className="text-primary-600 mb-2" size={24} />
              <p className="font-medium text-gray-900">Add Admin</p>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
