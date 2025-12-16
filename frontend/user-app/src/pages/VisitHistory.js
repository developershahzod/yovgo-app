import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import axios from 'axios';
import { ArrowLeft, Calendar, MapPin, CheckCircle, Clock } from 'lucide-react';
import BottomNav from '../components/BottomNav';

const VisitHistory = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [visits, setVisits] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchVisits();
  }, []);

  const fetchVisits = async () => {
    try {
      setLoading(true);
      const VISIT_API = 'http://localhost:8004';
      const response = await axios.get(`${VISIT_API}/visits?user_id=${user.id}`);
      setVisits(response.data);
    } catch (error) {
      console.error('Failed to fetch visits:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    const today = new Date();
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    if (date.toDateString() === today.toDateString()) {
      return `Сегодня, ${date.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' })}`;
    } else if (date.toDateString() === yesterday.toDateString()) {
      return `Вчера, ${date.toLocaleTimeString('ru-RU', { hour: '2-digit', minute: '2-digit' })}`;
    } else {
      return date.toLocaleDateString('ru-RU', { 
        day: 'numeric', 
        month: 'long',
        hour: '2-digit',
        minute: '2-digit'
      });
    }
  };

  return (
    <div className="min-h-screen bg-[#F5F5F7] pb-24">
      {/* Header */}
      <div className="bg-white px-6 py-4 border-b border-gray-200">
        <div className="flex items-center gap-4">
          <button 
            onClick={() => navigate('/home')}
            className="w-10 h-10 rounded-full bg-gray-100 flex items-center justify-center"
          >
            <ArrowLeft size={20} className="text-gray-700" />
          </button>
          <div>
            <h1 className="text-xl font-bold text-gray-900">История визитов</h1>
            <p className="text-sm text-gray-500">Все ваши посещения</p>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {loading ? (
          <div className="flex items-center justify-center py-12">
            <div className="w-12 h-12 border-4 border-gray-200 border-t-gray-900 rounded-full animate-spin"></div>
          </div>
        ) : visits.length === 0 ? (
          <div className="text-center py-12">
            <div className="w-20 h-20 rounded-full bg-gray-100 flex items-center justify-center mx-auto mb-4">
              <Calendar size={32} className="text-gray-400" />
            </div>
            <h3 className="text-lg font-bold text-gray-900 mb-2">Нет визитов</h3>
            <p className="text-gray-500 mb-6">Отсканируйте QR код на автомойке</p>
            <button
              onClick={() => navigate('/qr')}
              className="bg-gray-900 text-white px-6 py-3 rounded-xl font-semibold"
            >
              Сканировать QR
            </button>
          </div>
        ) : (
          <div className="space-y-3">
            {visits.map((visit) => (
              <div key={visit.id} className="bg-white rounded-2xl p-4 border border-gray-200">
                <div className="flex items-start gap-3">
                  <div className="w-12 h-12 rounded-xl bg-green-50 flex items-center justify-center flex-shrink-0">
                    <CheckCircle size={24} className="text-green-500" />
                  </div>
                  
                  <div className="flex-1">
                    <div className="flex items-start justify-between mb-2">
                      <div>
                        <h3 className="font-bold text-gray-900">Визит завершен</h3>
                        <div className="flex items-center gap-2 text-sm text-gray-500 mt-1">
                          <Clock size={14} />
                          <span>{formatDate(visit.check_in_time)}</span>
                        </div>
                      </div>
                      <span className="text-xs font-semibold text-green-600 bg-green-50 px-2 py-1 rounded-lg">
                        {visit.status === 'completed' ? 'Завершен' : visit.status}
                      </span>
                    </div>
                    
                    {visit.partner_name && (
                      <div className="flex items-center gap-2 text-sm text-gray-600 mt-2">
                        <MapPin size={14} />
                        <span>{visit.partner_name}</span>
                      </div>
                    )}
                    
                    {visit.notes && (
                      <p className="text-sm text-gray-500 mt-2">{visit.notes}</p>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default VisitHistory;
