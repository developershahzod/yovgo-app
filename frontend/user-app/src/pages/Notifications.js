import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Bell, Check, X, Trash2 } from 'lucide-react';
import BottomNav from '../components/BottomNav';

const Notifications = () => {
  const navigate = useNavigate();
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    // Load notifications from localStorage
    const savedNotifications = localStorage.getItem('notifications');
    if (savedNotifications) {
      setNotifications(JSON.parse(savedNotifications));
    } else {
      // Mock notifications for demo
      const mockNotifications = [
        {
          id: 1,
          type: 'success',
          title: 'Визит зарегистрирован',
          message: 'Ваш визит на Premium Car Wash успешно зарегистрирован',
          timestamp: new Date().toISOString(),
          read: false
        },
        {
          id: 2,
          type: 'info',
          title: 'Новая автомойка',
          message: 'Новая автомойка "Deluxe Wash" теперь доступна в вашем районе',
          timestamp: new Date(Date.now() - 3600000).toISOString(),
          read: false
        },
        {
          id: 3,
          type: 'warning',
          title: 'Осталось 2 визита',
          message: 'У вас осталось только 2 визита. Обновите подписку!',
          timestamp: new Date(Date.now() - 7200000).toISOString(),
          read: true
        }
      ];
      setNotifications(mockNotifications);
      localStorage.setItem('notifications', JSON.stringify(mockNotifications));
    }
  }, []);

  const markAsRead = (id) => {
    const updated = notifications.map(n => 
      n.id === id ? { ...n, read: true } : n
    );
    setNotifications(updated);
    localStorage.setItem('notifications', JSON.stringify(updated));
  };

  const markAllAsRead = () => {
    const updated = notifications.map(n => ({ ...n, read: true }));
    setNotifications(updated);
    localStorage.setItem('notifications', JSON.stringify(updated));
  };

  const deleteNotification = (id) => {
    const updated = notifications.filter(n => n.id !== id);
    setNotifications(updated);
    localStorage.setItem('notifications', JSON.stringify(updated));
  };

  const clearAll = () => {
    setNotifications([]);
    localStorage.removeItem('notifications');
  };

  const getTimeAgo = (timestamp) => {
    const now = new Date();
    const time = new Date(timestamp);
    const diff = Math.floor((now - time) / 1000);

    if (diff < 60) return 'Только что';
    if (diff < 3600) return `${Math.floor(diff / 60)} мин назад`;
    if (diff < 86400) return `${Math.floor(diff / 3600)} ч назад`;
    return `${Math.floor(diff / 86400)} дн назад`;
  };

  const getNotificationIcon = (type) => {
    switch (type) {
      case 'success':
        return <Check size={20} className="text-green-500" />;
      case 'warning':
        return <Bell size={20} className="text-yellow-500" />;
      case 'error':
        return <X size={20} className="text-red-500" />;
      default:
        return <Bell size={20} className="text-blue-500" />;
    }
  };

  const unreadCount = notifications.filter(n => !n.read).length;

  return (
    <div className="min-h-screen bg-[#F5F5F7] pb-24">
      {/* Header */}
      <div className="bg-white px-6 py-4 border-b border-gray-200">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <button 
              onClick={() => navigate('/home')}
              className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center"
            >
              <ArrowLeft size={20} className="text-gray-700" />
            </button>
            <div>
              <h1 className="text-xl font-bold text-gray-900">Уведомления</h1>
              {unreadCount > 0 && (
                <p className="text-sm text-gray-500">{unreadCount} непрочитанных</p>
              )}
            </div>
          </div>
          
          {notifications.length > 0 && (
            <div className="flex gap-2">
              {unreadCount > 0 && (
                <button
                  onClick={markAllAsRead}
                  className="text-sm text-blue-600 font-medium"
                >
                  Прочитать все
                </button>
              )}
              <button
                onClick={clearAll}
                className="text-sm text-red-600 font-medium"
              >
                Очистить
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Notifications List */}
      <div className="px-6 py-4">
        {notifications.length === 0 ? (
          <div className="bg-white rounded-2xl p-12 text-center border border-gray-200">
            <div className="w-16 h-16 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-4">
              <Bell size={32} className="text-gray-400" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-2">Нет уведомлений</h3>
            <p className="text-sm text-gray-500">Здесь будут отображаться ваши уведомления</p>
          </div>
        ) : (
          <div className="space-y-3">
            {notifications.map((notification) => (
              <div
                key={notification.id}
                className={`bg-white rounded-2xl p-4 border transition-all ${
                  notification.read 
                    ? 'border-gray-200' 
                    : 'border-blue-200 bg-blue-50/30'
                }`}
              >
                <div className="flex items-start gap-3">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 ${
                    notification.type === 'success' ? 'bg-green-50' :
                    notification.type === 'warning' ? 'bg-yellow-50' :
                    notification.type === 'error' ? 'bg-red-50' :
                    'bg-blue-50'
                  }`}>
                    {getNotificationIcon(notification.type)}
                  </div>
                  
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between gap-2 mb-1">
                      <h3 className="font-bold text-gray-900">{notification.title}</h3>
                      {!notification.read && (
                        <div className="w-2 h-2 rounded-full bg-blue-500 flex-shrink-0 mt-2"></div>
                      )}
                    </div>
                    <p className="text-sm text-gray-600 mb-2">{notification.message}</p>
                    <div className="flex items-center justify-between">
                      <p className="text-xs text-gray-500">{getTimeAgo(notification.timestamp)}</p>
                      <div className="flex gap-2">
                        {!notification.read && (
                          <button
                            onClick={() => markAsRead(notification.id)}
                            className="text-xs text-blue-600 font-medium"
                          >
                            Прочитано
                          </button>
                        )}
                        <button
                          onClick={() => deleteNotification(notification.id)}
                          className="p-1 text-gray-400 hover:text-red-600 transition-colors"
                        >
                          <Trash2 size={14} />
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default Notifications;
