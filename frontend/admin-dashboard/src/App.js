import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Login from './pages/LoginNew';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import Partners from './pages/Partners';
import Subscriptions from './pages/Subscriptions';
import Payments from './pages/Payments';
import Analytics from './pages/Analytics';
import Admins from './pages/Admins';
import Promotions from './pages/Promotions';
import AuditLogs from './pages/AuditLogs';
import LocationsMap from './pages/LocationsMap';
import Layout from './components/LayoutNew';

const ProtectedRoute = ({ children, requiredPermission }) => {
  const { user, hasPermission } = useAuth();

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
          </Route>
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;
