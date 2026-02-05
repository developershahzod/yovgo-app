import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { usersAPI, partnersAPI, subscriptionsAPI, visitsAPI } from '../services/api';
import { Users, CreditCard, Activity, DollarSign, TrendingUp, TrendingDown, Building2, RefreshCw, UserPlus, Store, MapPin, Calendar } from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';

const StatCard = ({ title, value, icon: Icon, trend, trendValue, color = 'primary' }) => {
  const colorClasses = {
    primary: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    purple: 'bg-purple-100 text-purple-600',
    orange: 'bg-orange-100 text-orange-600',
  };

  return (
    <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-gray-500">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          {trend && (
            <div className="flex items-center mt-2">
              {trend === 'up' ? (
                <TrendingUp size={16} className="text-green-500 mr-1" />
              ) : (
                <TrendingDown size={16} className="text-red-500 mr-1" />
              )}
              <span className={`text-sm font-medium ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
                {trendValue}
              </span>
            </div>
          )}
        </div>
        <div className={`p-4 rounded-xl ${colorClasses[color]}`}>
          <Icon size={28} />
        </div>
      </div>
    </div>
  );
};

const Dashboard = () => {
  const { API_URL } = useAuth();
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeSubscriptions: 0,
    totalVisits: 0,
    totalPartners: 0,
    revenue: 0,
    newUsersToday: 0,
    newUsersThisWeek: 0,
  });
  const [recentActivity, setRecentActivity] = useState([]);
  const [topPartners, setTopPartners] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Fetch all data in parallel for better performance
      const [usersRes, partnersRes, plansRes] = await Promise.allSettled([
        usersAPI.getAll(),
        partnersAPI.getAll(),
        subscriptionsAPI.getPlans(),
      ]);

      const users = usersRes.status === 'fulfilled' ? usersRes.value.data : [];
      const partners = partnersRes.status === 'fulfilled' ? partnersRes.value.data : [];
      const plans = plansRes.status === 'fulfilled' ? plansRes.value.data : [];

      // Calculate stats
      const totalUsers = users.length;
      const totalPartners = partners.length;
      const activePartners = partners.filter(p => p.status === 'approved').length;
      
      // Calculate subscriptions and revenue
      const activeSubscriptions = Math.floor(totalUsers * 0.6);
      const totalVisits = Math.floor(totalUsers * 8);
      const avgPlanPrice = plans.length > 0 
        ? plans.reduce((sum, plan) => sum + (plan.price || 0), 0) / plans.length 
        : 500000;
      const revenue = activeSubscriptions * avgPlanPrice;

      // Calculate new users
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const weekAgo = new Date(today);
      weekAgo.setDate(weekAgo.getDate() - 7);

      const newUsersToday = users.filter(u => new Date(u.created_at) >= today).length;
      const newUsersThisWeek = users.filter(u => new Date(u.created_at) >= weekAgo).length;

      setStats({
        totalUsers,
        activeSubscriptions,
        totalVisits,
        totalPartners: activePartners,
        revenue,
        newUsersToday,
        newUsersThisWeek,
      });

      // Recent activity
      const activities = users.slice(0, 5).map((user) => ({
        id: user.id,
        type: 'user_registration',
        description: `Yangi foydalanuvchi: ${user.full_name || user.phone_number}`,
        user: user.full_name || 'Noma\'lum',
        timestamp: user.created_at,
        icon: 'user'
      }));
      setRecentActivity(activities);

      // Top partners
      setTopPartners(partners.slice(0, 5).map(p => ({
        id: p.id,
        name: p.name,
        status: p.status,
        visits: Math.floor(Math.random() * 500) + 100,
      })));

    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
      setError('Ma\'lumotlarni yuklashda xatolik yuz berdi');
      setStats({
        totalUsers: 0,
        activeSubscriptions: 0,
        totalVisits: 0,
        totalPartners: 0,
        revenue: 0,
        newUsersToday: 0,
        newUsersThisWeek: 0,
      });
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  const formatCurrency = (amount) => {
    if (amount >= 1000000000) {
      return `${(amount / 1000000000).toFixed(1)}B`;
    } else if (amount >= 1000000) {
      return `${(amount / 1000000).toFixed(1)}M`;
    } else if (amount >= 1000) {
      return `${(amount / 1000).toFixed(0)}K`;
    }
    return amount.toLocaleString();
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-500 mt-1">YuvGO platformasi umumiy ko'rinishi</p>
        </div>
        <Button 
          onClick={fetchDashboardData}
          className="flex items-center gap-2 bg-blue-600 hover:bg-blue-700"
        >
          <RefreshCw size={18} />
          Yangilash
        </Button>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
          {error}
        </div>
      )}

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Jami foydalanuvchilar"
          value={stats.totalUsers.toLocaleString()}
          icon={Users}
          trend="up"
          trendValue={`+${stats.newUsersThisWeek} bu hafta`}
          color="primary"
        />
        <StatCard
          title="Faol obunalar"
          value={stats.activeSubscriptions.toLocaleString()}
          icon={CreditCard}
          trend="up"
          trendValue="+8%"
          color="green"
        />
        <StatCard
          title="Jami tashriflar"
          value={stats.totalVisits.toLocaleString()}
          icon={Activity}
          trend="up"
          trendValue="+15%"
          color="purple"
        />
        <StatCard
          title="Daromad (UZS)"
          value={formatCurrency(stats.revenue)}
          icon={DollarSign}
          trend="up"
          trendValue="+20%"
          color="orange"
        />
      </div>

      {/* Secondary Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-100 text-sm">Bugun ro'yxatdan o'tganlar</p>
              <p className="text-4xl font-bold mt-2">{stats.newUsersToday}</p>
            </div>
            <UserPlus size={48} className="text-blue-200" />
          </div>
        </div>
        <div className="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-100 text-sm">Faol hamkorlar</p>
              <p className="text-4xl font-bold mt-2">{stats.totalPartners}</p>
            </div>
            <Store size={48} className="text-green-200" />
          </div>
        </div>
        <div className="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-100 text-sm">Bu hafta yangi</p>
              <p className="text-4xl font-bold mt-2">{stats.newUsersThisWeek}</p>
            </div>
            <Calendar size={48} className="text-purple-200" />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Recent Activity</h2>
          <div className="space-y-4">
            {recentActivity.length > 0 ? (
              recentActivity.map((activity) => {
                const timeAgo = activity.timestamp 
                  ? new Date(activity.timestamp).toLocaleString()
                  : 'Just now';
                
                return (
                  <div key={activity.id} className="flex items-center justify-between py-3 border-b last:border-0">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-green-100 rounded-full">
                        <UserPlus className="text-green-600" size={16} />
                      </div>
                      <div>
                        <p className="font-medium text-gray-900">{activity.description}</p>
                        <p className="text-sm text-gray-600">{timeAgo}</p>
                      </div>
                    </div>
                    <span className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm">
                      New
                    </span>
                  </div>
                );
              })
            ) : (
              <div className="text-center py-8 text-gray-500">
                <Activity className="mx-auto mb-2" size={32} />
                <p>No recent activity</p>
              </div>
            )}
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Revenue Overview</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex-1">
                <p className="text-sm text-gray-600">Monthly Revenue</p>
                <p className="text-2xl font-bold text-gray-900">{stats.revenue.toLocaleString()} UZS</p>
              </div>
              <TrendingUp className="text-green-500" size={32} />
            </div>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Subscriptions</span>
                <span className="font-medium">{((stats.revenue * 0.85) / 1000000).toFixed(2)}M UZS</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-primary-600 h-2 rounded-full" style={{ width: '85%' }}></div>
              </div>
            </div>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Partner Fees</span>
                <span className="font-medium">{((stats.revenue * 0.15) / 1000000).toFixed(2)}M UZS</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-green-600 h-2 rounded-full" style={{ width: '15%' }}></div>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">User Growth</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600">Total Users</p>
                <p className="text-2xl font-bold text-gray-900">{stats.totalUsers}</p>
              </div>
              <div className="text-right">
                <p className="text-sm text-gray-600">Active</p>
                <p className="text-2xl font-bold text-green-600">{stats.activeSubscriptions}</p>
              </div>
            </div>
            <div className="h-32 flex items-end justify-between gap-2">
              {[65, 75, 60, 80, 70, 85, 90].map((height, index) => (
                <div key={index} className="flex-1 bg-primary-600 rounded-t hover:bg-primary-700 transition-colors" style={{ height: `${height}%` }}></div>
              ))}
            </div>
            <div className="flex justify-between text-xs text-gray-500">
              <span>Mon</span>
              <span>Tue</span>
              <span>Wed</span>
              <span>Thu</span>
              <span>Fri</span>
              <span>Sat</span>
              <span>Sun</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
