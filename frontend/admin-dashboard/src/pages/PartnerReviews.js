import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Star, Trash2, MapPin, User, Calendar } from 'lucide-react';

const PartnerReviews = () => {
  const { API_URL } = useAuth();
  const [reviews, setReviews] = useState([]);
  const [partners, setPartners] = useState([]);
  const [locations, setLocations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPartner, setSelectedPartner] = useState('all');
  const [selectedLocation, setSelectedLocation] = useState('all');
  const [success, setSuccess] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      
      // Fetch partners
      const partnersRes = await axios.get(`${API_URL}/api/partner/partners`);
      setPartners(partnersRes.data || []);

      // Fetch all reviews from database
      const reviewsRes = await axios.get(`${API_URL}/api/partner/reviews`);
      setReviews(reviewsRes.data || []);

      // Fetch all locations
      const locationsRes = await axios.get(`${API_URL}/api/partner/locations`);
      setLocations(locationsRes.data || []);
    } catch (err) {
      console.error('Failed to fetch data:', err);
      setError('Ma\'lumotlarni yuklashda xatolik');
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteReview = async (reviewId) => {
    if (!window.confirm('Bu sharhni o\'chirmoqchimisiz?')) return;
    
    try {
      await axios.delete(`${API_URL}/api/partner/reviews/${reviewId}`);
      setSuccess('Sharh o\'chirildi!');
      fetchData();
      setTimeout(() => setSuccess(''), 3000);
    } catch (err) {
      setError(err.response?.data?.detail || 'O\'chirishda xatolik');
      setTimeout(() => setError(''), 3000);
    }
  };

  const getPartnerName = (partnerId) => {
    const partner = partners.find(p => p.id === partnerId);
    return partner?.name || 'Unknown';
  };

  const getLocationName = (locationId) => {
    const location = locations.find(l => l.id === locationId);
    return location?.name || 'Main';
  };

  const filteredReviews = reviews.filter(review => {
    if (selectedPartner !== 'all' && review.partner_id !== selectedPartner) return false;
    if (selectedLocation !== 'all' && review.location_id !== selectedLocation) return false;
    return true;
  });

  const renderStars = (rating) => {
    return (
      <div className="flex items-center gap-1">
        {[1, 2, 3, 4, 5].map(star => (
          <Star
            key={star}
            size={16}
            className={star <= rating ? 'fill-yellow-400 text-yellow-400' : 'text-gray-300'}
          />
        ))}
      </div>
    );
  };

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">Sharhlar (Reviews)</h1>
        <p className="text-gray-600 mt-1">Partnerlar va filiallar uchun sharhlarni boshqarish</p>
      </div>

      {success && (
        <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg">
          <p className="text-sm text-green-600">{success}</p>
        </div>
      )}

      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg">
          <p className="text-sm text-red-600">{error}</p>
        </div>
      )}

      {/* Filters */}
      <div className="bg-white rounded-lg shadow p-4 mb-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Partner</label>
            <select
              value={selectedPartner}
              onChange={(e) => setSelectedPartner(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg"
            >
              <option value="all">Barcha partnerlar</option>
              {partners.map(partner => (
                <option key={partner.id} value={partner.id}>{partner.name}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Filial</label>
            <select
              value={selectedLocation}
              onChange={(e) => setSelectedLocation(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              disabled={selectedPartner === 'all'}
            >
              <option value="all">Barcha filiallar</option>
              {locations
                .filter(loc => selectedPartner === 'all' || loc.partner_id === selectedPartner)
                .map(location => (
                  <option key={location.id} value={location.id}>{location.name}</option>
                ))}
            </select>
          </div>
        </div>
      </div>

      {/* Reviews List */}
      <div className="bg-white rounded-lg shadow">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
          </div>
        ) : filteredReviews.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500">Sharhlar topilmadi</p>
          </div>
        ) : (
          <div className="divide-y divide-gray-200">
            {filteredReviews.map((review) => (
              <div key={review.id} className="p-6 hover:bg-gray-50">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    {/* Header */}
                    <div className="flex items-center gap-3 mb-2">
                      {renderStars(review.rating)}
                      <span className="text-sm font-semibold text-gray-900">
                        {review.rating}.0
                      </span>
                    </div>

                    {/* Comment */}
                    {review.comment && (
                      <p className="text-gray-700 mb-3">{review.comment}</p>
                    )}

                    {/* Meta Info */}
                    <div className="flex flex-wrap items-center gap-4 text-sm text-gray-500">
                      <div className="flex items-center gap-1">
                        <MapPin size={14} />
                        <span>{getPartnerName(review.partner_id)}</span>
                        {review.location_id && (
                          <span className="text-gray-400">
                            • {getLocationName(review.location_id)}
                          </span>
                        )}
                      </div>
                      
                      {review.user_id && (
                        <div className="flex items-center gap-1">
                          <User size={14} />
                          <span>User ID: {review.user_id.substring(0, 8)}...</span>
                        </div>
                      )}

                      <div className="flex items-center gap-1">
                        <Calendar size={14} />
                        <span>{new Date(review.created_at).toLocaleDateString('ru-RU')}</span>
                      </div>
                    </div>
                  </div>

                  {/* Delete Button */}
                  <button
                    onClick={() => handleDeleteReview(review.id)}
                    className="ml-4 p-2 text-red-500 hover:text-red-700 hover:bg-red-50 rounded-lg transition-colors"
                    title="O'chirish"
                  >
                    <Trash2 size={18} />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Stats */}
      {!loading && filteredReviews.length > 0 && (
        <div className="mt-6 bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">Statistika</h3>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="text-center">
              <p className="text-3xl font-bold text-gray-900">{filteredReviews.length}</p>
              <p className="text-sm text-gray-500">Jami sharhlar</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-yellow-500">
                {(filteredReviews.reduce((sum, r) => sum + r.rating, 0) / filteredReviews.length).toFixed(1)}
              </p>
              <p className="text-sm text-gray-500">O'rtacha reyting</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-green-500">
                {filteredReviews.filter(r => r.rating === 5).length}
              </p>
              <p className="text-sm text-gray-500">5 yulduzli</p>
            </div>
            <div className="text-center">
              <p className="text-3xl font-bold text-red-500">
                {filteredReviews.filter(r => r.rating <= 2).length}
              </p>
              <p className="text-sm text-gray-500">Yomon (≤2)</p>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default PartnerReviews;
