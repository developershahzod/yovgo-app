import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Check, Sparkles, Calendar, Zap } from 'lucide-react';

const Subscriptions = () => {
  const { API_URL } = useAuth();
  const [plans, setPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [purchasing, setPurchasing] = useState(false);

  useEffect(() => {
    fetchPlans();
  }, []);

  const fetchPlans = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/subscription/plans`);
      setPlans(response.data);
    } catch (error) {
      console.error('Failed to fetch plans:', error);
    } finally {
      setLoading(false);
    }
  };

  const handlePurchase = async (planId) => {
    setPurchasing(true);
    try {
      // Create subscription
      const subResponse = await axios.post(`${API_URL}/api/subscription/subscriptions`, {
        plan_id: planId,
        auto_renew: true,
      });

      // In production, redirect to payment gateway
      alert('Subscription created! Redirecting to payment...');
      
      // For demo, mark as success
      window.location.href = '/home';
    } catch (error) {
      alert(error.response?.data?.detail || 'Failed to create subscription');
    } finally {
      setPurchasing(false);
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
        <h1 className="text-2xl font-bold mb-2">Subscription Plans</h1>
        <p className="text-primary-100">Choose the perfect plan for you</p>
      </div>

      {/* Plans */}
      <div className="px-6 py-6 space-y-4">
        {plans.map((plan) => {
          const isPopular = plan.name.includes('Premium');
          
          return (
            <div
              key={plan.id}
              className={`bg-white rounded-2xl shadow-lg overflow-hidden ${
                isPopular ? 'ring-2 ring-primary-500' : ''
              }`}
            >
              {isPopular && (
                <div className="bg-primary-500 text-white text-center py-2 text-sm font-semibold">
                  ⭐ Most Popular
                </div>
              )}
              
              <div className="p-6">
                <div className="flex items-start justify-between mb-4">
                  <div>
                    <h3 className="text-xl font-bold text-gray-900 mb-1">
                      {plan.name}
                    </h3>
                    <p className="text-gray-600 text-sm">{plan.description}</p>
                  </div>
                  <div className={`w-12 h-12 rounded-full flex items-center justify-center ${
                    isPopular ? 'bg-primary-100' : 'bg-gray-100'
                  }`}>
                    {plan.is_unlimited ? (
                      <Zap className={isPopular ? 'text-primary-600' : 'text-gray-600'} size={24} />
                    ) : (
                      <Sparkles className={isPopular ? 'text-primary-600' : 'text-gray-600'} size={24} />
                    )}
                  </div>
                </div>

                <div className="mb-6">
                  <div className="flex items-baseline">
                    <span className="text-4xl font-bold text-gray-900">
                      {(plan.price / 1000).toFixed(0)}K
                    </span>
                    <span className="text-gray-600 ml-2">UZS</span>
                  </div>
                  <div className="flex items-center text-gray-600 text-sm mt-1">
                    <Calendar size={14} className="mr-1" />
                    <span>{plan.duration_days} days</span>
                  </div>
                </div>

                <div className="space-y-3 mb-6">
                  <div className="flex items-center space-x-3">
                    <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                      <Check size={14} className="text-green-600" />
                    </div>
                    <span className="text-gray-700 text-sm">
                      {plan.is_unlimited 
                        ? 'Unlimited car washes' 
                        : `${plan.visit_limit} car washes`}
                    </span>
                  </div>
                  
                  <div className="flex items-center space-x-3">
                    <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                      <Check size={14} className="text-green-600" />
                    </div>
                    <span className="text-gray-700 text-sm">
                      Access to all partner locations
                    </span>
                  </div>
                  
                  <div className="flex items-center space-x-3">
                    <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                      <Check size={14} className="text-green-600" />
                    </div>
                    <span className="text-gray-700 text-sm">
                      Easy QR code check-in
                    </span>
                  </div>
                  
                  {plan.is_unlimited && (
                    <div className="flex items-center space-x-3">
                      <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                        <Check size={14} className="text-green-600" />
                      </div>
                      <span className="text-gray-700 text-sm">
                        Priority support
                      </span>
                    </div>
                  )}
                </div>

                <button
                  onClick={() => handlePurchase(plan.id)}
                  disabled={purchasing}
                  className={`w-full py-3 px-4 rounded-xl font-semibold transition-colors ${
                    isPopular
                      ? 'bg-primary-600 text-white hover:bg-primary-700'
                      : 'bg-gray-900 text-white hover:bg-gray-800'
                  } disabled:opacity-50 disabled:cursor-not-allowed`}
                >
                  {purchasing ? 'Processing...' : 'Subscribe Now'}
                </button>
              </div>
            </div>
          );
        })}
      </div>

      {/* Info */}
      <div className="px-6 pb-6">
        <div className="bg-blue-50 rounded-2xl p-4">
          <p className="text-blue-900 font-medium text-sm mb-2">
            💳 Payment Methods
          </p>
          <p className="text-blue-700 text-xs">
            We accept Payme, Click, and Paynet. Your subscription will be activated immediately after payment.
          </p>
        </div>
      </div>
    </div>
  );
};

export default Subscriptions;
