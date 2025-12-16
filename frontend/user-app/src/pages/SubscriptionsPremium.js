import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Check, Sparkles, Zap, Crown, ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import BottomNav from '../components/BottomNav';

const SubscriptionsPremium = () => {
  const { API_URL, user } = useAuth();
  const navigate = useNavigate();
  const [plans, setPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [purchasing, setPurchasing] = useState(false);
  const [activeSubscription, setActiveSubscription] = useState(null);

  useEffect(() => {
    // Проверяем что пользователь залогинен
    const token = localStorage.getItem('user_token');
    console.log('Page loaded. Token:', token);
    console.log('User:', user);
    
    if (!token && !user) {
      console.warn('No token or user found, redirecting to login');
      navigate('/login');
      return;
    }
    
    checkActiveSubscription();
    fetchPlans();
  }, [user]);

  const checkActiveSubscription = () => {
    const subData = localStorage.getItem('active_subscription');
    if (subData) {
      const sub = JSON.parse(subData);
      const endDate = new Date(sub.end_date);
      const now = new Date();
      
      if (endDate > now && sub.visits_remaining > 0) {
        setActiveSubscription(sub);
      } else {
        localStorage.removeItem('active_subscription');
        setActiveSubscription(null);
      }
    }
  };

  const fetchPlans = async () => {
    try {
      const SUBSCRIPTION_API = 'http://localhost:8002';
      const response = await axios.get(`${SUBSCRIPTION_API}/plans`);
      setPlans(response.data);
    } catch (error) {
      console.error('Failed to fetch plans:', error);
    } finally {
      setLoading(false);
    }
  };

  const handlePurchase = async (planId) => {
    setPurchasing(true);
    setSelectedPlan(planId);
    
    try {
      const selectedPlanData = plans.find(p => p.id === planId);
      if (!selectedPlanData) {
        throw new Error('Plan not found');
      }

      // Получаем токен из localStorage
      const token = localStorage.getItem('user_token');
      console.log('Token from localStorage:', token);
      console.log('User from context:', user);
      
      if (!token) {
        console.error('No token found in localStorage');
        console.log('All localStorage keys:', Object.keys(localStorage));
        throw new Error('Необходимо войти в систему');
      }

      // Отправляем запрос на создание подписки (Subscription Service на порту 8002)
      const SUBSCRIPTION_API = 'http://localhost:8002';
      const response = await axios.post(
        `${SUBSCRIPTION_API}/subscriptions`,
        {
          plan_id: planId,
          auto_renew: true
        },
        {
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
          }
        }
      );

      // Сохраняем подписку из ответа backend
      const subscription = {
        id: response.data.id,
        plan_id: response.data.plan_id,
        plan_name: selectedPlanData.name,
        status: response.data.status,
        start_date: response.data.start_date,
        end_date: response.data.end_date,
        visits_remaining: response.data.visits_remaining || selectedPlanData.visit_limit || 999,
        visits_used: 0,
        is_unlimited: response.data.is_unlimited || selectedPlanData.is_unlimited,
        auto_renew: response.data.auto_renew,
        price: selectedPlanData.price,
        currency: selectedPlanData.currency
      };
      
      localStorage.setItem('active_subscription', JSON.stringify(subscription));
      
      alert(`🎉 Оплата успешна! Ваша подписка ${selectedPlanData.name} активирована.`);
      navigate('/home');
      
    } catch (error) {
      console.error('Purchase error:', error);
      alert(error.response?.data?.detail || error.message || 'Ошибка оплаты. Попробуйте снова.');
    } finally {
      setPurchasing(false);
      setSelectedPlan(null);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-[#F5F5F7] flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-yuvgo-cyan border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-600">Загрузка планов...</p>
        </div>
      </div>
    );
  }

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
            <h1 className="text-xl font-bold text-gray-900">Подписки</h1>
            <p className="text-sm text-gray-500">Выберите подходящий план</p>
          </div>
        </div>
      </div>

      {/* Active Subscription */}
      {activeSubscription && (
        <div className="px-6 py-4">
          <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl p-4 border border-green-200">
            <div className="flex items-center gap-3">
              <div className="w-12 h-12 rounded-full bg-green-100 flex items-center justify-center">
                <Check size={24} className="text-green-600" />
              </div>
              <div className="flex-1">
                <p className="text-sm font-semibold text-green-900">Активная подписка</p>
                <p className="text-lg font-bold text-green-700">{activeSubscription.plan_name}</p>
              </div>
              <div className="text-right">
                <p className="text-sm text-green-600">Осталось</p>
                <p className="text-xl font-black text-green-700">{activeSubscription.visits_remaining}</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Plans Grid */}
      <div className="px-6 py-4 space-y-4">
        {plans.map((plan, index) => {
          const isPopular = index === 1; // Make second plan popular
          const isPremium = plan.is_unlimited;
          
          return (
            <div
              key={plan.id}
              className={`bg-white rounded-2xl p-6 border-2 transition-all ${
                isPopular 
                  ? 'border-yuvgo-cyan' 
                  : 'border-gray-200'
              }`}
            >
              {/* Badge */}
              {isPopular && (
                <div className="flex items-center gap-2 mb-4">
                  <div className="px-3 py-1 bg-yuvgo-cyan text-white text-xs font-bold rounded-full">
                    ПОПУЛЯРНЫЙ
                  </div>
                </div>
              )}

              {/* Header */}
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className={`w-14 h-14 rounded-2xl flex items-center justify-center ${
                    isPremium ? 'bg-yellow-50' : 'bg-blue-50'
                  }`}>
                    {isPremium ? (
                      <Crown size={28} className="text-yellow-500" />
                    ) : (
                      <Zap size={28} className="text-blue-500" />
                    )}
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-gray-900">{plan.name}</h3>
                    <p className="text-sm text-gray-500">{plan.description}</p>
                  </div>
                </div>
              </div>

              {/* Price */}
              <div className="mb-6">
                <div className="flex items-baseline gap-2">
                  <span className="text-3xl font-black text-gray-900">
                    {(plan.price / 1000).toFixed(0)}K
                  </span>
                  <span className="text-lg text-gray-600">UZS</span>
                  <span className="text-sm text-gray-500">/ {plan.duration_days} дней</span>
                </div>
              </div>

              {/* Features */}
              <div className="space-y-3 mb-6">
                <div className="flex items-center gap-3">
                  <div className="w-5 h-5 rounded-full bg-green-100 flex items-center justify-center">
                    <Check size={14} className="text-green-600" />
                  </div>
                  <span className="text-sm text-gray-700">
                    {plan.is_unlimited ? 'Безлимитные визиты' : `${plan.visit_limit} визитов`}
                  </span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-5 h-5 rounded-full bg-green-100 flex items-center justify-center">
                    <Check size={14} className="text-green-600" />
                  </div>
                  <span className="text-sm text-gray-700">
                    Все партнерские автомойки
                  </span>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-5 h-5 rounded-full bg-green-100 flex items-center justify-center">
                    <Check size={14} className="text-green-600" />
                  </div>
                  <span className="text-sm text-gray-700">
                    Поддержка 24/7
                  </span>
                </div>
              </div>

              {/* Button */}
              <button
                onClick={() => handlePurchase(plan.id)}
                disabled={purchasing && selectedPlan === plan.id}
                className={`w-full py-4 rounded-xl font-bold text-base transition-all ${
                  isPopular
                    ? 'bg-yuvgo-cyan text-white active:scale-95'
                    : 'bg-gray-900 text-white active:scale-95'
                } disabled:opacity-50 disabled:cursor-not-allowed`}
              >
                {purchasing && selectedPlan === plan.id ? (
                  <span className="flex items-center justify-center gap-2">
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                    Обработка...
                  </span>
                ) : activeSubscription?.plan_id === plan.id ? (
                  'Текущий план'
                ) : (
                  'Выбрать план'
                )}
              </button>
            </div>
          );
        })}
      </div>


      <BottomNav />
    </div>
  );
};

export default SubscriptionsPremium;
