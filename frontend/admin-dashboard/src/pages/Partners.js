import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Building2, CheckCircle, XCircle } from 'lucide-react';

const Partners = () => {
  const { API_URL, hasPermission } = useAuth();
  const [partners, setPartners] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');

  useEffect(() => {
    fetchPartners();
  }, [filter]);

  const fetchPartners = async () => {
    try {
      const url = filter === 'all' 
        ? `${API_URL}/api/partner/partners`
        : `${API_URL}/api/partner/partners?status=${filter}`;
      const response = await axios.get(url);
      setPartners(response.data);
    } catch (error) {
      console.error('Failed to fetch partners:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (partnerId) => {
    try {
      await axios.put(`${API_URL}/api/admin/partners/${partnerId}/approve`);
      fetchPartners();
    } catch (error) {
      console.error('Failed to approve partner:', error);
    }
  };

  const handleReject = async (partnerId) => {
    try {
      await axios.put(`${API_URL}/api/admin/partners/${partnerId}/reject`);
      fetchPartners();
    } catch (error) {
      console.error('Failed to reject partner:', error);
    }
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Partners</h1>
          <p className="text-gray-600 mt-1">Manage car wash partners</p>
        </div>
      </div>

      <div className="mb-6 flex space-x-2">
        {['all', 'pending', 'approved', 'rejected'].map((status) => (
          <button
            key={status}
            onClick={() => setFilter(status)}
            className={`px-4 py-2 rounded-lg font-medium capitalize ${
              filter === status
                ? 'bg-primary-600 text-white'
                : 'bg-white text-gray-700 hover:bg-gray-100'
            }`}
          >
            {status}
          </button>
        ))}
      </div>

      <div className="bg-white rounded-lg shadow">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Partner</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Contact</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Registered</th>
                  {hasPermission('partners.write') && (
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
                  )}
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {partners.map((partner) => (
                  <tr key={partner.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center">
                        <Building2 className="text-gray-400 mr-3" size={20} />
                        <div>
                          <div className="text-sm font-medium text-gray-900">{partner.name}</div>
                          <div className="text-sm text-gray-500">{partner.description?.substring(0, 50)}...</div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm text-gray-900">{partner.email}</div>
                      <div className="text-sm text-gray-500">{partner.phone_number}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${
                        partner.status === 'approved' ? 'bg-green-100 text-green-800' :
                        partner.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                        'bg-red-100 text-red-800'
                      }`}>
                        {partner.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {new Date(partner.created_at).toLocaleDateString()}
                    </td>
                    {hasPermission('partners.write') && (
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        {partner.status === 'pending' && (
                          <>
                            <button
                              onClick={() => handleApprove(partner.id)}
                              className="text-green-600 hover:text-green-900 mr-3"
                            >
                              <CheckCircle size={20} />
                            </button>
                            <button
                              onClick={() => handleReject(partner.id)}
                              className="text-red-600 hover:text-red-900"
                            >
                              <XCircle size={20} />
                            </button>
                          </>
                        )}
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default Partners;
