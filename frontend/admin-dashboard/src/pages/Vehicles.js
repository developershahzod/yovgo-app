import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Car, Search, Trash2, Plus, User, Phone, Calendar } from 'lucide-react';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';

const Vehicles = () => {
  const { API_URL } = useAuth();
  const [vehicles, setVehicles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [stats, setStats] = useState({ total: 0 });

  useEffect(() => {
    fetchVehicles();
  }, []);

  const fetchVehicles = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/mobile/vehicles/all`);
      const data = response.data;
      const vehiclesList = data.vehicles || [];
      setVehicles(vehiclesList);
      setStats({ total: data.total || vehiclesList.length });
    } catch (error) {
      console.error('Failed to fetch vehicles:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (vehicle) => {
    if (!window.confirm(`"${vehicle.name || vehicle.license_plate}" ni o'chirmoqchimisiz?`)) return;
    try {
      await axios.delete(`${API_URL}/api/user/vehicles/${vehicle.id}`);
      fetchVehicles();
    } catch (error) {
      console.error('Failed to delete vehicle:', error);
      alert(error.response?.data?.detail || 'O\'chirishda xatolik');
    }
  };

  const filteredVehicles = vehicles.filter(v =>
    v.license_plate?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    v.brand?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    v.model?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    v.user_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    v.user_phone?.includes(searchTerm)
  );

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Avtomobillar</h1>
          <p className="text-gray-600 mt-1">Foydalanuvchilar avtomobillari</p>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-3 bg-blue-100 rounded-xl">
                <Car className="h-6 w-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-bold">{stats.total}</p>
                <p className="text-sm text-gray-500">Jami avtomobillar</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Search */}
      <div className="mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
          <input
            type="text"
            placeholder="Raqam, marka, model yoki egasi bo'yicha qidirish..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent"
          />
        </div>
      </div>

      {/* Table */}
      <Card>
        <CardContent className="p-0">
          {loading ? (
            <div className="flex items-center justify-center h-64">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50 border-b">
                  <tr>
                    <th className="text-left py-3 px-4 font-medium text-gray-700">Avtomobil</th>
                    <th className="text-left py-3 px-4 font-medium text-gray-700">Davlat raqami</th>
                    <th className="text-left py-3 px-4 font-medium text-gray-700">Egasi</th>
                    <th className="text-left py-3 px-4 font-medium text-gray-700">Rang / Yil</th>
                    <th className="text-left py-3 px-4 font-medium text-gray-700">Qo'shilgan</th>
                    <th className="text-right py-3 px-4 font-medium text-gray-700">Amallar</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredVehicles.map((vehicle) => (
                    <tr key={vehicle.id} className="border-b hover:bg-gray-50">
                      <td className="py-3 px-4">
                        <div className="flex items-center gap-3">
                          <div className="p-2 bg-blue-50 rounded-lg">
                            <Car className="h-5 w-5 text-blue-600" />
                          </div>
                          <div>
                            <div className="font-medium">{vehicle.name || '—'}</div>
                            <div className="text-sm text-gray-500">
                              {[vehicle.brand, vehicle.model].filter(Boolean).join(' ') || '—'}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="py-3 px-4">
                        <span className="inline-flex items-center px-3 py-1 rounded-lg bg-gray-100 font-mono font-medium text-sm">
                          {vehicle.license_plate}
                        </span>
                      </td>
                      <td className="py-3 px-4">
                        <div>
                          <div className="font-medium flex items-center gap-1">
                            <User className="h-3 w-3 text-gray-400" />
                            {vehicle.user_name || '—'}
                          </div>
                          <div className="text-sm text-gray-500 flex items-center gap-1">
                            <Phone className="h-3 w-3 text-gray-400" />
                            {vehicle.user_phone || '—'}
                          </div>
                        </div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="text-sm">
                          {vehicle.color && <span className="mr-2">{vehicle.color}</span>}
                          {vehicle.year && <span className="text-gray-500">{vehicle.year}</span>}
                          {!vehicle.color && !vehicle.year && '—'}
                        </div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="text-sm text-gray-500 flex items-center gap-1">
                          <Calendar className="h-3 w-3" />
                          {vehicle.created_at ? new Date(vehicle.created_at).toLocaleDateString() : '—'}
                        </div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="flex items-center justify-end gap-2">
                          <Button variant="ghost" size="sm" onClick={() => handleDelete(vehicle)} title="O'chirish">
                            <Trash2 className="h-4 w-4 text-red-500" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          {!loading && filteredVehicles.length === 0 && (
            <div className="text-center py-12">
              <Car className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">Avtomobillar topilmadi</p>
              <p className="text-sm text-gray-500 mt-1">
                {searchTerm ? 'Qidiruv natijasi bo\'sh' : 'Hali avtomobil qo\'shilmagan'}
              </p>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
};

export default Vehicles;
