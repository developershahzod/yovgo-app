import React, { createContext, useState, useContext, useEffect } from 'react';
import axios from 'axios';

const AuthContext = createContext();

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
};

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

  useEffect(() => {
    const token = localStorage.getItem('user_token');
    const userData = localStorage.getItem('user_data');
    
    if (token && userData) {
      setUser(JSON.parse(userData));
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    }
    
    setLoading(false);
  }, []);

  const register = async (phoneNumber, email, fullName) => {
    try {
      const response = await axios.post(`${API_URL}/api/user/users`, {
        phone_number: phoneNumber,
        email,
        full_name: fullName,
      });

      return { success: true, user: response.data };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.detail || 'Registration failed',
      };
    }
  };

  const login = async (phoneNumber) => {
    try {
      // In production, implement proper authentication
      // For now, we'll use phone number to fetch user
      const response = await axios.get(`${API_URL}/api/user/users`);
      const foundUser = response.data.find(u => u.phone_number === phoneNumber);
      
      if (!foundUser) {
        return { success: false, error: 'User not found' };
      }

      // Create a simple token (in production, use proper JWT from backend)
      const token = btoa(foundUser.id);
      
      const userData = {
        id: foundUser.id,
        phone_number: foundUser.phone_number,
        email: foundUser.email,
        full_name: foundUser.full_name,
      };

      localStorage.setItem('user_token', token);
      localStorage.setItem('user_data', JSON.stringify(userData));
      
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      
      setUser(userData);
      
      return { success: true };
    } catch (error) {
      return {
        success: false,
        error: error.response?.data?.detail || 'Login failed',
      };
    }
  };

  const logout = () => {
    localStorage.removeItem('user_token');
    localStorage.removeItem('user_data');
    delete axios.defaults.headers.common['Authorization'];
    setUser(null);
  };

  const value = {
    user,
    loading,
    register,
    login,
    logout,
    API_URL,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
