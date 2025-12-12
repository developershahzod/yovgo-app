import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { MerchantAuthProvider, useMerchantAuth } from './context/MerchantAuthContext';
import MerchantLogin from './pages/MerchantLogin';
import Dashboard from './pages/Dashboard';
import QRScanner from './pages/QRScanner';
import Clients from './pages/Clients';
import Earnings from './pages/Earnings';
import VisitHistory from './pages/VisitHistory';
import QRTemplates from './pages/QRTemplates';
import Layout from './components/Layout';

const ProtectedRoute = ({ children }) => {
  const { merchant } = useMerchantAuth();

  if (!merchant) {
    return <Navigate to="/login" />;
  }

  return children;
};

function App() {
  return (
    <MerchantAuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<MerchantLogin />} />
          
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
            <Route path="scanner" element={<QRScanner />} />
            <Route path="clients" element={<Clients />} />
            <Route path="earnings" element={<Earnings />} />
            <Route path="visits" element={<VisitHistory />} />
            <Route path="qr-templates" element={<QRTemplates />} />
          </Route>
        </Routes>
      </Router>
    </MerchantAuthProvider>
  );
}

export default App;
