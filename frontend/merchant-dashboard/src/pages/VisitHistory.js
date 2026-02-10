import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { Calendar, User, Download, Filter, RefreshCw } from 'lucide-react';

const VisitHistory = () => {
  const { merchant, API_URL } = useMerchantAuth();
  const [visits, setVisits] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dateFilter, setDateFilter] = useState('all');

  useEffect(() => {
    fetchVisits();
  }, [dateFilter]);

  const fetchVisits = async () => {
    try {
      setLoading(true);
      
      const partnerId = merchant?.partner?.id;
      
      if (!partnerId) {
        console.error('No partner ID found');
        setVisits([]);
        setLoading(false);
        return;
      }
      
      // Загружаем визиты с backend
      const response = await axios.get(`${API_URL}/api/visit/visits`, { params: { partner_id: partnerId } });
      
      let filteredVisits = response.data || [];
      
      // Apply date filter
      if (dateFilter !== 'all' && filteredVisits.length > 0) {
        const filterDate = new Date();
        
        if (dateFilter === 'today') {
          filterDate.setHours(0, 0, 0, 0);
          filteredVisits = filteredVisits.filter(v => new Date(v.check_in_time) >= filterDate);
        } else if (dateFilter === 'week') {
          filterDate.setDate(filterDate.getDate() - 7);
          filteredVisits = filteredVisits.filter(v => new Date(v.check_in_time) >= filterDate);
        } else if (dateFilter === 'month') {
          filterDate.setMonth(filterDate.getMonth() - 1);
          filteredVisits = filteredVisits.filter(v => new Date(v.check_in_time) >= filterDate);
        }
      }
      
      setVisits(filteredVisits);
    } catch (error) {
      console.error('Failed to fetch visits:', error);
      setVisits([]);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleString('ru-RU', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">История визитов</h1>
        <p className="text-gray-600">Все визиты в вашем филиале</p>
      </div>

      {/* Filters */}
      <div className="flex items-center gap-4 mb-6">
        <div className="flex items-center gap-2">
          <Filter size={20} className="text-gray-500" />
          <select
            value={dateFilter}
            onChange={(e) => setDateFilter(e.target.value)}
            className="px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="all">Все время</option>
            <option value="today">Сегодня</option>
            <option value="week">Неделя</option>
            <option value="month">Месяц</option>
          </select>
        </div>
        
        <button
          onClick={fetchVisits}
          className="flex items-center gap-2 px-4 py-2 bg-blue-50 text-blue-600 rounded-lg hover:bg-blue-100 transition-colors"
        >
          <RefreshCw size={18} />
          <span>Обновить</span>
        </button>
      </div>

      {/* Visits List */}
      {loading ? (
        <div className="flex items-center justify-center py-12">
          <div className="w-12 h-12 border-4 border-gray-200 border-t-blue-500 rounded-full animate-spin"></div>
        </div>
      ) : visits.length === 0 ? (
        <div className="text-center py-12 bg-white rounded-lg border border-gray-200">
          <Calendar size={48} className="mx-auto text-gray-400 mb-4" />
          <h3 className="text-lg font-semibold text-gray-900 mb-2">Нет визитов</h3>
          <p className="text-gray-500">Визиты появятся после сканирования QR кодов</p>
        </div>
      ) : (
        <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase">Клиент</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase">Дата и время</th>
                <th className="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase">Статус</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {visits.map((visit) => (
                <tr key={visit.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                        <User size={20} className="text-blue-600" />
                      </div>
                      <div>
                        <p className="font-medium text-gray-900">{visit.user_name || 'Клиент'}</p>
                        <p className="text-sm text-gray-500">{visit.user_phone || 'N/A'}</p>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-2 text-gray-600">
                      <Calendar size={16} />
                      <span>{formatDate(visit.check_in_time)}</span>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800">
                      {visit.status === 'completed' ? 'Завершен' : visit.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Stats */}
      {!loading && visits.length > 0 && (
        <div className="mt-6 grid grid-cols-3 gap-4">
          <div className="bg-white p-4 rounded-lg border border-gray-200">
            <p className="text-sm text-gray-500 mb-1">Всего визитов</p>
            <p className="text-2xl font-bold text-gray-900">{visits.length}</p>
          </div>
          <div className="bg-white p-4 rounded-lg border border-gray-200">
            <p className="text-sm text-gray-500 mb-1">Сегодня</p>
            <p className="text-2xl font-bold text-gray-900">
              {visits.filter(v => {
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                return new Date(v.check_in_time) >= today;
              }).length}
            </p>
          </div>
          <div className="bg-white p-4 rounded-lg border border-gray-200">
            <p className="text-sm text-gray-500 mb-1">Эта неделя</p>
            <p className="text-2xl font-bold text-gray-900">
              {visits.filter(v => {
                const weekAgo = new Date();
                weekAgo.setDate(weekAgo.getDate() - 7);
                return new Date(v.check_in_time) >= weekAgo;
              }).length}
            </p>
          </div>
        </div>
      )}
    </div>
  );
};

export default VisitHistory;
