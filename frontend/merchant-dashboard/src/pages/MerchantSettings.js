import React, { useState } from 'react';
import { 
  Settings, Save, Bell, User, Building2, Clock, 
  CheckCircle, Camera, Phone, Mail, MapPin
} from 'lucide-react';

const MerchantSettings = () => {
  const [profile, setProfile] = useState({
    businessName: 'Black Star Car Wash',
    ownerName: 'Merchant Admin',
    email: 'merchant@yuvgo.uz',
    phone: '+998901234500',
    address: 'Yunusobod tumani, Amir Temur ko\'chasi 15',
    city: 'Tashkent',
    workingHours: '08:00 - 22:00',
    description: 'Premium avtomoyка xizmati',
  });

  const [notifications, setNotifications] = useState({
    newVisit: true,
    dailyReport: true,
    weeklyReport: false,
    promotions: true,
    systemUpdates: true,
  });

  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  const handleProfileChange = (key, value) => {
    setProfile(prev => ({ ...prev, [key]: value }));
    setSaved(false);
  };

  const handleNotificationChange = (key, value) => {
    setNotifications(prev => ({ ...prev, [key]: value }));
    setSaved(false);
  };

  const handleSave = async () => {
    setSaving(true);
    await new Promise(resolve => setTimeout(resolve, 1000));
    setSaving(false);
    setSaved(true);
    setTimeout(() => setSaved(false), 3000);
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Sozlamalar</h1>
          <p className="text-gray-600">Biznes profilingizni boshqaring</p>
        </div>
        <button
          onClick={handleSave}
          disabled={saving}
          className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg hover:bg-emerald-700 disabled:opacity-50"
        >
          {saving ? (
            <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
          ) : saved ? (
            <CheckCircle size={20} />
          ) : (
            <Save size={20} />
          )}
          {saving ? 'Saqlanmoqda...' : saved ? 'Saqlandi!' : 'Saqlash'}
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Business Profile */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-emerald-100 rounded-lg">
              <Building2 className="text-emerald-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Biznes profili</h2>
          </div>

          {/* Logo Upload */}
          <div className="flex items-center gap-4 mb-6">
            <div className="w-20 h-20 bg-gray-100 rounded-xl flex items-center justify-center">
              <Camera className="text-gray-400" size={32} />
            </div>
            <div>
              <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium">
                Logo yuklash
              </button>
              <p className="text-sm text-gray-500 mt-1">PNG, JPG (max 2MB)</p>
            </div>
          </div>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Biznes nomi</label>
              <input
                type="text"
                value={profile.businessName}
                onChange={(e) => handleProfileChange('businessName', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Tavsif</label>
              <textarea
                value={profile.description}
                onChange={(e) => handleProfileChange('description', e.target.value)}
                rows={3}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Ish vaqti</label>
              <div className="flex items-center gap-2">
                <Clock size={18} className="text-gray-400" />
                <input
                  type="text"
                  value={profile.workingHours}
                  onChange={(e) => handleProfileChange('workingHours', e.target.value)}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Contact Info */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-blue-100 rounded-lg">
              <User className="text-blue-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Aloqa ma'lumotlari</h2>
          </div>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Egasi ismi</label>
              <input
                type="text"
                value={profile.ownerName}
                onChange={(e) => handleProfileChange('ownerName', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <div className="flex items-center gap-2">
                <Mail size={18} className="text-gray-400" />
                <input
                  type="email"
                  value={profile.email}
                  onChange={(e) => handleProfileChange('email', e.target.value)}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                />
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Telefon</label>
              <div className="flex items-center gap-2">
                <Phone size={18} className="text-gray-400" />
                <input
                  type="tel"
                  value={profile.phone}
                  onChange={(e) => handleProfileChange('phone', e.target.value)}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                />
              </div>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Manzil</label>
              <div className="flex items-center gap-2">
                <MapPin size={18} className="text-gray-400" />
                <input
                  type="text"
                  value={profile.address}
                  onChange={(e) => handleProfileChange('address', e.target.value)}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500"
                />
              </div>
            </div>
          </div>
        </div>

        {/* Notifications */}
        <div className="bg-white rounded-xl border border-gray-200 p-6 lg:col-span-2">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-purple-100 rounded-lg">
              <Bell className="text-purple-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Bildirishnomalar</h2>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {[
              { key: 'newVisit', label: 'Yangi tashrif', desc: 'Har bir yangi tashrif haqida xabar' },
              { key: 'dailyReport', label: 'Kunlik hisobot', desc: 'Har kuni ertalab hisobot' },
              { key: 'weeklyReport', label: 'Haftalik hisobot', desc: 'Har hafta dushanba kuni' },
              { key: 'promotions', label: 'Aksiyalar', desc: 'Yangi aksiyalar haqida xabar' },
              { key: 'systemUpdates', label: 'Tizim yangilanishlari', desc: 'Muhim tizim xabarlari' },
            ].map((item) => (
              <label
                key={item.key}
                className="flex items-start gap-3 p-4 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-50"
              >
                <input
                  type="checkbox"
                  checked={notifications[item.key]}
                  onChange={(e) => handleNotificationChange(item.key, e.target.checked)}
                  className="w-5 h-5 mt-0.5 text-emerald-600 rounded focus:ring-emerald-500"
                />
                <div>
                  <span className="font-medium text-gray-900 block">{item.label}</span>
                  <span className="text-sm text-gray-500">{item.desc}</span>
                </div>
              </label>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default MerchantSettings;
