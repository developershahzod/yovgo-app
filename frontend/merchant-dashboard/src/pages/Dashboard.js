import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { Users, DollarSign, Activity, TrendingUp, Calendar, Clock } from 'lucide-react';

const StatCard = ({ title, value, icon: Icon, trend, color = 'primary' }) => (
  <div className="bg-white rounded-lg shadow p-6">
    <div className="flex items-center justify-between">
      <div>
        <p className="text-sm font-medium text-gray-600">{title}</p>
        <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        {trend && (
          <div className="flex items-center mt-2">
            <TrendingUp size={16} className="text-green-500 mr-1" />
            <span className="text-sm text-green-600">{trend}</span>
          </div>
        )}
      </div>
      <div className={`p-3 bg-${color}-100 rounded-full`}>
        <Icon className={`text-${color}-600`} size={24} />
      </div>
    </div>
  </div>
);

const Dashboard = () => {
  const { API_URL, merchant } = useMerchantAuth();
  const [stats, setStats] = useState({
    todayVisits: 0,
    totalVisits: 0,
    totalClients: 0,
    monthlyEarnings: 0,
    avgDailyVisits: 0,
  });
  const [recentVisits, setRecentVisits] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      // Fetch partner statistics
      const [visitsRes, clientsRes] = await Promise.all([
        axios.get(`${API_URL}/api/visit/partner/${merchant.partner.id}/visits?limit=10`),
        axios.get(`${API_URL}/api/visit/partner/${merchant.partner.id}/stats`),
      ]);

      const visits = visitsRes.data;
      setRecentVisits(visits.slice(0, 5));

      // Calculate statistics
      const today = new Date().toDateString();
      const todayVisits = visits.filter(v => 
        new Date(v.check_in_time).toDateString() === today
      ).length;

      setStats({
        todayVisits,
        totalVisits: visits.length,
        totalClients: clientsRes.data?.total_clients || 0,
        monthlyEarnings: clientsRes.data?.monthly_revenue || 0,
        avgDailyVisits: clientsRes.data?.avg_daily_visits || 0,
      });
    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
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
        <p className="text-gray-600 mt-1">Welcome back, {merchant?.name}!</p>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Today's Visits"
          value={stats.todayVisits}
          icon={Calendar}
          trend="+5 from yesterday"
          color="blue"
        />
        <StatCard
          title="Total Visits"
          value={stats.totalVisits.toLocaleString()}
          icon={Activity}
          trend="+12% this month"
          color="green"
        />
        <StatCard
          title="Total Clients"
          value={stats.totalClients.toLocaleString()}
          icon={Users}
          trend="+8% this month"
          color="purple"
        />
        <StatCard
          title="Monthly Revenue"
          value={`${(stats.monthlyEarnings / 1000000).toFixed(1)}M`}
          icon={DollarSign}
          trend="+15% from last month"
          color="yellow"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Visits */}
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Recent Check-ins</h2>
          <div className="space-y-4">
            {recentVisits.length === 0 ? (
              <p className="text-gray-500 text-center py-8">No recent visits</p>
            ) : (
              recentVisits.map((visit, index) => (
                <div key={visit.id} className="flex items-center justify-between py-3 border-b last:border-b-0">
                  <div className="flex items-center">
                    <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center mr-3">
                      <Users size={20} className="text-primary-600" />
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">Customer #{index + 1}</p>
                      <p className="text-sm text-gray-500">
                        {new Date(visit.check_in_time).toLocaleTimeString()}
                      </p>
                    </div>
                  </div>
                  <span className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm">
                    Completed
                  </span>
                </div>
              ))
            )}
          </div>
        </div>

        {/* Quick Stats */}
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Performance</h2>
          <div className="space-y-4">
            <div>
              <div className="flex justify-between text-sm mb-2">
                <span className="text-gray-600">Average Daily Visits</span>
                <span className="font-medium">{stats.avgDailyVisits.toFixed(1)}</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div 
                  className="bg-primary-600 h-2 rounded-full" 
                  style={{ width: `${Math.min((stats.avgDailyVisits / 50) * 100, 100)}%` }}
                ></div>
              </div>
            </div>

            <div>
              <div className="flex justify-between text-sm mb-2">
                <span className="text-gray-600">Today's Progress</span>
                <span className="font-medium">{stats.todayVisits} visits</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div 
                  className="bg-green-600 h-2 rounded-full" 
                  style={{ width: `${Math.min((stats.todayVisits / 30) * 100, 100)}%` }}
                ></div>
              </div>
            </div>

            <div className="pt-4 border-t">
              <div className="flex items-center justify-between mb-3">
                <span className="text-sm text-gray-600">Peak Hours</span>
                <Clock size={16} className="text-gray-400" />
              </div>
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-700">Morning (9-12)</span>
                  <span className="font-medium">35%</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-700">Afternoon (12-15)</span>
                  <span className="font-medium">45%</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-700">Evening (15-18)</span>
                  <span className="font-medium">20%</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="mt-6 bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
            <Activity className="text-primary-600 mb-2 mx-auto" size={24} />
            <p className="font-medium text-gray-900 text-sm">Scan QR</p>
          </button>
          <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
            <Users className="text-primary-600 mb-2 mx-auto" size={24} />
            <p className="font-medium text-gray-900 text-sm">View Clients</p>
          </button>
          <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
            <DollarSign className="text-primary-600 mb-2 mx-auto" size={24} />
            <p className="font-medium text-gray-900 text-sm">Earnings</p>
          </button>
          <button className="p-4 border-2 border-gray-200 rounded-lg hover:border-primary-500 hover:bg-primary-50 transition-colors">
            <Calendar className="text-primary-600 mb-2 mx-auto" size={24} />
            <p className="font-medium text-gray-900 text-sm">History</p>
          </button>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
