import React, { useState, useEffect } from 'react';
import { 
  Settings as SettingsIcon, Save, Bell, Shield, Globe, 
  Database, Mail, CreditCard, Clock, CheckCircle, AlertCircle
} from 'lucide-react';

const Settings = () => {
  const [settings, setSettings] = useState({
    siteName: 'YuvGO',
    siteDescription: 'Avtomoyqa Obuna Xizmati',
    supportEmail: 'support@yuvgo.uz',
    supportPhone: '+998901234567',
    defaultCurrency: 'UZS',
    timezone: 'Asia/Tashkent',
    maintenanceMode: false,
    emailNotifications: true,
    smsNotifications: true,
    pushNotifications: true,
    autoApprovePartners: false,
    minSubscriptionPrice: 50000,
    maxVisitsPerDay: 3,
    qrCodeExpiry: 300,
    sessionTimeout: 3600,
  });
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(false);

  const handleChange = (key, value) => {
    setSettings(prev => ({ ...prev, [key]: value }));
    setSaved(false);
  };

  const handleSave = async () => {
    setSaving(true);
    // Simulate API call
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
          <h1 className="text-2xl font-bold text-gray-900">Settings</h1>
          <p className="text-gray-600">Manage system configuration</p>
        </div>
        <button
          onClick={handleSave}
          disabled={saving}
          className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50"
        >
          {saving ? (
            <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
          ) : saved ? (
            <CheckCircle size={20} />
          ) : (
            <Save size={20} />
          )}
          {saving ? 'Saving...' : saved ? 'Saved!' : 'Save Changes'}
        </button>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* General Settings */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-blue-100 rounded-lg">
              <Globe className="text-blue-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">General Settings</h2>
          </div>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Site Name</label>
              <input
                type="text"
                value={settings.siteName}
                onChange={(e) => handleChange('siteName', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Site Description</label>
              <input
                type="text"
                value={settings.siteDescription}
                onChange={(e) => handleChange('siteDescription', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Default Currency</label>
              <select
                value={settings.defaultCurrency}
                onChange={(e) => handleChange('defaultCurrency', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="UZS">UZS - Uzbek Som</option>
                <option value="USD">USD - US Dollar</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Timezone</label>
              <select
                value={settings.timezone}
                onChange={(e) => handleChange('timezone', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              >
                <option value="Asia/Tashkent">Asia/Tashkent (UTC+5)</option>
                <option value="UTC">UTC</option>
              </select>
            </div>
          </div>
        </div>

        {/* Contact Settings */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-green-100 rounded-lg">
              <Mail className="text-green-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Contact Settings</h2>
          </div>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Support Email</label>
              <input
                type="email"
                value={settings.supportEmail}
                onChange={(e) => handleChange('supportEmail', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Support Phone</label>
              <input
                type="tel"
                value={settings.supportPhone}
                onChange={(e) => handleChange('supportPhone', e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
          </div>
        </div>

        {/* Notification Settings */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-purple-100 rounded-lg">
              <Bell className="text-purple-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Notifications</h2>
          </div>
          
          <div className="space-y-4">
            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">Email Notifications</span>
              <input
                type="checkbox"
                checked={settings.emailNotifications}
                onChange={(e) => handleChange('emailNotifications', e.target.checked)}
                className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
              />
            </label>
            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">SMS Notifications</span>
              <input
                type="checkbox"
                checked={settings.smsNotifications}
                onChange={(e) => handleChange('smsNotifications', e.target.checked)}
                className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
              />
            </label>
            <label className="flex items-center justify-between cursor-pointer">
              <span className="text-gray-700">Push Notifications</span>
              <input
                type="checkbox"
                checked={settings.pushNotifications}
                onChange={(e) => handleChange('pushNotifications', e.target.checked)}
                className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
              />
            </label>
          </div>
        </div>

        {/* Security Settings */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-red-100 rounded-lg">
              <Shield className="text-red-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Security</h2>
          </div>
          
          <div className="space-y-4">
            <label className="flex items-center justify-between cursor-pointer">
              <div>
                <span className="text-gray-700 block">Maintenance Mode</span>
                <span className="text-sm text-gray-500">Disable access for regular users</span>
              </div>
              <input
                type="checkbox"
                checked={settings.maintenanceMode}
                onChange={(e) => handleChange('maintenanceMode', e.target.checked)}
                className="w-5 h-5 text-red-600 rounded focus:ring-red-500"
              />
            </label>
            <label className="flex items-center justify-between cursor-pointer">
              <div>
                <span className="text-gray-700 block">Auto-approve Partners</span>
                <span className="text-sm text-gray-500">Skip manual approval for new partners</span>
              </div>
              <input
                type="checkbox"
                checked={settings.autoApprovePartners}
                onChange={(e) => handleChange('autoApprovePartners', e.target.checked)}
                className="w-5 h-5 text-blue-600 rounded focus:ring-blue-500"
              />
            </label>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Session Timeout (seconds)</label>
              <input
                type="number"
                value={settings.sessionTimeout}
                onChange={(e) => handleChange('sessionTimeout', parseInt(e.target.value))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
          </div>
        </div>

        {/* Business Rules */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-yellow-100 rounded-lg">
              <CreditCard className="text-yellow-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">Business Rules</h2>
          </div>
          
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Minimum Subscription Price (UZS)</label>
              <input
                type="number"
                value={settings.minSubscriptionPrice}
                onChange={(e) => handleChange('minSubscriptionPrice', parseInt(e.target.value))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Max Visits Per Day</label>
              <input
                type="number"
                value={settings.maxVisitsPerDay}
                onChange={(e) => handleChange('maxVisitsPerDay', parseInt(e.target.value))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">QR Code Expiry (seconds)</label>
              <input
                type="number"
                value={settings.qrCodeExpiry}
                onChange={(e) => handleChange('qrCodeExpiry', parseInt(e.target.value))}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              />
            </div>
          </div>
        </div>

        {/* System Info */}
        <div className="bg-white rounded-xl border border-gray-200 p-6">
          <div className="flex items-center gap-3 mb-6">
            <div className="p-2 bg-gray-100 rounded-lg">
              <Database className="text-gray-600" size={24} />
            </div>
            <h2 className="text-lg font-semibold">System Information</h2>
          </div>
          
          <div className="space-y-3">
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Version</span>
              <span className="font-medium">1.0.0</span>
            </div>
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Environment</span>
              <span className="font-medium text-green-600">Production</span>
            </div>
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Database</span>
              <span className="font-medium text-green-600">Connected</span>
            </div>
            <div className="flex justify-between py-2 border-b border-gray-100">
              <span className="text-gray-600">Redis Cache</span>
              <span className="font-medium text-green-600">Connected</span>
            </div>
            <div className="flex justify-between py-2">
              <span className="text-gray-600">Last Backup</span>
              <span className="font-medium">2026-02-05 18:00</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Settings;
