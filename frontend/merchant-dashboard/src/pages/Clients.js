import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { Search, User, Calendar, Activity } from 'lucide-react';

const Clients = () => {
  const { API_URL, merchant } = useMerchantAuth();
  const [clients, setClients] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchClients();
  }, []);

  const fetchClients = async () => {
    try {
      const response = await axios.get(
        `${API_URL}/api/visit/partner/${merchant.partner.id}/clients`
      );
      setClients(response.data);
    } catch (error) {
      console.error('Failed to fetch clients:', error);
    } finally {
      setLoading(false);
    }
  };

  const filteredClients = clients.filter(client =>
    client.user_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    client.phone_number?.includes(searchTerm)
  );

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Clients</h1>
          <p className="text-gray-600 mt-1">Customers who visited your car wash</p>
        </div>
        <div className="text-right">
          <p className="text-3xl font-bold text-primary-600">{clients.length}</p>
          <p className="text-sm text-gray-600">Total Clients</p>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow">
        <div className="p-4 border-b">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Search clients..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-primary-500 focus:border-transparent"
            />
          </div>
        </div>

        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Client
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Total Visits
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Last Visit
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredClients.length === 0 ? (
                  <tr>
                    <td colSpan="4" className="px-6 py-8 text-center text-gray-500">
                      No clients found
                    </td>
                  </tr>
                ) : (
                  filteredClients.map((client) => (
                    <tr key={client.user_id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center mr-3">
                            <User size={20} className="text-primary-600" />
                          </div>
                          <div>
                            <div className="text-sm font-medium text-gray-900">
                              {client.user_name || 'Customer'}
                            </div>
                            <div className="text-sm text-gray-500">
                              {client.phone_number || 'N/A'}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <Activity size={16} className="text-gray-400 mr-2" />
                          <span className="text-sm font-medium text-gray-900">
                            {client.visit_count || 0} visits
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <div className="flex items-center">
                          <Calendar size={16} className="text-gray-400 mr-2" />
                          <span className="text-sm text-gray-900">
                            {client.last_visit 
                              ? new Date(client.last_visit).toLocaleDateString()
                              : 'Never'}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${
                          client.subscription_active
                            ? 'bg-green-100 text-green-800'
                            : 'bg-gray-100 text-gray-800'
                        }`}>
                          {client.subscription_active ? 'Active' : 'Inactive'}
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

      {/* Client Statistics */}
      <div className="mt-6 grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">New This Month</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">
                {clients.filter(c => {
                  const firstVisit = new Date(c.first_visit);
                  const now = new Date();
                  return firstVisit.getMonth() === now.getMonth() && 
                         firstVisit.getFullYear() === now.getFullYear();
                }).length}
              </p>
            </div>
            <div className="p-3 bg-blue-100 rounded-full">
              <User className="text-blue-600" size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Active Subscriptions</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">
                {clients.filter(c => c.subscription_active).length}
              </p>
            </div>
            <div className="p-3 bg-green-100 rounded-full">
              <Activity className="text-green-600" size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Avg. Visits/Client</p>
              <p className="text-2xl font-bold text-gray-900 mt-1">
                {clients.length > 0
                  ? (clients.reduce((sum, c) => sum + (c.visit_count || 0), 0) / clients.length).toFixed(1)
                  : '0'}
              </p>
            </div>
            <div className="p-3 bg-purple-100 rounded-full">
              <Calendar className="text-purple-600" size={24} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Clients;
