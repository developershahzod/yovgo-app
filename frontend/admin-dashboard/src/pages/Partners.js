import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Building2, CheckCircle, XCircle, Plus, Edit, MapPin, Phone, Upload, X, Image, Clock, Star, Trash2 } from 'lucide-react';
import { Button } from '../components/ui/button';
import { Card, CardContent } from '../components/ui/card';

const Partners = () => {
  const { API_URL, hasPermission } = useAuth();
  const [partners, setPartners] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');
  const [showModal, setShowModal] = useState(false);
  const [editingPartner, setEditingPartner] = useState(null);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [logoPreview, setLogoPreview] = useState('');
  const [galleryPreviews, setGalleryPreviews] = useState([]);
  const [merchantForm, setMerchantForm] = useState({
    email: '',
    password: '',
    full_name: '',
    phone_number: ''
  });
  const [partnerForm, setPartnerForm] = useState({
    name: '',
    name_ru: '',
    name_en: '',
    description: '',
    description_ru: '',
    description_en: '',
    phone: '',
    email: '',
    address: '',
    city: '',
    latitude: 41.2995,
    longitude: 69.2401,
    service_type: 'full_service',
    logo_url: '',
    gallery_urls: [],
    is_active: true,
    is_24_hours: false,
    is_premium: false,
    working_hours: '08:00 - 22:00',
    rating: 4.5
  });
  const [staffForm, setStaffForm] = useState({
    phone_number: '',
    pin_code: '',
    full_name: ''
  });
  const [showStaffSection, setShowStaffSection] = useState(false);

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

  const handleDelete = async (partner) => {
    if (!window.confirm(`"${partner.name}" partnerni o'chirmoqchimisiz? Bu amalni qaytarib bo'lmaydi!`)) return;
    try {
      await axios.delete(`${API_URL}/api/partner/partners/${partner.id}`);
      setSuccess('Partner o\'chirildi!');
      fetchPartners();
      setTimeout(() => setSuccess(''), 3000);
    } catch (error) {
      console.error('Failed to delete partner:', error);
      setError(error.response?.data?.detail || 'O\'chirishda xatolik');
    }
  };

  const handleCreatePartner = () => {
    setEditingPartner(null);
    setPartnerForm({
      name: '',
      name_ru: '',
      name_en: '',
      description: '',
      description_ru: '',
      description_en: '',
      phone: '',
      email: '',
      address: '',
      city: '',
      latitude: 41.2995,
      longitude: 69.2401,
      service_type: 'full_service',
      logo_url: '',
      gallery_urls: [],
      is_active: true,
      is_24_hours: false,
      is_premium: false,
      working_hours: '08:00 - 22:00',
      rating: 4.5
    });
    setLogoPreview('');
    setGalleryPreviews([]);
    setMerchantForm({ email: '', password: '', full_name: '', phone_number: '' });
    setShowModal(true);
  };

  const handleGalleryUpload = async (e) => {
    const files = Array.from(e.target.files);
    if (files.length === 0) return;
    try {
      const formData = new FormData();
      files.forEach(f => formData.append('files', f));
      formData.append('category', 'gallery');
      const res = await axios.post(`${API_URL}/api/upload/images`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      });
      const urls = res.data.urls || [];
      setGalleryPreviews(prev => [...prev, ...urls]);
      setPartnerForm(prev => ({ ...prev, gallery_urls: [...(prev.gallery_urls || []), ...urls] }));
    } catch (err) {
      console.error('Gallery upload failed:', err);
      setError('Galereya yuklashda xatolik');
    }
  };

  const removeGalleryImage = (index) => {
    setGalleryPreviews(prev => prev.filter((_, i) => i !== index));
    setPartnerForm(prev => ({
      ...prev,
      gallery_urls: (prev.gallery_urls || []).filter((_, i) => i !== index)
    }));
  };

  const handleEditPartner = async (partner) => {
    setEditingPartner(partner);
    setPartnerForm({
      name: partner.name,
      name_ru: partner.name_ru || '',
      name_en: partner.name_en || '',
      description: partner.description || '',
      description_ru: partner.description_ru || '',
      description_en: partner.description_en || '',
      phone: partner.phone || '',
      email: partner.email || '',
      address: partner.address || '',
      city: partner.city || '',
      latitude: partner.latitude || 41.2995,
      longitude: partner.longitude || 69.2401,
      service_type: partner.service_type || 'full_service',
      logo_url: partner.logo_url || '',
      gallery_urls: partner.gallery_urls || [],
      is_active: partner.is_active,
      is_24_hours: partner.is_24_hours || false,
      is_premium: partner.is_premium || false,
      working_hours: partner.working_hours || '08:00 - 22:00',
      rating: partner.rating || 4.5
    });
    setLogoPreview(partner.logo_url || '');
    setGalleryPreviews(partner.gallery_urls || []);
    
    // Fetch merchant user credentials for this partner
    try {
      const response = await axios.get(`${API_URL}/api/partner/partners/${partner.id}/merchant-users`);
      if (response.data && response.data.length > 0) {
        const mu = response.data[0];
        setMerchantForm({
          email: mu.email || '',
          password: '',
          full_name: mu.full_name || '',
          phone_number: mu.phone_number || ''
        });
      } else {
        setMerchantForm({ email: '', password: '', full_name: '', phone_number: '' });
      }
    } catch (error) {
      console.log('No merchant user found');
      setMerchantForm({ email: '', password: '', full_name: '', phone_number: '' });
    }
    
    setShowModal(true);
  };

  const handleLogoUpload = async (e) => {
    const file = e.target.files[0];
    if (file) {
      try {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('category', 'logo');
        const res = await axios.post(`${API_URL}/api/upload/image`, formData, {
          headers: { 'Content-Type': 'multipart/form-data' }
        });
        const url = res.data.full_url;
        setLogoPreview(url);
        setPartnerForm(prev => ({ ...prev, logo_url: url }));
      } catch (err) {
        console.error('Logo upload failed:', err);
        setError('Logo yuklashda xatolik');
      }
    }
  };

  const handleSavePartner = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    try {
      let partnerId;
      
      if (editingPartner) {
        await axios.put(`${API_URL}/api/partner/partners/${editingPartner.id}`, partnerForm);
        partnerId = editingPartner.id;
        
        // Update merchant user credentials if editing
        if (showStaffSection && merchantForm.email) {
          try {
            await axios.put(`${API_URL}/api/partner/partners/${partnerId}/merchant-users`, {
              email: merchantForm.email,
              password: merchantForm.password || undefined,
              full_name: merchantForm.full_name || partnerForm.name,
              phone_number: merchantForm.phone_number || partnerForm.phone,
            });
            setSuccess('Partner va merchant ma\'lumotlari yangilandi!');
          } catch (muErr) {
            // If no merchant user exists yet, create one
            if (muErr.response?.status === 404 && merchantForm.password) {
              try {
                await axios.post(`${API_URL}/api/partner/partners/${partnerId}/merchant-users`, {
                  email: merchantForm.email,
                  password: merchantForm.password,
                  full_name: merchantForm.full_name || partnerForm.name,
                  phone_number: merchantForm.phone_number || partnerForm.phone,
                  role: 'owner'
                });
                setSuccess('Partner yangilandi va merchant akkaunt yaratildi!');
              } catch (createErr) {
                setError('Merchant akkaunt yaratishda xatolik: ' + (createErr.response?.data?.detail || createErr.message));
                return;
              }
            } else {
              console.error('Failed to update merchant user:', muErr);
              setSuccess('Partner yangilandi!');
            }
          }
        } else {
          setSuccess('Partner yangilandi!');
        }
      } else {
        const response = await axios.post(`${API_URL}/api/partner/partners`, partnerForm);
        partnerId = response.data.id;
        
        // Create merchant user for the new partner
        if (merchantForm.email && merchantForm.password) {
          try {
            await axios.post(`${API_URL}/api/partner/partners/${partnerId}/merchant-users`, {
              email: merchantForm.email,
              password: merchantForm.password,
              full_name: merchantForm.full_name || partnerForm.name,
              phone_number: merchantForm.phone_number || partnerForm.phone,
              role: 'owner'
            });
          } catch (muErr) {
            console.error('Failed to create merchant user:', muErr);
            setError('Partner yaratildi lekin merchant login yaratishda xatolik: ' + (muErr.response?.data?.detail || muErr.message));
            return;
          }
        }
        setSuccess('Partner va merchant akkaunt yaratildi!');
      }

      setTimeout(() => {
        setShowModal(false);
        setSuccess('');
        setShowStaffSection(false);
        fetchPartners();
      }, 1500);
    } catch (error) {
      setError(error.response?.data?.detail || 'Failed to save partner');
    }
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Partners</h1>
          <p className="text-gray-600 mt-1">Manage car wash partners</p>
        </div>
        <Button onClick={handleCreatePartner} className="gap-2">
          <Plus className="h-4 w-4" />
          Add Partner
        </Button>
      </div>

      {success && (
        <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg">
          <p className="text-sm text-green-600">{success}</p>
        </div>
      )}

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
                        <div className="flex items-center gap-2">
                          <button
                            onClick={() => handleEditPartner(partner)}
                            className="text-primary-600 hover:text-primary-900"
                            title="Edit"
                          >
                            <Edit size={18} />
                          </button>
                          {partner.status === 'pending' && (
                            <>
                              <button
                                onClick={() => handleApprove(partner.id)}
                                className="text-green-600 hover:text-green-900"
                                title="Approve"
                              >
                                <CheckCircle size={18} />
                              </button>
                              <button
                                onClick={() => handleReject(partner.id)}
                                className="text-red-600 hover:text-red-900"
                                title="Reject"
                              >
                                <XCircle size={18} />
                              </button>
                            </>
                          )}
                          <button
                            onClick={() => handleDelete(partner)}
                            className="text-red-500 hover:text-red-700"
                            title="O'chirish"
                          >
                            <Trash2 size={18} />
                          </button>
                        </div>
                      </td>
                    )}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Create/Edit Partner Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 w-full max-w-3xl max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-xl font-bold">
                {editingPartner ? 'Edit Partner' : 'Add New Partner'}
              </h2>
              <button
                onClick={() => setShowModal(false)}
                className="text-gray-400 hover:text-gray-600"
              >
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

            <form onSubmit={handleSavePartner} className="space-y-4">
              {/* Logo Upload */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Partner Logo
                </label>
                <div className="flex items-center gap-4">
                  {logoPreview ? (
                    <div className="relative">
                      <img
                        src={logoPreview}
                        alt="Logo preview"
                        className="w-24 h-24 object-cover rounded-lg border-2 border-gray-300"
                      />
                      <button
                        type="button"
                        onClick={() => {
                          setLogoPreview('');
                          setPartnerForm({ ...partnerForm, logo_url: '' });
                        }}
                        className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                      >
                        <X size={14} />
                      </button>
                    </div>
                  ) : (
                    <div className="w-24 h-24 border-2 border-dashed border-gray-300 rounded-lg flex items-center justify-center">
                      <Upload className="text-gray-400" size={32} />
                    </div>
                  )}
                  <div className="flex-1">
                    <input
                      type="file"
                      accept="image/*"
                      onChange={handleLogoUpload}
                      className="hidden"
                      id="logo-upload"
                    />
                    <label
                      htmlFor="logo-upload"
                      className="cursor-pointer inline-flex items-center px-4 py-2 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 bg-white hover:bg-gray-50"
                    >
                      <Upload size={16} className="mr-2" />
                      Upload Logo
                    </label>
                    <p className="text-xs text-gray-500 mt-1">
                      PNG, JPG up to 2MB
                    </p>
                  </div>
                </div>
              </div>

              {/* Basic Info */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Partner Name (UZ) *
                  </label>
                  <input
                    type="text"
                    value={partnerForm.name}
                    onChange={(e) => setPartnerForm({ ...partnerForm, name: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="Premium Car Wash"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Service Type *
                  </label>
                  <select
                    value={partnerForm.service_type}
                    onChange={(e) => setPartnerForm({ ...partnerForm, service_type: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                    <option value="full_service">Full Service</option>
                    <option value="self_service">Self Service</option>
                    <option value="automatic">Automatic</option>
                    <option value="hand_wash">Hand Wash</option>
                    <option value="detailing">Detailing</option>
                  </select>
                </div>
              </div>

              {/* Multilingual Names */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    🇷🇺 Name (RU)
                  </label>
                  <input
                    type="text"
                    value={partnerForm.name_ru}
                    onChange={(e) => setPartnerForm({ ...partnerForm, name_ru: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="Название на русском"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    🇬🇧 Name (EN)
                  </label>
                  <input
                    type="text"
                    value={partnerForm.name_en}
                    onChange={(e) => setPartnerForm({ ...partnerForm, name_en: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="Name in English"
                  />
                </div>
              </div>

              {/* Description UZ */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Description (UZ)
                </label>
                <textarea
                  value={partnerForm.description}
                  onChange={(e) => setPartnerForm({ ...partnerForm, description: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  rows="2"
                  placeholder="O'zbek tilida tavsif..."
                />
              </div>

              {/* Multilingual Descriptions */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    🇷🇺 Description (RU)
                  </label>
                  <textarea
                    value={partnerForm.description_ru}
                    onChange={(e) => setPartnerForm({ ...partnerForm, description_ru: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    rows="2"
                    placeholder="Описание на русском языке..."
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    🇬🇧 Description (EN)
                  </label>
                  <textarea
                    value={partnerForm.description_en}
                    onChange={(e) => setPartnerForm({ ...partnerForm, description_en: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    rows="2"
                    placeholder="Description in English..."
                  />
                </div>
              </div>

              {/* Contact Info */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Phone Number *
                  </label>
                  <input
                    type="tel"
                    value={partnerForm.phone}
                    onChange={(e) => setPartnerForm({ ...partnerForm, phone: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="+998901234567"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Email *
                  </label>
                  <input
                    type="email"
                    value={partnerForm.email}
                    onChange={(e) => setPartnerForm({ ...partnerForm, email: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="partner@example.com"
                    required
                  />
                </div>
              </div>

              {/* Location */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    City *
                  </label>
                  <input
                    type="text"
                    value={partnerForm.city}
                    onChange={(e) => setPartnerForm({ ...partnerForm, city: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="Tashkent"
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Address *
                  </label>
                  <input
                    type="text"
                    value={partnerForm.address}
                    onChange={(e) => setPartnerForm({ ...partnerForm, address: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="123 Main Street"
                    required
                  />
                </div>
              </div>

              {/* Coordinates */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Location on Map *
                </label>
                <div className="grid grid-cols-2 gap-4 mb-3">
                  <div>
                    <label className="block text-xs text-gray-600 mb-1">Latitude</label>
                    <input
                      type="number"
                      step="0.000001"
                      value={partnerForm.latitude}
                      onChange={(e) => setPartnerForm({ ...partnerForm, latitude: parseFloat(e.target.value) || 0 })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
                      placeholder="41.2995"
                      required
                    />
                  </div>
                  <div>
                    <label className="block text-xs text-gray-600 mb-1">Longitude</label>
                    <input
                      type="number"
                      step="0.000001"
                      value={partnerForm.longitude}
                      onChange={(e) => setPartnerForm({ ...partnerForm, longitude: parseFloat(e.target.value) || 0 })}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
                      placeholder="69.2401"
                      required
                    />
                  </div>
                </div>
                <div className="bg-gray-100 rounded-lg p-4 border-2 border-dashed border-gray-300">
                  <div className="flex items-center justify-center text-gray-500">
                    <MapPin className="mr-2" size={20} />
                    <div className="text-sm">
                      <p className="font-medium">Click on map to select location</p>
                      <p className="text-xs mt-1">
                        Current: {partnerForm.latitude.toFixed(6)}, {partnerForm.longitude.toFixed(6)}
                      </p>
                      <a
                        href={`https://www.google.com/maps?q=${partnerForm.latitude},${partnerForm.longitude}`}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="text-primary hover:underline text-xs mt-1 inline-block"
                      >
                        View on Google Maps →
                      </a>
                    </div>
                  </div>
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  💡 Tip: Use Google Maps to find exact coordinates, or enter them manually above
                </p>
              </div>

              {/* Gallery Photos */}
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  <Image size={16} className="inline mr-1" />
                  Gallery Photos
                </label>
                <div className="flex flex-wrap gap-3 mb-3">
                  {galleryPreviews.map((img, idx) => (
                    <div key={idx} className="relative">
                      <img src={img} alt={`Gallery ${idx + 1}`} className="w-24 h-24 object-cover rounded-lg border" />
                      <button
                        type="button"
                        onClick={() => removeGalleryImage(idx)}
                        className="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 hover:bg-red-600"
                      >
                        <X size={12} />
                      </button>
                    </div>
                  ))}
                  <label className="w-24 h-24 border-2 border-dashed border-gray-300 rounded-lg flex flex-col items-center justify-center cursor-pointer hover:border-primary-400 hover:bg-gray-50">
                    <Plus size={20} className="text-gray-400" />
                    <span className="text-xs text-gray-400 mt-1">Add</span>
                    <input
                      type="file"
                      accept="image/*"
                      multiple
                      onChange={handleGalleryUpload}
                      className="hidden"
                    />
                  </label>
                </div>
                <p className="text-xs text-gray-500">Upload photos of the car wash (exterior, interior, equipment)</p>
              </div>

              {/* Working Hours */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    <Clock size={14} className="inline mr-1" />
                    Working Hours
                  </label>
                  <input
                    type="text"
                    value={partnerForm.working_hours}
                    onChange={(e) => setPartnerForm({ ...partnerForm, working_hours: e.target.value })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="08:00 - 22:00"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    <Star size={14} className="inline mr-1" />
                    Initial Rating
                  </label>
                  <input
                    type="number"
                    step="0.1"
                    min="0"
                    max="5"
                    value={partnerForm.rating}
                    onChange={(e) => setPartnerForm({ ...partnerForm, rating: parseFloat(e.target.value) || 0 })}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  />
                </div>
              </div>

              {/* Flags */}
              <div className="flex flex-wrap gap-6">
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="is_active"
                    checked={partnerForm.is_active}
                    onChange={(e) => setPartnerForm({ ...partnerForm, is_active: e.target.checked })}
                    className="w-4 h-4 text-primary border-gray-300 rounded"
                  />
                  <label htmlFor="is_active" className="text-sm font-medium text-gray-700">
                    Active
                  </label>
                </div>
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="is_24_hours"
                    checked={partnerForm.is_24_hours}
                    onChange={(e) => setPartnerForm({ ...partnerForm, is_24_hours: e.target.checked })}
                    className="w-4 h-4 text-primary border-gray-300 rounded"
                  />
                  <label htmlFor="is_24_hours" className="text-sm font-medium text-gray-700">
                    24/7
                  </label>
                </div>
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    id="is_premium"
                    checked={partnerForm.is_premium}
                    onChange={(e) => setPartnerForm({ ...partnerForm, is_premium: e.target.checked })}
                    className="w-4 h-4 text-primary border-gray-300 rounded"
                  />
                  <label htmlFor="is_premium" className="text-sm font-medium text-gray-700">
                    Premium Partner
                  </label>
                </div>
              </div>

              {/* Merchant Dashboard Access - for both new and existing partners */}
              <div className="border-t pt-4 mt-4">
                <div className="flex items-center justify-between mb-3">
                  <h3 className="text-lg font-semibold text-gray-900">
                    Merchant Dashboard Access
                  </h3>
                  {editingPartner && (
                    <button
                      type="button"
                      onClick={() => setShowStaffSection(!showStaffSection)}
                      className="text-sm text-primary-600 hover:text-primary-700 font-medium"
                    >
                      {showStaffSection ? 'Yashirish' : 'Tahrirlash'}
                    </button>
                  )}
                </div>
                <p className="text-sm text-gray-600 mb-4">
                  merchant.yuvgo.uz ga kirish uchun login va parol
                </p>

                {(!editingPartner || showStaffSection) && (
                  <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 space-y-4">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Ism *</label>
                        <input
                          type="text"
                          value={merchantForm.full_name}
                          onChange={(e) => setMerchantForm({ ...merchantForm, full_name: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="Egasi ismi"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Telefon</label>
                        <input
                          type="tel"
                          value={merchantForm.phone_number}
                          onChange={(e) => setMerchantForm({ ...merchantForm, phone_number: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="+998901234567"
                        />
                      </div>
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Login Email *</label>
                        <input
                          type="email"
                          value={merchantForm.email}
                          onChange={(e) => setMerchantForm({ ...merchantForm, email: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                          placeholder="merchant@example.com"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">
                          {editingPartner ? 'Yangi parol (bo\'sh qoldiring eski parolni saqlash uchun)' : 'Parol *'}
                        </label>
                        <input
                          type="text"
                          value={merchantForm.password}
                          onChange={(e) => setMerchantForm({ ...merchantForm, password: e.target.value })}
                          className="w-full px-3 py-2 border border-gray-300 rounded-lg font-mono"
                          placeholder={editingPartner ? 'Yangi parol...' : 'Kamida 6 belgi'}
                        />
                      </div>
                    </div>
                    {editingPartner && (
                      <div className="bg-yellow-50 border border-yellow-200 rounded p-3">
                        <p className="text-xs text-yellow-800">
                          Parolni bo'sh qoldiring agar o'zgartirmoqchi bo'lmasangiz.
                        </p>
                      </div>
                    )}
                  </div>
                )}
              </div>

              {/* Actions */}
              <div className="flex gap-3 pt-4">
                <Button type="submit" className="flex-1">
                  {editingPartner ? 'Update Partner' : 'Create Partner'}
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => {
                    setShowModal(false);
                    setError('');
                    setSuccess('');
                  }}
                  className="flex-1"
                >
                  Cancel
                </Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Partners;
