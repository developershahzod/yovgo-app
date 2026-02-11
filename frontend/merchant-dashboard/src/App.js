import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { MerchantAuthProvider, useMerchantAuth } from './context/MerchantAuthContext';
import { LanguageProvider } from './i18n';
import MerchantLogin from './pages/MerchantLoginNew';
import MerchantRegister from './pages/MerchantRegister';
import Dashboard from './pages/DashboardNew';
import Clients from './pages/Clients';
import Earnings from './pages/Earnings';
import VisitHistory from './pages/VisitHistory';
import QRTemplates from './pages/QRTemplates';
import QRCodeDisplay from './pages/QRCodeDisplay';
import MerchantSettings from './pages/MerchantSettings';
import MerchantAnalytics from './pages/MerchantAnalytics';
import Branches from './pages/Branches';
import Layout from './components/LayoutClean';

const ProtectedRoute = ({ children }) => {
  const { merchant, loading } = useMerchantAuth();

  if (loading) {
    return <div className="flex items-center justify-center h-screen"><div className="w-8 h-8 border-4 border-emerald-500 border-t-transparent rounded-full animate-spin" /></div>;
  }

  if (!merchant) {
    return <Navigate to="/login" />;
  }

  return children;
};

function App() {
  return (
    <LanguageProvider>
      <MerchantAuthProvider>
        <Router>
          <Routes>
            <Route path="/login" element={<MerchantLogin />} />
            <Route path="/register" element={<MerchantRegister />} />
            
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
              <Route path="qr-scanner" element={<QRCodeDisplay />} />
              <Route path="clients" element={<Clients />} />
              <Route path="earnings" element={<Earnings />} />
              <Route path="visits" element={<VisitHistory />} />
              <Route path="qr-templates" element={<QRTemplates />} />
              <Route path="analytics" element={<MerchantAnalytics />} />
              <Route path="branches" element={<Branches />} />
              <Route path="settings" element={<MerchantSettings />} />
            </Route>
          </Routes>
        </Router>
      </MerchantAuthProvider>
    </LanguageProvider>
  );
}

export default App;
