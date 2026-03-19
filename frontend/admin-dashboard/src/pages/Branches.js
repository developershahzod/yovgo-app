import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { MapPin, Building2, Search, ChevronDown, ChevronUp } from 'lucide-react';

const Branches = () => {
  const { API_URL } = useAuth();
  const [partners, setPartners] = useState([]);
  const [branches, setBranches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [expandedPartner, setExpandedPartner] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const [partnersRes, branchesRes] = await Promise.allSettled([
        axios.get(`${API_URL}/api/partner/partners`),
        axios.get(`${API_URL}/api/partner/locations`),
      ]);
      const partnersData = partnersRes.status === 'fulfilled' ? (partnersRes.value.data || []) : [];
      const branchesData = branchesRes.status === 'fulfilled' ? (branchesRes.value.data || []) : [];
      setPartners(partnersData);
      setBranches(branchesData);
    } catch (err) {
      setError('Ma\'lumotlarni yuklashda xatolik');
    } finally {
      setLoading(false);
    }
  };

  const getBranchesForPartner = (partnerId) =>
    branches.filter(b => b.partner_id === partnerId);

  const filteredPartners = partners.filter(p =>
    p.name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    p.city?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="w-10 h-10 border-4 border-blue-200 border-t-blue-600 rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Filiallar</h1>
          <p className="text-sm text-gray-500 mt-1">Barcha hamkor avtomoykalarning filiallari</p>
        </div>
        <div className="flex items-center gap-3 bg-blue-50 rounded-xl px-4 py-2">
          <MapPin size={18} className="text-blue-600" />
          <span className="text-sm font-semibold text-blue-700">{branches.length} ta filial</span>
        </div>
      </div>

      {error && (
        <div className="p-3 bg-red-50 border border-red-200 rounded-lg text-sm text-red-600">{error}</div>
      )}

      {/* Search */}
      <div className="relative">
        <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
        <input
          type="text"
          placeholder="Hamkor yoki shahar bo'yicha qidirish..."
          value={searchTerm}
          onChange={e => setSearchTerm(e.target.value)}
          className="w-full pl-9 pr-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
        />
      </div>

      {/* Partners with branches */}
      <div className="space-y-3">
        {filteredPartners.map(partner => {
          const partnerBranches = getBranchesForPartner(partner.id);
          const isExpanded = expandedPartner === partner.id;

          return (
            <div key={partner.id} className="bg-white rounded-xl border border-gray-200 overflow-hidden shadow-sm">
              {/* Partner header */}
              <button
                onClick={() => setExpandedPartner(isExpanded ? null : partner.id)}
                className="w-full flex items-center justify-between p-4 hover:bg-gray-50 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center">
                    <Building2 size={18} className="text-white" />
                  </div>
                  <div className="text-left">
                    <p className="font-semibold text-gray-900">{partner.name}</p>
                    <p className="text-xs text-gray-500">{partner.city || 'Toshkent'} · {partner.address || ''}</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <span className={`text-xs px-2 py-1 rounded-full font-medium ${
                    partner.status === 'approved' ? 'bg-emerald-100 text-emerald-700' :
                    partner.status === 'pending' ? 'bg-yellow-100 text-yellow-700' :
                    'bg-red-100 text-red-700'
                  }`}>
                    {partner.status === 'approved' ? 'Faol' : partner.status === 'pending' ? 'Kutilmoqda' : 'Rad etilgan'}
                  </span>
                  <span className="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full font-medium">
                    {partnerBranches.length} filial
                  </span>
                  {isExpanded ? <ChevronUp size={16} className="text-gray-400" /> : <ChevronDown size={16} className="text-gray-400" />}
                </div>
              </button>

              {/* Branches list */}
              {isExpanded && (
                <div className="border-t border-gray-100">
                  {partnerBranches.length === 0 ? (
                    <div className="p-6 text-center text-sm text-gray-400">
                      Bu hamkorning filiallari yo'q
                    </div>
                  ) : (
                    <div className="divide-y divide-gray-50">
                      {partnerBranches.map(branch => (
                        <div key={branch.id} className="flex items-center gap-4 px-6 py-3 hover:bg-gray-50">
                          <div className="w-8 h-8 rounded-lg bg-gray-100 flex items-center justify-center flex-shrink-0">
                            <MapPin size={14} className="text-gray-500" />
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-sm font-medium text-gray-800 truncate">
                              {branch.name || 'Filial'}
                            </p>
                            <p className="text-xs text-gray-500 truncate">
                              {branch.address || ''}{branch.city ? ` · ${branch.city}` : ''}
                            </p>
                          </div>
                          <div className="flex items-center gap-2 flex-shrink-0">
                            {branch.latitude && branch.longitude && (
                              <a
                                href={`https://maps.google.com/?q=${branch.latitude},${branch.longitude}`}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="text-xs text-blue-600 hover:underline"
                              >
                                Xaritada ko'rish
                              </a>
                            )}
                            <span className={`text-xs px-2 py-0.5 rounded-full ${
                              branch.is_active ? 'bg-emerald-100 text-emerald-700' : 'bg-gray-100 text-gray-500'
                            }`}>
                              {branch.is_active ? 'Faol' : 'Nofaol'}
                            </span>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          );
        })}

        {filteredPartners.length === 0 && (
          <div className="text-center py-12 text-gray-400">
            <Building2 size={40} className="mx-auto mb-3 opacity-30" />
            <p>Hamkorlar topilmadi</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default Branches;
