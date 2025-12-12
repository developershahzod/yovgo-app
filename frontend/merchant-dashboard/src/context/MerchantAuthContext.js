import React, { createContext, useState, useContext, useEffect } from 'react';
import axios from 'axios';

const MerchantAuthContext = createContext();

export const useMerchantAuth = () => {
  const context = useContext(MerchantAuthContext);
  if (!context) {
    throw new Error('useMerchantAuth must be used within MerchantAuthProvider');
  }
  return context;
};

export const MerchantAuthProvider = ({ children }) => {
  const [merchant, setMerchant] = useState(null);
  const [loading, setLoading] = useState(true);

  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

  useEffect(() => {
    // Check if merchant is logged in
    const token = localStorage.getItem('merchant_token');
    const merchantData = localStorage.getItem('merchant_data');
    
    if (token && merchantData) {
      setMerchant(JSON.parse(merchantData));
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    }
    
    setLoading(false);
  }, []);

  const login = async (phoneNumber, pinCode) => {
    try {
      // Login via staff credentials
      const response = await axios.post(`${API_URL}/api/partner/staff/login`, {
        phone_number: phoneNumber,
        pin_code: pinCode,
      });

      const { access_token, staff, partner, location } = response.data;
      
      const merchantData = {
        id: staff.id,
        name: staff.full_name,
        phone: staff.phone_number,
        role: staff.role,
        partner: {
          id: partner.id,
          name: partner.name,
        },
        location: location ? {
          id: location.id,
          name: location.name,
          address: location.address,
        } : null,
      };

      localStorage.setItem('merchant_token', access_token);
      localStorage.setItem('merchant_data', JSON.stringify(merchantData));
      
      axios.defaults.headers.common['Authorization'] = `Bearer ${access_token}`;
      
      setMerchant(merchantData);
      
      return { success: true };
    } catch (error) {
      let errorMessage = 'Login failed';
      
      if (error.response?.data?.detail) {
        const detail = error.response.data.detail;
        // Handle array of validation errors
        if (Array.isArray(detail)) {
          errorMessage = detail.map(err => err.msg || JSON.stringify(err)).join(', ');
        } else if (typeof detail === 'string') {
          errorMessage = detail;
        } else {
          errorMessage = JSON.stringify(detail);
        }
      }
      
      return {
        success: false,
        error: errorMessage,
      };
    }
  };

  const logout = () => {
    localStorage.removeItem('merchant_token');
    localStorage.removeItem('merchant_data');
    delete axios.defaults.headers.common['Authorization'];
    setMerchant(null);
  };

  const value = {
    merchant,
    loading,
    login,
    logout,
    API_URL,
  };

  return <MerchantAuthContext.Provider value={value}>{children}</MerchantAuthContext.Provider>;
};
