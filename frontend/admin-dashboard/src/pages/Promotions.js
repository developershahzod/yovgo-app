import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import {
  Gift,
  Plus,
  Edit,
  Trash2,
  Eye,
  Calendar,
  Percent,
  Tag,
  Users,
  TrendingUp,
  CheckCircle,
  XCircle,
  Clock,
  Copy
} from 'lucide-react';

const Promotions = () => {
  const { API_URL } = useAuth();
  const [promotions, setPromotions] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [editingPromotion, setEditingPromotion] = useState(null);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [formData, setFormData] = useState({
    code: '',
    description: '',
    discount_type: 'percentage',
    discount_value: '',
    max_uses: '',
    valid_from: '',
    valid_until: '',
    is_active: true
  });

  useEffect(() => {
    fetchPromotions();
  }, []);

  const fetchPromotions = async () => {
    try {
      setLoading(true);
      
      // Mock data - replace with actual API call
      const mockPromotions = [
        {
          id: '1',
          code: 'SUMMER2024',
          description: 'Summer special discount',
          discount_type: 'percentage',
          discount_value: 20,
          max_uses: 100,
          used_count: 45,
          valid_from: '2024-06-01',
          valid_until: '2024-08-31',
          is_active: true,
          created_at: '2024-05-15'
        },
        {
          id: '2',
          code: 'NEWUSER50',
          description: 'New user welcome discount',
          discount_type: 'fixed',
          discount_value: 50000,
          max_uses: 500,
          used_count: 234,
          valid_from: '2024-01-01',
          valid_until: '2024-12-31',
          is_active: true,
          created_at: '2024-01-01'
        },
        {
          id: '3',
          code: 'PREMIUM15',
          description: '15% off premium plans',
          discount_type: 'percentage',
          discount_value: 15,
          max_uses: 200,
          used_count: 189,
          valid_from: '2024-11-01',
          valid_until: '2024-12-31',
          is_active: true,
          created_at: '2024-10-25'
        },
        {
          id: '4',
          code: 'EXPIRED10',
          description: 'Expired promotion',
          discount_type: 'percentage',
          discount_value: 10,
          max_uses: 50,
          used_count: 50,
          valid_from: '2024-01-01',
          valid_until: '2024-06-30',
          is_active: false,
          created_at: '2024-01-01'
        }
      ];

      setPromotions(mockPromotions);
    } catch (error) {
      console.error('Error fetching promotions:', error);
      setError('Failed to load promotions');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    try {
      if (editingPromotion) {
        // Update existing promotion
        await axios.put(`${API_URL}/api/admin/promotions/${editingPromotion.id}`, formData);
        setSuccess('Promotion updated successfully!');
      } else {
        // Create new promotion
        await axios.post(`${API_URL}/api/admin/promotions`, formData);
        setSuccess('Promotion created successfully!');
      }

      setTimeout(() => {
        setShowModal(false);
        setSuccess('');
        setEditingPromotion(null);
        resetForm();
        fetchPromotions();
      }, 1500);
    } catch (error) {
      console.error('Error saving promotion:', error);
      const errorMessage = error.response?.data?.detail || 'Failed to save promotion';
      setError(errorMessage);
    }
  };

  const handleEdit = (promotion) => {
    setEditingPromotion(promotion);
    setFormData({
      code: promotion.code,
      description: promotion.description,
      discount_type: promotion.discount_type,
      discount_value: promotion.discount_value,
      max_uses: promotion.max_uses,
      valid_from: promotion.valid_from,
      valid_until: promotion.valid_until,
      is_active: promotion.is_active
    });
    setShowModal(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this promotion?')) return;

    try {
      await axios.delete(`${API_URL}/api/admin/promotions/${id}`);
      setSuccess('Promotion deleted successfully!');
      fetchPromotions();
      setTimeout(() => setSuccess(''), 3000);
    } catch (error) {
      console.error('Error deleting promotion:', error);
      setError('Failed to delete promotion');
      setTimeout(() => setError(''), 3000);
    }
  };

  const resetForm = () => {
    setFormData({
      code: '',
      description: '',
      discount_type: 'percentage',
      discount_value: '',
      max_uses: '',
      valid_from: '',
      valid_until: '',
      is_active: true
    });
  };

  const copyCode = (code) => {
    navigator.clipboard.writeText(code);
    setSuccess(`Code "${code}" copied to clipboard!`);
    setTimeout(() => setSuccess(''), 2000);
  };

  const getStatusBadge = (promotion) => {
    const now = new Date();
    const validUntil = new Date(promotion.valid_until);
    const isExpired = validUntil < now;
    const isMaxedOut = promotion.used_count >= promotion.max_uses;

    if (!promotion.is_active || isExpired || isMaxedOut) {
      return { text: 'Inactive', class: 'bg-red-100 text-red-800', icon: <XCircle className="h-3 w-3" /> };
    }
    return { text: 'Active', class: 'bg-green-100 text-green-800', icon: <CheckCircle className="h-3 w-3" /> };
  };

  const stats = {
    total: promotions.length,
    active: promotions.filter(p => p.is_active).length,
    totalUses: promotions.reduce((sum, p) => sum + p.used_count, 0),
    totalSavings: promotions.reduce((sum, p) => {
      if (p.discount_type === 'fixed') {
        return sum + (p.discount_value * p.used_count);
      }
      return sum;
    }, 0)
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
          <p className="mt-4 text-gray-600">Loading promotions...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Promotions</h1>
          <p className="text-gray-600 mt-1">Manage discount codes and promotional campaigns</p>
        </div>
        <Button
          onClick={() => {
            setEditingPromotion(null);
            resetForm();
            setShowModal(true);
          }}
          className="gap-2"
        >
          <Plus className="h-4 w-4" />
          Create Promotion
        </Button>
      </div>

      {/* Success/Error Messages */}
      {success && (
        <div className="p-3 bg-green-50 border border-green-200 rounded-lg">
          <p className="text-sm text-green-600">{success}</p>
        </div>
      )}
      {error && (
        <div className="p-3 bg-red-50 border border-red-200 rounded-lg">
          <p className="text-sm text-red-600">{error}</p>
        </div>
      )}

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Promotions</CardTitle>
            <Gift className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
            <p className="text-xs text-muted-foreground">All time promotions</p>
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
            <CardTitle className="text-sm font-medium">Total Uses</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalUses}</div>
            <p className="text-xs text-muted-foreground">Redemptions</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Savings</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.totalSavings.toLocaleString()} UZS</div>
            <p className="text-xs text-muted-foreground">Customer savings</p>
          </CardContent>
        </Card>
      </div>

      {/* Promotions List */}
      <Card>
        <CardHeader>
          <CardTitle>All Promotions</CardTitle>
          <CardDescription>Manage your promotional codes and discounts</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {promotions.map((promotion) => {
              const status = getStatusBadge(promotion);
              const usagePercent = (promotion.used_count / promotion.max_uses) * 100;

              return (
                <div key={promotion.id} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-center gap-3 mb-2">
                        <div className="flex items-center gap-2">
                          <Tag className="h-5 w-5 text-primary" />
                          <span className="text-lg font-bold font-mono">{promotion.code}</span>
                        </div>
                        <button
                          onClick={() => copyCode(promotion.code)}
                          className="p-1 hover:bg-gray-100 rounded"
                          title="Copy code"
                        >
                          <Copy className="h-4 w-4 text-gray-400" />
                        </button>
                        <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${status.class}`}>
                          {status.icon}
                          {status.text}
                        </span>
                      </div>

                      <p className="text-gray-600 mb-3">{promotion.description}</p>

                      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
                        <div>
                          <div className="flex items-center gap-1 text-gray-500 mb-1">
                            <Percent className="h-3 w-3" />
                            <span>Discount</span>
                          </div>
                          <div className="font-medium">
                            {promotion.discount_type === 'percentage'
                              ? `${promotion.discount_value}%`
                              : `${promotion.discount_value.toLocaleString()} UZS`}
                          </div>
                        </div>

                        <div>
                          <div className="flex items-center gap-1 text-gray-500 mb-1">
                            <Users className="h-3 w-3" />
                            <span>Usage</span>
                          </div>
                          <div className="font-medium">
                            {promotion.used_count} / {promotion.max_uses}
                          </div>
                          <div className="w-full bg-gray-200 rounded-full h-1.5 mt-1">
                            <div
                              className="bg-primary h-1.5 rounded-full"
                              style={{ width: `${Math.min(usagePercent, 100)}%` }}
                            ></div>
                          </div>
                        </div>

                        <div>
                          <div className="flex items-center gap-1 text-gray-500 mb-1">
                            <Calendar className="h-3 w-3" />
                            <span>Valid From</span>
                          </div>
                          <div className="font-medium">
                            {new Date(promotion.valid_from).toLocaleDateString()}
                          </div>
                        </div>

                        <div>
                          <div className="flex items-center gap-1 text-gray-500 mb-1">
                            <Clock className="h-3 w-3" />
                            <span>Valid Until</span>
                          </div>
                          <div className="font-medium">
                            {new Date(promotion.valid_until).toLocaleDateString()}
                          </div>
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-2 ml-4">
                      <Button variant="ghost" size="sm" onClick={() => handleEdit(promotion)}>
                        <Edit className="h-4 w-4" />
                      </Button>
                      <Button variant="ghost" size="sm" onClick={() => handleDelete(promotion.id)}>
                        <Trash2 className="h-4 w-4 text-red-600" />
                      </Button>
                    </div>
                  </div>
                </div>
              );
            })}

            {promotions.length === 0 && (
              <div className="text-center py-12">
                <Gift className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">No promotions yet</p>
                <p className="text-sm text-gray-500 mt-1">Create your first promotion to get started</p>
              </div>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Create/Edit Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">
              {editingPromotion ? 'Edit Promotion' : 'Create New Promotion'}
            </h2>

            {error && (
              <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg">
                <p className="text-sm text-red-600">{error}</p>
              </div>
            )}

            {success && (
              <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg">
                <p className="text-sm text-green-600">{success}</p>
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Promotion Code *
                  </label>
                  <input
                    type="text"
                    value={formData.code}
                    onChange={(e) => setFormData({ ...formData, code: e.target.value.toUpperCase() })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg font-mono"
                    placeholder="SUMMER2024"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Discount Type *
                  </label>
                  <select
                    value={formData.discount_type}
                    onChange={(e) => setFormData({ ...formData, discount_type: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                    <option value="percentage">Percentage (%)</option>
                    <option value="fixed">Fixed Amount (UZS)</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Description *
                </label>
                <textarea
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  rows="2"
                  placeholder="Summer special discount for all users"
                  required
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Discount Value *
                  </label>
                  <input
                    type="number"
                    value={formData.discount_value}
                    onChange={(e) => setFormData({ ...formData, discount_value: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder={formData.discount_type === 'percentage' ? '20' : '50000'}
                    required
                    min="0"
                    max={formData.discount_type === 'percentage' ? '100' : undefined}
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Max Uses *
                  </label>
                  <input
                    type="number"
                    value={formData.max_uses}
                    onChange={(e) => setFormData({ ...formData, max_uses: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="100"
                    required
                    min="1"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Valid From *
                  </label>
                  <input
                    type="date"
                    value={formData.valid_from}
                    onChange={(e) => setFormData({ ...formData, valid_from: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Valid Until *
                  </label>
                  <input
                    type="date"
                    value={formData.valid_until}
                    onChange={(e) => setFormData({ ...formData, valid_until: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    required
                  />
                </div>
              </div>

              <div className="flex items-center gap-2">
                <input
                  type="checkbox"
                  id="is_active"
                  checked={formData.is_active}
                  onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                  className="w-4 h-4 text-primary border-gray-300 rounded"
                />
                <label htmlFor="is_active" className="text-sm font-medium text-gray-700">
                  Active (users can use this promotion)
                </label>
              </div>

              <div className="flex gap-3 pt-4">
                <Button type="submit" className="flex-1">
                  {editingPromotion ? 'Update Promotion' : 'Create Promotion'}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setShowModal(false);
                    setEditingPromotion(null);
                    resetForm();
                    setError('');
                    setSuccess('');
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

export default Promotions;
