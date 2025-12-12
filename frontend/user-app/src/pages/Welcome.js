import React from 'react';
import { useNavigate } from 'react-router-dom';
import { Car, Sparkles, MapPin, QrCode } from 'lucide-react';

const Welcome = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-500 to-primary-700 flex flex-col">
      <div className="flex-1 flex flex-col items-center justify-center px-6 py-12">
        <div className="text-center mb-12">
          <div className="inline-flex items-center justify-center w-24 h-24 bg-white rounded-full mb-6 shadow-lg">
            <Car className="text-primary-600" size={48} />
          </div>
          <h1 className="text-4xl font-bold text-white mb-4">YuvGo</h1>
          <p className="text-xl text-primary-100">
            Subscription-based car wash service
          </p>
        </div>

        <div className="w-full max-w-md space-y-4 mb-12">
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-white">
            <div className="flex items-start space-x-4">
              <div className="flex-shrink-0 w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
                <Sparkles size={24} />
              </div>
              <div>
                <h3 className="font-semibold text-lg mb-1">Unlimited Washes</h3>
                <p className="text-primary-100 text-sm">
                  Subscribe once, wash multiple times per month
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-white">
            <div className="flex items-start space-x-4">
              <div className="flex-shrink-0 w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
                <MapPin size={24} />
              </div>
              <div>
                <h3 className="font-semibold text-lg mb-1">Multiple Locations</h3>
                <p className="text-primary-100 text-sm">
                  Access partner car washes across the city
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-white">
            <div className="flex items-start space-x-4">
              <div className="flex-shrink-0 w-12 h-12 bg-white/20 rounded-full flex items-center justify-center">
                <QrCode size={24} />
              </div>
              <div>
                <h3 className="font-semibold text-lg mb-1">Easy Check-in</h3>
                <p className="text-primary-100 text-sm">
                  Just show your QR code and you're done
                </p>
              </div>
            </div>
          </div>
        </div>

        <div className="w-full max-w-md space-y-3">
          <button
            onClick={() => navigate('/register')}
            className="w-full bg-white text-primary-600 py-4 px-6 rounded-xl font-semibold text-lg shadow-lg hover:bg-primary-50 transition-colors"
          >
            Get Started
          </button>
          <button
            onClick={() => navigate('/login')}
            className="w-full bg-white/10 backdrop-blur-sm text-white py-4 px-6 rounded-xl font-semibold text-lg border-2 border-white/30 hover:bg-white/20 transition-colors"
          >
            I Have an Account
          </button>
        </div>
      </div>

      <div className="text-center pb-6 text-primary-100 text-sm">
        <p>© 2024 YuvGo. All rights reserved.</p>
      </div>
    </div>
  );
};

export default Welcome;
