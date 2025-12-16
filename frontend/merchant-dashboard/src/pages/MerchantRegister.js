import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { Building2, Phone, Mail, MapPin, User, Lock, Eye, EyeOff, CheckCircle, AlertCircle } from 'lucide-react';

const MerchantRegister = () => {
  const navigate = useNavigate();
  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';
  
  const [formData, setFormData] = useState({
    business_name: '',
    owner_name: '',
    phone_number: '',
    email: '',
    address: '',
    city: '',
    pin: '',
    confirm_pin: ''
  });
  
  const [showPin, setShowPin] = useState(false);
  const [showConfirmPin, setShowConfirmPin] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    // Validation
    if (formData.pin !== formData.confirm_pin) {
      setError('PIN codes do not match');
      return;
    }

    if (formData.pin.length !== 4) {
      setError('PIN must be 4 digits');
      return;
    }

    if (formData.phone_number.length < 10) {
      setError('Please enter a valid phone number');
      return;
    }

    setLoading(true);

    try {
      const response = await axios.post(`${API_URL}/api/partner/register`, {
        name: formData.business_name,
        owner_name: formData.owner_name,
        phone_number: formData.phone_number,
        email: formData.email,
        address: formData.address,
        city: formData.city,
        pin: formData.pin,
        status: 'pending' // Will be approved by admin
      });

      setSuccess('Registration successful! Your account is pending approval.');
      
      // Redirect to login after 3 seconds
      setTimeout(() => {
        navigate('/login');
      }, 3000);

    } catch (err) {
      setError(err.response?.data?.detail || 'Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex">
      {/* Left Side - Branding */}
      <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-emerald-500 to-emerald-700 p-12 flex-col justify-between">
        <div>
          <div className="flex items-center gap-3 mb-8">
            <div className="w-12 h-12 bg-white rounded-xl flex items-center justify-center">
              <Building2 className="text-emerald-600" size={28} />
            </div>
            <h1 className="text-3xl font-bold text-white">YuvGo Partner</h1>
          </div>
          
          <div className="space-y-6 text-white">
            <h2 className="text-4xl font-bold leading-tight">
              Join Our Car Wash Network
            </h2>
            <p className="text-emerald-100 text-lg">
              Register your car wash business and start accepting customers with subscriptions.
            </p>
            
            <div className="space-y-4 mt-8">
              <div className="flex items-start gap-3">
                <CheckCircle className="text-emerald-200 flex-shrink-0 mt-1" size={20} />
                <div>
                  <p className="font-semibold">Increase Revenue</p>
                  <p className="text-emerald-100 text-sm">Get more customers through our platform</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <CheckCircle className="text-emerald-200 flex-shrink-0 mt-1" size={20} />
                <div>
                  <p className="font-semibold">Easy Management</p>
                  <p className="text-emerald-100 text-sm">Track visits and earnings in real-time</p>
                </div>
              </div>
              <div className="flex items-start gap-3">
                <CheckCircle className="text-emerald-200 flex-shrink-0 mt-1" size={20} />
                <div>
                  <p className="font-semibold">QR Code System</p>
                  <p className="text-emerald-100 text-sm">Simple check-in process for customers</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div className="text-emerald-100 text-sm">
          © 2025 YuvGo. All rights reserved.
        </div>
      </div>

      {/* Right Side - Registration Form */}
      <div className="flex-1 flex items-center justify-center p-8">
        <div className="w-full max-w-md">
          <div className="mb-8">
            <h2 className="text-3xl font-bold text-gray-900 mb-2">Create Account</h2>
            <p className="text-gray-600">Register your car wash business</p>
          </div>

          {/* Success Message */}
          {success && (
            <div className="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
              <div className="flex items-start gap-3">
                <CheckCircle className="text-green-600 flex-shrink-0 mt-0.5" size={20} />
                <div>
                  <p className="text-green-900 font-medium text-sm">Success!</p>
                  <p className="text-green-700 text-sm mt-1">{success}</p>
                </div>
              </div>
            </div>
          )}

          {/* Error Message */}
          {error && (
            <div className="mb-6 p-4 bg-red-50 border border-red-200 rounded-lg">
              <div className="flex items-start gap-3">
                <AlertCircle className="text-red-600 flex-shrink-0 mt-0.5" size={20} />
                <div>
                  <p className="text-red-900 font-medium text-sm">Error</p>
                  <p className="text-red-700 text-sm mt-1">{error}</p>
                </div>
              </div>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            {/* Business Name */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Business Name *
              </label>
              <div className="relative">
                <Building2 className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="text"
                  name="business_name"
                  value={formData.business_name}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="Premium Car Wash"
                  required
                />
              </div>
            </div>

            {/* Owner Name */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Owner Name *
              </label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="text"
                  name="owner_name"
                  value={formData.owner_name}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="John Doe"
                  required
                />
              </div>
            </div>

            {/* Phone Number */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Phone Number *
              </label>
              <div className="relative">
                <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="tel"
                  name="phone_number"
                  value={formData.phone_number}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="+998901234567"
                  required
                />
              </div>
            </div>

            {/* Email */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Email *
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="business@example.com"
                  required
                />
              </div>
            </div>

            {/* City */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                City *
              </label>
              <div className="relative">
                <MapPin className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="text"
                  name="city"
                  value={formData.city}
                  onChange={handleChange}
                  className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="Tashkent"
                  required
                />
              </div>
            </div>

            {/* Address */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Address *
              </label>
              <input
                type="text"
                name="address"
                value={formData.address}
                onChange={handleChange}
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                placeholder="123 Main Street"
                required
              />
            </div>

            {/* PIN */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Create 4-Digit PIN *
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type={showPin ? "text" : "password"}
                  name="pin"
                  value={formData.pin}
                  onChange={handleChange}
                  className="w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="••••"
                  maxLength="4"
                  pattern="[0-9]{4}"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPin(!showPin)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPin ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
            </div>

            {/* Confirm PIN */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Confirm PIN *
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type={showConfirmPin ? "text" : "password"}
                  name="confirm_pin"
                  value={formData.confirm_pin}
                  onChange={handleChange}
                  className="w-full pl-10 pr-12 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-transparent"
                  placeholder="••••"
                  maxLength="4"
                  pattern="[0-9]{4}"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPin(!showConfirmPin)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showConfirmPin ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={loading}
              className="w-full py-3 bg-gradient-to-r from-emerald-500 to-emerald-600 text-white rounded-lg font-semibold hover:from-emerald-600 hover:to-emerald-700 transition-all shadow-lg hover:shadow-xl disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Creating Account...' : 'Create Account'}
            </button>
          </form>

          {/* Login Link */}
          <div className="mt-6 text-center">
            <p className="text-gray-600 text-sm">
              Already have an account?{' '}
              <button
                onClick={() => navigate('/login')}
                className="text-emerald-600 font-semibold hover:text-emerald-700"
              >
                Sign In
              </button>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MerchantRegister;
