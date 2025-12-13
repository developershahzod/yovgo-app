import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Users, CreditCard, Activity, DollarSign, TrendingUp, TrendingDown, Building2, Tag, Shield, ArrowUpRight, ArrowDownRight, MoreHorizontal, UserPlus, Store, Gift, UserCog } from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';

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
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeSubscriptions: 0,
    totalVisits: 0,
    revenue: 0
  });
  const [recentActivity, setRecentActivity] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      
      // Fetch users count
      const usersResponse = await axios.get(`${API_URL}/api/user/users`);
      const totalUsers = usersResponse.data.length;

      // Fetch subscription plans to calculate stats
      const plansResponse = await axios.get(`${API_URL}/api/subscription/plans`);
      const plans = plansResponse.data;

      // Fetch partners
      const partnersResponse = await axios.get(`${API_URL}/api/partner/partners`);
      const partners = partnersResponse.data;

      // Mock active subscriptions and visits for now
      // In production, these would come from actual subscription and visit APIs
      const activeSubscriptions = Math.floor(totalUsers * 0.6); // Assume 60% have subscriptions
      const totalVisits = Math.floor(totalUsers * 8); // Assume 8 visits per user on average
      const revenue = plans.reduce((sum, plan) => sum + plan.price, 0) * activeSubscriptions;

      setStats({
        totalUsers,
        activeSubscriptions,
        totalVisits,
        revenue
      });

      // Create recent activity from users
      const activities = usersResponse.data.slice(0, 5).map((user, index) => ({
        id: user.id,
        type: 'user_registration',
        description: `New user registration: ${user.full_name}`,
        user: user.full_name,
        timestamp: user.created_at,
        icon: 'user'
      }));

      setRecentActivity(activities);

    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
      // Set default values on error
      setStats({
        totalUsers: 0,
        activeSubscriptions: 0,
        totalVisits: 0,
        revenue: 0
      });
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
          value={stats.totalUsers.toLocaleString()}
          icon={Users}
          trend="up"
          trendValue="+12%"
        />
        <StatCard
          title="Active Subscriptions"
          value={stats.activeSubscriptions.toLocaleString()}
          icon={CreditCard}
          trend="up"
          trendValue="+8%"
        />
        <StatCard
          title="Total Visits"
          value={stats.totalVisits.toLocaleString()}
          icon={Activity}
          trend="up"
          trendValue="+15%"
        />
        <StatCard
          title="Revenue (UZS)"
          value={stats.revenue.toLocaleString()}
          icon={DollarSign}
          trend="up"
          trendValue="+20%"
        />
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
