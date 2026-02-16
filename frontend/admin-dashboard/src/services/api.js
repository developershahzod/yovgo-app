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
    const token = localStorage.getItem('access_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor for error handling
let isRedirecting = false;
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      const url = error.config?.url || '';
      // Don't redirect on login requests or if already redirecting
      if (!url.includes('/auth/login') && !isRedirecting && window.location.pathname !== '/login') {
        isRedirecting = true;
        localStorage.removeItem('access_token');
        localStorage.removeItem('user');
        window.location.href = '/login';
        setTimeout(() => { isRedirecting = false; }, 3000);
      }
    }
    return Promise.reject(error);
  }
);

// ==================== AUTH API ====================
export const authAPI = {
  login: (email, password) => api.post('/api/admin/auth/login', { email, password }),
  logout: () => {
    localStorage.removeItem('access_token');
    localStorage.removeItem('user');
  },
  refreshToken: () => api.post('/api/admin/auth/refresh'),
};

// ==================== USERS API ====================
export const usersAPI = {
  getAll: (params = {}) => api.get('/api/user/users', { params }),
  getById: (id) => api.get(`/api/user/users/${id}`),
  create: (data) => api.post('/api/user/users', data),
  update: (id, data) => api.put(`/api/user/users/${id}`, data),
  delete: (id) => api.delete(`/api/user/users/${id}`),
  getVehicles: (userId) => api.get(`/api/user/users/${userId}/vehicles`),
  getSubscription: (userId) => api.get(`/api/user/users/${userId}/subscription`),
  getStats: () => api.get('/api/user/stats'),
};

// ==================== PARTNERS API ====================
export const partnersAPI = {
  getAll: (params = {}) => api.get('/api/partner/partners', { params }),
  getById: (id) => api.get(`/api/partner/partners/${id}`),
  create: (data) => api.post('/api/partner/partners', data),
  update: (id, data) => api.put(`/api/partner/partners/${id}`, data),
  delete: (id) => api.delete(`/api/partner/partners/${id}`),
  approve: (id) => api.post(`/api/partner/partners/${id}/approve`),
  reject: (id) => api.post(`/api/partner/partners/${id}/reject`),
  getLocations: (partnerId) => api.get('/api/partner/locations', { params: { partner_id: partnerId } }),
  addLocation: (data) => api.post('/api/partner/locations', data),
  updateLocation: (id, data) => api.put(`/api/partner/locations/${id}`, data),
  deleteLocation: (id) => api.delete(`/api/partner/locations/${id}`),
  getStaff: (partnerId) => api.get(`/api/partner/partners/${partnerId}/staff`),
  addStaff: (data) => api.post('/api/partner/staff', data),
  updateStaff: (partnerId, data) => api.put(`/api/partner/partners/${partnerId}/staff`, data),
  getStats: () => api.get('/api/partner/stats'),
};

// ==================== SUBSCRIPTIONS API ====================
export const subscriptionsAPI = {
  // Plans
  getPlans: () => api.get('/api/subscription/plans'),
  getPlanById: (id) => api.get(`/api/subscription/plans/${id}`),
  createPlan: (data) => api.post('/api/subscription/plans', data),
  updatePlan: (id, data) => api.put(`/api/subscription/plans/${id}`, data),
  deletePlan: (id) => api.delete(`/api/subscription/plans/${id}`),
  
  // Subscriptions
  getAll: (params = {}) => api.get('/api/subscription/subscriptions', { params }),
  getById: (id) => api.get(`/api/subscription/subscriptions/${id}`),
  create: (data) => api.post('/api/subscription/subscriptions', data),
  cancel: (id) => api.post(`/api/subscription/subscriptions/${id}/cancel`),
  freeze: (id, days) => api.post(`/api/subscription/subscriptions/${id}/freeze`, { days }),
  unfreeze: (id) => api.post(`/api/subscription/subscriptions/${id}/unfreeze`),
  getStats: () => api.get('/api/subscription/stats'),
};

// ==================== VISITS API ====================
export const visitsAPI = {
  getAll: (params = {}) => api.get('/api/visit/visits', { params }),
  getById: (id) => api.get(`/api/visit/visits/${id}`),
  getByUser: (userId) => api.get('/api/visit/visits', { params: { user_id: userId } }),
  getByPartner: (partnerId) => api.get('/api/visit/visits', { params: { partner_id: partnerId } }),
  getStats: () => api.get('/api/visit/stats'),
  getDailyStats: (startDate, endDate) => api.get('/api/visit/stats/daily', { params: { start_date: startDate, end_date: endDate } }),
};

// ==================== PAYMENTS API ====================
export const paymentsAPI = {
  getAll: (params = {}) => api.get('/api/payment/payments', { params }),
  getById: (id) => api.get(`/api/payment/payments/${id}`),
  getByUser: (userId) => api.get('/api/payment/payments', { params: { user_id: userId } }),
  refund: (id) => api.post(`/api/payment/payments/${id}/refund`),
  getStats: () => api.get('/api/payment/stats'),
  getRevenue: (period = 'month') => api.get('/api/payment/revenue', { params: { period } }),
};

// ==================== ADMINS API ====================
export const adminsAPI = {
  getAll: () => api.get('/api/admin/admins'),
  getById: (id) => api.get(`/api/admin/admins/${id}`),
  create: (data) => api.post('/api/admin/admins', data),
  update: (id, data) => api.put(`/api/admin/admins/${id}`, data),
  delete: (id) => api.delete(`/api/admin/admins/${id}`),
  updatePermissions: (id, permissions) => api.put(`/api/admin/admins/${id}/permissions`, { permissions }),
};

// ==================== PROMOTIONS API ====================
export const promotionsAPI = {
  getAll: (params = {}) => api.get('/api/admin/promotions', { params }),
  getById: (id) => api.get(`/api/admin/promotions/${id}`),
  create: (data) => api.post('/api/admin/promotions', data),
  update: (id, data) => api.put(`/api/admin/promotions/${id}`, data),
  delete: (id) => api.delete(`/api/admin/promotions/${id}`),
  activate: (id) => api.post(`/api/admin/promotions/${id}/activate`),
  deactivate: (id) => api.post(`/api/admin/promotions/${id}/deactivate`),
};

// ==================== NOTIFICATIONS API ====================
export const notificationsAPI = {
  getAll: (params = {}) => api.get('/api/notification/notifications', { params }),
  send: (data) => api.post('/api/notification/send', data),
  sendBulk: (data) => api.post('/api/notification/send-bulk', data),
  getTemplates: () => api.get('/api/notification/templates'),
  createTemplate: (data) => api.post('/api/notification/templates', data),
};

// ==================== ANALYTICS API ====================
export const analyticsAPI = {
  getDashboard: () => api.get('/api/admin/analytics/dashboard'),
  getUsers: (period = 'month') => api.get('/api/admin/analytics/users', { params: { period } }),
  getRevenue: (period = 'month') => api.get('/api/admin/analytics/revenue', { params: { period } }),
  getVisits: (period = 'month') => api.get('/api/admin/analytics/visits', { params: { period } }),
  getPartners: (period = 'month') => api.get('/api/admin/analytics/partners', { params: { period } }),
  getSubscriptions: (period = 'month') => api.get('/api/admin/analytics/subscriptions', { params: { period } }),
  exportReport: (type, params) => api.get(`/api/admin/analytics/export/${type}`, { params, responseType: 'blob' }),
};

// ==================== AUDIT LOGS API ====================
export const auditLogsAPI = {
  getAll: (params = {}) => api.get('/api/admin/audit-logs', { params }),
  getById: (id) => api.get(`/api/admin/audit-logs/${id}`),
};

// ==================== SETTINGS API ====================
export const settingsAPI = {
  get: () => api.get('/api/admin/settings'),
  update: (data) => api.put('/api/admin/settings', data),
  getConfig: (key) => api.get(`/api/admin/settings/${key}`),
  updateConfig: (key, value) => api.put(`/api/admin/settings/${key}`, { value }),
};

export default api;
