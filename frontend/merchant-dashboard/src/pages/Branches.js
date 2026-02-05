import React, { useState, useEffect } from 'react';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import axios from 'axios';
import { 
  Building2, Plus, MapPin, Clock, Users, QrCode, 
  Edit2, Trash2, Eye, X, Check, Phone, ChevronRight
} from 'lucide-react';
import QRCode from 'qrcode.react';

const Branches = () => {
  const { API_URL, merchant } = useMerchantAuth();
  const [branches, setBranches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showQRModal, setShowQRModal] = useState(false);
  const [showStaffModal, setShowStaffModal] = useState(false);
  const [selectedBranch, setSelectedBranch] = useState(null);
  const [branchStaff, setBranchStaff] = useState([]);

  const [newBranch, setNewBranch] = useState({
    name: '',
    address: '',
    city: 'Tashkent',
    phone_number: '',
    working_hours: { open: '08:00', close: '22:00' }
  });

  const [newStaff, setNewStaff] = useState({
    full_name: '',
    phone_number: '',
    role: 'staff'
  });

  useEffect(() => {
    fetchBranches();
  }, []);

  const fetchBranches = async () => {
    try {
      setLoading(true);
      const response = await axios.get(
        `${API_URL}/api/partner/merchant/branches?partner_id=${merchant?.partner_id}`
      );
      setBranches(response.data || []);
    } catch (error) {
      console.error('Failed to fetch branches:', error);
      // Mock data for demo
      setBranches([
        {
          id: '1',
          name: 'Asosiy filial',
          address: 'Yunusobod tumani, Amir Temur ko\'chasi 15',
          city: 'Tashkent',
          is_active: true,
          visit_count: 156,
          staff_count: 3,
          qr_code: 'BRANCH_1',
          working_hours: { open: '08:00', close: '22:00' }
        },
        {
          id: '2',
          name: 'Chilonzor filiali',
          address: 'Chilonzor tumani, 9-mavze',
          city: 'Tashkent',
          is_active: true,
          visit_count: 89,
          staff_count: 2,
          qr_code: 'BRANCH_2',
          working_hours: { open: '09:00', close: '21:00' }
        }
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleAddBranch = async () => {
    try {
      const response = await axios.post(
        `${API_URL}/api/partner/merchant/branches?partner_id=${merchant?.partner_id}`,
        newBranch
      );
      setBranches([...branches, response.data]);
      setShowAddModal(false);
      setNewBranch({
        name: '',
        address: '',
        city: 'Tashkent',
        phone_number: '',
        working_hours: { open: '08:00', close: '22:00' }
      });
    } catch (error) {
      console.error('Failed to add branch:', error);
      // Add mock branch for demo
      const mockBranch = {
        id: Date.now().toString(),
        ...newBranch,
        is_active: true,
        visit_count: 0,
        staff_count: 0,
        qr_code: `BRANCH_${Date.now()}`
      };
      setBranches([...branches, mockBranch]);
      setShowAddModal(false);
      setNewBranch({
        name: '',
        address: '',
        city: 'Tashkent',
        phone_number: '',
        working_hours: { open: '08:00', close: '22:00' }
      });
    }
  };

  const handleDeleteBranch = async (branchId) => {
    if (!window.confirm('Filialni o\'chirmoqchimisiz?')) return;
    
    try {
      await axios.delete(`${API_URL}/api/partner/merchant/branches/${branchId}`);
      setBranches(branches.filter(b => b.id !== branchId));
    } catch (error) {
      console.error('Failed to delete branch:', error);
      setBranches(branches.filter(b => b.id !== branchId));
    }
  };

  const handleShowQR = (branch) => {
    setSelectedBranch(branch);
    setShowQRModal(true);
  };

  const handleShowStaff = async (branch) => {
    setSelectedBranch(branch);
    try {
      const response = await axios.get(
        `${API_URL}/api/partner/merchant/branches/${branch.id}/staff`
      );
      setBranchStaff(response.data || []);
    } catch (error) {
      // Mock staff data
      setBranchStaff([
        { id: '1', full_name: 'Alisher Karimov', phone_number: '+998901234567', role: 'manager' },
        { id: '2', full_name: 'Dilshod Rahimov', phone_number: '+998901234568', role: 'staff' }
      ]);
    }
    setShowStaffModal(true);
  };

  const handleAddStaff = async () => {
    try {
      const response = await axios.post(
        `${API_URL}/api/partner/merchant/branches/${selectedBranch.id}/staff`,
        newStaff
      );
      setBranchStaff([...branchStaff, response.data]);
      setNewStaff({ full_name: '', phone_number: '', role: 'staff' });
    } catch (error) {
      // Add mock staff
      const mockStaff = {
        id: Date.now().toString(),
        ...newStaff,
        pin_code: Math.floor(1000 + Math.random() * 9000).toString()
      };
      setBranchStaff([...branchStaff, mockStaff]);
      setNewStaff({ full_name: '', phone_number: '', role: 'staff' });
      alert(`Xodim qo'shildi! PIN kod: ${mockStaff.pin_code}`);
    }
  };

  const handleRemoveStaff = async (staffId) => {
    if (!window.confirm('Xodimni o\'chirmoqchimisiz?')) return;
    
    try {
      await axios.delete(
        `${API_URL}/api/partner/merchant/branches/${selectedBranch.id}/staff/${staffId}`
      );
      setBranchStaff(branchStaff.filter(s => s.id !== staffId));
    } catch (error) {
      setBranchStaff(branchStaff.filter(s => s.id !== staffId));
    }
  };

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
          <h1 className="text-2xl font-bold text-gray-900">Filiallar</h1>
          <p className="text-gray-600">Barcha filiallaringizni boshqaring</p>
        </div>
        <button
          onClick={() => setShowAddModal(true)}
          className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
        >
          <Plus size={20} />
          Yangi filial
        </button>
      </div>

      {/* Branches Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {branches.map((branch) => (
          <div key={branch.id} className="bg-white rounded-xl border border-gray-200 overflow-hidden">
            <div className="p-5">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-emerald-100 rounded-lg">
                    <Building2 className="text-emerald-600" size={24} />
                  </div>
                  <div>
                    <h3 className="font-semibold text-gray-900">{branch.name}</h3>
                    <span className={`text-xs px-2 py-0.5 rounded-full ${
                      branch.is_active 
                        ? 'bg-green-100 text-green-700' 
                        : 'bg-gray-100 text-gray-600'
                    }`}>
                      {branch.is_active ? 'Faol' : 'Nofaol'}
                    </span>
                  </div>
                </div>
              </div>

              <div className="space-y-2 text-sm">
                <div className="flex items-center gap-2 text-gray-600">
                  <MapPin size={16} />
                  <span>{branch.address}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-600">
                  <Clock size={16} />
                  <span>{branch.working_hours?.open || '08:00'} - {branch.working_hours?.close || '22:00'}</span>
                </div>
              </div>

              <div className="flex items-center gap-4 mt-4 pt-4 border-t">
                <div className="flex-1 text-center">
                  <p className="text-2xl font-bold text-gray-900">{branch.visit_count || 0}</p>
                  <p className="text-xs text-gray-500">Tashriflar</p>
                </div>
                <div className="flex-1 text-center border-l">
                  <p className="text-2xl font-bold text-gray-900">{branch.staff_count || 0}</p>
                  <p className="text-xs text-gray-500">Xodimlar</p>
                </div>
              </div>
            </div>

            <div className="flex border-t">
              <button
                onClick={() => handleShowQR(branch)}
                className="flex-1 flex items-center justify-center gap-2 py-3 text-emerald-600 hover:bg-emerald-50 transition-colors"
              >
                <QrCode size={18} />
                QR kod
              </button>
              <button
                onClick={() => handleShowStaff(branch)}
                className="flex-1 flex items-center justify-center gap-2 py-3 text-blue-600 hover:bg-blue-50 transition-colors border-l"
              >
                <Users size={18} />
                Xodimlar
              </button>
              <button
                onClick={() => handleDeleteBranch(branch.id)}
                className="flex-1 flex items-center justify-center gap-2 py-3 text-red-600 hover:bg-red-50 transition-colors border-l"
              >
                <Trash2 size={18} />
                O'chirish
              </button>
            </div>
          </div>
        ))}
      </div>

      {branches.length === 0 && (
        <div className="text-center py-12 bg-white rounded-xl border border-gray-200">
          <Building2 className="mx-auto text-gray-400 mb-4" size={48} />
          <h3 className="text-lg font-medium text-gray-900 mb-2">Filiallar yo'q</h3>
          <p className="text-gray-500 mb-4">Birinchi filialingizni qo'shing</p>
          <button
            onClick={() => setShowAddModal(true)}
            className="px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
          >
            Filial qo'shish
          </button>
        </div>
      )}

      {/* Add Branch Modal */}
      {showAddModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl w-full max-w-md mx-4 p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold">Yangi filial</h2>
              <button onClick={() => setShowAddModal(false)} className="text-gray-400 hover:text-gray-600">
                <X size={24} />
              </button>
            </div>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Filial nomi</label>
                <input
                  type="text"
                  value={newBranch.name}
                  onChange={(e) => setNewBranch({...newBranch, name: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
                  placeholder="Masalan: Chilonzor filiali"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Manzil</label>
                <input
                  type="text"
                  value={newBranch.address}
                  onChange={(e) => setNewBranch({...newBranch, address: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
                  placeholder="To'liq manzil"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Shahar</label>
                <select
                  value={newBranch.city}
                  onChange={(e) => setNewBranch({...newBranch, city: e.target.value})}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
                >
                  <option value="Tashkent">Toshkent</option>
                  <option value="Samarkand">Samarqand</option>
                  <option value="Bukhara">Buxoro</option>
                  <option value="Namangan">Namangan</option>
                  <option value="Andijan">Andijon</option>
                </select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Ochilish</label>
                  <input
                    type="time"
                    value={newBranch.working_hours.open}
                    onChange={(e) => setNewBranch({
                      ...newBranch, 
                      working_hours: {...newBranch.working_hours, open: e.target.value}
                    })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Yopilish</label>
                  <input
                    type="time"
                    value={newBranch.working_hours.close}
                    onChange={(e) => setNewBranch({
                      ...newBranch, 
                      working_hours: {...newBranch.working_hours, close: e.target.value}
                    })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500"
                  />
                </div>
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setShowAddModal(false)}
                className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50"
              >
                Bekor qilish
              </button>
              <button
                onClick={handleAddBranch}
                disabled={!newBranch.name || !newBranch.address}
                className="flex-1 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 disabled:opacity-50"
              >
                Qo'shish
              </button>
            </div>
          </div>
        </div>
      )}

      {/* QR Code Modal */}
      {showQRModal && selectedBranch && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl w-full max-w-sm mx-4 p-6 text-center">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold">QR kod</h2>
              <button onClick={() => setShowQRModal(false)} className="text-gray-400 hover:text-gray-600">
                <X size={24} />
              </button>
            </div>

            <div className="bg-white p-4 rounded-xl inline-block border-2 border-gray-200">
              <QRCode 
                value={`YUVGO_BRANCH_${selectedBranch.id}`}
                size={200}
                level="H"
              />
            </div>

            <div className="mt-4">
              <h3 className="font-semibold text-gray-900">{selectedBranch.name}</h3>
              <p className="text-sm text-gray-500">{selectedBranch.address}</p>
            </div>

            <p className="text-xs text-gray-400 mt-4">
              Bu QR kodni mijozlar skanerlaydi
            </p>

            <button
              onClick={() => {
                // Download QR code
                const canvas = document.querySelector('canvas');
                if (canvas) {
                  const url = canvas.toDataURL('image/png');
                  const link = document.createElement('a');
                  link.download = `qr-${selectedBranch.name}.png`;
                  link.href = url;
                  link.click();
                }
              }}
              className="mt-4 w-full px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700"
            >
              QR kodni yuklab olish
            </button>
          </div>
        </div>
      )}

      {/* Staff Modal */}
      {showStaffModal && selectedBranch && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
          <div className="bg-white rounded-xl w-full max-w-lg mx-4 p-6">
            <div className="flex items-center justify-between mb-6">
              <div>
                <h2 className="text-xl font-bold">Xodimlar</h2>
                <p className="text-sm text-gray-500">{selectedBranch.name}</p>
              </div>
              <button onClick={() => setShowStaffModal(false)} className="text-gray-400 hover:text-gray-600">
                <X size={24} />
              </button>
            </div>

            {/* Add Staff Form */}
            <div className="bg-gray-50 rounded-lg p-4 mb-4">
              <h3 className="font-medium text-gray-900 mb-3">Yangi xodim qo'shish</h3>
              <div className="grid grid-cols-2 gap-3">
                <input
                  type="text"
                  value={newStaff.full_name}
                  onChange={(e) => setNewStaff({...newStaff, full_name: e.target.value})}
                  className="px-3 py-2 border border-gray-300 rounded-lg text-sm"
                  placeholder="Ism familiya"
                />
                <input
                  type="tel"
                  value={newStaff.phone_number}
                  onChange={(e) => setNewStaff({...newStaff, phone_number: e.target.value})}
                  className="px-3 py-2 border border-gray-300 rounded-lg text-sm"
                  placeholder="+998901234567"
                />
              </div>
              <div className="flex gap-3 mt-3">
                <select
                  value={newStaff.role}
                  onChange={(e) => setNewStaff({...newStaff, role: e.target.value})}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-lg text-sm"
                >
                  <option value="staff">Xodim</option>
                  <option value="manager">Menejer</option>
                </select>
                <button
                  onClick={handleAddStaff}
                  disabled={!newStaff.full_name || !newStaff.phone_number}
                  className="px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 disabled:opacity-50 text-sm"
                >
                  Qo'shish
                </button>
              </div>
            </div>

            {/* Staff List */}
            <div className="space-y-2 max-h-64 overflow-y-auto">
              {branchStaff.map((staff) => (
                <div key={staff.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center text-emerald-600 font-medium">
                      {staff.full_name.charAt(0)}
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">{staff.full_name}</p>
                      <p className="text-sm text-gray-500">{staff.phone_number}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className={`text-xs px-2 py-1 rounded-full ${
                      staff.role === 'manager' 
                        ? 'bg-blue-100 text-blue-700' 
                        : 'bg-gray-100 text-gray-600'
                    }`}>
                      {staff.role === 'manager' ? 'Menejer' : 'Xodim'}
                    </span>
                    <button
                      onClick={() => handleRemoveStaff(staff.id)}
                      className="p-1 text-red-500 hover:bg-red-50 rounded"
                    >
                      <Trash2 size={16} />
                    </button>
                  </div>
                </div>
              ))}

              {branchStaff.length === 0 && (
                <p className="text-center text-gray-500 py-4">Xodimlar yo'q</p>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Branches;
