import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Check, Sparkles, Calendar, Zap, AlertCircle } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const Subscriptions = () => {
  const { API_URL } = useAuth();
  const navigate = useNavigate();
  const [plans, setPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedPlan, setSelectedPlan] = useState(null);
  const [purchasing, setPurchasing] = useState(false);
  const [activeSubscription, setActiveSubscription] = useState(null);

  useEffect(() => {
    checkActiveSubscription();
    fetchPlans();
  }, []);

  const checkActiveSubscription = () => {
    const subData = localStorage.getItem('active_subscription');
    if (subData) {
      const sub = JSON.parse(subData);
      const endDate = new Date(sub.end_date);
      const now = new Date();
      
      // Check if subscription is still valid
      if (endDate > now && sub.visits_remaining > 0) {
        setActiveSubscription(sub);
      } else {
        // Expired or no visits left
        localStorage.removeItem('active_subscription');
        setActiveSubscription(null);
      }
    }
  };

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
    setSelectedPlan(planId);
    
    try {
      // Find the selected plan from database data
      const selectedPlanData = plans.find(p => p.id === planId);
      if (!selectedPlanData) {
        throw new Error('Plan not found');
      }

      // Mock payment process (in production, integrate with Payme/Click/Paynet)
      // Simulate payment delay
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Create subscription with real plan data
      const subscription = {
        id: 'sub_' + Date.now(),
        plan_id: planId,
        plan_name: selectedPlanData.name,
        status: 'active',
        start_date: new Date().toISOString(),
        end_date: new Date(Date.now() + (selectedPlanData.duration_days * 24 * 60 * 60 * 1000)).toISOString(),
        visits_remaining: selectedPlanData.visit_limit || 999,
        visits_used: 0,
        is_unlimited: selectedPlanData.is_unlimited,
        auto_renew: true,
        price: selectedPlanData.price,
        currency: selectedPlanData.currency
      };
      
      // Store subscription in localStorage
      localStorage.setItem('active_subscription', JSON.stringify(subscription));
      
      // Show success message
      alert(`🎉 Payment Successful! Your ${selectedPlanData.name} subscription is now active.`);
      
      // Redirect to home page
      navigate('/home');
      
    } catch (error) {
      alert(error.message || 'Payment failed. Please try again.');
    } finally {
      setPurchasing(false);
      setSelectedPlan(null);
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
        <h1 className="text-2xl font-bold mb-2">
          {activeSubscription ? 'Active Subscription' : 'Subscription Plans'}
        </h1>
        <p className="text-primary-100">
          {activeSubscription ? 'Manage your subscription' : 'Choose the perfect plan for you'}
        </p>
      </div>

      {/* Active Subscription Info */}
      {activeSubscription && (
        <div className="px-6 py-6">
          <div className="bg-white rounded-2xl p-6 shadow-lg border-2 border-primary-500">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-2">
                <Sparkles className="text-primary-600" size={24} />
                <h2 className="text-xl font-bold text-gray-900">Your Plan</h2>
              </div>
              <span className="px-3 py-1 bg-green-100 text-green-700 rounded-full text-sm font-medium">
                Active
              </span>
            </div>
            
            <div className="space-y-4">
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Visits Remaining</span>
                <span className="text-2xl font-bold text-primary-600">
                  {activeSubscription.visits_remaining}
                </span>
              </div>
              
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Valid Until</span>
                <span className="font-semibold text-gray-900">
                  {new Date(activeSubscription.end_date).toLocaleDateString()}
                </span>
              </div>
              
              <div className="pt-4 border-t border-gray-200">
                <button
                  onClick={() => navigate('/qr')}
                  className="w-full py-3 bg-gradient-to-r from-primary-500 to-primary-600 text-white rounded-xl font-semibold shadow-lg hover:shadow-xl transition-all"
                >
                  Scan QR Code
                </button>
              </div>
            </div>
          </div>

          <div className="mt-6 bg-blue-50 border border-blue-200 rounded-xl p-4">
            <div className="flex items-start gap-3">
              <AlertCircle className="text-blue-600 flex-shrink-0 mt-0.5" size={20} />
              <div>
                <p className="text-blue-900 font-medium text-sm">Active Plan</p>
                <p className="text-blue-700 text-sm mt-1">
                  You already have an active subscription. New plans will be available after your current plan expires or runs out of visits.
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Plans - Only show if no active subscription */}
      {!activeSubscription && (
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
      )}

      {/* Info */}
      {!activeSubscription && (
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
      )}
    </div>
  );
};

export default Subscriptions;
