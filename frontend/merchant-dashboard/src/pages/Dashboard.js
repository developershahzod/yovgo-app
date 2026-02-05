import React, { useState, useEffect } from 'react';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { visitsAPI, clientsAPI, earningsAPI, analyticsAPI } from '../services/api';
import { Users, DollarSign, Activity, TrendingUp, Calendar, Clock, RefreshCw, QrCode, ChevronRight, Car } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const StatCard = ({ title, value, icon: Icon, trend, color = 'blue', onClick }) => {
  const colorClasses = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    purple: 'bg-purple-100 text-purple-600',
    orange: 'bg-orange-100 text-orange-600',
  };

  return (
    <div 
      className={`bg-white rounded-xl shadow-sm border border-gray-100 p-6 hover:shadow-md transition-all ${onClick ? 'cursor-pointer' : ''}`}
      onClick={onClick}
    >
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm font-medium text-gray-500">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          {trend && (
            <div className="flex items-center mt-2">
              <TrendingUp size={16} className="text-green-500 mr-1" />
              <span className="text-sm font-medium text-green-600">{trend}</span>
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
  const { merchant } = useMerchantAuth();
  const navigate = useNavigate();
  const [stats, setStats] = useState({
    todayVisits: 0,
    totalVisits: 0,
    totalClients: 0,
    monthlyEarnings: 0,
    avgDailyVisits: 0,
    weeklyGrowth: 0,
  });
  const [recentVisits, setRecentVisits] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Try to fetch from API first, fallback to localStorage
      let visits = [];
      try {
        const response = await visitsAPI.getTodayVisits(merchant?.partner_id);
        visits = response.data || [];
      } catch (apiError) {
        // Fallback to localStorage
        visits = JSON.parse(localStorage.getItem('merchant_visits') || '[]');
      }

      setRecentVisits(visits.slice(0, 5));

      // Calculate statistics
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      const allVisits = JSON.parse(localStorage.getItem('merchant_visits') || '[]');
      
      const todayVisits = allVisits.filter(v => {
        const visitDate = new Date(v.check_in_time);
        visitDate.setHours(0, 0, 0, 0);
        return visitDate.getTime() === today.getTime();
      }).length;

      // Calculate unique clients
      const uniqueClients = new Set(allVisits.map(v => v.user_phone || v.qr_token)).size;

      // Calculate monthly earnings (estimate: 50,000 UZS per visit)
      const thisMonth = new Date();
      thisMonth.setDate(1);
      thisMonth.setHours(0, 0, 0, 0);
      
      const monthlyVisits = allVisits.filter(v => 
        new Date(v.check_in_time) >= thisMonth
      ).length;
      const monthlyEarnings = monthlyVisits * 50000;

      // Calculate average daily visits
      const oldestVisit = allVisits.length > 0 ? new Date(allVisits[allVisits.length - 1].check_in_time) : new Date();
      const daysSinceFirst = Math.max(1, Math.ceil((new Date() - oldestVisit) / (1000 * 60 * 60 * 24)));
      const avgDailyVisits = (allVisits.length / daysSinceFirst).toFixed(1);

      // Calculate weekly growth
      const weekAgo = new Date();
      weekAgo.setDate(weekAgo.getDate() - 7);
      const lastWeekVisits = allVisits.filter(v => new Date(v.check_in_time) >= weekAgo).length;
      const weeklyGrowth = allVisits.length > 0 ? Math.round((lastWeekVisits / allVisits.length) * 100) : 0;

      setStats({
        todayVisits,
        totalVisits: allVisits.length,
        totalClients: uniqueClients,
        monthlyEarnings,
        avgDailyVisits: parseFloat(avgDailyVisits),
        weeklyGrowth,
      });
    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
      setError('Ma\'lumotlarni yuklashda xatolik');
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
    if (amount >= 1000000) {
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
          <p className="text-gray-500 mt-1">Xush kelibsiz, {merchant?.name || 'Hamkor'}!</p>
        </div>
        <button
          onClick={fetchDashboardData}
          className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
        >
          <RefreshCw size={20} />
          Yangilash
        </button>
      </div>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
          {error}
        </div>
      )}

      {/* Quick Actions */}
      <div className="bg-gradient-to-r from-blue-600 to-blue-700 rounded-xl p-6 text-white">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-xl font-bold">QR kod skanerlash</h2>
            <p className="text-blue-100 mt-1">Mijozlarni qabul qilish uchun QR kodni skanerlang</p>
          </div>
          <button
            onClick={() => navigate('/qr-scanner')}
            className="flex items-center gap-2 px-6 py-3 bg-white text-blue-600 rounded-lg font-semibold hover:bg-blue-50 transition-colors"
          >
            <QrCode size={24} />
            Skanerlash
            <ChevronRight size={20} />
          </button>
        </div>
      </div>

      {/* Statistics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <StatCard
          title="Bugungi tashriflar"
          value={stats.todayVisits}
          icon={Calendar}
          trend={`+${stats.weeklyGrowth}% bu hafta`}
          color="blue"
          onClick={() => navigate('/visits')}
        />
        <StatCard
          title="Jami tashriflar"
          value={stats.totalVisits.toLocaleString()}
          icon={Activity}
          trend="+12% bu oy"
          color="green"
          onClick={() => navigate('/visits')}
        />
        <StatCard
          title="Jami mijozlar"
          value={stats.totalClients.toLocaleString()}
          icon={Users}
          trend="+8% bu oy"
          color="purple"
          onClick={() => navigate('/clients')}
        />
        <StatCard
          title="Oylik daromad"
          value={`${formatCurrency(stats.monthlyEarnings)} UZS`}
          icon={DollarSign}
          trend="+15% o'tgan oyga nisbatan"
          color="orange"
          onClick={() => navigate('/earnings')}
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
