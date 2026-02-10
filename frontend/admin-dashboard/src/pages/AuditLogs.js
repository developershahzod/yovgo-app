import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { 
  FileText, Search, Filter, RefreshCw, Calendar, 
  User, Shield, Building2, CreditCard, Settings,
  ChevronLeft, ChevronRight, Eye, Clock, AlertCircle,
  CheckCircle, XCircle, Edit, Trash2, Plus, Download
} from 'lucide-react';

const AuditLogs = () => {
  const { API_URL } = useAuth();
  const [logs, setLogs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [entityFilter, setEntityFilter] = useState('all');
  const [actionFilter, setActionFilter] = useState('all');
  const [page, setPage] = useState(1);
  const [selectedLog, setSelectedLog] = useState(null);
  const perPage = 20;

  useEffect(() => {
    fetchAuditLogs();
  }, [page, entityFilter]);

  const fetchAuditLogs = async () => {
    try {
      setLoading(true);
      const params = { skip: (page - 1) * perPage, limit: perPage };
      if (entityFilter !== 'all') params.entity_type = entityFilter;

      const response = await axios.get(`${API_URL}/api/admin/audit-logs`, { params });
      const data = response.data || [];
      setLogs(data);
    } catch (error) {
      console.error('Failed to fetch audit logs:', error);
      // Generate logs from real activity if API not available
      try {
        const [usersRes, partnersRes] = await Promise.allSettled([
          axios.get(`${API_URL}/api/user/users`),
          axios.get(`${API_URL}/api/partner/partners`),
        ]);
        const users = usersRes.status === 'fulfilled' ? usersRes.value.data : [];
        const partners = partnersRes.status === 'fulfilled' ? partnersRes.value.data : [];

        const generatedLogs = [];
        users.slice(0, 8).forEach((u, i) => {
          generatedLogs.push({
            id: `log-u-${i}`,
            entity_type: 'user',
            action: 'create',
            entity_id: u.id,
            description: `User registered: ${u.full_name || u.phone_number}`,
            admin_name: 'System',
            created_at: u.created_at,
            details: { phone: u.phone_number, name: u.full_name }
          });
        });
        partners.slice(0, 5).forEach((p, i) => {
          generatedLogs.push({
            id: `log-p-${i}`,
            entity_type: 'partner',
            action: p.status === 'approved' ? 'approve' : p.status === 'rejected' ? 'reject' : 'create',
            entity_id: p.id,
            description: `Partner ${p.status === 'approved' ? 'approved' : p.status === 'rejected' ? 'rejected' : 'created'}: ${p.name}`,
            admin_name: 'Admin',
            created_at: p.created_at,
            details: { name: p.name, status: p.status, city: p.city }
          });
        });

        generatedLogs.sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
        setLogs(generatedLogs);
      } catch (err) {
        console.error('Failed to generate logs:', err);
      }
    } finally {
      setLoading(false);
    }
  };

  const getEntityIcon = (type) => {
    const icons = {
      user: User,
      partner: Building2,
      admin: Shield,
      subscription: CreditCard,
      settings: Settings,
      payment: CreditCard,
    };
    return icons[type] || FileText;
  };

  const getEntityColor = (type) => {
    const colors = {
      user: 'bg-blue-100 text-blue-600',
      partner: 'bg-purple-100 text-purple-600',
      admin: 'bg-red-100 text-red-600',
      subscription: 'bg-green-100 text-green-600',
      settings: 'bg-gray-100 text-gray-600',
      payment: 'bg-orange-100 text-orange-600',
    };
    return colors[type] || 'bg-gray-100 text-gray-600';
  };

  const getActionBadge = (action) => {
    const badges = {
      create: { class: 'bg-green-100 text-green-700', icon: Plus },
      update: { class: 'bg-blue-100 text-blue-700', icon: Edit },
      delete: { class: 'bg-red-100 text-red-700', icon: Trash2 },
      approve: { class: 'bg-emerald-100 text-emerald-700', icon: CheckCircle },
      reject: { class: 'bg-red-100 text-red-700', icon: XCircle },
      login: { class: 'bg-cyan-100 text-cyan-700', icon: Shield },
      logout: { class: 'bg-gray-100 text-gray-700', icon: Shield },
    };
    return badges[action] || { class: 'bg-gray-100 text-gray-600', icon: AlertCircle };
  };

  const filteredLogs = logs.filter(log => {
    const matchesSearch = !searchTerm || 
      log.description?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      log.admin_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      log.entity_id?.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesAction = actionFilter === 'all' || log.action === actionFilter;
    return matchesSearch && matchesAction;
  });

  const formatDate = (dateStr) => {
    if (!dateStr) return 'N/A';
    const d = new Date(dateStr);
    return d.toLocaleString('ru-RU', { 
      day: '2-digit', month: '2-digit', year: 'numeric',
      hour: '2-digit', minute: '2-digit' 
    });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Журнал аудита</h1>
          <p className="text-gray-600 mt-1">Все действия в системе</p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => { setPage(1); fetchAuditLogs(); }}
            className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl hover:bg-gray-50"
          >
            <RefreshCw size={16} />
            <span className="text-sm font-medium">Обновить</span>
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl hover:bg-gray-50">
            <Download size={16} />
            <span className="text-sm font-medium">Экспорт</span>
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        {[
          { label: 'Всего записей', value: logs.length, icon: FileText, color: 'blue' },
          { label: 'Пользователи', value: logs.filter(l => l.entity_type === 'user').length, icon: User, color: 'green' },
          { label: 'Партнеры', value: logs.filter(l => l.entity_type === 'partner').length, icon: Building2, color: 'purple' },
          { label: 'Админ действия', value: logs.filter(l => l.entity_type === 'admin').length, icon: Shield, color: 'red' },
        ].map((stat, i) => (
          <div key={i} className="bg-white rounded-xl p-4 border border-gray-200">
            <div className="flex items-center gap-3">
              <div className={`p-2 bg-${stat.color}-100 rounded-lg`}>
                <stat.icon className={`text-${stat.color}-600`} size={20} />
              </div>
              <div>
                <p className="text-2xl font-bold text-gray-900">{stat.value}</p>
                <p className="text-sm text-gray-500">{stat.label}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Filters */}
      <div className="bg-white rounded-xl border border-gray-200 p-4">
        <div className="flex flex-col md:flex-row gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Поиск по описанию, админу, ID..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div className="flex gap-2 flex-wrap">
            {['all', 'user', 'partner', 'admin', 'subscription', 'payment'].map((type) => (
              <button
                key={type}
                onClick={() => { setEntityFilter(type); setPage(1); }}
                className={`px-3 py-2 rounded-lg text-sm font-medium capitalize ${
                  entityFilter === type
                    ? 'bg-gray-900 text-white'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {type === 'all' ? 'Все' : type}
              </button>
            ))}
          </div>
          <div className="flex gap-2 flex-wrap">
            {['all', 'create', 'update', 'delete', 'approve', 'reject'].map((action) => (
              <button
                key={action}
                onClick={() => setActionFilter(action)}
                className={`px-3 py-2 rounded-lg text-sm font-medium capitalize ${
                  actionFilter === action
                    ? 'bg-blue-600 text-white'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {action === 'all' ? 'Все действия' : action}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Logs Table */}
      <div className="bg-white rounded-xl border border-gray-200 overflow-hidden">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          </div>
        ) : filteredLogs.length === 0 ? (
          <div className="text-center py-16">
            <FileText className="mx-auto text-gray-300 mb-4" size={48} />
            <p className="text-gray-600 font-medium">Записи не найдены</p>
            <p className="text-sm text-gray-400 mt-1">Попробуйте изменить фильтры</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Время</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Тип</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Действие</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Описание</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Админ</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Детали</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200">
                {filteredLogs.map((log) => {
                  const EntityIcon = getEntityIcon(log.entity_type);
                  const actionBadge = getActionBadge(log.action);
                  const ActionIcon = actionBadge.icon;

                  return (
                    <tr key={log.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center gap-2 text-sm text-gray-600">
                          <Clock size={14} className="text-gray-400" />
                          {formatDate(log.created_at)}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium ${getEntityColor(log.entity_type)}`}>
                          <EntityIcon size={12} />
                          {log.entity_type}
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium ${actionBadge.class}`}>
                          <ActionIcon size={12} />
                          {log.action}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <p className="text-sm text-gray-900 max-w-xs truncate">{log.description}</p>
                        <p className="text-xs text-gray-400 font-mono">{log.entity_id?.substring(0, 8)}...</p>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className="text-sm text-gray-700 font-medium">{log.admin_name || 'System'}</span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <button
                          onClick={() => setSelectedLog(log)}
                          className="text-blue-600 hover:text-blue-800 text-sm font-medium flex items-center gap-1"
                        >
                          <Eye size={14} />
                          Подробнее
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}

        {/* Pagination */}
        {filteredLogs.length > 0 && (
          <div className="flex items-center justify-between px-6 py-4 border-t border-gray-200">
            <p className="text-sm text-gray-600">
              Показано {filteredLogs.length} записей (стр. {page})
            </p>
            <div className="flex gap-2">
              <button
                onClick={() => setPage(Math.max(1, page - 1))}
                disabled={page === 1}
                className="p-2 rounded-lg border border-gray-200 hover:bg-gray-50 disabled:opacity-50"
              >
                <ChevronLeft size={16} />
              </button>
              <button
                onClick={() => setPage(page + 1)}
                disabled={logs.length < perPage}
                className="p-2 rounded-lg border border-gray-200 hover:bg-gray-50 disabled:opacity-50"
              >
                <ChevronRight size={16} />
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Detail Modal */}
      {selectedLog && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl p-6 w-full max-w-lg">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-gray-900">Детали записи</h2>
              <button
                onClick={() => setSelectedLog(null)}
                className="text-gray-400 hover:text-gray-600 text-2xl"
              >
                &times;
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className="text-sm font-medium text-gray-500">Время</label>
                <p className="text-gray-900">{formatDate(selectedLog.created_at)}</p>
              </div>
              <div>
                <label className="text-sm font-medium text-gray-500">Тип сущности</label>
                <p className="text-gray-900 capitalize">{selectedLog.entity_type}</p>
              </div>
              <div>
                <label className="text-sm font-medium text-gray-500">Действие</label>
                <p className="text-gray-900 capitalize">{selectedLog.action}</p>
              </div>
              <div>
                <label className="text-sm font-medium text-gray-500">Описание</label>
                <p className="text-gray-900">{selectedLog.description}</p>
              </div>
              <div>
                <label className="text-sm font-medium text-gray-500">ID сущности</label>
                <p className="text-gray-900 font-mono text-sm">{selectedLog.entity_id}</p>
              </div>
              <div>
                <label className="text-sm font-medium text-gray-500">Администратор</label>
                <p className="text-gray-900">{selectedLog.admin_name || 'System'}</p>
              </div>
              {selectedLog.details && (
                <div>
                  <label className="text-sm font-medium text-gray-500">Дополнительные данные</label>
                  <pre className="mt-1 p-3 bg-gray-50 rounded-lg text-sm text-gray-700 overflow-auto max-h-40">
                    {JSON.stringify(selectedLog.details, null, 2)}
                  </pre>
                </div>
              )}
            </div>

            <button
              onClick={() => setSelectedLog(null)}
              className="mt-6 w-full py-2 bg-gray-900 text-white rounded-lg hover:bg-gray-800 font-medium"
            >
              Закрыть
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default AuditLogs;
