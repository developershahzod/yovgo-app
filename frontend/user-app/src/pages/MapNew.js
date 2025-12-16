import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { 
  MapPin, Phone, Clock, Navigation, Search, Filter,
  Star, ChevronRight, Sparkles, AlertCircle, X
} from 'lucide-react';
import BottomNav from '../components/BottomNav';

const MapNew = () => {
  const { API_URL } = useAuth();
  const [locations, setLocations] = useState([]);
  const [filteredLocations, setFilteredLocations] = useState([]);
  const [selectedLocation, setSelectedLocation] = useState(null);
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [showFilters, setShowFilters] = useState(false);
  const [filterType, setFilterType] = useState('all'); // all, nearby, open

  useEffect(() => {
    fetchLocations();
  }, []);

  useEffect(() => {
    filterLocations();
  }, [searchQuery, filterType, locations]);

  const fetchLocations = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/partner/partners`);
      const partners = response.data;
      
      // Create locations from partners
      const locs = partners
        .filter(p => p.is_active)
        .map((partner, index) => ({
          id: partner.id,
          name: partner.name,
          address: partner.address || 'Ташкент, Узбекистан',
          city: partner.city || 'Ташкент',
          latitude: partner.latitude || (41.2995 + (Math.random() - 0.5) * 0.1),
          longitude: partner.longitude || (69.2401 + (Math.random() - 0.5) * 0.1),
          phone: partner.phone || '+998 90 123 45 67',
          rating: 4.5 + Math.random() * 0.5,
          distance: (Math.random() * 10).toFixed(1),
          isOpen: Math.random() > 0.3,
          services: ['Мойка', 'Детейлинг', 'Полировка'],
          logo: partner.logo_url
        }));
      
      setLocations(locs);
      setFilteredLocations(locs);
    } catch (error) {
      console.error('Error fetching locations:', error);
    } finally {
      setLoading(false);
    }
  };

  const filterLocations = () => {
    let filtered = [...locations];

    // Search filter
    if (searchQuery) {
      filtered = filtered.filter(loc =>
        loc.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        loc.address.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }

    // Type filter
    if (filterType === 'nearby') {
      filtered = filtered.sort((a, b) => parseFloat(a.distance) - parseFloat(b.distance));
    } else if (filterType === 'open') {
      filtered = filtered.filter(loc => loc.isOpen);
    }

    setFilteredLocations(filtered);
  };

  const openInMaps = (location) => {
    const url = `https://www.google.com/maps/dir/?api=1&destination=${location.latitude},${location.longitude}`;
    window.open(url, '_blank');
  };

  const callLocation = (phone) => {
    window.location.href = `tel:${phone}`;
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-yuvgo-cyan border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Загрузка автомоек...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-24">
      {/* Header */}
      <div className="bg-white border-b border-gray-100 sticky top-0 z-40">
        <div className="px-6 py-4">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Автомойки</h1>
          
          {/* Search Bar */}
          <div className="relative mb-3">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Поиск автомойки..."
              className="w-full pl-10 pr-4 py-3 border-2 border-gray-200 rounded-2xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none"
            />
          </div>

          {/* Filter Chips */}
          <div className="flex gap-2 overflow-x-auto pb-2">
            <button
              onClick={() => setFilterType('all')}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all ${
                filterType === 'all'
                  ? 'bg-yuvgo-cyan text-white'
                  : 'bg-gray-100 text-gray-700'
              }`}
            >
              Все ({locations.length})
            </button>
            <button
              onClick={() => setFilterType('nearby')}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all ${
                filterType === 'nearby'
                  ? 'bg-yuvgo-cyan text-white'
                  : 'bg-gray-100 text-gray-700'
              }`}
            >
              Рядом
            </button>
            <button
              onClick={() => setFilterType('open')}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-all ${
                filterType === 'open'
                  ? 'bg-yuvgo-cyan text-white'
                  : 'bg-gray-100 text-gray-700'
              }`}
            >
              Открыто сейчас
            </button>
          </div>
        </div>
      </div>

      {/* Locations List */}
      <div className="px-6 py-4 space-y-3">
        {filteredLocations.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 text-center border border-gray-100">
            <AlertCircle className="mx-auto text-gray-300 mb-3" size={48} />
            <p className="text-gray-600">Автомойки не найдены</p>
            <p className="text-gray-400 text-sm mt-1">Попробуйте изменить фильтры</p>
          </div>
        ) : (
          filteredLocations.map((location) => (
            <div
              key={location.id}
              className="bg-white rounded-2xl p-4 border border-gray-100 active:scale-95 transition-all"
            >
              <div className="flex gap-4">
                {/* Logo/Icon */}
                <div className="w-16 h-16 rounded-xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center flex-shrink-0">
                  {location.logo ? (
                    <img src={location.logo} alt={location.name} className="w-full h-full rounded-xl object-cover" />
                  ) : (
                    <Sparkles size={28} className="text-white" />
                  )}
                </div>

                {/* Info */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1">
                      <h3 className="font-bold text-gray-900 truncate">{location.name}</h3>
                      <div className="flex items-center gap-2 mt-1">
                        <div className="flex items-center gap-1">
                          <Star size={14} className="text-yellow-500 fill-yellow-500" />
                          <span className="text-sm font-medium text-gray-700">{location.rating.toFixed(1)}</span>
                        </div>
                        <span className="text-gray-300">•</span>
                        <span className="text-sm text-gray-500">{location.distance} км</span>
                      </div>
                    </div>
                    <div className={`px-2 py-1 rounded-full text-xs font-semibold ${
                      location.isOpen 
                        ? 'bg-green-50 text-green-600' 
                        : 'bg-red-50 text-red-600'
                    }`}>
                      {location.isOpen ? 'Открыто' : 'Закрыто'}
                    </div>
                  </div>

                  <div className="flex items-center gap-1 text-gray-500 text-sm mb-3">
                    <MapPin size={14} />
                    <span className="truncate">{location.address}</span>
                  </div>

                  {/* Services */}
                  <div className="flex gap-2 mb-3 overflow-x-auto">
                    {location.services.map((service, idx) => (
                      <span key={idx} className="px-2 py-1 bg-blue-50 text-blue-600 text-xs rounded-lg whitespace-nowrap">
                        {service}
                      </span>
                    ))}
                  </div>

                  {/* Actions */}
                  <div className="flex gap-2">
                    <button
                      onClick={() => openInMaps(location)}
                      className="flex-1 bg-yuvgo-cyan text-white py-2 px-4 rounded-xl text-sm font-semibold flex items-center justify-center gap-2 active:scale-95 transition-all"
                    >
                      <Navigation size={16} />
                      Маршрут
                    </button>
                    <button
                      onClick={() => callLocation(location.phone)}
                      className="flex-1 bg-gray-100 text-gray-700 py-2 px-4 rounded-xl text-sm font-semibold flex items-center justify-center gap-2 active:scale-95 transition-all"
                    >
                      <Phone size={16} />
                      Позвонить
                    </button>
                    <button
                      onClick={() => setSelectedLocation(location)}
                      className="bg-gray-100 text-gray-700 py-2 px-3 rounded-xl active:scale-95 transition-all"
                    >
                      <ChevronRight size={20} />
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>

      {/* Location Details Modal */}
      {selectedLocation && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-end">
          <div className="bg-white rounded-t-3xl w-full max-h-[80vh] overflow-y-auto animate-slide-up">
            <div className="sticky top-0 bg-white border-b border-gray-100 px-6 py-4 flex items-center justify-between">
              <h2 className="text-xl font-bold text-gray-900">Детали</h2>
              <button
                onClick={() => setSelectedLocation(null)}
                className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center"
              >
                <X size={20} />
              </button>
            </div>

            <div className="p-6 space-y-6">
              {/* Header */}
              <div className="flex gap-4">
                <div className="w-20 h-20 rounded-2xl bg-gradient-to-br from-yuvgo-cyan to-yuvgo-dark flex items-center justify-center">
                  <Sparkles size={32} className="text-white" />
                </div>
                <div className="flex-1">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{selectedLocation.name}</h3>
                  <div className="flex items-center gap-2">
                    <Star size={16} className="text-yellow-500 fill-yellow-500" />
                    <span className="font-semibold">{selectedLocation.rating.toFixed(1)}</span>
                    <span className="text-gray-400">•</span>
                    <span className="text-gray-600">{selectedLocation.distance} км</span>
                  </div>
                </div>
              </div>

              {/* Info Cards */}
              <div className="space-y-3">
                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-start gap-3">
                    <MapPin size={20} className="text-gray-600 mt-0.5" />
                    <div>
                      <p className="font-semibold text-gray-900 mb-1">Адрес</p>
                      <p className="text-gray-600">{selectedLocation.address}</p>
                    </div>
                  </div>
                </div>

                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-start gap-3">
                    <Phone size={20} className="text-gray-600 mt-0.5" />
                    <div>
                      <p className="font-semibold text-gray-900 mb-1">Телефон</p>
                      <p className="text-gray-600">{selectedLocation.phone}</p>
                    </div>
                  </div>
                </div>

                <div className="bg-gray-50 rounded-2xl p-4">
                  <div className="flex items-start gap-3">
                    <Clock size={20} className="text-gray-600 mt-0.5" />
                    <div>
                      <p className="font-semibold text-gray-900 mb-1">Часы работы</p>
                      <p className="text-gray-600">Пн-Пт: 09:00 - 20:00</p>
                      <p className="text-gray-600">Сб-Вс: 10:00 - 18:00</p>
                    </div>
                  </div>
                </div>
              </div>

              {/* Services */}
              <div>
                <h4 className="font-bold text-gray-900 mb-3">Услуги</h4>
                <div className="flex flex-wrap gap-2">
                  {selectedLocation.services.map((service, idx) => (
                    <span key={idx} className="px-4 py-2 bg-blue-50 text-blue-600 rounded-xl font-medium">
                      {service}
                    </span>
                  ))}
                </div>
              </div>

              {/* Actions */}
              <div className="space-y-3">
                <button
                  onClick={() => openInMaps(selectedLocation)}
                  className="w-full bg-yuvgo-cyan text-white py-4 rounded-2xl font-bold flex items-center justify-center gap-2"
                >
                  <Navigation size={20} />
                  Построить маршрут
                </button>
                <button
                  onClick={() => callLocation(selectedLocation.phone)}
                  className="w-full bg-gray-100 text-gray-700 py-4 rounded-2xl font-bold flex items-center justify-center gap-2"
                >
                  <Phone size={20} />
                  Позвонить
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      <BottomNav />
    </div>
  );
};

export default MapNew;
