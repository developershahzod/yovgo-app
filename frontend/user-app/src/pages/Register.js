import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Car, ArrowLeft, Phone, Mail, User } from 'lucide-react';

const Register = () => {
  const [formData, setFormData] = useState({
    phoneNumber: '',
    email: '',
    fullName: '',
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const { register } = useAuth();
  const navigate = useNavigate();

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const result = await register(
      formData.phoneNumber,
      formData.email,
      formData.fullName
    );

    if (result.success) {
      navigate('/login');
    } else {
      setError(result.error);
    }

    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-500 to-primary-700 flex flex-col">
      <div className="p-6">
        <button
          onClick={() => navigate('/welcome')}
          className="text-white flex items-center space-x-2"
        >
          <ArrowLeft size={24} />
          <span>Back</span>
        </button>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-6 pb-12">
        <div className="w-full max-w-md">
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-16 h-16 bg-white rounded-full mb-4">
              <Car className="text-primary-600" size={32} />
            </div>
            <h1 className="text-3xl font-bold text-white mb-2">Create Account</h1>
            <p className="text-primary-100">Join YuvGo today</p>
          </div>

          {error && (
            <div className="mb-4 p-4 bg-red-500/20 backdrop-blur-sm border border-red-300 rounded-xl">
              <p className="text-white text-sm">{error}</p>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-white font-medium mb-2">
                Full Name
              </label>
              <div className="relative">
                <User className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="text"
                  name="fullName"
                  value={formData.fullName}
                  onChange={handleChange}
                  className="w-full pl-12 pr-4 py-4 bg-white/10 backdrop-blur-sm border border-white/30 rounded-xl text-white placeholder-primary-200 focus:outline-none focus:ring-2 focus:ring-white/50"
                  placeholder="John Doe"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-white font-medium mb-2">
                Phone Number
              </label>
              <div className="relative">
                <Phone className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="tel"
                  name="phoneNumber"
                  value={formData.phoneNumber}
                  onChange={handleChange}
                  className="w-full pl-12 pr-4 py-4 bg-white/10 backdrop-blur-sm border border-white/30 rounded-xl text-white placeholder-primary-200 focus:outline-none focus:ring-2 focus:ring-white/50"
                  placeholder="+998 90 123 4567"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-white font-medium mb-2">
                Email (Optional)
              </label>
              <div className="relative">
                <Mail className="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  className="w-full pl-12 pr-4 py-4 bg-white/10 backdrop-blur-sm border border-white/30 rounded-xl text-white placeholder-primary-200 focus:outline-none focus:ring-2 focus:ring-white/50"
                  placeholder="john@example.com"
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-white text-primary-600 py-4 px-6 rounded-xl font-semibold text-lg shadow-lg hover:bg-primary-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? 'Creating Account...' : 'Sign Up'}
            </button>
          </form>

          <div className="mt-6 text-center">
            <p className="text-primary-100">
              Already have an account?{' '}
              <Link to="/login" className="text-white font-semibold underline">
                Sign in
              </Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Register;
