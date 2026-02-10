import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { DollarSign, Calendar, PieChart } from 'lucide-react';

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
      const partnerId = merchant?.partner?.id || merchant?.partner_id;
      const response = await axios.get(
        `${API_URL}/api/partner/merchant/earnings`, { params: { partner_id: partnerId } }
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
      setEarnings({ today: 0, week: 0, month: 0, total: 0 });
      setBreakdown([]);
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
        <h1 className="text-3xl font-bold text-gray-900">Daromad</h1>
        <p className="text-gray-600 mt-1">Daromadingiz va ko'rsatkichlaringizni kuzating</p>
      </div>

      {/* Earnings Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Bugun</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.today)}
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
              <p className="text-sm font-medium text-gray-600">Bu hafta</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.week)}
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
              <p className="text-sm font-medium text-gray-600">Bu oy</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.month)}
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
              <p className="text-sm font-medium text-gray-600">Jami daromad</p>
              <p className="text-2xl font-bold text-gray-900 mt-2">
                {formatCurrency(earnings.total)}
              </p>
              <p className="text-sm text-gray-500 mt-2">Barcha vaqt</p>
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
          <h2 className="text-xl font-bold text-gray-900 mb-4">Haftalik taqsimot</h2>
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
          <h2 className="text-xl font-bold text-gray-900 mb-4">Daromad manbalari</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div>
                <p className="font-medium text-gray-900">Obuna tashriflari</p>
                <p className="text-sm text-gray-600">YuvGO obunachilari</p>
              </div>
              <div className="text-right">
                <p className="text-lg font-bold text-gray-900">100%</p>
                <p className="text-sm text-gray-600">{formatCurrency(earnings.month)}</p>
              </div>
            </div>
          </div>

          <div className="mt-6 pt-6 border-t">
            <h3 className="font-medium text-gray-900 mb-3">To'lov usullari</h3>
            <div className="space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-gray-600">Ipak Yo'li Bank</span>
                <span className="font-medium">100%</span>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>
  );
};

export default Earnings;
