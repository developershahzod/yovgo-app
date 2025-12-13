import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import { MapPin, Phone, Clock, Navigation, AlertCircle, Sparkles } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Fix for default marker icon
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

const Map = () => {
  const { API_URL } = useAuth();
  const navigate = useNavigate();
  const [locations, setLocations] = useState([]);
  const [selectedLocation, setSelectedLocation] = useState(null);
  const [userLocation, setUserLocation] = useState([41.2995, 69.2401]); // Tashkent default
  const [loading, setLoading] = useState(true);
  const [subscription, setSubscription] = useState(null);
  const [showSubscriptionPrompt, setShowSubscriptionPrompt] = useState(false);

  useEffect(() => {
    checkSubscription();
    fetchLocations();
    getUserLocation();
  }, []);

  const checkSubscription = () => {
    const subData = localStorage.getItem('active_subscription');
    if (subData) {
      const sub = JSON.parse(subData);
      const endDate = new Date(sub.end_date);
      const now = new Date();
      
      // Check if expired or no visits
      if (endDate <= now || sub.visits_remaining <= 0) {
        setShowSubscriptionPrompt(true);
        localStorage.removeItem('active_subscription');
      } else {
        setSubscription(sub);
      }
    } else {
      setShowSubscriptionPrompt(true);
    }
  };

  const getUserLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          setUserLocation([position.coords.latitude, position.coords.longitude]);
        },
        (error) => {
          console.error('Error getting location:', error);
        }
      );
    }
  };

  const fetchLocations = async () => {
    try {
      // Fetch partners
      const partnersResponse = await axios.get(`${API_URL}/api/partner/partners`);
      const partners = partnersResponse.data;
      
      // Create mock locations based on real partners
      const mockLocations = partners.map((partner, index) => {
        // Tashkent coordinates with slight variations
        const baseLatitude = 41.2995;
        const baseLongitude = 69.2401;
        const latOffset = (Math.random() - 0.5) * 0.1; // ~5km variation
        const lngOffset = (Math.random() - 0.5) * 0.1;
        
        return {
          id: partner.id,
          name: partner.name,
          address: partner.description || `${partner.name} Location`,
          city: 'Tashkent',
          latitude: baseLatitude + latOffset,
          longitude: baseLongitude + lngOffset,
          working_hours: {
            monday: '09:00-20:00',
            tuesday: '09:00-20:00',
            wednesday: '09:00-20:00',
            thursday: '09:00-20:00',
            friday: '09:00-20:00',
            saturday: '10:00-18:00',
            sunday: '10:00-18:00'
          },
          phone: '+998 90 123 45 67',
          is_active: partner.is_active
        };
      });
      
      setLocations(mockLocations.filter(loc => loc.is_active));
      
    } catch (error) {
      console.error('Failed to fetch locations:', error);
      // Fallback to hardcoded locations if API fails
      setLocations([
        {
          id: '1',
          name: 'YuvGo Car Wash - Chilanzar',
          address: 'Chilanzar District, Tashkent',
          city: 'Tashkent',
          latitude: 41.2856,
          longitude: 69.2034,
          working_hours: { monday: '09:00-20:00', saturday: '10:00-18:00' }
        },
        {
          id: '2',
          name: 'YuvGo Car Wash - Yunusabad',
          address: 'Yunusabad District, Tashkent',
          city: 'Tashkent',
          latitude: 41.3456,
          longitude: 69.2890,
          working_hours: { monday: '09:00-20:00', saturday: '10:00-18:00' }
        }
      ]);
    } finally {
      setLoading(false);
    }
  };

  const getDirections = (lat, lng) => {
    const url = `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`;
    window.open(url, '_blank');
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  return (
    <div className="h-screen flex flex-col">
      {/* Header */}
      <div className="bg-white p-4 shadow-sm">
        <h1 className="text-xl font-bold text-gray-900">Car Wash Locations</h1>
        <p className="text-gray-600 text-sm">{locations.length} locations available</p>
      </div>

      {/* Subscription Prompt */}
      {showSubscriptionPrompt && (
        <div className="bg-gradient-to-r from-primary-500 to-primary-600 p-4">
          <div className="flex items-start gap-3">
            <AlertCircle className="text-white flex-shrink-0 mt-0.5" size={20} />
            <div className="flex-1">
              <p className="text-white font-semibold text-sm">Subscription Required</p>
              <p className="text-primary-100 text-xs mt-1">
                Your subscription has expired or you have no visits remaining. Purchase a plan to start washing!
              </p>
            </div>
            <button
              onClick={() => navigate('/subscriptions')}
              className="bg-white text-primary-600 px-4 py-2 rounded-lg text-sm font-semibold hover:bg-primary-50 transition-colors flex items-center gap-1"
            >
              <Sparkles size={16} />
              View Plans
            </button>
          </div>
        </div>
      )}

      {/* Map */}
      <div className="flex-1 relative">
        <MapContainer
          center={userLocation}
          zoom={12}
          style={{ height: '100%', width: '100%' }}
        >
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />
          
          {locations.map((location) => (
            <Marker
              key={location.id}
              position={[location.latitude || 41.2995, location.longitude || 69.2401]}
              eventHandlers={{
                click: () => setSelectedLocation(location),
              }}
            >
              <Popup>
                <div className="p-2">
                  <h3 className="font-bold text-sm">{location.name}</h3>
                  <p className="text-xs text-gray-600 mt-1">{location.address}</p>
                </div>
              </Popup>
            </Marker>
          ))}
        </MapContainer>

        {/* Location Details Sheet */}
        {selectedLocation && (
          <div className="absolute bottom-0 left-0 right-0 bg-white rounded-t-3xl shadow-2xl p-6 slide-up max-h-[50vh] overflow-y-auto">
            <div className="w-12 h-1 bg-gray-300 rounded-full mx-auto mb-4"></div>
            
            <div className="flex items-start justify-between mb-4">
              <div className="flex-1">
                <h2 className="text-xl font-bold text-gray-900 mb-1">
                  {selectedLocation.name}
                </h2>
                <div className="flex items-start space-x-2 text-gray-600">
                  <MapPin size={16} className="mt-1 flex-shrink-0" />
                  <p className="text-sm">{selectedLocation.address}</p>
                </div>
              </div>
              <button
                onClick={() => setSelectedLocation(null)}
                className="text-gray-400 hover:text-gray-600"
              >
                ✕
              </button>
            </div>

            {selectedLocation.working_hours && (
              <div className="flex items-start space-x-2 text-gray-600 mb-3">
                <Clock size={16} className="mt-1 flex-shrink-0" />
                <div className="text-sm">
                  <p className="font-medium">Working Hours</p>
                  <p>Mon-Fri: {selectedLocation.working_hours.monday || '9:00-20:00'}</p>
                  <p>Sat-Sun: {selectedLocation.working_hours.saturday || '10:00-18:00'}</p>
                </div>
              </div>
            )}

            <button
              onClick={() => getDirections(
                selectedLocation.latitude || 41.2995,
                selectedLocation.longitude || 69.2401
              )}
              className="w-full bg-primary-600 text-white py-3 px-4 rounded-xl font-medium flex items-center justify-center space-x-2 hover:bg-primary-700 transition-colors"
            >
              <Navigation size={20} />
              <span>Get Directions</span>
            </button>
          </div>
        )}
      </div>

      {/* Location List */}
      <div className="bg-white border-t border-gray-200 p-4 max-h-48 overflow-y-auto">
        <h3 className="font-semibold text-gray-900 mb-3">All Locations</h3>
        <div className="space-y-2">
          {locations.map((location) => (
            <button
              key={location.id}
              onClick={() => setSelectedLocation(location)}
              className="w-full text-left p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <p className="font-medium text-gray-900 text-sm">{location.name}</p>
              <p className="text-gray-600 text-xs mt-1">{location.city}</p>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Map;
