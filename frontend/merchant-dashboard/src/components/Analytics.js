import React from 'react';
import { TrendingUp, Users, Calendar, DollarSign } from 'lucide-react';

const StatCard = ({ title, value, icon: Icon, change }) => (
  <div className="bg-white rounded-lg shadow p-6">
    <div className="flex items-center justify-between">
      <div>
        <p className="text-sm font-medium text-gray-600">{title}</p>
        <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
        {change && (
          <p className="text-sm text-green-600 mt-2 flex items-center">
            <TrendingUp size={16} className="mr-1" />
            {change}
          </p>
        )}
      </div>
      <div className="p-3 bg-primary-100 rounded-full">
        <Icon className="text-primary-600" size={24} />
      </div>
    </div>
  </div>
);

const Analytics = () => {
  return (
    <div>
      <div className="mb-6">
        <h2 className="text-2xl font-bold text-gray-900">Analytics</h2>
        <p className="text-gray-600 mt-1">Performance overview for this month</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Total Visits"
          value="342"
          icon={Users}
          change="+12% from last month"
        />
        <StatCard
          title="Today's Visits"
          value="28"
          icon={Calendar}
          change="+5 from yesterday"
        />
        <StatCard
          title="Avg. Daily Visits"
          value="11.4"
          icon={TrendingUp}
          change="+8% from last month"
        />
        <StatCard
          title="Revenue Impact"
          value="3.4M UZS"
          icon={DollarSign}
          change="+15% from last month"
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Peak Hours</h3>
          <div className="space-y-4">
            <div>
              <div className="flex justify-between text-sm mb-1">
                <span className="text-gray-600">9:00 - 12:00</span>
                <span className="font-medium">45 visits</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-primary-600 h-2 rounded-full" style={{ width: '75%' }}></div>
              </div>
            </div>
            <div>
              <div className="flex justify-between text-sm mb-1">
                <span className="text-gray-600">12:00 - 15:00</span>
                <span className="font-medium">60 visits</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-primary-600 h-2 rounded-full" style={{ width: '100%' }}></div>
              </div>
            </div>
            <div>
              <div className="flex justify-between text-sm mb-1">
                <span className="text-gray-600">15:00 - 18:00</span>
                <span className="font-medium">38 visits</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div className="bg-primary-600 h-2 rounded-full" style={{ width: '63%' }}></div>
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Weekly Trend</h3>
          <div className="space-y-4">
            {['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day, index) => (
              <div key={day}>
                <div className="flex justify-between text-sm mb-1">
                  <span className="text-gray-600">{day}</span>
                  <span className="font-medium">{Math.floor(Math.random() * 20) + 30} visits</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div
                    className="bg-primary-600 h-2 rounded-full"
                    style={{ width: `${Math.floor(Math.random() * 40) + 60}%` }}
                  ></div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Analytics;
