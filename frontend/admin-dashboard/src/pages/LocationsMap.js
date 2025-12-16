import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { 
  MapPin, Search, Filter, Navigation, Phone, 
  Building2, Clock, Star, Eye, Edit, Trash2,
  CheckCircle, XCircle, TrendingUp
} from 'lucide-react';

const LocationsMap = () => {
  const [partners, setPartners] = useState([]);
  const [filteredPartners, setFilteredPartners] = useState([]);
  const [selectedPartner, setSelectedPartner] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [filterStatus, setFilterStatus] = useState('all'); // all, active, inactive
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState({
    total: 0,
    active: 0,
    inactive: 0
  });

  useEffect(() => {
    fetchPartners();
  }, []);

  useEffect(() => {
    filterPartners();
  }, [searchQuery, filterStatus, partners]);

  const fetchPartners = async () => {
    try {
      const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';
      const response = await axios.get(`${API_URL}/api/partner/partners`);
      const data = response.data;
      
      setPartners(data);
      
      // Calculate stats
      const active = data.filter(p => p.is_active).length;
      setStats({
        total: data.length,
        active: active,
        inactive: data.length - active
      });
    } catch (error) {
      console.error('Error fetching partners:', error);
    } finally {
      setLoading(false);
    }
  };

  const filterPartners = () => {
    let filtered = [...partners];

    // Search filter
    if (searchQuery) {
      filtered = filtered.filter(p =>
        p.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        (p.address && p.address.toLowerCase().includes(searchQuery.toLowerCase())) ||
        (p.city && p.city.toLowerCase().includes(searchQuery.toLowerCase()))
      );
    }

    // Status filter
    if (filterStatus === 'active') {
      filtered = filtered.filter(p => p.is_active);
    } else if (filterStatus === 'inactive') {
      filtered = filtered.filter(p => !p.is_active);
    }

    setFilteredPartners(filtered);
  };

  const openInGoogleMaps = (partner) => {
    const lat = partner.latitude || 41.2995;
    const lng = partner.longitude || 69.2401;
    window.open(`https://www.google.com/maps?q=${lat},${lng}`, '_blank');
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-yuvgo-cyan border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Загрузка локаций...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-black text-gray-900 mb-2">Карта локаций</h1>
        <p className="text-gray-600">Все автомойки на карте</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-2xl p-6 border border-gray-100">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 rounded-xl bg-blue-50 flex items-center justify-center">
              <Building2 className="text-blue-500" size={24} />
            </div>
            <TrendingUp className="text-blue-500" size={20} />
          </div>
          <p className="text-gray-600 text-sm mb-1">Всего локаций</p>
          <p className="text-3xl font-black text-gray-900">{stats.total}</p>
        </div>

        <div className="bg-white rounded-2xl p-6 border border-gray-100">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 rounded-xl bg-green-50 flex items-center justify-center">
              <CheckCircle className="text-green-500" size={24} />
            </div>
          </div>
          <p className="text-gray-600 text-sm mb-1">Активные</p>
          <p className="text-3xl font-black text-gray-900">{stats.active}</p>
        </div>

        <div className="bg-white rounded-2xl p-6 border border-gray-100">
          <div className="flex items-center justify-between mb-4">
            <div className="w-12 h-12 rounded-xl bg-red-50 flex items-center justify-center">
              <XCircle className="text-red-500" size={24} />
            </div>
          </div>
          <p className="text-gray-600 text-sm mb-1">Неактивные</p>
          <p className="text-3xl font-black text-gray-900">{stats.inactive}</p>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="bg-white rounded-2xl p-6 border border-gray-100">
        <div className="flex flex-col md:flex-row gap-4">
          {/* Search */}
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Поиск по названию, адресу, городу..."
              className="w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none"
            />
          </div>

          {/* Filter Buttons */}
          <div className="flex gap-2">
            <button
              onClick={() => setFilterStatus('all')}
              className={`px-4 py-3 rounded-xl font-semibold transition-all ${
                filterStatus === 'all'
                  ? 'bg-yuvgo-cyan text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              Все ({stats.total})
            </button>
            <button
              onClick={() => setFilterStatus('active')}
              className={`px-4 py-3 rounded-xl font-semibold transition-all ${
                filterStatus === 'active'
                  ? 'bg-green-500 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              Активные ({stats.active})
            </button>
            <button
              onClick={() => setFilterStatus('inactive')}
              className={`px-4 py-3 rounded-xl font-semibold transition-all ${
                filterStatus === 'inactive'
                  ? 'bg-red-500 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              Неактивные ({stats.inactive})
            </button>
          </div>
        </div>
      </div>

      {/* Locations Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
        {filteredPartners.length === 0 ? (
          <div className="col-span-full bg-white rounded-2xl p-12 text-center border border-gray-100">
            <MapPin className="mx-auto text-gray-300 mb-4" size={64} />
            <p className="text-gray-600 text-lg">Локации не найдены</p>
            <p className="text-gray-400 text-sm mt-2">Попробуйте изменить фильтры</p>
          </div>
        ) : (
          filteredPartners.map((partner) => (
            <div
              key={partner.id}
              className="bg-white rounded-2xl p-6 border border-gray-100 hover:border-yuvgo-cyan transition-all cursor-pointer"
              onClick={() => setSelectedPartner(partner)}
            >
              {/* Header */}
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center">
                    <Building2 className="text-white" size={24} />
                  </div>
                  <div>
                    <h3 className="font-bold text-gray-900">{partner.name}</h3>
                    <p className="text-sm text-gray-500">{partner.city || 'Ташкент'}</p>
                  </div>
                </div>
                <div className={`px-3 py-1 rounded-full text-xs font-semibold ${
                  partner.is_active
                    ? 'bg-green-50 text-green-600'
                    : 'bg-red-50 text-red-600'
                }`}>
                  {partner.is_active ? 'Активно' : 'Неактивно'}
                </div>
              </div>

              {/* Info */}
              <div className="space-y-3 mb-4">
                <div className="flex items-start gap-2 text-sm">
                  <MapPin className="text-gray-400 flex-shrink-0 mt-0.5" size={16} />
                  <span className="text-gray-600">
                    {partner.address || 'Адрес не указан'}
                  </span>
                </div>
                {partner.phone && (
                  <div className="flex items-center gap-2 text-sm">
                    <Phone className="text-gray-400" size={16} />
                    <span className="text-gray-600">{partner.phone}</span>
                  </div>
                )}
                <div className="flex items-center gap-2 text-sm">
                  <Navigation className="text-gray-400" size={16} />
                  <span className="text-gray-600">
                    {partner.latitude?.toFixed(4) || '41.2995'}, {partner.longitude?.toFixed(4) || '69.2401'}
                  </span>
                </div>
              </div>

              {/* Actions */}
              <div className="flex gap-2">
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    openInGoogleMaps(partner);
                  }}
                  className="flex-1 bg-yuvgo-cyan text-white py-2 px-4 rounded-xl text-sm font-semibold hover:bg-yuvgo-dark transition-all flex items-center justify-center gap-2"
                >
                  <Navigation size={16} />
                  Карта
                </button>
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    setSelectedPartner(partner);
                  }}
                  className="bg-gray-100 text-gray-700 py-2 px-4 rounded-xl text-sm font-semibold hover:bg-gray-200 transition-all"
                >
                  <Eye size={16} />
                </button>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Detail Modal */}
      {selectedPartner && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-center justify-between rounded-t-3xl">
              <h2 className="text-2xl font-bold text-gray-900">Детали локации</h2>
              <button
                onClick={() => setSelectedPartner(null)}
                className="w-10 h-10 rounded-full bg-gray-100 hover:bg-gray-200 flex items-center justify-center transition-all"
              >
                ×
              </button>
            </div>

            <div className="p-6 space-y-6">
              {/* Header */}
              <div className="flex items-start gap-4">
                <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center">
                  <Building2 className="text-white" size={32} />
                </div>
                <div className="flex-1">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{selectedPartner.name}</h3>
                  <div className={`inline-flex px-3 py-1 rounded-full text-sm font-semibold ${
                    selectedPartner.is_active
                      ? 'bg-green-50 text-green-600'
                      : 'bg-red-50 text-red-600'
                  }`}>
                    {selectedPartner.is_active ? 'Активно' : 'Неактивно'}
                  </div>
                </div>
              </div>

              {/* Info Cards */}
              <div className="space-y-3">
                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-start gap-3">
                    <MapPin className="text-gray-600 mt-0.5" size={20} />
                    <div>
                      <p className="font-semibold text-gray-900 mb-1">Адрес</p>
                      <p className="text-gray-600">{selectedPartner.address || 'Не указан'}</p>
                      <p className="text-gray-500 text-sm mt-1">{selectedPartner.city || 'Ташкент'}</p>
                    </div>
                  </div>
                </div>

                {selectedPartner.phone && (
                  <div className="bg-gray-50 rounded-2xl p-4">
                    <div className="flex items-start gap-3">
                      <Phone className="text-gray-600 mt-0.5" size={20} />
                      <div>
                        <p className="font-semibold text-gray-900 mb-1">Телефон</p>
                        <p className="text-gray-600">{selectedPartner.phone}</p>
                      </div>
                    </div>
                  </div>
                )}

                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-start gap-3">
                    <Navigation className="text-gray-600 mt-0.5" size={20} />
                    <div>
                      <p className="font-semibold text-gray-900 mb-1">Координаты</p>
                      <p className="text-gray-600">
                        Широта: {selectedPartner.latitude?.toFixed(6) || '41.299500'}
                      </p>
                      <p className="text-gray-600">
                        Долгота: {selectedPartner.longitude?.toFixed(6) || '69.240100'}
                      </p>
                    </div>
                  </div>
                </div>

                {selectedPartner.description && (
                  <div className="bg-gray-50 rounded-2xl p-4">
                    <p className="font-semibold text-gray-900 mb-1">Описание</p>
                    <p className="text-gray-600">{selectedPartner.description}</p>
                  </div>
                )}
              </div>

              {/* Actions */}
              <div className="flex gap-3">
                <button
                  onClick={() => openInGoogleMaps(selectedPartner)}
                  className="flex-1 bg-yuvgo-cyan text-white py-4 rounded-2xl font-bold hover:bg-yuvgo-dark transition-all flex items-center justify-center gap-2"
                >
                  <Navigation size={20} />
                  Открыть в Google Maps
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default LocationsMap;
