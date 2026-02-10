import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import { 
  DollarSign,
  CreditCard,
  TrendingUp,
  CheckCircle,
  XCircle,
  Clock,
  AlertCircle,
  Download,
  Filter,
  Search,
  Eye,
  RefreshCw,
  Calendar,
  ArrowUpRight,
  ArrowDownRight
} from 'lucide-react';

const Payments = () => {
  const { API_URL } = useAuth();
  const [payments, setPayments] = useState([]);
  const [stats, setStats] = useState({
    totalRevenue: 0,
    successfulPayments: 0,
    pendingPayments: 0,
    failedPayments: 0
  });
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all'); // all, success, pending, failed
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      
      // Fetch real payments from mobile API
      let realPayments = [];
      let apiStats = null;
      try {
        const paymentsRes = await axios.get(`${API_URL}/api/mobile/payments/all?limit=200`);
        const data = paymentsRes.data;
        realPayments = Array.isArray(data.payments) ? data.payments : [];
        apiStats = data.stats || null;
      } catch (e) {
        console.log('Payments API error:', e.message);
      }

      // Map real payments to display format
      const mappedPayments = realPayments.map((p, index) => ({
        id: p.id || `PAY-${index + 1}`,
        user: { 
          name: p.user_name || p.user_phone || 'Foydalanuvchi', 
          phone: p.user_phone || '' 
        },
        amount: parseFloat(p.amount) || 0,
        currency: p.currency || 'UZS',
        status: p.status || 'pending',
        method: p.payment_method || p.provider || 'Ipak Yo\'li',
        subscription: p.plan_name || '-',
        date: p.created_at || p.updated_at || new Date().toISOString(),
        transactionId: p.transaction_id || p.id || '-',
        failureReason: p.failure_reason || null
      }));

      setPayments(mappedPayments);

      // Use API stats if available, otherwise calculate
      if (apiStats) {
        setStats({
          totalRevenue: apiStats.total_revenue || 0,
          successfulPayments: apiStats.success_count || 0,
          pendingPayments: apiStats.pending_count || 0,
          failedPayments: apiStats.failed_count || 0
        });
      } else {
        const successful = mappedPayments.filter(p => p.status === 'success' || p.status === 'completed');
        const pending = mappedPayments.filter(p => p.status === 'pending');
        const failed = mappedPayments.filter(p => p.status === 'failed');
        const totalRevenue = successful.reduce((sum, p) => sum + p.amount, 0);
        setStats({
          totalRevenue,
          successfulPayments: successful.length,
          pendingPayments: pending.length,
          failedPayments: failed.length
        });
      }

    } catch (error) {
      console.error('Error fetching payments:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusBadge = (status) => {
    const badges = {
      success: 'bg-green-100 text-green-800',
      pending: 'bg-yellow-100 text-yellow-800',
      failed: 'bg-red-100 text-red-800',
      refunded: 'bg-gray-100 text-gray-800'
    };
    return badges[status] || badges.pending;
  };

  const getStatusIcon = (status) => {
    const icons = {
      success: <CheckCircle className="h-4 w-4" />,
      pending: <Clock className="h-4 w-4" />,
      failed: <XCircle className="h-4 w-4" />,
      refunded: <RefreshCw className="h-4 w-4" />
    };
    return icons[status] || icons.pending;
  };

  const getPaymentMethodLogo = (method) => {
    // In production, return actual logos
    return method;
  };

  const filteredPayments = payments.filter(payment => {
    const matchesFilter = filter === 'all' || payment.status === filter;
    const matchesSearch = payment.user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         payment.user.phone.includes(searchTerm) ||
                         payment.transactionId.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading payments...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Payments</h1>
          <p className="text-gray-600 mt-1">Track and manage all payment transactions</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export
          </Button>
          <Button variant="outline" className="gap-2" onClick={fetchData}>
            <RefreshCw className="h-4 w-4" />
            Refresh
          </Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Revenue</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalRevenue.toLocaleString()} UZS</div>
            <p className="text-xs text-muted-foreground mt-1">Muvaffaqiyatli to'lovlardan</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Successful</CardTitle>
            <CheckCircle className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{stats.successfulPayments}</div>
            <p className="text-xs text-muted-foreground">Completed payments</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Pending</CardTitle>
            <Clock className="h-4 w-4 text-yellow-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-yellow-600">{stats.pendingPayments}</div>
            <p className="text-xs text-muted-foreground">Awaiting confirmation</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Failed</CardTitle>
            <XCircle className="h-4 w-4 text-red-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{stats.failedPayments}</div>
            <p className="text-xs text-muted-foreground">Unsuccessful attempts</p>
          </CardContent>
        </Card>
      </div>

      {/* Payments List */}
      <Card>
        <CardHeader>
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
              <CardTitle>Payment Transactions</CardTitle>
              <CardDescription>All payment transactions and their status</CardDescription>
            </div>
            <div className="flex flex-col sm:flex-row gap-2">
              {/* Search */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="Search payments..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10 pr-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                />
              </div>
              {/* Filters */}
              <div className="flex gap-2">
                <Button 
                  variant={filter === 'all' ? 'default' : 'outline'} 
                  size="sm"
                  onClick={() => setFilter('all')}
                >
                  All
                </Button>
                <Button 
                  variant={filter === 'success' ? 'default' : 'outline'} 
                  size="sm"
                  onClick={() => setFilter('success')}
                >
                  Success
                </Button>
                <Button 
                  variant={filter === 'pending' ? 'default' : 'outline'} 
                  size="sm"
                  onClick={() => setFilter('pending')}
                >
                  Pending
                </Button>
                <Button 
                  variant={filter === 'failed' ? 'default' : 'outline'} 
                  size="sm"
                  onClick={() => setFilter('failed')}
                >
                  Failed
                </Button>
              </div>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Transaction ID</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">User</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Subscription</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Amount</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Method</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Status</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Date</th>
                  <th className="text-right py-3 px-4 font-medium text-gray-700">Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredPayments.map((payment) => (
                  <tr key={payment.id} className="border-b hover:bg-gray-50">
                    <td className="py-3 px-4">
                      <div className="font-mono text-sm">{payment.transactionId}</div>
                      <div className="text-xs text-gray-500">{payment.id}</div>
                    </td>
                    <td className="py-3 px-4">
                      <div>
                        <div className="font-medium">{payment.user.name}</div>
                        <div className="text-sm text-gray-600">{payment.user.phone}</div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="font-medium text-sm">{payment.subscription}</div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="font-bold">{payment.amount.toLocaleString()} {payment.currency}</div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-2">
                        <CreditCard className="h-4 w-4 text-gray-400" />
                        <span className="font-medium">{payment.method}</span>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${getStatusBadge(payment.status)}`}>
                        {getStatusIcon(payment.status)}
                        {payment.status.charAt(0).toUpperCase() + payment.status.slice(1)}
                      </span>
                      {payment.status === 'failed' && payment.failureReason && (
                        <div className="text-xs text-red-600 mt-1 flex items-center gap-1">
                          <AlertCircle className="h-3 w-3" />
                          {payment.failureReason}
                        </div>
                      )}
                    </td>
                    <td className="py-3 px-4">
                      <div className="text-sm">
                        <div>{new Date(payment.date).toLocaleDateString()}</div>
                        <div className="text-gray-600">{new Date(payment.date).toLocaleTimeString()}</div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex items-center justify-end gap-2">
                        <Button variant="ghost" size="sm" title="View Details">
                          <Eye className="h-4 w-4" />
                        </Button>
                        {payment.status === 'failed' && (
                          <Button variant="ghost" size="sm" title="Retry Payment">
                            <RefreshCw className="h-4 w-4 text-blue-600" />
                          </Button>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {filteredPayments.length === 0 && (
            <div className="text-center py-12">
              <DollarSign className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No payments found</p>
              <p className="text-sm text-gray-500 mt-1">
                {searchTerm ? 'Try adjusting your search' : filter !== 'all' ? `No ${filter} payments` : 'No payment transactions yet'}
              </p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Payment Methods Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Payment Methods</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {['ipakyuli', 'Ipak Yo\'li', 'UzCard', 'Humo'].map((method) => {
                const count = payments.filter(p => p.method === method && p.status === 'success').length;
                const total = payments.filter(p => p.status === 'success').length;
                const percentage = total > 0 ? ((count / total) * 100).toFixed(1) : 0;
                
                return (
                  <div key={method} className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <CreditCard className="h-4 w-4 text-gray-400" />
                      <span className="font-medium">{method}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <span className="text-sm text-gray-600">{count} payments</span>
                      <span className="text-sm font-medium text-primary">{percentage}%</span>
                    </div>
                  </div>
                );
              })}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-base">Recent Activity</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {payments.slice(0, 3).map((payment) => (
                <div key={payment.id} className="flex items-start gap-3">
                  <div className={`mt-1 ${getStatusBadge(payment.status)} p-1 rounded-full`}>
                    {getStatusIcon(payment.status)}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium truncate">{payment.user.name}</p>
                    <p className="text-xs text-gray-600">{payment.amount.toLocaleString()} UZS</p>
                  </div>
                  <div className="text-xs text-gray-500">
                    {new Date(payment.date).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-base">Quick Stats</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Success Rate</span>
                <span className="text-sm font-bold text-green-600">
                  {payments.length > 0 ? ((stats.successfulPayments / payments.length) * 100).toFixed(1) : 0}%
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Avg. Transaction</span>
                <span className="text-sm font-bold">
                  {stats.successfulPayments > 0 ? (stats.totalRevenue / stats.successfulPayments).toLocaleString() : 0} UZS
                </span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-600">Total Transactions</span>
                <span className="text-sm font-bold">{payments.length}</span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Payments;
