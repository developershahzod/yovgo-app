import React, { useState, useEffect } from 'react';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { useLanguage } from '../i18n';
import { useNavigate } from 'react-router-dom';
import { 
  Users, DollarSign, Activity, TrendingUp, Calendar, Clock, RefreshCw, 
  QrCode, ChevronRight, Car, Zap, Target, BarChart3, ArrowUpRight,
  ArrowDownRight, Eye, CheckCircle, XCircle, Sparkles, MapPin, Star
} from 'lucide-react';

// Modern Stat Card with gradient
const StatCard = ({ title, value, icon: Icon, trend, trendValue, color, subtitle, onClick }) => {
  const gradients = {
    blue: 'from-blue-500 to-blue-600',
    green: 'from-emerald-500 to-emerald-600',
    purple: 'from-purple-500 to-purple-600',
    orange: 'from-orange-500 to-orange-600',
    cyan: 'from-cyan-500 to-cyan-600',
    pink: 'from-pink-500 to-pink-600',
  };

  return (
    <div 
      className={`bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-lg transition-all duration-300 group ${onClick ? 'cursor-pointer' : ''}`}
      onClick={onClick}
    >
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <p className="text-sm font-medium text-gray-500 mb-1">{title}</p>
          <p className="text-3xl font-bold text-gray-900">{value}</p>
          {subtitle && <p className="text-xs text-gray-400 mt-1">{subtitle}</p>}
          {trend && (
            <div className="flex items-center mt-3 gap-1">
              {trend === 'up' ? (
                <div className="flex items-center text-emerald-600 bg-emerald-50 px-2 py-1 rounded-full">
                  <ArrowUpRight size={14} className="mr-1" />
                  <span className="text-xs font-semibold">{trendValue}</span>
                </div>
              ) : (
                <div className="flex items-center text-red-600 bg-red-50 px-2 py-1 rounded-full">
                  <ArrowDownRight size={14} className="mr-1" />
                  <span className="text-xs font-semibold">{trendValue}</span>
                </div>
              )}
            </div>
          )}
        </div>
        <div className={`p-4 rounded-2xl bg-gradient-to-br ${gradients[color]} shadow-lg group-hover:scale-110 transition-transform duration-300`}>
          <Icon size={24} className="text-white" />
        </div>
      </div>
    </div>
  );
};

// Quick Action Button
const QuickAction = ({ title, icon: Icon, onClick, color, badge }) => {
  const colors = {
    blue: 'bg-blue-50 text-blue-600 hover:bg-blue-100',
    green: 'bg-emerald-50 text-emerald-600 hover:bg-emerald-100',
    purple: 'bg-purple-50 text-purple-600 hover:bg-purple-100',
    orange: 'bg-orange-50 text-orange-600 hover:bg-orange-100',
  };

  return (
    <button
      onClick={onClick}
      className={`relative flex flex-col items-center justify-center p-6 rounded-2xl ${colors[color]} transition-all duration-300 hover:scale-105`}
    >
      {badge && (
        <span className="absolute -top-2 -right-2 bg-red-500 text-white text-xs font-bold px-2 py-1 rounded-full">
          {badge}
        </span>
      )}
      <Icon size={32} className="mb-2" />
      <span className="text-sm font-semibold">{title}</span>
    </button>
  );
};

// Visit Item
const VisitItem = ({ visit }) => {
  const formatTime = (dateString) => {
    if (!dateString) return '--:--';
    const date = new Date(dateString);
    return date.toLocaleTimeString('uz-UZ', { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className="flex items-center gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors">
      <div className="w-12 h-12 rounded-full bg-gradient-to-br from-emerald-400 to-emerald-600 flex items-center justify-center">
        <Car size={20} className="text-white" />
      </div>
      <div className="flex-1 min-w-0">
        <p className="font-semibold text-gray-900">{visit.user_name || visit.user_phone || 'Mehmon'}</p>
        <p className="text-sm text-gray-500">{visit.vehicle_plate || 'Avtomobil'}</p>
      </div>
      <div className="text-right">
        <p className="text-sm font-medium text-gray-900">{formatTime(visit.check_in_time)}</p>
        <span className="text-xs px-2 py-1 rounded-full bg-emerald-100 text-emerald-700">
          {visit.status || 'Completed'}
        </span>
      </div>
    </div>
  );
};

// Performance Chart Placeholder
const PerformanceChart = ({ data }) => {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  const maxValue = Math.max(...data, 1);

  return (
    <div className="flex items-end justify-between h-32 gap-2">
      {data.map((value, index) => (
        <div key={index} className="flex-1 flex flex-col items-center gap-2">
          <div 
            className="w-full bg-gradient-to-t from-emerald-500 to-emerald-400 rounded-t-lg transition-all duration-500 hover:from-emerald-600 hover:to-emerald-500"
            style={{ height: `${(value / maxValue) * 100}%`, minHeight: '4px' }}
          />
          <span className="text-xs text-gray-500">{days[index]}</span>
        </div>
      ))}
    </div>
  );
};

const DashboardNew = () => {
  const { merchant, API_URL } = useMerchantAuth();
  const { t } = useLanguage();
  const navigate = useNavigate();
  const [stats, setStats] = useState({
    todayVisits: 0,
    totalVisits: 0,
    totalClients: 0,
    monthlyEarnings: 0,
    avgDailyVisits: 0,
    weeklyGrowth: 0,
    pendingVisits: 0,
    rating: 0,
  });
  const [recentVisits, setRecentVisits] = useState([]);
  const [weeklyData, setWeeklyData] = useState([0, 0, 0, 0, 0, 0, 0]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      const partnerId = merchant?.partner?.id;

      let allVisits = [];
      
      // Fetch visits from real API
      if (partnerId) {
        try {
          const response = await fetch(`${API_URL}/api/visit/visits?partner_id=${partnerId}`, {
            headers: { 'Authorization': `Bearer ${localStorage.getItem('merchant_token')}` }
          });
          if (response.ok) {
            allVisits = await response.json();
            if (!Array.isArray(allVisits)) allVisits = [];
          }
        } catch (err) {
          console.error('API fetch failed, using empty data:', err);
        }
      }
      
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      const todayVisits = allVisits.filter(v => {
        const visitDate = new Date(v.check_in_time);
        visitDate.setHours(0, 0, 0, 0);
        return visitDate.getTime() === today.getTime();
      }).length;

      // Calculate unique clients
      const uniqueClients = new Set(allVisits.map(v => v.user_id || v.user_phone || v.qr_token)).size;

      // Calculate monthly earnings (50,000 UZS per visit)
      const thisMonth = new Date();
      thisMonth.setDate(1);
      thisMonth.setHours(0, 0, 0, 0);
      
      const monthlyVisits = allVisits.filter(v => 
        new Date(v.check_in_time) >= thisMonth
      ).length;
      const monthlyEarnings = monthlyVisits * 50000;

      // Calculate weekly data
      const weekData = [0, 0, 0, 0, 0, 0, 0];
      const now = new Date();
      allVisits.forEach(v => {
        const visitDate = new Date(v.check_in_time);
        const daysDiff = Math.floor((now - visitDate) / (1000 * 60 * 60 * 24));
        if (daysDiff < 7) {
          const dayIndex = 6 - daysDiff;
          if (dayIndex >= 0 && dayIndex < 7) {
            weekData[dayIndex]++;
          }
        }
      });
      setWeeklyData(weekData);

      // Calculate average daily visits
      const avgDailyVisits = allVisits.length > 0 
        ? (allVisits.length / Math.max(1, Math.ceil((new Date() - new Date(allVisits[allVisits.length - 1]?.check_in_time || new Date())) / (1000 * 60 * 60 * 24)))).toFixed(1)
        : '0';

      // Weekly growth
      const weekAgo = new Date();
      weekAgo.setDate(weekAgo.getDate() - 7);
      const lastWeekVisits = allVisits.filter(v => new Date(v.check_in_time) >= weekAgo).length;
      const weeklyGrowth = allVisits.length > 0 ? Math.round((lastWeekVisits / allVisits.length) * 100) : 0;

      // Fetch real rating
      let partnerRating = 0;
      if (partnerId) {
        try {
          const ratingRes = await fetch(`${API_URL}/api/mobile/reviews/partner/${partnerId}`);
          if (ratingRes.ok) {
            const ratingData = await ratingRes.json();
            partnerRating = ratingData.average_rating || 0;
          }
        } catch (err) { console.log('Rating fetch failed'); }
      }

      setStats({
        todayVisits,
        totalVisits: allVisits.length,
        totalClients: uniqueClients,
        monthlyEarnings,
        avgDailyVisits: parseFloat(avgDailyVisits),
        weeklyGrowth,
        pendingVisits: 0,
        rating: partnerRating,
      });

      setRecentVisits(allVisits.slice(0, 5));
    } catch (error) {
      console.error('Failed to fetch dashboard data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchDashboardData();
    setTimeout(() => setRefreshing(false), 500);
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('uz-UZ').format(amount) + ' UZS';
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-50">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto"></div>
          <p className="mt-4 text-gray-600 font-medium">{t('common.loading')}</p>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 bg-gray-50 min-h-screen">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center md:justify-between mb-8">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">
            {t('dashboard.title')} 👋
          </h1>
          <p className="text-gray-500 mt-1">
            {t('dashboard.welcome')}, {merchant?.name || merchant?.partner?.name || 'Hamkor'}!
          </p>
        </div>
        <div className="flex items-center gap-3 mt-4 md:mt-0">
          <button
            onClick={handleRefresh}
            disabled={refreshing}
            className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors disabled:opacity-50"
          >
            <RefreshCw size={16} className={refreshing ? 'animate-spin' : ''} />
            <span className="text-sm font-medium">{t('common.refresh')}</span>
          </button>
          <div className="flex items-center gap-2 px-4 py-2 bg-emerald-50 text-emerald-700 rounded-xl">
            <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse"></div>
            <span className="text-sm font-medium">{t('common.active')}</span>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
        <QuickAction
          title={t('qrScanner.title')}
          icon={QrCode}
          color="green"
          onClick={() => navigate('/qr-scanner')}
        />
        <QuickAction
          title={t('clients.title')}
          icon={Users}
          color="blue"
          badge={stats.totalClients > 0 ? stats.totalClients : null}
          onClick={() => navigate('/clients')}
        />
        <QuickAction
          title={t('earnings.title')}
          icon={DollarSign}
          color="orange"
          onClick={() => navigate('/earnings')}
        />
        <QuickAction
          title={t('qrTemplates.title')}
          icon={Sparkles}
          color="purple"
          onClick={() => navigate('/qr-templates')}
        />
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title={t('dashboard.todayVisits')}
          value={stats.todayVisits}
          icon={Activity}
          color="green"
          subtitle={t('dashboard.today')}
        />
        <StatCard
          title={t('dashboard.totalClients')}
          value={stats.totalClients}
          icon={Users}
          color="blue"
          subtitle={t('dashboard.uniqueClients')}
        />
        <StatCard
          title={t('dashboard.monthlyEarnings')}
          value={formatCurrency(stats.monthlyEarnings)}
          icon={DollarSign}
          color="orange"
          subtitle={t('dashboard.thisMonth')}
        />
        <StatCard
          title={t('dashboard.totalVisits')}
          value={stats.totalVisits}
          icon={TrendingUp}
          color="purple"
          subtitle={t('dashboard.allTime')}
        />
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Weekly Performance */}
        <div className="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-lg font-bold text-gray-900">{t('dashboard.weeklyPerformance')}</h2>
              <p className="text-sm text-gray-500">{t('dashboard.visitsThisWeek')}</p>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-2xl font-bold text-emerald-600">
                {weeklyData.reduce((a, b) => a + b, 0)}
              </span>
              <span className="text-sm text-gray-500">{t('dashboard.visits')}</span>
            </div>
          </div>
          <PerformanceChart data={weeklyData} />
        </div>

        {/* Recent Visits */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between p-6 border-b border-gray-100">
            <div>
              <h2 className="text-lg font-bold text-gray-900">{t('dashboard.recentVisits')}</h2>
              <p className="text-sm text-gray-500">{t('dashboard.latestActivity')}</p>
            </div>
          </div>
          <div className="divide-y divide-gray-50">
            {recentVisits.length > 0 ? (
              recentVisits.map((visit, index) => (
                <VisitItem key={visit.id || index} visit={visit} />
              ))
            ) : (
              <div className="p-8 text-center">
                <Car size={48} className="mx-auto text-gray-300 mb-3" />
                <p className="text-gray-500 font-medium">{t('dashboard.noVisitsYet')}</p>
                <p className="text-sm text-gray-400 mt-1">{t('dashboard.scanQRToStart')}</p>
              </div>
            )}
          </div>
          {recentVisits.length > 0 && (
            <div className="p-4 border-t border-gray-100">
              <button 
                onClick={() => navigate('/visits')}
                className="w-full py-2 text-sm font-medium text-emerald-600 hover:bg-emerald-50 rounded-lg transition-colors flex items-center justify-center gap-1"
              >
                {t('dashboard.viewAll')} <ChevronRight size={16} />
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Bottom Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-8">
        <div className="bg-gradient-to-br from-emerald-500 to-emerald-600 rounded-2xl p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-emerald-100 text-sm font-medium">{t('dashboard.avgDaily')}</p>
              <p className="text-3xl font-bold mt-2">{stats.avgDailyVisits}</p>
              <p className="text-emerald-100 text-sm mt-1">{t('dashboard.visitsPerDay')}</p>
            </div>
            <div className="p-4 bg-white/20 rounded-2xl">
              <BarChart3 size={32} />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-100 text-sm font-medium">{t('dashboard.weeklyGrowth')}</p>
              <p className="text-3xl font-bold mt-2">{stats.weeklyGrowth}%</p>
              <p className="text-blue-100 text-sm mt-1">{t('dashboard.ofTotalVisits')}</p>
            </div>
            <div className="p-4 bg-white/20 rounded-2xl">
              <TrendingUp size={32} />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-500 to-purple-600 rounded-2xl p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-100 text-sm font-medium">{t('dashboard.rating')}</p>
              <p className="text-3xl font-bold mt-2 flex items-center gap-2">
                {stats.rating > 0 ? stats.rating.toFixed(1) : '—'} <Star size={24} fill="currentColor" />
              </p>
              <p className="text-purple-100 text-sm mt-1">{t('dashboard.customerRating')}</p>
            </div>
            <div className="p-4 bg-white/20 rounded-2xl">
              <Target size={32} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardNew;
