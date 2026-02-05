import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

// Create axios instance with default config
const api = axios.create({
  baseURL: API_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('merchant_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('merchant_token');
      localStorage.removeItem('merchant');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// ==================== AUTH API ====================
export const authAPI = {
  login: (phone_number, pin_code) => api.post('/api/partner/staff/login', { phone_number, pin_code }),
  register: (data) => api.post('/api/partner/partners', data),
  logout: () => {
    localStorage.removeItem('merchant_token');
    localStorage.removeItem('merchant');
  },
};

// ==================== PARTNER API ====================
export const partnerAPI = {
  getProfile: (partnerId) => api.get(`/api/partner/partners/${partnerId}`),
  updateProfile: (partnerId, data) => api.put(`/api/partner/partners/${partnerId}`, data),
  getLocations: (partnerId) => api.get('/api/partner/locations', { params: { partner_id: partnerId } }),
  addLocation: (data) => api.post('/api/partner/locations', data),
  updateLocation: (id, data) => api.put(`/api/partner/locations/${id}`, data),
  deleteLocation: (id) => api.delete(`/api/partner/locations/${id}`),
  getQRCode: (partnerId) => api.get(`/api/partner/partners/${partnerId}/qr`),
  getStaff: (partnerId) => api.get(`/api/partner/partners/${partnerId}/staff`),
  updateStaff: (partnerId, data) => api.put(`/api/partner/partners/${partnerId}/staff`, data),
};

// ==================== VISITS API ====================
export const visitsAPI = {
  getAll: (params = {}) => api.get('/api/visit/visits', { params }),
  getById: (id) => api.get(`/api/visit/visits/${id}`),
  recordVisit: (data) => api.post('/api/visit/visits', data),
  checkIn: (qrToken, vehicleId) => api.post('/api/visit/check-in', { qr_token: qrToken, vehicle_id: vehicleId }),
  checkOut: (visitId) => api.post(`/api/visit/visits/${visitId}/check-out`),
  getStats: (partnerId) => api.get('/api/visit/stats', { params: { partner_id: partnerId } }),
  getDailyStats: (partnerId, startDate, endDate) => api.get('/api/visit/stats/daily', { 
    params: { partner_id: partnerId, start_date: startDate, end_date: endDate } 
  }),
  getTodayVisits: (partnerId) => api.get('/api/visit/visits/today', { params: { partner_id: partnerId } }),
};

// ==================== CLIENTS API ====================
export const clientsAPI = {
  getAll: (partnerId, params = {}) => api.get('/api/visit/clients', { params: { partner_id: partnerId, ...params } }),
  getById: (clientId) => api.get(`/api/visit/clients/${clientId}`),
  getVisitHistory: (clientId) => api.get(`/api/visit/clients/${clientId}/visits`),
  getStats: (partnerId) => api.get('/api/visit/clients/stats', { params: { partner_id: partnerId } }),
};

// ==================== EARNINGS API ====================
export const earningsAPI = {
  getSummary: (partnerId, period = 'month') => api.get('/api/payment/earnings', { 
    params: { partner_id: partnerId, period } 
  }),
  getDaily: (partnerId, startDate, endDate) => api.get('/api/payment/earnings/daily', { 
    params: { partner_id: partnerId, start_date: startDate, end_date: endDate } 
  }),
  getMonthly: (partnerId, year) => api.get('/api/payment/earnings/monthly', { 
    params: { partner_id: partnerId, year } 
  }),
  getPayouts: (partnerId) => api.get('/api/payment/payouts', { params: { partner_id: partnerId } }),
  requestPayout: (partnerId, amount) => api.post('/api/payment/payouts/request', { partner_id: partnerId, amount }),
};

// ==================== QR CODE API ====================
export const qrAPI = {
  generate: (partnerId, locationId) => api.post('/api/partner/qr/generate', { partner_id: partnerId, location_id: locationId }),
  validate: (qrToken) => api.post('/api/visit/qr/validate', { qr_token: qrToken }),
  scan: (qrToken) => api.post('/api/visit/qr/scan', { qr_token: qrToken }),
  getTemplates: () => api.get('/api/partner/qr/templates'),
};

// ==================== NOTIFICATIONS API ====================
export const notificationsAPI = {
  getAll: (params = {}) => api.get('/api/notification/notifications', { params }),
  markAsRead: (id) => api.put(`/api/notification/notifications/${id}/read`),
  markAllAsRead: () => api.put('/api/notification/notifications/read-all'),
};

// ==================== ANALYTICS API ====================
export const analyticsAPI = {
  getDashboard: (partnerId) => api.get('/api/partner/analytics/dashboard', { params: { partner_id: partnerId } }),
  getVisitTrends: (partnerId, period = 'week') => api.get('/api/partner/analytics/visits', { 
    params: { partner_id: partnerId, period } 
  }),
  getPeakHours: (partnerId) => api.get('/api/partner/analytics/peak-hours', { params: { partner_id: partnerId } }),
  getClientRetention: (partnerId) => api.get('/api/partner/analytics/retention', { params: { partner_id: partnerId } }),
};

export default api;
