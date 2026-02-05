import React, { useState } from 'react';
import { 
  FileText, Download, Calendar, Filter, TrendingUp, 
  Users, CreditCard, Car, Building2, BarChart3
} from 'lucide-react';

const Reports = () => {
  const [reportType, setReportType] = useState('revenue');
  const [dateRange, setDateRange] = useState('month');
  const [generating, setGenerating] = useState(false);

  const reportTypes = [
    { id: 'revenue', name: 'Revenue Report', icon: TrendingUp, color: 'green' },
    { id: 'users', name: 'Users Report', icon: Users, color: 'blue' },
    { id: 'subscriptions', name: 'Subscriptions Report', icon: CreditCard, color: 'purple' },
    { id: 'visits', name: 'Visits Report', icon: Car, color: 'orange' },
    { id: 'partners', name: 'Partners Report', icon: Building2, color: 'cyan' },
  ];

  const recentReports = [
    { id: 1, name: 'Revenue Report - January 2026', date: '2026-02-01', size: '245 KB', type: 'revenue' },
    { id: 2, name: 'Users Report - Q4 2025', date: '2026-01-15', size: '128 KB', type: 'users' },
    { id: 3, name: 'Subscriptions Report - December 2025', date: '2026-01-05', size: '89 KB', type: 'subscriptions' },
    { id: 4, name: 'Partners Performance - 2025', date: '2025-12-31', size: '312 KB', type: 'partners' },
  ];

  const handleGenerate = async () => {
    setGenerating(true);
    await new Promise(resolve => setTimeout(resolve, 2000));
    setGenerating(false);
    alert('Report generated successfully!');
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Reports</h1>
        <p className="text-gray-600">Generate and download business reports</p>
      </div>

      {/* Report Generator */}
      <div className="bg-white rounded-xl border border-gray-200 p-6">
        <h2 className="text-lg font-semibold mb-6 flex items-center gap-2">
          <BarChart3 className="text-blue-600" size={24} />
          Generate New Report
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Report Type Selection */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-3">Report Type</label>
            <div className="space-y-2">
              {reportTypes.map((type) => (
                <label
                  key={type.id}
                  className={`flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-all ${
                    reportType === type.id
                      ? 'border-blue-500 bg-blue-50'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <input
                    type="radio"
                    name="reportType"
                    value={type.id}
                    checked={reportType === type.id}
                    onChange={(e) => setReportType(e.target.value)}
                    className="hidden"
                  />
                  <type.icon size={20} className={`text-${type.color}-600`} />
                  <span className="font-medium">{type.name}</span>
                </label>
              ))}
            </div>
          </div>

          {/* Date Range */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-3">Date Range</label>
            <div className="space-y-2">
              {[
                { id: 'today', name: 'Today' },
                { id: 'week', name: 'This Week' },
                { id: 'month', name: 'This Month' },
                { id: 'quarter', name: 'This Quarter' },
                { id: 'year', name: 'This Year' },
                { id: 'custom', name: 'Custom Range' },
              ].map((range) => (
                <label
                  key={range.id}
                  className={`flex items-center gap-3 p-3 rounded-lg border cursor-pointer transition-all ${
                    dateRange === range.id
                      ? 'border-blue-500 bg-blue-50'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <input
                    type="radio"
                    name="dateRange"
                    value={range.id}
                    checked={dateRange === range.id}
                    onChange={(e) => setDateRange(e.target.value)}
                    className="hidden"
                  />
                  <Calendar size={20} className="text-gray-500" />
                  <span className="font-medium">{range.name}</span>
                </label>
              ))}
            </div>
          </div>

          {/* Actions */}
          <div className="flex flex-col justify-between">
            <div className="bg-gray-50 rounded-lg p-4 mb-4">
              <h3 className="font-medium text-gray-900 mb-2">Report Preview</h3>
              <p className="text-sm text-gray-600">
                <strong>Type:</strong> {reportTypes.find(t => t.id === reportType)?.name}
              </p>
              <p className="text-sm text-gray-600">
                <strong>Period:</strong> {dateRange.charAt(0).toUpperCase() + dateRange.slice(1)}
              </p>
              <p className="text-sm text-gray-600">
                <strong>Format:</strong> PDF, Excel
              </p>
            </div>

            <div className="space-y-3">
              <button
                onClick={handleGenerate}
                disabled={generating}
                className="w-full flex items-center justify-center gap-2 px-4 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:opacity-50 font-medium"
              >
                {generating ? (
                  <>
                    <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    Generating...
                  </>
                ) : (
                  <>
                    <FileText size={20} />
                    Generate Report
                  </>
                )}
              </button>
              <button className="w-full flex items-center justify-center gap-2 px-4 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 font-medium">
                <Filter size={20} />
                Advanced Filters
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Recent Reports */}
      <div className="bg-white rounded-xl border border-gray-200 p-6">
        <h2 className="text-lg font-semibold mb-4">Recent Reports</h2>
        
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-3 px-4 font-medium text-gray-600">Report Name</th>
                <th className="text-left py-3 px-4 font-medium text-gray-600">Generated</th>
                <th className="text-left py-3 px-4 font-medium text-gray-600">Size</th>
                <th className="text-right py-3 px-4 font-medium text-gray-600">Actions</th>
              </tr>
            </thead>
            <tbody>
              {recentReports.map((report) => (
                <tr key={report.id} className="border-b border-gray-100 hover:bg-gray-50">
                  <td className="py-3 px-4">
                    <div className="flex items-center gap-3">
                      <FileText className="text-gray-400" size={20} />
                      <span className="font-medium">{report.name}</span>
                    </div>
                  </td>
                  <td className="py-3 px-4 text-gray-600">{report.date}</td>
                  <td className="py-3 px-4 text-gray-600">{report.size}</td>
                  <td className="py-3 px-4 text-right">
                    <button className="inline-flex items-center gap-1 px-3 py-1 text-blue-600 hover:bg-blue-50 rounded-lg">
                      <Download size={16} />
                      Download
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <div className="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-4 text-white">
          <p className="text-green-100 text-sm">Total Revenue (This Month)</p>
          <p className="text-2xl font-bold mt-1">45,230,000 UZS</p>
          <p className="text-green-100 text-sm mt-2">+12.5% from last month</p>
        </div>
        <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-4 text-white">
          <p className="text-blue-100 text-sm">Active Users</p>
          <p className="text-2xl font-bold mt-1">1,234</p>
          <p className="text-blue-100 text-sm mt-2">+8.3% from last month</p>
        </div>
        <div className="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-4 text-white">
          <p className="text-purple-100 text-sm">Active Subscriptions</p>
          <p className="text-2xl font-bold mt-1">892</p>
          <p className="text-purple-100 text-sm mt-2">+15.2% from last month</p>
        </div>
        <div className="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl p-4 text-white">
          <p className="text-orange-100 text-sm">Total Visits</p>
          <p className="text-2xl font-bold mt-1">5,678</p>
          <p className="text-orange-100 text-sm mt-2">+22.1% from last month</p>
        </div>
      </div>
    </div>
  );
};

export default Reports;
