import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import { 
  CreditCard, 
  Users, 
  TrendingUp, 
  DollarSign,
  Calendar,
  CheckCircle,
  XCircle,
  Clock,
  Plus,
  Edit,
  Trash2,
  Eye,
  Filter,
  Download
} from 'lucide-react';

const Subscriptions = () => {
  const { API_URL } = useAuth();
  const [subscriptions, setSubscriptions] = useState([]);
  const [plans, setPlans] = useState([]);
  const [stats, setStats] = useState({
    total: 0,
    active: 0,
    expired: 0,
    revenue: 0
  });
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all'); // all, active, expired, cancelled
  const [showPlanModal, setShowPlanModal] = useState(false);
  const [editingPlan, setEditingPlan] = useState(null);
  const [planForm, setPlanForm] = useState({
    name: '',
    description: '',
    price: '',
    currency: 'UZS',
    duration_days: '',
    visit_limit: '',
    is_unlimited: false,
    is_active: true
  });
  const [planError, setPlanError] = useState('');
  const [planSuccess, setPlanSuccess] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      
      // Fetch subscription plans
      const plansResponse = await axios.get(`${API_URL}/api/subscription/plans`);
      setPlans(plansResponse.data);

      // Fetch subscriptions (mock data for now - replace with actual API)
      const mockSubscriptions = [
        {
          id: '1',
          user: { name: 'Test User 1', phone: '+998901111111' },
          plan: plansResponse.data[0],
          status: 'active',
          startDate: '2024-12-01',
          endDate: '2024-12-31',
          visitsUsed: 5,
          autoRenew: true
        },
        {
          id: '2',
          user: { name: 'Test User 2', phone: '+998902222222' },
          plan: plansResponse.data[1],
          status: 'active',
          startDate: '2024-12-05',
          endDate: '2025-01-05',
          visitsUsed: 8,
          autoRenew: false
        },
        {
          id: '3',
          user: { name: 'Test User 3', phone: '+998903333333' },
          plan: plansResponse.data[2],
          status: 'expired',
          startDate: '2024-09-01',
          endDate: '2024-11-30',
          visitsUsed: 36,
          autoRenew: false
        }
      ];

      setSubscriptions(mockSubscriptions);

      // Calculate stats
      const activeCount = mockSubscriptions.filter(s => s.status === 'active').length;
      const expiredCount = mockSubscriptions.filter(s => s.status === 'expired').length;
      const totalRevenue = mockSubscriptions
        .filter(s => s.status === 'active')
        .reduce((sum, s) => sum + s.plan.price, 0);

      setStats({
        total: mockSubscriptions.length,
        active: activeCount,
        expired: expiredCount,
        revenue: totalRevenue
      });

    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const getStatusBadge = (status) => {
    const badges = {
      active: 'bg-green-100 text-green-800',
      expired: 'bg-red-100 text-red-800',
      cancelled: 'bg-gray-100 text-gray-800',
      pending: 'bg-yellow-100 text-yellow-800'
    };
    return badges[status] || badges.pending;
  };

  const getStatusIcon = (status) => {
    const icons = {
      active: <CheckCircle className="h-4 w-4" />,
      expired: <XCircle className="h-4 w-4" />,
      cancelled: <XCircle className="h-4 w-4" />,
      pending: <Clock className="h-4 w-4" />
    };
    return icons[status] || icons.pending;
  };

  const handleCreatePlan = () => {
    setEditingPlan(null);
    setPlanForm({
      name: '',
      description: '',
      price: '',
      currency: 'UZS',
      duration_days: '',
      visit_limit: '',
      is_unlimited: false,
      is_active: true
    });
    setShowPlanModal(true);
  };

  const handleEditPlan = (plan) => {
    setEditingPlan(plan);
    setPlanForm({
      name: plan.name,
      description: plan.description,
      price: plan.price,
      currency: plan.currency,
      duration_days: plan.duration_days,
      visit_limit: plan.visit_limit || '',
      is_unlimited: plan.is_unlimited,
      is_active: plan.is_active
    });
    setShowPlanModal(true);
  };

  const handleSavePlan = async (e) => {
    e.preventDefault();
    setPlanError('');
    setPlanSuccess('');

    try {
      if (editingPlan) {
        // Update existing plan
        await axios.put(`${API_URL}/api/subscription/plans/${editingPlan.id}`, planForm);
        setPlanSuccess('Plan updated successfully!');
      } else {
        // Create new plan
        await axios.post(`${API_URL}/api/subscription/plans`, planForm);
        setPlanSuccess('Plan created successfully!');
      }

      setTimeout(() => {
        setShowPlanModal(false);
        setPlanSuccess('');
        fetchData();
      }, 1500);
    } catch (error) {
      setPlanError(error.response?.data?.detail || 'Failed to save plan');
    }
  };

  const filteredSubscriptions = subscriptions.filter(sub => {
    if (filter === 'all') return true;
    return sub.status === filter;
  });

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading subscriptions...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Subscriptions</h1>
          <p className="text-gray-600 mt-1">Manage user subscriptions and plans</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export
          </Button>
          <Button onClick={handleCreatePlan} className="gap-2">
            <Plus className="h-4 w-4" />
            New Plan
          </Button>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Subscriptions</CardTitle>
            <CreditCard className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
            <p className="text-xs text-muted-foreground">All time subscriptions</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Active</CardTitle>
            <CheckCircle className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{stats.active}</div>
            <p className="text-xs text-muted-foreground">Currently active</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Expired</CardTitle>
            <XCircle className="h-4 w-4 text-red-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{stats.expired}</div>
            <p className="text-xs text-muted-foreground">Need renewal</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Monthly Revenue</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.revenue.toLocaleString()} UZS</div>
            <p className="text-xs text-muted-foreground">From active subscriptions</p>
          </CardContent>
        </Card>
      </div>

      {/* Subscription Plans */}
      <Card>
        <CardHeader>
          <CardTitle>Subscription Plans</CardTitle>
          <CardDescription>Available subscription plans for users</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {plans.map((plan) => (
              <div key={plan.id} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between mb-2">
                  <h3 className="font-semibold text-lg">{plan.name}</h3>
                  {plan.is_active && (
                    <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded">Active</span>
                  )}
                </div>
                <p className="text-2xl font-bold text-primary mb-2">
                  {plan.price.toLocaleString()} {plan.currency}
                </p>
                <p className="text-sm text-gray-600 mb-3">{plan.description}</p>
                <div className="space-y-1 text-sm text-gray-600">
                  <div className="flex items-center gap-2">
                    <Calendar className="h-3 w-3" />
                    <span>{plan.duration_days} days</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Users className="h-3 w-3" />
                    <span>{plan.is_unlimited ? 'Unlimited' : plan.visit_limit} visits</span>
                  </div>
                </div>
                <div className="mt-4 flex gap-2">
                  <Button onClick={() => handleEditPlan(plan)} variant="outline" size="sm" className="flex-1">
                    <Edit className="h-3 w-3 mr-1" />
                    Edit
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Subscriptions List */}
      <Card>
        <CardHeader>
          <div className="flex items-center justify-between">
            <div>
              <CardTitle>User Subscriptions</CardTitle>
              <CardDescription>All user subscriptions and their status</CardDescription>
            </div>
            <div className="flex gap-2">
              <Button 
                variant={filter === 'all' ? 'default' : 'outline'} 
                size="sm"
                onClick={() => setFilter('all')}
              >
                All
              </Button>
              <Button 
                variant={filter === 'active' ? 'default' : 'outline'} 
                size="sm"
                onClick={() => setFilter('active')}
              >
                Active
              </Button>
              <Button 
                variant={filter === 'expired' ? 'default' : 'outline'} 
                size="sm"
                onClick={() => setFilter('expired')}
              >
                Expired
              </Button>
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-3 px-4 font-medium text-gray-700">User</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Plan</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Status</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Period</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Usage</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Auto Renew</th>
                  <th className="text-right py-3 px-4 font-medium text-gray-700">Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredSubscriptions.map((subscription) => (
                  <tr key={subscription.id} className="border-b hover:bg-gray-50">
                    <td className="py-3 px-4">
                      <div>
                        <div className="font-medium">{subscription.user.name}</div>
                        <div className="text-sm text-gray-600">{subscription.user.phone}</div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div>
                        <div className="font-medium">{subscription.plan.name}</div>
                        <div className="text-sm text-gray-600">
                          {subscription.plan.price.toLocaleString()} {subscription.plan.currency}
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${getStatusBadge(subscription.status)}`}>
                        {getStatusIcon(subscription.status)}
                        {subscription.status.charAt(0).toUpperCase() + subscription.status.slice(1)}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      <div className="text-sm">
                        <div>{new Date(subscription.startDate).toLocaleDateString()}</div>
                        <div className="text-gray-600">to {new Date(subscription.endDate).toLocaleDateString()}</div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <div className="text-sm">
                        <div className="font-medium">{subscription.visitsUsed} visits</div>
                        <div className="text-gray-600">
                          of {subscription.plan.is_unlimited ? '∞' : subscription.plan.visit_limit}
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      {subscription.autoRenew ? (
                        <span className="text-green-600 text-sm">Yes</span>
                      ) : (
                        <span className="text-gray-600 text-sm">No</span>
                      )}
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex items-center justify-end gap-2">
                        <Button variant="ghost" size="sm">
                          <Eye className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="sm">
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button variant="ghost" size="sm">
                          <Trash2 className="h-4 w-4 text-red-600" />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {filteredSubscriptions.length === 0 && (
            <div className="text-center py-12">
              <CreditCard className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">No subscriptions found</p>
              <p className="text-sm text-gray-500 mt-1">
                {filter !== 'all' ? `No ${filter} subscriptions` : 'Get started by creating a subscription'}
              </p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Create/Edit Plan Modal */}
      {showPlanModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">
              {editingPlan ? 'Edit Plan' : 'Create New Plan'}
            </h2>

            {planError && (
              <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg">
                <p className="text-sm text-red-600">{planError}</p>
              </div>
            )}

            {planSuccess && (
              <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg">
                <p className="text-sm text-green-600">{planSuccess}</p>
              </div>
            )}

            <form onSubmit={handleSavePlan} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Plan Name *
                  </label>
                  <input
                    type="text"
                    value={planForm.name}
                    onChange={(e) => setPlanForm({ ...planForm, name: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="Premium Monthly"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Price (UZS) *
                  </label>
                  <input
                    type="number"
                    value={planForm.price}
                    onChange={(e) => setPlanForm({ ...planForm, price: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="199000"
                    required
                    min="0"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Description *
                </label>
                <textarea
                  value={planForm.description}
                  onChange={(e) => setPlanForm({ ...planForm, description: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  rows="2"
                  placeholder="Unlimited car washes per month"
                  required
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Duration (Days) *
                  </label>
                  <input
                    type="number"
                    value={planForm.duration_days}
                    onChange={(e) => setPlanForm({ ...planForm, duration_days: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="30"
                    required
                    min="1"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Visit Limit {!planForm.is_unlimited && '*'}
                  </label>
                  <input
                    type="number"
                    value={planForm.visit_limit}
                    onChange={(e) => setPlanForm({ ...planForm, visit_limit: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="12"
                    required={!planForm.is_unlimited}
                    disabled={planForm.is_unlimited}
                    min="1"
                  />
                </div>
              </div>

              <div className="flex items-center gap-4">
                <label className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={planForm.is_unlimited}
                    onChange={(e) => setPlanForm({ ...planForm, is_unlimited: e.target.checked, visit_limit: e.target.checked ? '' : planForm.visit_limit })}
                    className="w-4 h-4 text-primary border-gray-300 rounded"
                  />
                  <span className="text-sm font-medium text-gray-700">
                    Unlimited Visits
                  </span>
                </label>

                <label className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={planForm.is_active}
                    onChange={(e) => setPlanForm({ ...planForm, is_active: e.target.checked })}
                    className="w-4 h-4 text-primary border-gray-300 rounded"
                  />
                  <span className="text-sm font-medium text-gray-700">
                    Active (visible to users)
                  </span>
                </label>
              </div>

              <div className="flex gap-3 pt-4">
                <Button type="submit" className="flex-1">
                  {editingPlan ? 'Update Plan' : 'Create Plan'}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setShowPlanModal(false);
                    setEditingPlan(null);
                    setPlanError('');
                    setPlanSuccess('');
                  }}
                  className="flex-1"
                >
                  Cancel
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Subscriptions;
