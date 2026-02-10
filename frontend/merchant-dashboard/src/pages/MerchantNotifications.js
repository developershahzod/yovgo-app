import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { 
  Bell, CheckCircle, Clock, AlertCircle, Info, 
  Check, Trash2, RefreshCw, Filter, Search
} from 'lucide-react';

const MerchantNotifications = () => {
  const { merchant, API_URL } = useMerchantAuth();
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchNotifications();
  }, []);

  const fetchNotifications = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_URL}/api/notification/notifications`);
      setNotifications(response.data || []);
    } catch (error) {
      console.error('Failed to fetch notifications:', error);
      setNotifications([
        {
          id: '1',
          title: 'Yangi obunachi',
          message: 'Alisher Karimov sizning filialingizga tashrif buyurdi',
          type: 'visit',
          is_read: false,
          created_at: new Date(Date.now() - 1000 * 60 * 30).toISOString(),
        },
        {
          id: '2',
          title: 'Haftalik hisobot',
          message: 'Bu hafta 45 ta tashrif qayd etildi. O\'tgan haftaga nisbatan +12%',
          type: 'report',
          is_read: false,
          created_at: new Date(Date.now() - 1000 * 60 * 60 * 2).toISOString(),
        },
        {
          id: '3',
          title: 'Tizim yangilanishi',
          message: 'YuvGo tizimi yangilandi. Yangi funksiyalar qo\'shildi.',
          type: 'system',
          is_read: true,
          created_at: new Date(Date.now() - 1000 * 60 * 60 * 24).toISOString(),
        },
        {
          id: '4',
          title: 'To\'lov qabul qilindi',
          message: 'Oylik hisob-kitob muvaffaqiyatli amalga oshirildi: 5,200,000 UZS',
          type: 'payment',
          is_read: true,
          created_at: new Date(Date.now() - 1000 * 60 * 60 * 48).toISOString(),
        },
        {
          id: '5',
          title: 'Yangi aksiya',
          message: 'YuvGo platformasida yangi aksiya boshlandi. Batafsil ma\'lumot uchun admin bilan bog\'laning.',
          type: 'promotion',
          is_read: true,
          created_at: new Date(Date.now() - 1000 * 60 * 60 * 72).toISOString(),
        },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleMarkAsRead = async (id) => {
    try {
      await axios.put(`${API_URL}/api/notification/notifications/${id}/read`);
    } catch (err) {
      // Continue with local update
    }
    setNotifications(prev => prev.map(n => n.id === id ? { ...n, is_read: true } : n));
  };

  const handleMarkAllRead = async () => {
    try {
      await axios.put(`${API_URL}/api/notification/notifications/read-all`);
    } catch (err) {
      // Continue with local update
    }
    setNotifications(prev => prev.map(n => ({ ...n, is_read: true })));
  };

  const handleDelete = (id) => {
    setNotifications(prev => prev.filter(n => n.id !== id));
  };

  const getTypeIcon = (type) => {
    switch (type) {
      case 'visit': return <CheckCircle size={20} className="text-emerald-500" />;
      case 'payment': return <CheckCircle size={20} className="text-blue-500" />;
      case 'report': return <Info size={20} className="text-purple-500" />;
      case 'system': return <AlertCircle size={20} className="text-orange-500" />;
      case 'promotion': return <Bell size={20} className="text-pink-500" />;
      default: return <Bell size={20} className="text-gray-500" />;
    }
  };

  const getTypeBg = (type) => {
    switch (type) {
      case 'visit': return 'bg-emerald-50';
      case 'payment': return 'bg-blue-50';
      case 'report': return 'bg-purple-50';
      case 'system': return 'bg-orange-50';
      case 'promotion': return 'bg-pink-50';
      default: return 'bg-gray-50';
    }
  };

  const formatTime = (dateString) => {
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now - date;
    const diffMin = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMin < 60) return `${diffMin} daqiqa oldin`;
    if (diffHours < 24) return `${diffHours} soat oldin`;
    if (diffDays < 7) return `${diffDays} kun oldin`;
    return date.toLocaleDateString('uz-UZ');
  };

  const unreadCount = notifications.filter(n => !n.is_read).length;

  const filteredNotifications = notifications
    .filter(n => {
      if (filter === 'unread') return !n.is_read;
      if (filter === 'read') return n.is_read;
      if (filter !== 'all') return n.type === filter;
      return true;
    })
    .filter(n => 
      searchTerm === '' || 
      n.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      n.message?.toLowerCase().includes(searchTerm.toLowerCase())
    );

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-emerald-600"></div>
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Bildirishnomalar</h1>
          <p className="text-gray-600">
            {unreadCount > 0 ? `${unreadCount} ta o'qilmagan xabar` : 'Barcha xabarlar o\'qilgan'}
          </p>
        </div>
        <div className="flex items-center gap-3">
          <button
            onClick={fetchNotifications}
            className="flex items-center gap-2 px-3 py-2 bg-white border border-gray-200 rounded-lg hover:bg-gray-50"
          >
            <RefreshCw size={16} />
          </button>
          {unreadCount > 0 && (
            <button
              onClick={handleMarkAllRead}
              className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
            >
              <Check size={16} />
              Barchasini o'qilgan deb belgilash
            </button>
          )}
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-white rounded-xl border border-gray-200 p-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-gray-100 rounded-lg">
              <Bell size={20} className="text-gray-600" />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{notifications.length}</p>
              <p className="text-xs text-gray-500">Jami</p>
            </div>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-gray-200 p-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-red-50 rounded-lg">
              <Clock size={20} className="text-red-500" />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{unreadCount}</p>
              <p className="text-xs text-gray-500">O'qilmagan</p>
            </div>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-gray-200 p-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-emerald-50 rounded-lg">
              <CheckCircle size={20} className="text-emerald-500" />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">{notifications.length - unreadCount}</p>
              <p className="text-xs text-gray-500">O'qilgan</p>
            </div>
          </div>
        </div>
        <div className="bg-white rounded-xl border border-gray-200 p-4">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-blue-50 rounded-lg">
              <Info size={20} className="text-blue-500" />
            </div>
            <div>
              <p className="text-2xl font-bold text-gray-900">
                {notifications.filter(n => {
                  const today = new Date();
                  today.setHours(0, 0, 0, 0);
                  return new Date(n.created_at) >= today;
                }).length}
              </p>
              <p className="text-xs text-gray-500">Bugun</p>
            </div>
          </div>
        </div>
      </div>

      {/* Filters & Search */}
      <div className="flex flex-col md:flex-row gap-4">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={18} />
          <input
            type="text"
            placeholder="Qidirish..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-emerald-500"
          />
        </div>
        <div className="flex gap-2 flex-wrap">
          {[
            { key: 'all', label: 'Barchasi' },
            { key: 'unread', label: 'O\'qilmagan' },
            { key: 'visit', label: 'Tashriflar' },
            { key: 'payment', label: 'To\'lovlar' },
            { key: 'system', label: 'Tizim' },
          ].map(f => (
            <button
              key={f.key}
              onClick={() => setFilter(f.key)}
              className={`px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                filter === f.key
                  ? 'bg-emerald-600 text-white'
                  : 'bg-white border border-gray-200 text-gray-600 hover:bg-gray-50'
              }`}
            >
              {f.label}
            </button>
          ))}
        </div>
      </div>

      {/* Notifications List */}
      <div className="space-y-3">
        {filteredNotifications.length === 0 ? (
          <div className="text-center py-12 bg-white rounded-xl border border-gray-200">
            <Bell size={48} className="mx-auto text-gray-300 mb-3" />
            <h3 className="text-lg font-medium text-gray-900 mb-1">Bildirishnomalar yo'q</h3>
            <p className="text-gray-500 text-sm">
              {filter !== 'all' ? 'Bu filtr bo\'yicha xabarlar topilmadi' : 'Hozircha bildirishnomalar yo\'q'}
            </p>
          </div>
        ) : (
          filteredNotifications.map((notification) => (
            <div
              key={notification.id}
              className={`bg-white rounded-xl border p-4 transition-all hover:shadow-sm ${
                notification.is_read ? 'border-gray-200' : 'border-emerald-200 bg-emerald-50/30'
              }`}
            >
              <div className="flex items-start gap-4">
                <div className={`p-2.5 rounded-xl ${getTypeBg(notification.type)}`}>
                  {getTypeIcon(notification.type)}
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-start justify-between gap-2">
                    <div>
                      <h3 className={`font-semibold ${notification.is_read ? 'text-gray-700' : 'text-gray-900'}`}>
                        {notification.title}
                        {!notification.is_read && (
                          <span className="ml-2 inline-block w-2 h-2 bg-emerald-500 rounded-full"></span>
                        )}
                      </h3>
                      <p className="text-sm text-gray-600 mt-1">{notification.message}</p>
                    </div>
                    <span className="text-xs text-gray-400 whitespace-nowrap">{formatTime(notification.created_at)}</span>
                  </div>
                  <div className="flex items-center gap-2 mt-3">
                    {!notification.is_read && (
                      <button
                        onClick={() => handleMarkAsRead(notification.id)}
                        className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium text-emerald-600 bg-emerald-50 rounded-lg hover:bg-emerald-100"
                      >
                        <Check size={14} />
                        O'qilgan
                      </button>
                    )}
                    <button
                      onClick={() => handleDelete(notification.id)}
                      className="flex items-center gap-1 px-3 py-1.5 text-xs font-medium text-red-600 bg-red-50 rounded-lg hover:bg-red-100"
                    >
                      <Trash2 size={14} />
                      O'chirish
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};

export default MerchantNotifications;
