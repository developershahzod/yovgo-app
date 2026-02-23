import React, { useState, useEffect, useRef } from 'react';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import axios from 'axios';
import { 
  Building2, Plus, MapPin, Clock, Users, QrCode, 
  Edit2, Trash2, Eye, X, Check, Phone, ChevronRight,
  Image, DollarSign, Car, Droplets, Sparkles, Save,
  Upload, Camera, Navigation, ExternalLink, Copy, ChevronDown
} from 'lucide-react';
import { QRCodeCanvas } from 'qrcode.react';

const DEFAULT_SERVICE_PRICES = [
  { name: 'Express yuvish', price: 50000, icon: 'express' },
  { name: 'Sedan', price: 110000, icon: 'sedan' },
  { name: 'Krossover / SUV', price: 120000, icon: 'suv' },
];

const formatPrice = (price) => {
  return new Intl.NumberFormat('uz-UZ').format(price) + ' so\'m';
};

const Branches = () => {
  const { API_URL, merchant } = useMerchantAuth();
  const [branches, setBranches] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showEditModal, setShowEditModal] = useState(false);
  const [showQRModal, setShowQRModal] = useState(false);
  const [showStaffModal, setShowStaffModal] = useState(false);
  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedBranch, setSelectedBranch] = useState(null);
  const [branchStaff, setBranchStaff] = useState([]);
  const [activeTab, setActiveTab] = useState('info');
  const [saving, setSaving] = useState(false);
  const [uploading, setUploading] = useState(false);
  const bannerInputRef = useRef(null);
  const galleryInputRef = useRef(null);

  const emptyBranch = {
    name: '',
    address: '',
    city: 'Tashkent',
    phone_number: '',
    latitude: null,
    longitude: null,
    working_hours: { open: '08:00', close: '22:00' },
    banner_url: '',
    gallery_urls: [],
    service_prices: [...DEFAULT_SERVICE_PRICES],
  };

  const [formData, setFormData] = useState({ ...emptyBranch });

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
      const partnerId = merchant?.partner?.id || merchant?.partner_id;
      const response = await axios.get(
        `${API_URL}/api/partner/merchant/branches`, { params: { partner_id: partnerId } }
      );
      setBranches(response.data || []);
    } catch (error) {
      console.error('Failed to fetch branches:', error);
      setBranches([]);
    } finally {
      setLoading(false);
    }
  };

  const handleAddBranch = async () => {
    try {
      setSaving(true);
      const partnerId = merchant?.partner?.id || merchant?.partner_id;
      if (!partnerId) {
        alert('Xatolik: Partner ID topilmadi. Qayta login qiling.');
        return;
      }
      const response = await axios.post(
        `${API_URL}/api/partner/merchant/branches`, formData, { params: { partner_id: partnerId } }
      );
      setBranches([...branches, response.data]);
      setShowAddModal(false);
      setFormData({ ...emptyBranch });
      setActiveTab('info');
    } catch (error) {
      console.error('Failed to add branch:', error);
      const msg = error.response?.data?.detail || error.message || 'Filial qo\'shishda xatolik';
      alert(typeof msg === 'string' ? msg : JSON.stringify(msg));
    } finally {
      setSaving(false);
    }
  };

  const handleUpdateBranch = async () => {
    if (!selectedBranch) return;
    try {
      setSaving(true);
      const response = await axios.put(
        `${API_URL}/api/partner/merchant/branches/${selectedBranch.id}`, formData
      );
      setBranches(branches.map(b => b.id === selectedBranch.id ? { ...b, ...response.data } : b));
      setShowEditModal(false);
      setSelectedBranch(null);
    } catch (error) {
      console.error('Failed to update branch:', error);
      const msg = error.response?.data?.detail || error.message || 'Filialni yangilashda xatolik';
      alert(typeof msg === 'string' ? msg : JSON.stringify(msg));
    } finally {
      setSaving(false);
    }
  };

  const handleDeleteBranch = async (branchId) => {
    if (!window.confirm('Filialni o\'chirmoqchimisiz?')) return;
    try {
      await axios.delete(`${API_URL}/api/partner/merchant/branches/${branchId}`);
      setBranches(branches.filter(b => b.id !== branchId));
    } catch (error) {
      console.error('Failed to delete branch:', error);
      const msg = error.response?.data?.detail || error.message || 'Filialni o\'chirishda xatolik';
      alert(typeof msg === 'string' ? msg : JSON.stringify(msg));
    }
  };

  const handleEditBranch = (branch) => {
    setSelectedBranch(branch);
    setFormData({
      name: branch.name || '',
      address: branch.address || '',
      city: branch.city || 'Tashkent',
      phone_number: branch.phone_number || '',
      latitude: branch.latitude || null,
      longitude: branch.longitude || null,
      working_hours: branch.working_hours || { open: '08:00', close: '22:00' },
      banner_url: branch.banner_url || '',
      gallery_urls: branch.gallery_urls || [],
      service_prices: branch.service_prices?.length > 0 ? branch.service_prices : [...DEFAULT_SERVICE_PRICES],
    });
    setActiveTab('info');
    setShowEditModal(true);
  };

  const handleViewBranch = (branch) => {
    setSelectedBranch(branch);
    setShowDetailModal(true);
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
      setBranchStaff([]);
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
      if (response.data.pin_code) {
        alert(`Xodim qo'shildi! PIN kod: ${response.data.pin_code}`);
      }
    } catch (error) {
      console.error('Failed to add staff:', error);
      alert(error.response?.data?.detail || 'Xodim qo\'shishda xatolik');
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

  const addServicePrice = () => {
    setFormData({
      ...formData,
      service_prices: [...formData.service_prices, { name: '', price: 0, icon: 'custom' }]
    });
  };

  const updateServicePrice = (index, field, value) => {
    const updated = [...formData.service_prices];
    updated[index] = { ...updated[index], [field]: field === 'price' ? parseInt(value) || 0 : value };
    setFormData({ ...formData, service_prices: updated });
  };

  const removeServicePrice = (index) => {
    setFormData({
      ...formData,
      service_prices: formData.service_prices.filter((_, i) => i !== index)
    });
  };

  const uploadImage = async (file) => {
    const fd = new FormData();
    fd.append('file', file);
    fd.append('category', 'gallery');
    const response = await axios.post(`${API_URL}/api/upload/image`, fd, {
      headers: { 'Content-Type': 'multipart/form-data' }
    });
    return response.data.full_url || response.data.url;
  };

  const handleBannerUpload = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    try {
      setUploading(true);
      const url = await uploadImage(file);
      setFormData(prev => ({ ...prev, banner_url: url }));
    } catch (error) {
      console.error('Banner upload failed:', error);
      alert('Rasm yuklashda xatolik');
    } finally {
      setUploading(false);
      if (bannerInputRef.current) bannerInputRef.current.value = '';
    }
  };

  const handleGalleryUpload = async (e) => {
    const files = Array.from(e.target.files || []);
    if (files.length === 0) return;
    try {
      setUploading(true);
      const urls = [];
      for (const file of files) {
        const url = await uploadImage(file);
        urls.push(url);
      }
      setFormData(prev => ({ ...prev, gallery_urls: [...prev.gallery_urls, ...urls] }));
    } catch (error) {
      console.error('Gallery upload failed:', error);
      alert('Rasmlar yuklashda xatolik');
    } finally {
      setUploading(false);
      if (galleryInputRef.current) galleryInputRef.current.value = '';
    }
  };

  const removeGalleryUrl = (index) => {
    setFormData({
      ...formData,
      gallery_urls: formData.gallery_urls.filter((_, i) => i !== index)
    });
  };

  const getWorkingHoursDisplay = (wh) => {
    if (!wh) return '08:00 - 22:00';
    if (typeof wh === 'string') return wh;
    if (typeof wh === 'object') {
      const o = wh.open || wh.monday?.open || '08:00';
      const c = wh.close || wh.monday?.close || '22:00';
      return `${o} - ${c}`;
    }
    return '08:00 - 22:00';
  };

  const getServiceIcon = (icon) => {
    switch (icon) {
      case 'express': return <Sparkles size={18} className="text-yellow-500" />;
      case 'sedan': return <Car size={18} className="text-blue-500" />;
      case 'suv': return <Car size={18} className="text-emerald-500" />;
      default: return <Droplets size={18} className="text-cyan-500" />;
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
          <p className="text-gray-500">Barcha filiallaringizni boshqaring</p>
        </div>
        <button
          onClick={() => {
            setFormData({ ...emptyBranch });
            setShowAddModal(true);
          }}
          className="flex items-center gap-2 px-5 py-2.5 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 transition-colors font-medium shadow-sm"
        >
          <Plus size={20} />
          Yangi filial
        </button>
      </div>

      {/* Branches Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
        {branches.map((branch) => (
          <div key={branch.id} className="bg-white rounded-2xl border border-gray-100 overflow-hidden shadow-sm hover:shadow-md transition-shadow">
            {/* Branch Banner */}
            <div className="relative h-40 bg-gradient-to-br from-emerald-400 to-emerald-600 overflow-hidden">
              {branch.banner_url ? (
                <img
                  src={branch.banner_url}
                  alt={branch.name}
                  className="w-full h-full object-cover"
                  onError={(e) => { e.target.style.display = 'none'; e.target.nextSibling && (e.target.nextSibling.style.display = 'flex'); }}
                />
              ) : null}
              <div className="w-full h-full flex items-center justify-center" style={{display: branch.banner_url ? 'none' : 'flex'}}>
                <Building2 size={48} className="text-white/40" />
              </div>
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
              <div className="absolute bottom-3 left-4 right-4">
                <h3 className="text-lg font-bold text-white">{branch.name}</h3>
                <div className="flex items-center gap-1 text-white/80 text-sm mt-0.5">
                  <MapPin size={14} />
                  <span className="truncate">{branch.address}</span>
                </div>
              </div>
              <div className="absolute top-3 right-3">
                <span className={`text-xs px-2.5 py-1 rounded-full font-medium ${
                  branch.is_active 
                    ? 'bg-green-500/90 text-white' 
                    : 'bg-gray-500/90 text-white'
                }`}>
                  {branch.is_active ? 'Faol' : 'Nofaol'}
                </span>
              </div>
            </div>

            {/* Branch Info */}
            <div className="p-4">
              {/* Working Hours & Phone */}
              <div className="flex items-center gap-4 text-sm text-gray-600 mb-3">
                <div className="flex items-center gap-1.5">
                  <Clock size={14} className="text-emerald-500" />
                  <span>{getWorkingHoursDisplay(branch.working_hours)}</span>
                </div>
                {branch.phone_number && (
                  <div className="flex items-center gap-1.5">
                    <Phone size={14} className="text-emerald-500" />
                    <span>{branch.phone_number}</span>
                  </div>
                )}
              </div>

              {/* Service Prices Preview */}
              {branch.service_prices && branch.service_prices.length > 0 && (
                <div className="mb-3">
                  <p className="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">Xizmat narxlari</p>
                  <div className="space-y-1.5">
                    {branch.service_prices.slice(0, 3).map((sp, idx) => (
                      <div key={idx} className="flex items-center justify-between text-sm">
                        <div className="flex items-center gap-2">
                          {getServiceIcon(sp.icon)}
                          <span className="text-gray-700">{sp.name}</span>
                        </div>
                        <span className="font-semibold text-gray-900">{formatPrice(sp.price)}</span>
                      </div>
                    ))}
                    {branch.service_prices.length > 3 && (
                      <p className="text-xs text-emerald-600 font-medium">+{branch.service_prices.length - 3} boshqa xizmat</p>
                    )}
                  </div>
                </div>
              )}

              {/* Gallery Preview */}
              {branch.gallery_urls && branch.gallery_urls.length > 0 && (
                <div className="mb-3">
                  <div className="flex gap-1.5 overflow-hidden rounded-lg">
                    {branch.gallery_urls.slice(0, 3).map((url, idx) => (
                      <div key={idx} className="w-16 h-16 rounded-md overflow-hidden bg-gray-100 flex-shrink-0">
                        <img src={url} alt="" className="w-full h-full object-cover" onError={(e) => { e.target.style.display='none'; }} />
                      </div>
                    ))}
                    {branch.gallery_urls.length > 3 && (
                      <div className="w-16 h-16 rounded-md bg-gray-100 flex items-center justify-center text-gray-500 text-xs font-medium flex-shrink-0">
                        +{branch.gallery_urls.length - 3}
                      </div>
                    )}
                  </div>
                </div>
              )}

              {/* Stats */}
              <div className="flex items-center gap-4 pt-3 border-t border-gray-100">
                <div className="flex-1 text-center">
                  <p className="text-xl font-bold text-gray-900">{branch.visit_count || 0}</p>
                  <p className="text-xs text-gray-500">Tashriflar</p>
                </div>
                <div className="w-px h-8 bg-gray-200" />
                <div className="flex-1 text-center">
                  <p className="text-xl font-bold text-gray-900">{branch.staff_count || 0}</p>
                  <p className="text-xs text-gray-500">Xodimlar</p>
                </div>
                <div className="w-px h-8 bg-gray-200" />
                <div className="flex-1 text-center">
                  <p className="text-xl font-bold text-gray-900">{branch.service_prices?.length || 0}</p>
                  <p className="text-xs text-gray-500">Xizmatlar</p>
                </div>
              </div>
            </div>

            {/* Actions */}
            <div className="grid grid-cols-5 border-t border-gray-100">
              <button
                onClick={() => handleViewBranch(branch)}
                className="flex flex-col items-center justify-center gap-1 py-3 text-gray-500 hover:bg-gray-50 hover:text-emerald-600 transition-colors"
              >
                <Eye size={16} />
                <span className="text-[10px] font-medium">Ko'rish</span>
              </button>
              <button
                onClick={() => handleEditBranch(branch)}
                className="flex flex-col items-center justify-center gap-1 py-3 text-gray-500 hover:bg-gray-50 hover:text-blue-600 transition-colors"
              >
                <Edit2 size={16} />
                <span className="text-[10px] font-medium">Tahrirlash</span>
              </button>
              <button
                onClick={() => handleShowQR(branch)}
                className="flex flex-col items-center justify-center gap-1 py-3 text-gray-500 hover:bg-gray-50 hover:text-purple-600 transition-colors"
              >
                <QrCode size={16} />
                <span className="text-[10px] font-medium">QR kod</span>
              </button>
              <button
                onClick={() => handleShowStaff(branch)}
                className="flex flex-col items-center justify-center gap-1 py-3 text-gray-500 hover:bg-gray-50 hover:text-orange-600 transition-colors"
              >
                <Users size={16} />
                <span className="text-[10px] font-medium">Xodimlar</span>
              </button>
              <button
                onClick={() => handleDeleteBranch(branch.id)}
                className="flex flex-col items-center justify-center gap-1 py-3 text-gray-500 hover:bg-red-50 hover:text-red-600 transition-colors"
              >
                <Trash2 size={16} />
                <span className="text-[10px] font-medium">O'chirish</span>
              </button>
            </div>
          </div>
        ))}
      </div>

      {branches.length === 0 && (
        <div className="text-center py-16 bg-white rounded-2xl border border-gray-100 shadow-sm">
          <div className="w-20 h-20 bg-emerald-50 rounded-2xl flex items-center justify-center mx-auto mb-4">
            <Building2 className="text-emerald-500" size={40} />
          </div>
          <h3 className="text-lg font-bold text-gray-900 mb-2">Filiallar yo'q</h3>
          <p className="text-gray-500 mb-6 max-w-sm mx-auto">Birinchi filialingizni qo'shing va xizmat narxlarini belgilang</p>
          <button
            onClick={() => {
              setFormData({ ...emptyBranch });
              setShowAddModal(true);
            }}
            className="px-6 py-2.5 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 font-medium"
          >
            <Plus size={18} className="inline mr-2" />
            Filial qo'shish
          </button>
        </div>
      )}

      {/* ==================== ADD / EDIT BRANCH MODAL ==================== */}
      {(showAddModal || showEditModal) && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden flex flex-col">
            {/* Modal Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100">
              <h2 className="text-xl font-bold text-gray-900">
                {showEditModal ? 'Filialni tahrirlash' : 'Yangi filial qo\'shish'}
              </h2>
              <button 
                onClick={() => { setShowAddModal(false); setShowEditModal(false); }}
                className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <X size={20} className="text-gray-500" />
              </button>
            </div>

            {/* Tabs */}
            <div className="flex border-b border-gray-100 px-6">
              {[
                { id: 'info', label: 'Asosiy ma\'lumot', icon: Building2 },
                { id: 'prices', label: 'Xizmat narxlari', icon: DollarSign },
                { id: 'gallery', label: 'Galereya', icon: Image },
                { id: 'location', label: 'Lokatsiya', icon: MapPin },
              ].map(tab => (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center gap-2 px-4 py-3 text-sm font-medium border-b-2 transition-colors ${
                    activeTab === tab.id
                      ? 'border-emerald-500 text-emerald-600'
                      : 'border-transparent text-gray-500 hover:text-gray-700'
                  }`}
                >
                  <tab.icon size={16} />
                  {tab.label}
                </button>
              ))}
            </div>

            {/* Tab Content */}
            <div className="flex-1 overflow-y-auto p-6">
              {/* INFO TAB */}
              {activeTab === 'info' && (
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">Filial nomi *</label>
                    <input
                      type="text"
                      value={formData.name}
                      onChange={(e) => setFormData({...formData, name: e.target.value})}
                      className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                      placeholder="Masalan: Chilonzor filiali"
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">Manzil *</label>
                    <input
                      type="text"
                      value={formData.address}
                      onChange={(e) => setFormData({...formData, address: e.target.value})}
                      className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                      placeholder="To'liq manzil"
                    />
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1.5">Shahar</label>
                      <select
                        value={formData.city}
                        onChange={(e) => setFormData({...formData, city: e.target.value})}
                        className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                      >
                        <option value="Tashkent">Toshkent</option>
                        <option value="Samarkand">Samarqand</option>
                        <option value="Bukhara">Buxoro</option>
                        <option value="Namangan">Namangan</option>
                        <option value="Andijan">Andijon</option>
                        <option value="Fergana">Farg'ona</option>
                        <option value="Nukus">Nukus</option>
                        <option value="Karshi">Qarshi</option>
                        <option value="Navoi">Navoiy</option>
                        <option value="Jizzakh">Jizzax</option>
                        <option value="Urgench">Urganch</option>
                        <option value="Termez">Termiz</option>
                        <option value="Gulistan">Guliston</option>
                      </select>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1.5">Telefon raqam</label>
                      <input
                        type="tel"
                        value={formData.phone_number}
                        onChange={(e) => setFormData({...formData, phone_number: e.target.value})}
                        className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                        placeholder="+998 90 123 45 67"
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">Ish vaqti</label>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-xs text-gray-500 mb-1">Ochilish</label>
                        <input
                          type="time"
                          value={formData.working_hours?.open || '08:00'}
                          onChange={(e) => setFormData({
                            ...formData, 
                            working_hours: {...formData.working_hours, open: e.target.value}
                          })}
                          className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                        />
                      </div>
                      <div>
                        <label className="block text-xs text-gray-500 mb-1">Yopilish</label>
                        <input
                          type="time"
                          value={formData.working_hours?.close || '22:00'}
                          onChange={(e) => setFormData({
                            ...formData, 
                            working_hours: {...formData.working_hours, close: e.target.value}
                          })}
                          className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                        />
                      </div>
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-1.5">Banner rasm</label>
                    <input
                      type="file"
                      ref={bannerInputRef}
                      accept="image/jpeg,image/png,image/webp,image/gif"
                      onChange={handleBannerUpload}
                      className="hidden"
                    />
                    {formData.banner_url ? (
                      <div className="relative mt-1 rounded-xl overflow-hidden h-36 bg-gray-100 group">
                        <img src={formData.banner_url} alt="Banner" className="w-full h-full object-cover" />
                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-3">
                          <button
                            type="button"
                            onClick={() => bannerInputRef.current?.click()}
                            className="px-3 py-1.5 bg-white text-gray-800 rounded-lg text-sm font-medium hover:bg-gray-100"
                          >
                            <Camera size={14} className="inline mr-1" />
                            Almashtirish
                          </button>
                          <button
                            type="button"
                            onClick={() => setFormData({...formData, banner_url: ''})}
                            className="px-3 py-1.5 bg-red-500 text-white rounded-lg text-sm font-medium hover:bg-red-600"
                          >
                            <Trash2 size={14} className="inline mr-1" />
                            O'chirish
                          </button>
                        </div>
                      </div>
                    ) : (
                      <button
                        type="button"
                        onClick={() => bannerInputRef.current?.click()}
                        disabled={uploading}
                        className="w-full mt-1 flex flex-col items-center justify-center py-8 border-2 border-dashed border-gray-200 rounded-xl hover:border-emerald-400 hover:bg-emerald-50/50 transition-colors cursor-pointer"
                      >
                        {uploading ? (
                          <div className="w-8 h-8 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin mb-2" />
                        ) : (
                          <Upload size={28} className="text-gray-400 mb-2" />
                        )}
                        <span className="text-sm font-medium text-gray-600">Banner rasm yuklash</span>
                        <span className="text-xs text-gray-400 mt-1">JPG, PNG, WebP — max 5MB</span>
                      </button>
                    )}
                  </div>
                </div>
              )}

              {/* PRICES TAB */}
              {activeTab === 'prices' && (
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-semibold text-gray-900">Xizmat narxlari</h3>
                      <p className="text-sm text-gray-500">Moyxona xizmatlarining narxlarini belgilang</p>
                    </div>
                    <button
                      onClick={addServicePrice}
                      className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 text-emerald-600 rounded-lg hover:bg-emerald-100 text-sm font-medium transition-colors"
                    >
                      <Plus size={16} />
                      Qo'shish
                    </button>
                  </div>

                  <div className="space-y-3">
                    {formData.service_prices.map((sp, index) => (
                      <div key={index} className="flex items-center gap-3 p-3 bg-gray-50 rounded-xl">
                        <select
                          value={sp.icon}
                          onChange={(e) => updateServicePrice(index, 'icon', e.target.value)}
                          className="w-28 px-2 py-2 border border-gray-200 rounded-lg text-sm bg-white"
                        >
                          <option value="express">Express</option>
                          <option value="sedan">Sedan</option>
                          <option value="suv">SUV/Krossover</option>
                          <option value="custom">Boshqa</option>
                        </select>
                        <input
                          type="text"
                          value={sp.name}
                          onChange={(e) => updateServicePrice(index, 'name', e.target.value)}
                          className="flex-1 px-3 py-2 border border-gray-200 rounded-lg text-sm bg-white"
                          placeholder="Xizmat nomi"
                        />
                        <div className="relative">
                          <input
                            type="number"
                            value={sp.price}
                            onChange={(e) => updateServicePrice(index, 'price', e.target.value)}
                            className="w-36 px-3 py-2 border border-gray-200 rounded-lg text-sm bg-white pr-14"
                            placeholder="Narx"
                          />
                          <span className="absolute right-3 top-1/2 -translate-y-1/2 text-xs text-gray-400">so'm</span>
                        </div>
                        <button
                          onClick={() => removeServicePrice(index)}
                          className="p-2 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                    ))}
                  </div>

                  {formData.service_prices.length === 0 && (
                    <div className="text-center py-8 bg-gray-50 rounded-xl">
                      <DollarSign size={32} className="mx-auto text-gray-300 mb-2" />
                      <p className="text-gray-500 text-sm">Xizmat narxlari qo'shilmagan</p>
                      <button
                        onClick={() => setFormData({ ...formData, service_prices: [...DEFAULT_SERVICE_PRICES] })}
                        className="mt-3 text-sm text-emerald-600 font-medium hover:underline"
                      >
                        Standart narxlarni qo'shish
                      </button>
                    </div>
                  )}

                  {/* Price Preview */}
                  {formData.service_prices.length > 0 && (
                    <div className="mt-6 p-4 bg-emerald-50 rounded-xl border border-emerald-100">
                      <h4 className="text-sm font-semibold text-emerald-800 mb-3">Ko'rinishi</h4>
                      <div className="space-y-2">
                        {formData.service_prices.map((sp, idx) => (
                          <div key={idx} className="flex items-center justify-between bg-white px-3 py-2 rounded-lg">
                            <div className="flex items-center gap-2">
                              {getServiceIcon(sp.icon)}
                              <span className="text-sm font-medium text-gray-800">{sp.name || 'Nomsiz'}</span>
                            </div>
                            <span className="text-sm font-bold text-emerald-700">{formatPrice(sp.price)}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </div>
              )}

              {/* GALLERY TAB */}
              {activeTab === 'gallery' && (
                <div className="space-y-4">
                  <input
                    type="file"
                    ref={galleryInputRef}
                    accept="image/jpeg,image/png,image/webp,image/gif"
                    multiple
                    onChange={handleGalleryUpload}
                    className="hidden"
                  />
                  <div className="flex items-center justify-between">
                    <div>
                      <h3 className="font-semibold text-gray-900">Galereya</h3>
                      <p className="text-sm text-gray-500">Filial rasmlarini yuklang</p>
                    </div>
                    <button
                      onClick={() => galleryInputRef.current?.click()}
                      disabled={uploading}
                      className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 text-emerald-600 rounded-lg hover:bg-emerald-100 text-sm font-medium transition-colors disabled:opacity-50"
                    >
                      {uploading ? (
                        <div className="w-4 h-4 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin" />
                      ) : (
                        <Upload size={16} />
                      )}
                      Rasm yuklash
                    </button>
                  </div>

                  {formData.gallery_urls.length > 0 ? (
                    <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                      {formData.gallery_urls.map((url, index) => (
                        <div key={index} className="relative group rounded-xl overflow-hidden bg-gray-100 aspect-square">
                          <img src={url} alt={`Gallery ${index + 1}`} className="w-full h-full object-cover" 
                            onError={(e) => { e.target.src = 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><rect fill="%23f3f4f6" width="100" height="100"/><text x="50" y="55" text-anchor="middle" fill="%239ca3af" font-size="12">Rasm</text></svg>'; }} />
                          <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                            <button
                              onClick={() => removeGalleryUrl(index)}
                              className="p-2 bg-red-500 text-white rounded-full hover:bg-red-600"
                            >
                              <Trash2 size={16} />
                            </button>
                          </div>
                        </div>
                      ))}
                      {/* Add more button */}
                      <button
                        onClick={() => galleryInputRef.current?.click()}
                        disabled={uploading}
                        className="aspect-square rounded-xl border-2 border-dashed border-gray-200 hover:border-emerald-400 hover:bg-emerald-50/50 flex flex-col items-center justify-center transition-colors cursor-pointer"
                      >
                        {uploading ? (
                          <div className="w-6 h-6 border-2 border-emerald-500 border-t-transparent rounded-full animate-spin" />
                        ) : (
                          <>
                            <Plus size={24} className="text-gray-400 mb-1" />
                            <span className="text-xs text-gray-400">Qo'shish</span>
                          </>
                        )}
                      </button>
                    </div>
                  ) : (
                    <div 
                      onClick={() => !uploading && galleryInputRef.current?.click()}
                      className="text-center py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-200 hover:border-emerald-400 hover:bg-emerald-50/30 transition-colors cursor-pointer"
                    >
                      {uploading ? (
                        <div className="w-10 h-10 border-3 border-emerald-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
                      ) : (
                        <Camera size={40} className="mx-auto text-gray-300 mb-3" />
                      )}
                      <p className="text-gray-500 font-medium">Rasmlar qo'shilmagan</p>
                      <p className="text-sm text-gray-400 mt-1">Bosing yoki rasmlarni tanlang</p>
                      <p className="text-xs text-gray-300 mt-2">JPG, PNG, WebP — max 5MB har biri</p>
                    </div>
                  )}
                </div>
              )}

              {/* LOCATION TAB */}
              {activeTab === 'location' && (
                <div className="space-y-4">
                  <div>
                    <h3 className="font-semibold text-gray-900">Lokatsiya</h3>
                    <p className="text-sm text-gray-500">Filial joylashuvini xaritada ko'rsating</p>
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1.5">Kenglik (Latitude)</label>
                      <input
                        type="text"
                        inputMode="decimal"
                        value={formData.latitude ?? ''}
                        onChange={(e) => {
                          const v = e.target.value;
                          if (v === '' || v === '-' || /^-?\d*\.?\d*$/.test(v)) {
                            setFormData({...formData, latitude: v === '' || v === '-' ? null : (v.endsWith('.') ? v : parseFloat(v) || null)});
                          }
                        }}
                        className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                        placeholder="41.311081"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1.5">Uzunlik (Longitude)</label>
                      <input
                        type="text"
                        inputMode="decimal"
                        value={formData.longitude ?? ''}
                        onChange={(e) => {
                          const v = e.target.value;
                          if (v === '' || v === '-' || /^-?\d*\.?\d*$/.test(v)) {
                            setFormData({...formData, longitude: v === '' || v === '-' ? null : (v.endsWith('.') ? v : parseFloat(v) || null)});
                          }
                        }}
                        className="w-full px-4 py-2.5 border border-gray-200 rounded-xl focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 outline-none transition-all"
                        placeholder="69.279737"
                      />
                    </div>
                  </div>

                  {/* Map Preview */}
                  {formData.latitude && formData.longitude ? (
                    <div className="rounded-xl overflow-hidden border border-gray-200">
                      <iframe
                        title="Branch Location"
                        width="100%"
                        height="300"
                        frameBorder="0"
                        src={`https://www.openstreetmap.org/export/embed.html?bbox=${formData.longitude - 0.005},${formData.latitude - 0.003},${formData.longitude + 0.005},${formData.latitude + 0.003}&layer=mapnik&marker=${formData.latitude},${formData.longitude}`}
                        style={{ border: 0 }}
                      />
                      <div className="p-3 bg-gray-50 flex items-center justify-between">
                        <span className="text-sm text-gray-600">
                          {formData.latitude.toFixed(6)}, {formData.longitude.toFixed(6)}
                        </span>
                        <a
                          href={`https://www.google.com/maps?q=${formData.latitude},${formData.longitude}`}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="flex items-center gap-1 text-sm text-emerald-600 hover:underline"
                        >
                          <ExternalLink size={14} />
                          Google Maps
                        </a>
                      </div>
                    </div>
                  ) : (
                    <div className="text-center py-12 bg-gray-50 rounded-xl border-2 border-dashed border-gray-200">
                      <Navigation size={40} className="mx-auto text-gray-300 mb-3" />
                      <p className="text-gray-500 font-medium">Lokatsiya belgilanmagan</p>
                      <p className="text-sm text-gray-400 mt-1">Kenglik va uzunlik koordinatalarini kiriting</p>
                      <button
                        onClick={() => {
                          if (navigator.geolocation) {
                            navigator.geolocation.getCurrentPosition(
                              (pos) => {
                                setFormData({
                                  ...formData,
                                  latitude: pos.coords.latitude,
                                  longitude: pos.coords.longitude
                                });
                              },
                              () => alert('Joylashuvni aniqlab bo\'lmadi')
                            );
                          }
                        }}
                        className="mt-4 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 text-sm font-medium"
                      >
                        <Navigation size={16} className="inline mr-1.5" />
                        Joriy joylashuvni aniqlash
                      </button>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Modal Footer */}
            <div className="flex items-center justify-between px-6 py-4 border-t border-gray-100 bg-gray-50">
              <button
                onClick={() => { setShowAddModal(false); setShowEditModal(false); }}
                className="px-5 py-2.5 border border-gray-200 text-gray-700 rounded-xl hover:bg-gray-100 font-medium transition-colors"
              >
                Bekor qilish
              </button>
              <button
                onClick={showEditModal ? handleUpdateBranch : handleAddBranch}
                disabled={!formData.name || !formData.address || saving}
                className="flex items-center gap-2 px-6 py-2.5 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 disabled:opacity-50 font-medium transition-colors"
              >
                {saving ? (
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                ) : (
                  <Save size={18} />
                )}
                {showEditModal ? 'Saqlash' : 'Qo\'shish'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ==================== BRANCH DETAIL MODAL ==================== */}
      {showDetailModal && selectedBranch && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl w-full max-w-lg max-h-[90vh] overflow-hidden flex flex-col">
            {/* Banner */}
            <div className="relative h-48 bg-gradient-to-br from-emerald-400 to-emerald-600">
              {selectedBranch.banner_url ? (
                <img src={selectedBranch.banner_url} alt={selectedBranch.name} className="w-full h-full object-cover" />
              ) : (
                <div className="w-full h-full flex items-center justify-center">
                  <Building2 size={64} className="text-white/30" />
                </div>
              )}
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent" />
              <button 
                onClick={() => setShowDetailModal(false)}
                className="absolute top-3 right-3 p-2 bg-black/30 hover:bg-black/50 rounded-full text-white transition-colors"
              >
                <X size={20} />
              </button>
              <div className="absolute bottom-4 left-5 right-5">
                <h2 className="text-2xl font-bold text-white">{selectedBranch.name}</h2>
                <div className="flex items-center gap-2 text-white/80 text-sm mt-1">
                  <MapPin size={14} />
                  <span>{selectedBranch.address}, {selectedBranch.city}</span>
                </div>
              </div>
            </div>

            <div className="flex-1 overflow-y-auto p-5 space-y-5">
              {/* Info Cards */}
              <div className="grid grid-cols-2 gap-3">
                <div className="p-3 bg-emerald-50 rounded-xl">
                  <div className="flex items-center gap-2 mb-1">
                    <Clock size={16} className="text-emerald-600" />
                    <span className="text-xs font-medium text-emerald-600">Ish vaqti</span>
                  </div>
                  <p className="text-sm font-semibold text-gray-900">{getWorkingHoursDisplay(selectedBranch.working_hours)}</p>
                </div>
                {selectedBranch.phone_number && (
                  <div className="p-3 bg-blue-50 rounded-xl">
                    <div className="flex items-center gap-2 mb-1">
                      <Phone size={16} className="text-blue-600" />
                      <span className="text-xs font-medium text-blue-600">Telefon</span>
                    </div>
                    <p className="text-sm font-semibold text-gray-900">{selectedBranch.phone_number}</p>
                  </div>
                )}
              </div>

              {/* Service Prices */}
              {selectedBranch.service_prices && selectedBranch.service_prices.length > 0 && (
                <div>
                  <h3 className="text-sm font-bold text-gray-900 mb-3 flex items-center gap-2">
                    <DollarSign size={16} className="text-emerald-500" />
                    Xizmat narxlari
                  </h3>
                  <div className="space-y-2">
                    {selectedBranch.service_prices.map((sp, idx) => (
                      <div key={idx} className="flex items-center justify-between p-3 bg-gray-50 rounded-xl">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 bg-white rounded-lg flex items-center justify-center shadow-sm">
                            {getServiceIcon(sp.icon)}
                          </div>
                          <span className="font-medium text-gray-800">{sp.name}</span>
                        </div>
                        <span className="text-lg font-bold text-emerald-600">{formatPrice(sp.price)}</span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Gallery */}
              {selectedBranch.gallery_urls && selectedBranch.gallery_urls.length > 0 && (
                <div>
                  <h3 className="text-sm font-bold text-gray-900 mb-3 flex items-center gap-2">
                    <Image size={16} className="text-emerald-500" />
                    Galereya
                  </h3>
                  <div className="grid grid-cols-3 gap-2">
                    {selectedBranch.gallery_urls.map((url, idx) => (
                      <div key={idx} className="aspect-square rounded-xl overflow-hidden bg-gray-100">
                        <img src={url} alt={`Photo ${idx + 1}`} className="w-full h-full object-cover" />
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Location Map */}
              {selectedBranch.latitude && selectedBranch.longitude && (
                <div>
                  <h3 className="text-sm font-bold text-gray-900 mb-3 flex items-center gap-2">
                    <MapPin size={16} className="text-emerald-500" />
                    Lokatsiya
                  </h3>
                  <div className="rounded-xl overflow-hidden border border-gray-200">
                    <iframe
                      title="Branch Location"
                      width="100%"
                      height="200"
                      frameBorder="0"
                      src={`https://www.openstreetmap.org/export/embed.html?bbox=${selectedBranch.longitude - 0.005},${selectedBranch.latitude - 0.003},${selectedBranch.longitude + 0.005},${selectedBranch.latitude + 0.003}&layer=mapnik&marker=${selectedBranch.latitude},${selectedBranch.longitude}`}
                      style={{ border: 0 }}
                    />
                    <a
                      href={`https://www.google.com/maps?q=${selectedBranch.latitude},${selectedBranch.longitude}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center justify-center gap-2 p-2.5 bg-gray-50 text-emerald-600 hover:bg-emerald-50 text-sm font-medium transition-colors"
                    >
                      <ExternalLink size={14} />
                      Google Maps da ochish
                    </a>
                  </div>
                </div>
              )}

              {/* Branch ID */}
              <div className="p-3 bg-gray-50 rounded-xl">
                <p className="text-xs text-gray-400 mb-1">Filial ID</p>
                <div className="flex items-center gap-2">
                  <code className="text-sm text-gray-700 font-mono flex-1 truncate">{selectedBranch.id}</code>
                  <button
                    onClick={() => {
                      navigator.clipboard.writeText(selectedBranch.id);
                      alert('ID nusxalandi!');
                    }}
                    className="p-1.5 hover:bg-gray-200 rounded-lg transition-colors"
                  >
                    <Copy size={14} className="text-gray-500" />
                  </button>
                </div>
              </div>
            </div>

            {/* Footer Actions */}
            <div className="flex gap-3 p-4 border-t border-gray-100">
              <button
                onClick={() => {
                  setShowDetailModal(false);
                  handleEditBranch(selectedBranch);
                }}
                className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 font-medium transition-colors"
              >
                <Edit2 size={16} />
                Tahrirlash
              </button>
              <button
                onClick={() => {
                  setShowDetailModal(false);
                  handleShowQR(selectedBranch);
                }}
                className="flex items-center justify-center gap-2 px-5 py-2.5 border border-gray-200 text-gray-700 rounded-xl hover:bg-gray-50 font-medium transition-colors"
              >
                <QrCode size={16} />
                QR kod
              </button>
              <button
                onClick={() => {
                  handleDeleteBranch(selectedBranch.id);
                  setShowDetailModal(false);
                }}
                className="flex items-center justify-center gap-2 px-5 py-2.5 border border-red-200 text-red-600 rounded-xl hover:bg-red-50 font-medium transition-colors"
              >
                <Trash2 size={16} />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ==================== QR CODE MODAL ==================== */}
      {showQRModal && selectedBranch && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl w-full max-w-sm p-6 text-center">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-gray-900">QR kod</h2>
              <button onClick={() => setShowQRModal(false)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                <X size={20} className="text-gray-500" />
              </button>
            </div>

            <div className="bg-white p-6 rounded-2xl inline-block border-2 border-gray-100 shadow-sm">
              <QRCodeCanvas 
                value={`YUVGO_BRANCH_${selectedBranch.id}`}
                size={200}
                level="H"
              />
            </div>

            <div className="mt-4">
              <h3 className="font-bold text-gray-900">{selectedBranch.name}</h3>
              <p className="text-sm text-gray-500">{selectedBranch.address}</p>
            </div>

            <p className="text-xs text-gray-400 mt-4">
              Bu QR kodni mijozlar skanerlaydi
            </p>

            <button
              onClick={() => {
                const canvas = document.querySelector('canvas');
                if (canvas) {
                  const url = canvas.toDataURL('image/png');
                  const link = document.createElement('a');
                  link.download = `qr-${selectedBranch.name}.png`;
                  link.href = url;
                  link.click();
                }
              }}
              className="mt-4 w-full px-4 py-2.5 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 font-medium transition-colors"
            >
              QR kodni yuklab olish
            </button>
          </div>
        </div>
      )}

      {/* ==================== STAFF MODAL ==================== */}
      {showStaffModal && selectedBranch && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl w-full max-w-lg max-h-[80vh] overflow-hidden flex flex-col">
            <div className="flex items-center justify-between px-6 py-4 border-b border-gray-100">
              <div>
                <h2 className="text-xl font-bold text-gray-900">Xodimlar</h2>
                <p className="text-sm text-gray-500">{selectedBranch.name}</p>
              </div>
              <button onClick={() => setShowStaffModal(false)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                <X size={20} className="text-gray-500" />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto p-6">
              {/* Add Staff Form */}
              <div className="bg-gray-50 rounded-xl p-4 mb-4">
                <h3 className="font-medium text-gray-900 mb-3">Yangi xodim qo'shish</h3>
                <div className="grid grid-cols-2 gap-3">
                  <input
                    type="text"
                    value={newStaff.full_name}
                    onChange={(e) => setNewStaff({...newStaff, full_name: e.target.value})}
                    className="px-3 py-2.5 border border-gray-200 rounded-xl text-sm outline-none focus:ring-2 focus:ring-emerald-500"
                    placeholder="Ism familiya"
                  />
                  <input
                    type="tel"
                    value={newStaff.phone_number}
                    onChange={(e) => setNewStaff({...newStaff, phone_number: e.target.value})}
                    className="px-3 py-2.5 border border-gray-200 rounded-xl text-sm outline-none focus:ring-2 focus:ring-emerald-500"
                    placeholder="+998901234567"
                  />
                </div>
                <div className="flex gap-3 mt-3">
                  <select
                    value={newStaff.role}
                    onChange={(e) => setNewStaff({...newStaff, role: e.target.value})}
                    className="flex-1 px-3 py-2.5 border border-gray-200 rounded-xl text-sm outline-none focus:ring-2 focus:ring-emerald-500"
                  >
                    <option value="staff">Xodim</option>
                    <option value="manager">Menejer</option>
                  </select>
                  <button
                    onClick={handleAddStaff}
                    disabled={!newStaff.full_name || !newStaff.phone_number}
                    className="px-5 py-2.5 bg-emerald-600 text-white rounded-xl hover:bg-emerald-700 disabled:opacity-50 text-sm font-medium transition-colors"
                  >
                    Qo'shish
                  </button>
                </div>
              </div>

              {/* Staff List */}
              <div className="space-y-2">
                {branchStaff.map((staff) => (
                  <div key={staff.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-xl">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center text-emerald-600 font-bold text-sm">
                        {staff.full_name?.charAt(0) || '?'}
                      </div>
                      <div>
                        <p className="font-medium text-gray-900">{staff.full_name}</p>
                        <p className="text-sm text-gray-500">{staff.phone_number}</p>
                      </div>
                    </div>
                    <div className="flex items-center gap-2">
                      <span className={`text-xs px-2.5 py-1 rounded-full font-medium ${
                        staff.role === 'manager' 
                          ? 'bg-blue-100 text-blue-700' 
                          : 'bg-gray-100 text-gray-600'
                      }`}>
                        {staff.role === 'manager' ? 'Menejer' : 'Xodim'}
                      </span>
                      <button
                        onClick={() => handleRemoveStaff(staff.id)}
                        className="p-1.5 text-red-400 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                      >
                        <Trash2 size={16} />
                      </button>
                    </div>
                  </div>
                ))}

                {branchStaff.length === 0 && (
                  <div className="text-center py-8">
                    <Users size={32} className="mx-auto text-gray-300 mb-2" />
                    <p className="text-gray-500">Xodimlar yo'q</p>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Branches;
