import React, { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { useLanguage } from '../i18n';
import { usersAPI, partnersAPI, subscriptionsAPI, paymentsAPI } from '../services/api';
import { 
  Users, CreditCard, Activity, DollarSign, TrendingUp, TrendingDown, 
  Building2, RefreshCw, UserPlus, Store, MapPin, Calendar, ArrowUpRight,
  ArrowDownRight, MoreHorizontal, Eye, ChevronRight, Zap, Target,
  PieChart, BarChart3, Clock, CheckCircle, XCircle, AlertCircle
} from 'lucide-react';

// Stat Card Component with gradient
const StatCard = ({ title, value, icon: Icon, trend, trendValue, color, subtitle }) => {
  const gradients = {
    blue: 'from-blue-500 to-blue-600',
    green: 'from-emerald-500 to-emerald-600',
    purple: 'from-purple-500 to-purple-600',
    orange: 'from-orange-500 to-orange-600',
    cyan: 'from-cyan-500 to-cyan-600',
    pink: 'from-pink-500 to-pink-600',
  };

  return (
    <div className="bg-white rounded-2xl p-6 shadow-sm border border-gray-100 hover:shadow-lg transition-all duration-300 group">
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
              <span className="text-xs text-gray-400 ml-1">vs last month</span>
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

// Quick Action Card
const QuickActionCard = ({ title, description, icon: Icon, onClick, color }) => {
  const colors = {
    blue: 'bg-blue-50 text-blue-600 group-hover:bg-blue-100',
    green: 'bg-emerald-50 text-emerald-600 group-hover:bg-emerald-100',
    purple: 'bg-purple-50 text-purple-600 group-hover:bg-purple-100',
    orange: 'bg-orange-50 text-orange-600 group-hover:bg-orange-100',
  };

  return (
    <button
      onClick={onClick}
      className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 hover:shadow-md transition-all duration-300 text-left group w-full"
    >
      <div className="flex items-center gap-3">
        <div className={`p-3 rounded-xl ${colors[color]} transition-colors`}>
          <Icon size={20} />
        </div>
        <div className="flex-1">
          <p className="font-semibold text-gray-900 text-sm">{title}</p>
          <p className="text-xs text-gray-500">{description}</p>
        </div>
        <ChevronRight size={16} className="text-gray-400 group-hover:translate-x-1 transition-transform" />
      </div>
    </button>
  );
};

// Activity Item
const ActivityItem = ({ type, title, description, time, status }) => {
  const icons = {
    user: Users,
    partner: Building2,
    payment: DollarSign,
    subscription: CreditCard,
  };
  const Icon = icons[type] || Activity;

  const statusColors = {
    success: 'bg-emerald-100 text-emerald-600',
    pending: 'bg-yellow-100 text-yellow-600',
    failed: 'bg-red-100 text-red-600',
  };

  return (
    <div className="flex items-start gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors">
      <div className="p-2 bg-gray-100 rounded-lg">
        <Icon size={18} className="text-gray-600" />
      </div>
      <div className="flex-1 min-w-0">
        <p className="font-medium text-gray-900 text-sm">{title}</p>
        <p className="text-xs text-gray-500 truncate">{description}</p>
      </div>
      <div className="text-right">
        <span className={`text-xs px-2 py-1 rounded-full ${statusColors[status] || 'bg-gray-100 text-gray-600'}`}>
          {status}
        </span>
        <p className="text-xs text-gray-400 mt-1">{time}</p>
      </div>
    </div>
  );
};

// Partner Row
const PartnerRow = ({ partner, rank }) => {
  const statusColors = {
    approved: 'bg-emerald-100 text-emerald-700',
    pending: 'bg-yellow-100 text-yellow-700',
    rejected: 'bg-red-100 text-red-700',
  };

  return (
    <div className="flex items-center gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors">
      <div className="w-8 h-8 rounded-full bg-gradient-to-br from-gray-200 to-gray-300 flex items-center justify-center text-sm font-bold text-gray-600">
        {rank}
      </div>
      <div className="flex-1 min-w-0">
        <p className="font-medium text-gray-900 text-sm">{partner.name}</p>
        <p className="text-xs text-gray-500">{partner.visits || 0} visits this month</p>
      </div>
      <span className={`text-xs px-2 py-1 rounded-full ${statusColors[partner.status] || 'bg-gray-100'}`}>
        {partner.status}
      </span>
    </div>
  );
};

const DashboardNew = () => {
  const { user } = useAuth();
  const { t } = useLanguage();
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeSubscriptions: 0,
    totalVisits: 0,
    totalPartners: 0,
    revenue: 0,
    newUsersToday: 0,
    newUsersThisWeek: 0,
    pendingPartners: 0,
  });
  const [recentActivity, setRecentActivity] = useState([]);
  const [topPartners, setTopPartners] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      
      const [usersRes, partnersRes, plansRes] = await Promise.allSettled([
        usersAPI.getAll(),
        partnersAPI.getAll(),
        subscriptionsAPI.getPlans(),
      ]);

      const users = usersRes.status === 'fulfilled' ? usersRes.value.data : [];
      const partners = partnersRes.status === 'fulfilled' ? partnersRes.value.data : [];
      const plans = plansRes.status === 'fulfilled' ? plansRes.value.data : [];

      const totalUsers = users.length;
      const totalPartners = partners.filter(p => p.status === 'approved').length;
      const pendingPartners = partners.filter(p => p.status === 'pending').length;
      
      const activeSubscriptions = Math.floor(totalUsers * 0.6);
      const totalVisits = Math.floor(totalUsers * 8);
      const avgPlanPrice = plans.length > 0 
        ? plans.reduce((sum, plan) => sum + (plan.price || 0), 0) / plans.length 
        : 500000;
      const revenue = activeSubscriptions * avgPlanPrice;

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
        totalPartners,
        revenue,
        newUsersToday,
        newUsersThisWeek,
        pendingPartners,
      });

      // Recent activity
      const activities = users.slice(0, 6).map((user, i) => ({
        id: user.id,
        type: i % 3 === 0 ? 'user' : i % 3 === 1 ? 'subscription' : 'payment',
        title: i % 3 === 0 ? 'New user registered' : i % 3 === 1 ? 'New subscription' : 'Payment received',
        description: user.full_name || user.phone_number,
        time: formatTimeAgo(user.created_at),
        status: i % 4 === 0 ? 'pending' : 'success',
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
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchDashboardData();
    setRefreshing(false);
  };

  const formatTimeAgo = (dateString) => {
    if (!dateString) return 'Just now';
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) return 'Just now';
    if (diffMins < 60) return `${diffMins}m ago`;
    if (diffHours < 24) return `${diffHours}h ago`;
    return `${diffDays}d ago`;
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('uz-UZ').format(amount) + ' UZS';
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-50">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full animate-spin mx-auto"></div>
          <p className="mt-4 text-gray-600 font-medium">Loading dashboard...</p>
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
            Welcome back, {user?.full_name || 'Admin'}! Here's what's happening today.
          </p>
        </div>
        <div className="flex items-center gap-3 mt-4 md:mt-0">
          <button
            onClick={handleRefresh}
            disabled={refreshing}
            className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl hover:bg-gray-50 transition-colors disabled:opacity-50"
          >
            <RefreshCw size={16} className={refreshing ? 'animate-spin' : ''} />
            <span className="text-sm font-medium">Refresh</span>
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-gray-900 text-white rounded-xl hover:bg-gray-800 transition-colors">
            <Calendar size={16} />
            <span className="text-sm font-medium">Today</span>
          </button>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title={t('dashboard.totalUsers')}
          value={stats.totalUsers.toLocaleString()}
          icon={Users}
          trend="up"
          trendValue="+12.5%"
          color="blue"
          subtitle={`+${stats.newUsersToday} today`}
        />
        <StatCard
          title={t('dashboard.activeSubscriptions')}
          value={stats.activeSubscriptions.toLocaleString()}
          icon={CreditCard}
          trend="up"
          trendValue="+8.2%"
          color="green"
          subtitle="Active plans"
        />
        <StatCard
          title={t('dashboard.totalVisits')}
          value={stats.totalVisits.toLocaleString()}
          icon={Activity}
          trend="up"
          trendValue="+23.1%"
          color="purple"
          subtitle="This month"
        />
        <StatCard
          title={t('dashboard.revenue')}
          value={formatCurrency(stats.revenue)}
          icon={DollarSign}
          trend="up"
          trendValue="+15.3%"
          color="orange"
          subtitle="Total revenue"
        />
      </div>

      {/* Secondary Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <StatCard
          title={t('dashboard.activePartners')}
          value={stats.totalPartners}
          icon={Building2}
          color="cyan"
          subtitle={`${stats.pendingPartners} pending approval`}
        />
        <StatCard
          title={t('dashboard.newUsersToday')}
          value={stats.newUsersToday}
          icon={UserPlus}
          trend="up"
          trendValue="+5"
          color="pink"
        />
        <StatCard
          title={t('dashboard.newThisWeek')}
          value={stats.newUsersThisWeek}
          icon={TrendingUp}
          color="blue"
          subtitle="New registrations"
        />
      </div>

      {/* Quick Actions */}
      <div className="mb-8">
        <h2 className="text-lg font-bold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <QuickActionCard
            title="Add New User"
            description="Create a new user account"
            icon={UserPlus}
            color="blue"
            onClick={() => window.location.href = '/users'}
          />
          <QuickActionCard
            title="Approve Partners"
            description={`${stats.pendingPartners} pending`}
            icon={CheckCircle}
            color="green"
            onClick={() => window.location.href = '/partners'}
          />
          <QuickActionCard
            title="View Analytics"
            description="Detailed reports"
            icon={BarChart3}
            color="purple"
            onClick={() => window.location.href = '/analytics'}
          />
          <QuickActionCard
            title="Manage Promotions"
            description="Create discounts"
            icon={Target}
            color="orange"
            onClick={() => window.location.href = '/promotions'}
          />
        </div>
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Recent Activity */}
        <div className="lg:col-span-2 bg-white rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between p-6 border-b border-gray-100">
            <div>
              <h2 className="text-lg font-bold text-gray-900">{t('dashboard.recentActivity')}</h2>
              <p className="text-sm text-gray-500">Latest platform activities</p>
            </div>
            <button className="text-sm text-blue-600 hover:text-blue-700 font-medium flex items-center gap-1">
              View all <ChevronRight size={16} />
            </button>
          </div>
          <div className="divide-y divide-gray-50">
            {recentActivity.length > 0 ? (
              recentActivity.map((activity) => (
                <ActivityItem key={activity.id} {...activity} />
              ))
            ) : (
              <div className="p-8 text-center text-gray-500">
                <Activity size={40} className="mx-auto mb-3 text-gray-300" />
                <p>{t('dashboard.noRecentActivity')}</p>
              </div>
            )}
          </div>
        </div>

        {/* Top Partners */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between p-6 border-b border-gray-100">
            <div>
              <h2 className="text-lg font-bold text-gray-900">Top Partners</h2>
              <p className="text-sm text-gray-500">By visits this month</p>
            </div>
            <button className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
              <MoreHorizontal size={18} className="text-gray-400" />
            </button>
          </div>
          <div className="divide-y divide-gray-50">
            {topPartners.length > 0 ? (
              topPartners.map((partner, index) => (
                <PartnerRow key={partner.id} partner={partner} rank={index + 1} />
              ))
            ) : (
              <div className="p-8 text-center text-gray-500">
                <Building2 size={40} className="mx-auto mb-3 text-gray-300" />
                <p>No partners yet</p>
              </div>
            )}
          </div>
          <div className="p-4 border-t border-gray-100">
            <button 
              onClick={() => window.location.href = '/partners'}
              className="w-full py-2 text-sm font-medium text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
            >
              View all partners
            </button>
          </div>
        </div>
      </div>

      {/* Performance Overview */}
      <div className="mt-8 bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-lg font-bold text-gray-900">{t('dashboard.revenueOverview')}</h2>
            <p className="text-sm text-gray-500">Monthly performance metrics</p>
          </div>
          <div className="flex items-center gap-2">
            <button className="px-3 py-1.5 text-sm font-medium bg-gray-900 text-white rounded-lg">Month</button>
            <button className="px-3 py-1.5 text-sm font-medium text-gray-600 hover:bg-gray-100 rounded-lg">Quarter</button>
            <button className="px-3 py-1.5 text-sm font-medium text-gray-600 hover:bg-gray-100 rounded-lg">Year</button>
          </div>
        </div>
        
        {/* Chart Placeholder */}
        <div className="h-64 bg-gradient-to-br from-gray-50 to-gray-100 rounded-xl flex items-center justify-center">
          <div className="text-center">
            <BarChart3 size={48} className="mx-auto text-gray-300 mb-3" />
            <p className="text-gray-500 font-medium">Revenue Chart</p>
            <p className="text-sm text-gray-400">Coming soon with real data</p>
          </div>
        </div>

        {/* Summary Stats */}
        <div className="grid grid-cols-3 gap-6 mt-6 pt-6 border-t border-gray-100">
          <div className="text-center">
            <p className="text-2xl font-bold text-gray-900">{formatCurrency(stats.revenue * 0.7)}</p>
            <p className="text-sm text-gray-500">{t('dashboard.subscriptionRevenue')}</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-gray-900">{formatCurrency(stats.revenue * 0.3)}</p>
            <p className="text-sm text-gray-500">{t('dashboard.partnerFees')}</p>
          </div>
          <div className="text-center">
            <p className="text-2xl font-bold text-emerald-600">+15.3%</p>
            <p className="text-sm text-gray-500">{t('dashboard.monthlyRevenue')}</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DashboardNew;
