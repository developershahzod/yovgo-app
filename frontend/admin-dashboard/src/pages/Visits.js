import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { 
  Search, Calendar, Car, MapPin, Clock, User, 
  Filter, Download, RefreshCw, CheckCircle, Building2
} from 'lucide-react';

const Visits = () => {
  const { API_URL } = useAuth();
  const [visits, setVisits] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [dateFilter, setDateFilter] = useState('all');
  const [stats, setStats] = useState({
    total: 0,
    today: 0,
    thisWeek: 0,
    thisMonth: 0
  });

  useEffect(() => {
    fetchVisits();
  }, []);

  const fetchVisits = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_URL}/api/visit/visits`);
      const visitsData = response.data || [];
      setVisits(visitsData);

      // Calculate stats
      const now = new Date();
      const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      const weekAgo = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
      const monthAgo = new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);

      setStats({
        total: visitsData.length,
        today: visitsData.filter(v => new Date(v.check_in_time) >= today).length,
        thisWeek: visitsData.filter(v => new Date(v.check_in_time) >= weekAgo).length,
        thisMonth: visitsData.filter(v => new Date(v.check_in_time) >= monthAgo).length
      });
    } catch (error) {
      console.error('Failed to fetch visits:', error);
      // Mock data for demo
      const mockVisits = [
        {
          id: '1',
          user_name: 'Alisher Karimov',
          user_phone: '+998901234567',
          partner_name: 'Crystal Clean',
          location_name: 'Yunusobod filiali',
          check_in_time: new Date().toISOString(),
          status: 'completed',
          vehicle_plate: '01 A 777 AA'
        },
        {
          id: '2',
          user_name: 'Dilshod Rahimov',
          user_phone: '+998901234568',
          partner_name: 'Aqua Shine',
          location_name: 'Chilonzor filiali',
          check_in_time: new Date(Date.now() - 3600000).toISOString(),
          status: 'completed',
          vehicle_plate: '01 B 555 BB'
        }
      ];
      setVisits(mockVisits);
      setStats({ total: 2, today: 2, thisWeek: 2, thisMonth: 2 });
    } finally {
      setLoading(false);
    }
  };

  const filteredVisits = visits.filter(visit => {
    const matchesSearch = 
      visit.user_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      visit.user_phone?.includes(searchTerm) ||
      visit.partner_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      visit.vehicle_plate?.toLowerCase().includes(searchTerm.toLowerCase());

    if (dateFilter === 'all') return matchesSearch;

    const visitDate = new Date(visit.check_in_time);
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    if (dateFilter === 'today') return matchesSearch && visitDate >= today;
    if (dateFilter === 'week') return matchesSearch && visitDate >= new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
    if (dateFilter === 'month') return matchesSearch && visitDate >= new Date(today.getTime() - 30 * 24 * 60 * 60 * 1000);

    return matchesSearch;
  });

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Avtomoyka tashriflari</h1>
          <p className="text-gray-600 mt-1">Barcha foydalanuvchilarning avtomoyka tashriflari</p>
        </div>
        <button
          onClick={fetchVisits}
          className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
        >
          <RefreshCw size={18} />
          Yangilash
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Car className="text-blue-600" size={20} />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{stats.total}</p>
              <p className="text-sm text-gray-500">Jami tashriflar</p>
            </div>
          </div>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-green-100 rounded-lg">
              <Clock className="text-green-600" size={20} />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{stats.today}</p>
              <p className="text-sm text-gray-500">Bugun</p>
            </div>
          </div>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-purple-100 rounded-lg">
              <Calendar className="text-purple-600" size={20} />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{stats.thisWeek}</p>
              <p className="text-sm text-gray-500">Bu hafta</p>
            </div>
          </div>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-orange-100 rounded-lg">
              <Building2 className="text-orange-600" size={20} />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{stats.thisMonth}</p>
              <p className="text-sm text-gray-500">Bu oy</p>
            </div>
          </div>
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow mb-6">
        <div className="p-4 flex flex-wrap gap-4">
          <div className="flex-1 min-w-[200px]">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
              <input
                type="text"
                placeholder="Qidirish (ism, telefon, mashina raqami)..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
              />
            </div>
          </div>
          <div className="flex gap-2">
            {['all', 'today', 'week', 'month'].map((filter) => (
              <button
                key={filter}
                onClick={() => setDateFilter(filter)}
                className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                  dateFilter === filter
                    ? 'bg-emerald-600 text-white'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {filter === 'all' ? 'Barchasi' : filter === 'today' ? 'Bugun' : filter === 'week' ? 'Hafta' : 'Oy'}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Visits Table */}
      <div className="bg-white rounded-lg shadow overflow-hidden">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600"></div>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Foydalanuvchi</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Avtomoyka</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Mashina</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Vaqt</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {filteredVisits.length === 0 ? (
                  <tr>
                    <td colSpan="5" className="px-6 py-12 text-center text-gray-500">
                      Tashriflar topilmadi
                    </td>
                  </tr>
                ) : (
                  filteredVisits.map((visit) => (
                    <tr key={visit.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center">
                            <User className="text-emerald-600" size={18} />
                          </div>
                          <div>
                            <p className="font-medium text-gray-900">{visit.user_name || 'Noma\'lum'}</p>
                            <p className="text-sm text-gray-500">{visit.user_phone}</p>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div>
                          <p className="font-medium text-gray-900">{visit.partner_name}</p>
                          <p className="text-sm text-gray-500 flex items-center gap-1">
                            <MapPin size={12} />
                            {visit.location_name}
                          </p>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <Car size={16} className="text-gray-400" />
                          <span className="font-mono text-sm">{visit.vehicle_plate || '-'}</span>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500">
                        {new Date(visit.check_in_time).toLocaleString('uz-UZ')}
                      </td>
                      <td className="px-6 py-4">
                        <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${
                          visit.status === 'completed' 
                            ? 'bg-green-100 text-green-700' 
                            : 'bg-yellow-100 text-yellow-700'
                        }`}>
                          <CheckCircle size={12} />
                          {visit.status === 'completed' ? 'Bajarildi' : 'Kutilmoqda'}
                        </span>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default Visits;
