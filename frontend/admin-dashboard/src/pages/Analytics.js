import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import {
  LineChart,
  Line,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer
} from 'recharts';
import {
  TrendingUp,
  TrendingDown,
  Users,
  DollarSign,
  CreditCard,
  Activity,
  Calendar,
  Download,
  Filter,
  ArrowUpRight,
  ArrowDownRight,
  Eye,
  Car,
  Building2
} from 'lucide-react';

const Analytics = () => {
  const { API_URL } = useAuth();
  const [timeRange, setTimeRange] = useState('7days');
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    totalRevenue: 0,
    totalUsers: 0,
    activeSubscriptions: 0,
    totalVisits: 0,
    revenueGrowth: 0,
    userGrowth: 0
  });
  const [revenueData, setRevenueData] = useState([]);
  const [userGrowthData, setUserGrowthData] = useState([]);
  const [subscriptionDistribution, setSubscriptionDistribution] = useState([]);
  const [visitStats, setVisitStats] = useState([]);

  useEffect(() => {
    fetchAnalyticsData();
  }, [timeRange]);

  const [partnerPerformance, setPartnerPerformance] = useState([]);

  const fetchAnalyticsData = async () => {
    setLoading(true);
    try {
      // Fetch all real data
      const [usersRes, plansRes, partnersRes] = await Promise.allSettled([
        axios.get(`${API_URL}/api/user/users`),
        axios.get(`${API_URL}/api/subscription/plans`),
        axios.get(`${API_URL}/api/partner/partners`),
      ]);

      const users = usersRes.status === 'fulfilled' ? usersRes.value.data : [];
      const plans = plansRes.status === 'fulfilled' ? plansRes.value.data : [];
      const partners = partnersRes.status === 'fulfilled' ? partnersRes.value.data : [];

      // Fetch real visits, payments, subscriptions
      let allVisits = [];
      let allPayments = [];
      let allSubscriptions = [];
      try {
        const visitsRes = await axios.get(`${API_URL}/api/visit/visits`);
        allVisits = Array.isArray(visitsRes.data) ? visitsRes.data : [];
      } catch (e) {}
      try {
        const paymentsRes = await axios.get(`${API_URL}/api/payment/payments`);
        allPayments = Array.isArray(paymentsRes.data) ? paymentsRes.data : [];
      } catch (e) {}
      try {
        const subsRes = await axios.get(`${API_URL}/api/subscription/subscriptions`);
        allSubscriptions = Array.isArray(subsRes.data) ? subsRes.data : [];
      } catch (e) {}

      // Calculate real stats
      const totalUsers = users.length;
      const activeSubscriptions = allSubscriptions.filter(s => s.status === 'active').length;
      const successPayments = allPayments.filter(p => p.status === 'success' || p.status === 'completed');
      const totalRevenue = successPayments.reduce((sum, p) => sum + (parseFloat(p.amount) || 0), 0);
      const totalVisits = allVisits.length;

      setStats({
        totalRevenue,
        totalUsers,
        activeSubscriptions,
        totalVisits,
        revenueGrowth: 0,
        userGrowth: 0
      });

      // Revenue data from real payments (last 7 days)
      const revData = Array.from({ length: 7 }, (_, i) => {
        const date = new Date();
        date.setDate(date.getDate() - (6 - i));
        const dayStart = new Date(date); dayStart.setHours(0, 0, 0, 0);
        const dayEnd = new Date(date); dayEnd.setHours(23, 59, 59, 999);
        const dayPayments = successPayments.filter(p => {
          const pd = new Date(p.created_at);
          return pd >= dayStart && pd <= dayEnd;
        });
        const daySubs = allSubscriptions.filter(s => {
          const sd = new Date(s.created_at);
          return sd >= dayStart && sd <= dayEnd;
        });
        return {
          date: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
          revenue: dayPayments.reduce((sum, p) => sum + (parseFloat(p.amount) || 0), 0),
          subscriptions: daySubs.length
        };
      });
      setRevenueData(revData);

      // User growth data from real users (last 6 months)
      const now = new Date();
      const monthNames = [];
      const userGrowth = [];
      for (let i = 5; i >= 0; i--) {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const monthEnd = new Date(now.getFullYear(), now.getMonth() - i + 1, 0, 23, 59, 59);
        const monthLabel = d.toLocaleDateString('en-US', { month: 'short' });
        const usersUpToMonth = users.filter(u => new Date(u.created_at) <= monthEnd).length;
        const activeSubs = allSubscriptions.filter(s => {
          const sd = new Date(s.start_date || s.created_at);
          const ed = s.end_date ? new Date(s.end_date) : new Date('2099-01-01');
          return sd <= monthEnd && ed >= d && s.status === 'active';
        }).length;
        userGrowth.push({
          month: monthLabel,
          users: usersUpToMonth,
          active: activeSubs
        });
      }
      setUserGrowthData(userGrowth);

      // Subscription distribution from real subscriptions per plan
      const planCounts = {};
      allSubscriptions.filter(s => s.status === 'active').forEach(s => {
        const planId = s.plan_id;
        planCounts[planId] = (planCounts[planId] || 0) + 1;
      });
      const colors = ['#3B82F6', '#8B5CF6', '#10B981', '#F59E0B', '#EF4444'];
      const distribution = plans.map((plan, i) => ({
        name: plan.name,
        value: planCounts[plan.id] || 0,
        color: colors[i % colors.length]
      }));
      setSubscriptionDistribution(distribution);

      // Visit statistics from real visits (last 7 days)
      const dayNames = ['Yak', 'Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan'];
      const visitsByDay = Array.from({ length: 7 }, (_, i) => {
        const date = new Date();
        date.setDate(date.getDate() - (6 - i));
        const dayStart = new Date(date); dayStart.setHours(0, 0, 0, 0);
        const dayEnd = new Date(date); dayEnd.setHours(23, 59, 59, 999);
        const dayVisits = allVisits.filter(v => {
          const vd = new Date(v.check_in_time || v.created_at);
          return vd >= dayStart && vd <= dayEnd;
        });
        const completedVisits = dayVisits.filter(v => v.status === 'completed');
        return {
          day: dayNames[date.getDay()],
          visits: dayVisits.length,
          completed: completedVisits.length
        };
      });
      setVisitStats(visitsByDay);

      // Partner performance from real data
      const partnerVisits = {};
      const partnerRevenue = {};
      allVisits.forEach(v => {
        if (v.partner_id) {
          partnerVisits[v.partner_id] = (partnerVisits[v.partner_id] || 0) + 1;
        }
      });
      allPayments.filter(p => p.status === 'success' || p.status === 'completed').forEach(p => {
        if (p.partner_id) {
          partnerRevenue[p.partner_id] = (partnerRevenue[p.partner_id] || 0) + (parseFloat(p.amount) || 0);
        }
      });
      const perfData = partners
        .map(p => ({
          name: p.name,
          visits: partnerVisits[p.id] || 0,
          revenue: partnerRevenue[p.id] || 0
        }))
        .sort((a, b) => b.visits - a.visits)
        .slice(0, 5);
      setPartnerPerformance(perfData);

    } catch (error) {
      console.error('Failed to fetch analytics data:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Analytics</h1>
          <p className="text-gray-600 mt-1">Comprehensive business insights and metrics</p>
        </div>
        <div className="flex gap-2">
          <div className="flex gap-1 border rounded-lg p-1">
            <Button
              variant={timeRange === '7days' ? 'default' : 'ghost'}
              size="sm"
              onClick={() => setTimeRange('7days')}
            >
              7 Days
            </Button>
            <Button
              variant={timeRange === '30days' ? 'default' : 'ghost'}
              size="sm"
              onClick={() => setTimeRange('30days')}
            >
              30 Days
            </Button>
            <Button
              variant={timeRange === '90days' ? 'default' : 'ghost'}
              size="sm"
              onClick={() => setTimeRange('90days')}
            >
              90 Days
            </Button>
            <Button
              variant={timeRange === 'year' ? 'default' : 'ghost'}
              size="sm"
              onClick={() => setTimeRange('year')}
            >
              Year
            </Button>
          </div>
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export
          </Button>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Jami daromad</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalRevenue.toLocaleString()} UZS</div>
            <p className="text-xs text-muted-foreground mt-1">To'lovlardan</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Jami foydalanuvchilar</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalUsers}</div>
            <p className="text-xs text-muted-foreground mt-1">Ro'yxatdan o'tgan</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Faol obunalar</CardTitle>
            <CreditCard className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.activeSubscriptions}</div>
            <p className="text-xs text-muted-foreground mt-1">Hozirda faol</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Jami tashriflar</CardTitle>
            <Activity className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalVisits}</div>
            <p className="text-xs text-muted-foreground mt-1">Barcha vaqt uchun</p>
          </CardContent>
        </Card>
      </div>

      {/* Revenue & Subscriptions Chart */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <Card>
          <CardHeader>
            <CardTitle>Revenue Trend</CardTitle>
            <CardDescription>Daily revenue over the last 7 days</CardDescription>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={revenueData}>
                <defs>
                  <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#3B82F6" stopOpacity={0.3} />
                    <stop offset="95%" stopColor="#3B82F6" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" />
                <XAxis dataKey="date" stroke="#6B7280" fontSize={12} />
                <YAxis stroke="#6B7280" fontSize={12} />
                <Tooltip
                  contentStyle={{ backgroundColor: '#fff', border: '1px solid #E5E7EB', borderRadius: '8px' }}
                  formatter={(value) => `${value.toLocaleString()} UZS`}
                />
                <Area
                  type="monotone"
                  dataKey="revenue"
                  stroke="#3B82F6"
                  strokeWidth={2}
                  fillOpacity={1}
                  fill="url(#colorRevenue)"
                />
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>User Growth</CardTitle>
            <CardDescription>Total and active users over 6 months</CardDescription>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={userGrowthData}>
                <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" />
                <XAxis dataKey="month" stroke="#6B7280" fontSize={12} />
                <YAxis stroke="#6B7280" fontSize={12} />
                <Tooltip
                  contentStyle={{ backgroundColor: '#fff', border: '1px solid #E5E7EB', borderRadius: '8px' }}
                />
                <Legend />
                <Line
                  type="monotone"
                  dataKey="users"
                  stroke="#3B82F6"
                  strokeWidth={2}
                  name="Total Users"
                  dot={{ fill: '#3B82F6', r: 4 }}
                />
                <Line
                  type="monotone"
                  dataKey="active"
                  stroke="#10B981"
                  strokeWidth={2}
                  name="Active Users"
                  dot={{ fill: '#10B981', r: 4 }}
                />
              </LineChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Subscription Distribution & Visit Stats */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
        <Card>
          <CardHeader>
            <CardTitle>Subscription Distribution</CardTitle>
            <CardDescription>Breakdown by plan type</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="flex items-center justify-center">
              <ResponsiveContainer width="100%" height={300}>
                <PieChart>
                  <Pie
                    data={subscriptionDistribution}
                    cx="50%"
                    cy="50%"
                    labelLine={false}
                    label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                    outerRadius={100}
                    fill="#8884d8"
                    dataKey="value"
                  >
                    {subscriptionDistribution.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div className="grid grid-cols-2 gap-2 mt-4">
              {subscriptionDistribution.map((item) => (
                <div key={item.name} className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full" style={{ backgroundColor: item.color }}></div>
                  <span className="text-sm text-gray-600">{item.name}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Weekly Visit Statistics</CardTitle>
            <CardDescription>Visits vs completed washes</CardDescription>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={visitStats}>
                <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" />
                <XAxis dataKey="day" stroke="#6B7280" fontSize={12} />
                <YAxis stroke="#6B7280" fontSize={12} />
                <Tooltip
                  contentStyle={{ backgroundColor: '#fff', border: '1px solid #E5E7EB', borderRadius: '8px' }}
                />
                <Legend />
                <Bar dataKey="visits" fill="#3B82F6" name="Total Visits" radius={[4, 4, 0, 0]} />
                <Bar dataKey="completed" fill="#10B981" name="Completed" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Partner Performance */}
      <Card>
        <CardHeader>
          <CardTitle>Partner Performance</CardTitle>
          <CardDescription>Top performing partners by visits and revenue</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {partnerPerformance.map((partner, index) => (
              <div key={partner.name} className="flex items-center gap-4">
                <div className="flex items-center justify-center w-10 h-10 rounded-full bg-primary/10 text-primary font-bold">
                  {index + 1}
                </div>
                <div className="flex-1">
                  <div className="flex items-center justify-between mb-1">
                    <div className="flex items-center gap-2">
                      <Building2 className="h-4 w-4 text-gray-400" />
                      <span className="font-medium">{partner.name}</span>
                    </div>
                    <span className="text-sm font-bold">{partner.revenue.toLocaleString()} UZS</span>
                  </div>
                  <div className="flex items-center gap-4 text-sm text-gray-600">
                    <div className="flex items-center gap-1">
                      <Car className="h-3 w-3" />
                      <span>{partner.visits} visits</span>
                    </div>
                    <div className="flex-1">
                      <div className="w-full bg-gray-200 rounded-full h-2">
                        <div
                          className="bg-primary h-2 rounded-full"
                          style={{ width: `${partnerPerformance.length > 0 && partnerPerformance[0].visits > 0 ? (partner.visits / partnerPerformance[0].visits) * 100 : 0}%` }}
                        ></div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default Analytics;
