import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import {
  Bell, Send, Users, Plus, Eye, Trash2, CheckCircle,
  Clock, AlertCircle, Megaphone, Mail, Smartphone,
  Filter, Search, RefreshCw, X, MessageSquare
} from 'lucide-react';

const Notifications = () => {
  const { API_URL } = useAuth();
  const [notifications, setNotifications] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showSendModal, setShowSendModal] = useState(false);
  const [showBroadcastModal, setShowBroadcastModal] = useState(false);
  const [sending, setSending] = useState(false);
  const [success, setSuccess] = useState('');
  const [error, setError] = useState('');
  const [filter, setFilter] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [users, setUsers] = useState([]);

  const [sendForm, setSendForm] = useState({
    user_id: '',
    title: '',
    message: '',
    notification_type: 'general',
    channel: 'push'
  });

  const [broadcastForm, setBroadcastForm] = useState({
    title: '',
    message: '',
    notification_type: 'announcement',
    channel: 'push'
  });

  const notificationTypes = [
    { value: 'general', label: 'Общее' },
    { value: 'subscription_expiry', label: 'Истечение подписки' },
    { value: 'payment', label: 'Оплата' },
    { value: 'promotion', label: 'Акция' },
    { value: 'announcement', label: 'Объявление' },
    { value: 'system', label: 'Системное' },
  ];

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [notifRes, usersRes] = await Promise.allSettled([
        axios.get(`${API_URL}/api/notification/notifications`, { params: { limit: 50 } }),
        axios.get(`${API_URL}/api/user/users`),
      ]);

      if (notifRes.status === 'fulfilled') {
        setNotifications(notifRes.value.data || []);
      }
      if (usersRes.status === 'fulfilled') {
        setUsers(usersRes.value.data || []);
      }
    } catch (err) {
      console.error('Failed to fetch data:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleSendNotification = async (e) => {
    e.preventDefault();
    setError('');
    setSending(true);

    try {
      await axios.post(`${API_URL}/api/notification/notifications/send`, sendForm);
      setSuccess('Уведомление отправлено!');
      setTimeout(() => {
        setShowSendModal(false);
        setSuccess('');
        setSendForm({ user_id: '', title: '', message: '', notification_type: 'general', channel: 'push' });
        fetchData();
      }, 1500);
    } catch (err) {
      setError(err.response?.data?.detail || 'Ошибка отправки');
    } finally {
      setSending(false);
    }
  };

  const handleBroadcast = async (e) => {
    e.preventDefault();
    setError('');
    setSending(true);

    try {
      await axios.post(`${API_URL}/api/notification/notifications/broadcast`, broadcastForm);
      setSuccess('Массовое уведомление отправлено всем пользователям!');
      setTimeout(() => {
        setShowBroadcastModal(false);
        setSuccess('');
        setBroadcastForm({ title: '', message: '', notification_type: 'announcement', channel: 'push' });
        fetchData();
      }, 1500);
    } catch (err) {
      setError(err.response?.data?.detail || 'Ошибка отправки');
    } finally {
      setSending(false);
    }
  };

  const getTypeBadge = (type) => {
    const badges = {
      general: 'bg-blue-100 text-blue-700',
      subscription_expiry: 'bg-orange-100 text-orange-700',
      payment: 'bg-green-100 text-green-700',
      promotion: 'bg-purple-100 text-purple-700',
      announcement: 'bg-cyan-100 text-cyan-700',
      system: 'bg-gray-100 text-gray-700',
    };
    return badges[type] || 'bg-gray-100 text-gray-600';
  };

  const getTypeLabel = (type) => {
    const found = notificationTypes.find(t => t.value === type);
    return found ? found.label : type;
  };

  const filteredNotifications = notifications.filter(n => {
    const matchesFilter = filter === 'all' || n.notification_type === filter;
    const matchesSearch = !searchTerm ||
      n.title?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      n.message?.toLowerCase().includes(searchTerm.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  const stats = {
    total: notifications.length,
    read: notifications.filter(n => n.is_read).length,
    unread: notifications.filter(n => !n.is_read).length,
    today: notifications.filter(n => {
      const d = new Date(n.created_at);
      const today = new Date();
      return d.toDateString() === today.toDateString();
    }).length,
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Загрузка уведомлений...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Уведомления</h1>
          <p className="text-gray-600 mt-1">Управление push-уведомлениями и рассылками</p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" onClick={fetchData} className="gap-2">
            <RefreshCw className="h-4 w-4" />
            Обновить
          </Button>
          <Button
            variant="outline"
            onClick={() => { setError(''); setSuccess(''); setShowSendModal(true); }}
            className="gap-2"
          >
            <Send className="h-4 w-4" />
            Отправить
          </Button>
          <Button
            onClick={() => { setError(''); setSuccess(''); setShowBroadcastModal(true); }}
            className="gap-2 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700"
          >
            <Megaphone className="h-4 w-4" />
            Массовая рассылка
          </Button>
        </div>
      </div>

      {success && (
        <div className="p-3 bg-green-50 border border-green-200 rounded-lg">
          <p className="text-sm text-green-600 flex items-center gap-2">
            <CheckCircle className="h-4 w-4" />
            {success}
          </p>
        </div>
      )}

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Всего</CardTitle>
            <Bell className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
            <p className="text-xs text-muted-foreground">Все уведомления</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Прочитано</CardTitle>
            <CheckCircle className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{stats.read}</div>
            <p className="text-xs text-muted-foreground">Прочитанные</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Не прочитано</CardTitle>
            <AlertCircle className="h-4 w-4 text-orange-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-orange-600">{stats.unread}</div>
            <p className="text-xs text-muted-foreground">Ожидают прочтения</p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Сегодня</CardTitle>
            <Clock className="h-4 w-4 text-blue-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">{stats.today}</div>
            <p className="text-xs text-muted-foreground">Отправлено сегодня</p>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-col md:flex-row gap-4">
        <div className="flex-1 relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
          <input
            type="text"
            placeholder="Поиск по заголовку или тексту..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          />
        </div>
        <div className="flex gap-2 flex-wrap">
          {['all', 'general', 'subscription_expiry', 'payment', 'promotion', 'announcement'].map((type) => (
            <button
              key={type}
              onClick={() => setFilter(type)}
              className={`px-3 py-2 rounded-lg text-sm font-medium ${
                filter === type
                  ? 'bg-gray-900 text-white'
                  : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
              }`}
            >
              {type === 'all' ? 'Все' : getTypeLabel(type)}
            </button>
          ))}
        </div>
      </div>

      {/* Notifications List */}
      <Card>
        <CardHeader>
          <CardTitle>История уведомлений</CardTitle>
          <CardDescription>Все отправленные уведомления</CardDescription>
        </CardHeader>
        <CardContent>
          {filteredNotifications.length === 0 ? (
            <div className="text-center py-16">
              <Bell className="mx-auto text-gray-300 mb-4" size={48} />
              <p className="text-gray-600 font-medium">Уведомления не найдены</p>
              <p className="text-sm text-gray-400 mt-1">Отправьте первое уведомление</p>
            </div>
          ) : (
            <div className="space-y-3">
              {filteredNotifications.map((notif) => (
                <div key={notif.id} className="flex items-start gap-4 p-4 border border-gray-100 rounded-xl hover:bg-gray-50 transition-colors">
                  <div className={`p-2 rounded-lg ${notif.is_read ? 'bg-gray-100' : 'bg-blue-100'}`}>
                    <Bell size={18} className={notif.is_read ? 'text-gray-500' : 'text-blue-600'} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-1">
                      <h4 className="font-semibold text-gray-900 text-sm">{notif.title}</h4>
                      <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${getTypeBadge(notif.notification_type)}`}>
                        {getTypeLabel(notif.notification_type)}
                      </span>
                      {!notif.is_read && (
                        <span className="w-2 h-2 bg-blue-500 rounded-full"></span>
                      )}
                    </div>
                    <p className="text-sm text-gray-600 truncate">{notif.message}</p>
                    <div className="flex items-center gap-4 mt-2 text-xs text-gray-400">
                      <span className="flex items-center gap-1">
                        <Clock size={12} />
                        {new Date(notif.created_at).toLocaleString('ru-RU')}
                      </span>
                      <span className="flex items-center gap-1">
                        <Smartphone size={12} />
                        {notif.channel || 'push'}
                      </span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Send to User Modal */}
      {showSendModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl p-6 w-full max-w-lg">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-gray-900">Отправить уведомление</h2>
              <button onClick={() => setShowSendModal(false)} className="text-gray-400 hover:text-gray-600">
                <X size={24} />
              </button>
            </div>

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

            <form onSubmit={handleSendNotification} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Пользователь *</label>
                <select
                  value={sendForm.user_id}
                  onChange={(e) => setSendForm({ ...sendForm, user_id: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  required
                >
                  <option value="">Выберите пользователя</option>
                  {users.map(u => (
                    <option key={u.id} value={u.id}>
                      {u.full_name || u.phone_number} ({u.phone_number})
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Заголовок *</label>
                <input
                  type="text"
                  value={sendForm.title}
                  onChange={(e) => setSendForm({ ...sendForm, title: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  placeholder="Заголовок уведомления"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Сообщение *</label>
                <textarea
                  value={sendForm.message}
                  onChange={(e) => setSendForm({ ...sendForm, message: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  rows="3"
                  placeholder="Текст уведомления"
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Тип</label>
                  <select
                    value={sendForm.notification_type}
                    onChange={(e) => setSendForm({ ...sendForm, notification_type: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                    {notificationTypes.map(t => (
                      <option key={t.value} value={t.value}>{t.label}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Канал</label>
                  <select
                    value={sendForm.channel}
                    onChange={(e) => setSendForm({ ...sendForm, channel: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                    <option value="push">Push</option>
                    <option value="sms">SMS</option>
                    <option value="email">Email</option>
                  </select>
                </div>
              </div>

              <div className="flex gap-3 pt-4">
                <Button type="submit" disabled={sending} className="flex-1 gap-2">
                  {sending ? (
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  ) : (
                    <Send className="h-4 w-4" />
                  )}
                  {sending ? 'Отправка...' : 'Отправить'}
                </Button>
                <Button type="button" variant="outline" onClick={() => setShowSendModal(false)} className="flex-1">
                  Отмена
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Broadcast Modal */}
      {showBroadcastModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl p-6 w-full max-w-lg">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-gray-900">Массовая рассылка</h2>
              <button onClick={() => setShowBroadcastModal(false)} className="text-gray-400 hover:text-gray-600">
                <X size={24} />
              </button>
            </div>

            <div className="mb-4 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
              <p className="text-sm text-yellow-800 flex items-center gap-2">
                <AlertCircle className="h-4 w-4" />
                Это уведомление будет отправлено <strong>всем {users.length} пользователям</strong>
              </p>
            </div>

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

            <form onSubmit={handleBroadcast} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Заголовок *</label>
                <input
                  type="text"
                  value={broadcastForm.title}
                  onChange={(e) => setBroadcastForm({ ...broadcastForm, title: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  placeholder="Важное объявление"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Сообщение *</label>
                <textarea
                  value={broadcastForm.message}
                  onChange={(e) => setBroadcastForm({ ...broadcastForm, message: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  rows="4"
                  placeholder="Текст массового уведомления..."
                  required
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Тип</label>
                  <select
                    value={broadcastForm.notification_type}
                    onChange={(e) => setBroadcastForm({ ...broadcastForm, notification_type: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                    {notificationTypes.map(t => (
                      <option key={t.value} value={t.value}>{t.label}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Канал</label>
                  <select
                    value={broadcastForm.channel}
                    onChange={(e) => setBroadcastForm({ ...broadcastForm, channel: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                    <option value="push">Push</option>
                    <option value="sms">SMS</option>
                    <option value="email">Email</option>
                  </select>
                </div>
              </div>

              <div className="flex gap-3 pt-4">
                <Button type="submit" disabled={sending} className="flex-1 gap-2 bg-gradient-to-r from-blue-600 to-purple-600">
                  {sending ? (
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  ) : (
                    <Megaphone className="h-4 w-4" />
                  )}
                  {sending ? 'Отправка...' : `Отправить всем (${users.length})`}
                </Button>
                <Button type="button" variant="outline" onClick={() => setShowBroadcastModal(false)} className="flex-1">
                  Отмена
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Notifications;
