import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Car, Calendar, MapPin, Sparkles, ArrowRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const Home = () => {
  const { user, API_URL } = useAuth();
  const navigate = useNavigate();
  const [subscription, setSubscription] = useState(null);
  const [visits, setVisits] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      // Fetch subscription status
      const subRes = await axios.get(`${API_URL}/api/subscription/subscriptions/status`);
      setSubscription(subRes.data);

      // Fetch recent visits
      const visitsRes = await axios.get(`${API_URL}/api/visit/visits?limit=5`);
      setVisits(visitsRes.data);
    } catch (error) {
      console.error('Failed to fetch data:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-gradient-to-br from-primary-500 to-primary-700 text-white p-6 rounded-b-3xl shadow-lg">
        <div className="flex items-center justify-between mb-6">
          <div>
            <p className="text-primary-100 text-sm">Welcome back,</p>
            <h1 className="text-2xl font-bold">{user?.full_name || 'User'}</h1>
          </div>
          <div className="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
            <Car size={24} />
          </div>
        </div>

        {/* Subscription Card */}
        {subscription ? (
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-4 border border-white/20">
            <div className="flex items-center justify-between mb-3">
              <div className="flex items-center space-x-2">
                <Sparkles size={20} />
                <span className="font-semibold">Active Subscription</span>
              </div>
              <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                subscription.status === 'active' 
                  ? 'bg-green-500/30 text-green-100' 
                  : 'bg-yellow-500/30 text-yellow-100'
              }`}>
                {subscription.status}
              </span>
            </div>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-2xl font-bold">{subscription.visits_used || 0}</p>
                <p className="text-primary-100 text-sm">Visits used</p>
              </div>
              <div className="text-right">
                <p className="text-2xl font-bold">
                  {subscription.visit_limit ? subscription.visit_limit - (subscription.visits_used || 0) : '∞'}
                </p>
                <p className="text-primary-100 text-sm">Remaining</p>
              </div>
            </div>
            <div className="mt-3 pt-3 border-t border-white/20">
              <p className="text-primary-100 text-xs">
                Valid until {new Date(subscription.end_date).toLocaleDateString()}
              </p>
            </div>
          </div>
        ) : (
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20 text-center">
            <Sparkles className="mx-auto mb-3" size={32} />
            <p className="font-semibold mb-2">No Active Subscription</p>
            <p className="text-primary-100 text-sm mb-4">
              Subscribe now to start washing your car
            </p>
            <button
              onClick={() => navigate('/subscriptions')}
              className="bg-white text-primary-600 px-6 py-2 rounded-lg font-medium hover:bg-primary-50 transition-colors"
            >
              View Plans
            </button>
          </div>
        )}
      </div>

      {/* Quick Actions */}
      <div className="px-6 py-6">
        <h2 className="text-lg font-bold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-2 gap-4">
          <button
            onClick={() => navigate('/qr')}
            className="bg-white rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="w-12 h-12 bg-primary-100 rounded-full flex items-center justify-center mb-3">
              <Car className="text-primary-600" size={24} />
            </div>
            <p className="font-semibold text-gray-900">My QR Code</p>
            <p className="text-gray-500 text-sm mt-1">Show at car wash</p>
          </button>

          <button
            onClick={() => navigate('/map')}
            className="bg-white rounded-2xl p-6 shadow-sm hover:shadow-md transition-shadow"
          >
            <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mb-3">
              <MapPin className="text-green-600" size={24} />
            </div>
            <p className="font-semibold text-gray-900">Find Locations</p>
            <p className="text-gray-500 text-sm mt-1">Near you</p>
          </button>
        </div>
      </div>

      {/* Recent Visits */}
      <div className="px-6 py-4">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-lg font-bold text-gray-900">Recent Visits</h2>
          {visits.length > 0 && (
            <button className="text-primary-600 text-sm font-medium flex items-center">
              View All <ArrowRight size={16} className="ml-1" />
            </button>
          )}
        </div>

        {visits.length === 0 ? (
          <div className="bg-white rounded-2xl p-8 text-center shadow-sm">
            <Calendar className="mx-auto text-gray-300 mb-3" size={48} />
            <p className="text-gray-500">No visits yet</p>
            <p className="text-gray-400 text-sm mt-1">
              Your visit history will appear here
            </p>
          </div>
        ) : (
          <div className="space-y-3">
            {visits.map((visit) => (
              <div key={visit.id} className="bg-white rounded-xl p-4 shadow-sm">
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                      <Car className="text-primary-600" size={20} />
                    </div>
                    <div>
                      <p className="font-medium text-gray-900">Car Wash Visit</p>
                      <p className="text-gray-500 text-sm">
                        {new Date(visit.check_in_time).toLocaleDateString()}
                      </p>
                    </div>
                  </div>
                  <span className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-medium">
                    Completed
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default Home;
