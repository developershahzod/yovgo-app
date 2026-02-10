import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { LanguageProvider } from './i18n';
import Login from './pages/LoginNew';
import Dashboard from './pages/DashboardNew';
import Users from './pages/Users';
import Partners from './pages/Partners';
import Subscriptions from './pages/Subscriptions';
import Payments from './pages/Payments';
import Analytics from './pages/Analytics';
import Admins from './pages/Admins';
import Promotions from './pages/Promotions';
import AuditLogs from './pages/AuditLogs';
import LocationsMap from './pages/LocationsMap';
import Settings from './pages/Settings';
import Reports from './pages/Reports';
import Visits from './pages/Visits';
import Notifications from './pages/Notifications';
import Vehicles from './pages/Vehicles';
import Layout from './components/LayoutNew';

const ProtectedRoute = ({ children, requiredPermission }) => {
  const { user, loading, hasPermission } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-emerald-200 border-t-emerald-600 rounded-full animate-spin" />
      </div>
    );
  }

  if (!user) {
    return <Navigate to="/login" />;
  }

  if (requiredPermission && !hasPermission(requiredPermission)) {
    return <Navigate to="/dashboard" />;
  }

  return children;
};

function App() {
  return (
    <LanguageProvider>
      <AuthProvider>
        <Router>
          <Routes>
          <Route path="/login" element={<Login />} />
          
          <Route
            path="/"
            element={
              <ProtectedRoute>
                <Layout />
              </ProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/dashboard" />} />
            <Route path="dashboard" element={<Dashboard />} />
            
            <Route
              path="users"
              element={
                <ProtectedRoute requiredPermission="users.read">
                  <Users />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="partners"
              element={
                <ProtectedRoute requiredPermission="partners.read">
                  <Partners />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="subscriptions"
              element={
                <ProtectedRoute requiredPermission="subscriptions.read">
                  <Subscriptions />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="payments"
              element={
                <ProtectedRoute requiredPermission="payments.read">
                  <Payments />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="analytics"
              element={
                <ProtectedRoute requiredPermission="analytics.read">
                  <Analytics />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="admins"
              element={
                <ProtectedRoute requiredPermission="admins.read">
                  <Admins />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="promotions"
              element={
                <ProtectedRoute requiredPermission="promotions.read">
                  <Promotions />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="audit-logs"
              element={
                <ProtectedRoute requiredPermission="audit.read">
                  <AuditLogs />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="locations-map"
              element={
                <ProtectedRoute requiredPermission="partners.read">
                  <LocationsMap />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="settings"
              element={
                <ProtectedRoute requiredPermission="settings.read">
                  <Settings />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="reports"
              element={
                <ProtectedRoute requiredPermission="analytics.read">
                  <Reports />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="visits"
              element={
                <ProtectedRoute requiredPermission="analytics.read">
                  <Visits />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="notifications"
              element={
                <ProtectedRoute requiredPermission="users.read">
                  <Notifications />
                </ProtectedRoute>
              }
            />
            
            <Route
              path="vehicles"
              element={
                <ProtectedRoute requiredPermission="users.read">
                  <Vehicles />
                </ProtectedRoute>
              }
            />
          </Route>
          </Routes>
        </Router>
      </AuthProvider>
    </LanguageProvider>
  );
}

export default App;
