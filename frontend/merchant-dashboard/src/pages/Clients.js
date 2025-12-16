import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { Users, Search, Phone, Mail } from 'lucide-react';

const Clients = () => {
  const { merchant } = useMerchantAuth();
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchClients();
  }, []);

  const fetchClients = async () => {
    try {
      setLoading(true);
      
      const partnerId = merchant?.partner?.id;
      
      if (!partnerId) {
        console.error('No partner ID found');
        setClients([]);
        setLoading(false);
        return;
      }
      
      // Загружаем клиентов через визиты этого филиала
      const VISIT_API = 'http://localhost:8004';
      const response = await axios.get(`${VISIT_API}/visits?partner_id=${partnerId}`);
      
      // Извлекаем уникальных клиентов из визитов
      const visitsData = response.data || [];
      const uniqueClients = {};
      
      visitsData.forEach(visit => {
        if (visit.user_id && !uniqueClients[visit.user_id]) {
          uniqueClients[visit.user_id] = {
            id: visit.user_id,
            name: visit.user_name || 'Клиент',
            phone: visit.user_phone || 'N/A',
            email: visit.user_email || '',
            visits_count: 1,
            last_visit: visit.check_in_time
          };
        } else if (visit.user_id) {
          uniqueClients[visit.user_id].visits_count++;
          if (new Date(visit.check_in_time) > new Date(uniqueClients[visit.user_id].last_visit)) {
            uniqueClients[visit.user_id].last_visit = visit.check_in_time;
          }
        }
      });
      
      setClients(Object.values(uniqueClients));
    } catch (error) {
      console.error('Failed to fetch clients:', error);
      setClients([]);
    } finally {
      setLoading(false);
    }
  };

  const filteredClients = clients.filter(client =>
    client.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    client.phone.includes(searchTerm)
  );

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('ru-RU', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    });
  };

  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Клиенты</h1>
        <p className="text-gray-600">Клиенты вашего филиала</p>
      </div>

      {/* Search */}
      <div className="mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
          <input
            type="text"
            placeholder="Поиск по имени или телефону..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
      </div>

      {/* Clients List */}
      {loading ? (
        <div className="flex items-center justify-center py-12">
          <div className="w-12 h-12 border-4 border-gray-200 border-t-blue-500 rounded-full animate-spin"></div>
        </div>
      ) : filteredClients.length === 0 ? (
        <div className="text-center py-12 bg-white rounded-lg border border-gray-200">
          <Users size={48} className="mx-auto text-gray-400 mb-4" />
          <h3 className="text-lg font-semibold text-gray-900 mb-2">
            {searchTerm ? 'Клиенты не найдены' : 'Нет клиентов'}
          </h3>
          <p className="text-gray-500">
            {searchTerm ? 'Попробуйте изменить запрос' : 'Клиенты появятся после первых визитов'}
          </p>
        </div>
      ) : (
        <>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredClients.map((client) => (
              <div key={client.id} className="bg-white p-6 rounded-lg border border-gray-200 hover:shadow-md transition-shadow">
                <div className="flex items-start gap-4">
                  <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
                    <Users size={24} className="text-blue-600" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <h3 className="font-semibold text-gray-900 mb-2 truncate">{client.name}</h3>
                    
                    <div className="space-y-2">
                      <div className="flex items-center gap-2 text-sm text-gray-600">
                        <Phone size={14} />
                        <span className="truncate">{client.phone}</span>
                      </div>
                      
                      {client.email && (
                        <div className="flex items-center gap-2 text-sm text-gray-600">
                          <Mail size={14} />
                          <span className="truncate">{client.email}</span>
                        </div>
                      )}
                    </div>
                    
                    <div className="mt-4 pt-4 border-t border-gray-100">
                      <div className="flex items-center justify-between text-sm">
                        <span className="text-gray-500">Визитов:</span>
                        <span className="font-semibold text-gray-900">{client.visits_count}</span>
                      </div>
                      <div className="flex items-center justify-between text-sm mt-1">
                        <span className="text-gray-500">Последний:</span>
                        <span className="font-semibold text-gray-900">{formatDate(client.last_visit)}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Stats */}
          <div className="mt-6 grid grid-cols-3 gap-4">
            <div className="bg-white p-4 rounded-lg border border-gray-200">
              <p className="text-sm text-gray-500 mb-1">Всего клиентов</p>
              <p className="text-2xl font-bold text-gray-900">{clients.length}</p>
            </div>
            <div className="bg-white p-4 rounded-lg border border-gray-200">
              <p className="text-sm text-gray-500 mb-1">Активных</p>
              <p className="text-2xl font-bold text-gray-900">
                {clients.filter(c => {
                  const weekAgo = new Date();
                  weekAgo.setDate(weekAgo.getDate() - 7);
                  return new Date(c.last_visit) >= weekAgo;
                }).length}
              </p>
            </div>
            <div className="bg-white p-4 rounded-lg border border-gray-200">
              <p className="text-sm text-gray-500 mb-1">Средний визитов</p>
              <p className="text-2xl font-bold text-gray-900">
                {clients.length > 0 ? Math.round(clients.reduce((sum, c) => sum + c.visits_count, 0) / clients.length) : 0}
              </p>
            </div>
          </div>
        </>
      )}
    </div>
  );
};

export default Clients;
