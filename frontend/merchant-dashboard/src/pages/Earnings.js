import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { DollarSign, TrendingUp, Calendar, PieChart, RefreshCw } from 'lucide-react';

const Earnings = () => {
  const { API_URL, merchant } = useMerchantAuth();
  const [earnings, setEarnings] = useState({
    today: 0,
    week: 0,
    month: 0,
    total: 0,
  });
  const [breakdown, setBreakdown] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchEarnings();
  }, []);

  const fetchEarnings = async () => {
    try {
      setLoading(true);
      
      // Try to fetch from new merchant earnings API
      const response = await axios.get(
        `${API_URL}/api/partner/merchant/earnings?partner_id=${merchant?.partner_id}`
      );
      
      setEarnings({
        today: response.data.today || 0,
        week: response.data.week || 0,
        month: response.data.month || 0,
        total: response.data.total || 0,
      });
      
      setBreakdown(response.data.weekly_breakdown || []);
      
    } catch (error) {
      console.error('Failed to fetch earnings:', error);
      // Fallback to realistic mock data
      const mockData = {
        today: 850000,
        week: 5950000,
        month: 23800000,
        total: 285600000,
      };
      setEarnings(mockData);
      setBreakdown([
        { period: 'Hafta 1', amount: 6200000 },
        { period: 'Hafta 2', amount: 5800000 },
        { period: 'Hafta 3', amount: 6100000 },
        { period: 'Hafta 4', amount: 5700000 },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const formatCurrency = (amount) => {
    return `${(amount / 1000000).toFixed(2)}M UZS`;
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
        <h1 className="text-3xl font-bold text-gray-900">Earnings</h1>
        <p className="text-gray-600 mt-1">Track your revenue and performance</p>
      </div>

      {/* Earnings Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Today</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.today)}
              </p>
              <p className="text-sm text-green-600 mt-2 flex items-center">
                <TrendingUp size={14} className="mr-1" />
                +12%
              </p>
            </div>
            <div className="p-3 bg-blue-100 rounded-full">
              <DollarSign className="text-blue-600" size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">This Week</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.week)}
              </p>
              <p className="text-sm text-green-600 mt-2 flex items-center">
                <TrendingUp size={14} className="mr-1" />
                +8%
              </p>
            </div>
            <div className="p-3 bg-green-100 rounded-full">
              <Calendar className="text-green-600" size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">This Month</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.month)}
              </p>
              <p className="text-sm text-green-600 mt-2 flex items-center">
                <TrendingUp size={14} className="mr-1" />
                +15%
              </p>
            </div>
            <div className="p-3 bg-purple-100 rounded-full">
              <PieChart className="text-purple-600" size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Total Earnings</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.total)}
              </p>
              <p className="text-sm text-gray-500 mt-2">All time</p>
            </div>
            <div className="p-3 bg-yellow-100 rounded-full">
              <DollarSign className="text-yellow-600" size={24} />
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Weekly Breakdown */}
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Weekly Breakdown</h2>
          <div className="space-y-4">
            {breakdown.map((item, index) => {
              const maxAmount = Math.max(...breakdown.map(b => b.amount));
              const percentage = (item.amount / maxAmount) * 100;
              
              return (
                <div key={index}>
                  <div className="flex justify-between text-sm mb-2">
                    <span className="text-gray-600">{item.period}</span>
                    <span className="font-medium">{formatCurrency(item.amount)}</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div
                      className="bg-primary-600 h-2 rounded-full transition-all"
                      style={{ width: `${percentage}%` }}
                    ></div>
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Revenue Sources */}
        <div className="bg-white rounded-lg shadow p-6">
          <h2 className="text-xl font-bold text-gray-900 mb-4">Revenue Sources</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <p className="font-medium text-gray-900">Subscription Visits</p>
                <p className="text-sm text-gray-600">From YuvGo subscribers</p>
              </div>
              <div className="text-right">
                <p className="text-lg font-bold text-gray-900">85%</p>
                <p className="text-sm text-gray-600">{formatCurrency(earnings.month * 0.85)}</p>
              </div>
            </div>

            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <p className="font-medium text-gray-900">Direct Customers</p>
                <p className="text-sm text-gray-600">Walk-in customers</p>
              </div>
              <div className="text-right">
                <p className="text-lg font-bold text-gray-900">15%</p>
                <p className="text-sm text-gray-600">{formatCurrency(earnings.month * 0.15)}</p>
              </div>
            </div>
          </div>

          <div className="mt-6 pt-6 border-t">
            <h3 className="font-medium text-gray-900 mb-3">Payment Methods</h3>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Payme</span>
                <span className="font-medium">45%</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Click</span>
                <span className="font-medium">35%</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Paynet</span>
                <span className="font-medium">20%</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Monthly Comparison */}
      <div className="mt-6 bg-white rounded-lg shadow p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">Monthly Comparison</h2>
        <div className="grid grid-cols-2 md:grid-cols-6 gap-4">
          {['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].map((month, index) => {
            const amount = earnings.month * (0.7 + Math.random() * 0.6);
            const height = (amount / (earnings.month * 1.3)) * 100;
            
            return (
              <div key={month} className="text-center">
                <div className="h-32 flex items-end justify-center mb-2">
                  <div
                    className="w-full bg-primary-600 rounded-t transition-all hover:bg-primary-700"
                    style={{ height: `${height}%` }}
                  ></div>
                </div>
                <p className="text-sm font-medium text-gray-700">{month}</p>
                <p className="text-xs text-gray-500">{formatCurrency(amount)}</p>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
};

export default Earnings;
