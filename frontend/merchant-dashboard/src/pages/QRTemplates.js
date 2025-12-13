import React, { useState } from 'react';
import { useMerchantAuth } from '../context/MerchantAuthContext';
import { QrCode, Download, Printer, Copy, Check } from 'lucide-react';
import QRCode from 'qrcode.react';

const QRTemplates = () => {
  const { merchant } = useMerchantAuth();
  const [copied, setCopied] = useState(false);
  const [selectedTemplate, setSelectedTemplate] = useState('standard');

  // Generate valid QR code data that matches the scanner format
  const qrData = `YUVGO_PARTNER_${merchant?.partner?.id || 'DEMO'}_${Date.now()}`;

  const templates = [
    {
      id: 'standard',
      name: 'Standard',
      description: 'Simple QR code with partner name',
      size: 256,
    },
    {
      id: 'large',
      name: 'Large Print',
      description: 'Large QR code for wall mounting',
      size: 512,
    },
    {
      id: 'small',
      name: 'Small',
      description: 'Compact QR code for cards',
      size: 128,
    },
  ];

  const handleDownload = () => {
    const canvas = document.getElementById('qr-code');
    const pngUrl = canvas
      .toDataURL('image/png')
      .replace('image/png', 'image/octet-stream');
    
    const downloadLink = document.createElement('a');
    downloadLink.href = pngUrl;
    downloadLink.download = `yuvgo-qr-${merchant?.partner?.name?.replace(/\s+/g, '-').toLowerCase()}.png`;
    document.body.appendChild(downloadLink);
    downloadLink.click();
    document.body.removeChild(downloadLink);
  };

  const handlePrint = () => {
    const printWindow = window.open('', '_blank');
    const canvas = document.getElementById('qr-code');
    const imgData = canvas.toDataURL('image/png');
    
    printWindow.document.write(`
      <html>
        <head>
          <title>YuvGo QR Code - ${merchant?.partner?.name}</title>
          <style>
            body {
              display: flex;
              flex-direction: column;
              align-items: center;
              justify-content: center;
              min-height: 100vh;
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .container {
              text-align: center;
            }
            h1 {
              color: #0284c7;
              margin-bottom: 10px;
            }
            h2 {
              color: #333;
              margin-bottom: 30px;
            }
            img {
              max-width: 100%;
              height: auto;
            }
            .instructions {
              margin-top: 30px;
              padding: 20px;
              background: #f0f9ff;
              border-radius: 8px;
              max-width: 500px;
            }
            @media print {
              .instructions {
                page-break-before: always;
              }
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>YuvGo Car Wash</h1>
            <h2>${merchant?.partner?.name}</h2>
            <img src="${imgData}" alt="QR Code" />
            <div class="instructions">
              <h3>How to Use:</h3>
              <ol style="text-align: left;">
                <li>Customer opens YuvGo app</li>
                <li>Customer generates their personal QR code</li>
                <li>Staff scans customer's QR code</li>
                <li>Check-in is processed automatically</li>
              </ol>
            </div>
          </div>
        </body>
      </html>
    `);
    
    printWindow.document.close();
    printWindow.focus();
    setTimeout(() => {
      printWindow.print();
      printWindow.close();
    }, 250);
  };

  const copyToClipboard = () => {
    navigator.clipboard.writeText(qrData);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const selectedSize = templates.find(t => t.id === selectedTemplate)?.size || 256;

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-3xl font-bold text-gray-900">QR Code Templates</h1>
        <p className="text-gray-600 mt-1">Download and print QR codes for your location</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Template Selection */}
        <div className="lg:col-span-1">
          <div className="bg-white rounded-lg shadow p-6">
            <h2 className="text-lg font-bold text-gray-900 mb-4">Select Template</h2>
            <div className="space-y-3">
              {templates.map((template) => (
                <button
                  key={template.id}
                  onClick={() => setSelectedTemplate(template.id)}
                  className={`w-full p-4 text-left rounded-lg border-2 transition-colors ${
                    selectedTemplate === template.id
                      ? 'border-primary-600 bg-primary-50'
                      : 'border-gray-200 hover:border-gray-300'
                  }`}
                >
                  <p className="font-medium text-gray-900">{template.name}</p>
                  <p className="text-sm text-gray-600 mt-1">{template.description}</p>
                  <p className="text-xs text-gray-500 mt-2">{template.size}x{template.size}px</p>
                </button>
              ))}
            </div>

            <div className="mt-6 pt-6 border-t">
              <h3 className="font-medium text-gray-900 mb-3">Actions</h3>
              <div className="space-y-2">
                <button
                  onClick={handleDownload}
                  className="w-full flex items-center justify-center px-4 py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
                >
                  <Download size={20} className="mr-2" />
                  Download PNG
                </button>
                <button
                  onClick={handlePrint}
                  className="w-full flex items-center justify-center px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700"
                >
                  <Printer size={20} className="mr-2" />
                  Print
                </button>
                <button
                  onClick={copyToClipboard}
                  className="w-full flex items-center justify-center px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300"
                >
                  {copied ? <Check size={20} className="mr-2" /> : <Copy size={20} className="mr-2" />}
                  {copied ? 'Copied!' : 'Copy Data'}
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* QR Code Preview */}
        <div className="lg:col-span-2">
          <div className="bg-white rounded-lg shadow p-8">
            <h2 className="text-lg font-bold text-gray-900 mb-6 text-center">Preview</h2>
            
            <div className="flex flex-col items-center justify-center">
              <div className="mb-6">
                <h3 className="text-2xl font-bold text-primary-600 text-center">YuvGo</h3>
                <p className="text-xl font-medium text-gray-900 text-center mt-2">
                  {merchant?.partner?.name}
                </p>
                {merchant?.location && (
                  <p className="text-sm text-gray-600 text-center mt-1">
                    {merchant.location.name}
                  </p>
                )}
              </div>

              <div className="p-8 bg-white border-4 border-primary-600 rounded-lg">
                <QRCode
                  id="qr-code"
                  value={qrData}
                  size={selectedSize}
                  level="H"
                  includeMargin={true}
                />
              </div>

              <div className="mt-6 text-center max-w-md">
                <p className="text-sm text-gray-600 mb-4">
                  This QR code represents your car wash location. Display it prominently for customers to scan.
                </p>
                <div className="p-4 bg-blue-50 rounded-lg">
                  <p className="text-sm font-medium text-blue-900 mb-2">Important:</p>
                  <p className="text-xs text-blue-800">
                    Customers should scan their personal QR code from the YuvGo app, not this location QR code. 
                    This code is for reference and marketing purposes.
                  </p>
                </div>
              </div>
            </div>
          </div>

          {/* Usage Instructions */}
          <div className="mt-6 bg-white rounded-lg shadow p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">How to Use QR Codes</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="p-4 bg-gray-50 rounded-lg">
                <div className="flex items-start">
                  <div className="flex-shrink-0 w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold mr-3">
                    1
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">Print & Display</p>
                    <p className="text-sm text-gray-600 mt-1">
                      Print the QR code and display it at your entrance or reception
                    </p>
                  </div>
                </div>
              </div>

              <div className="p-4 bg-gray-50 rounded-lg">
                <div className="flex items-start">
                  <div className="flex-shrink-0 w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold mr-3">
                    2
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">Customer Opens App</p>
                    <p className="text-sm text-gray-600 mt-1">
                      Customer opens YuvGo app and generates their personal QR code
                    </p>
                  </div>
                </div>
              </div>

              <div className="p-4 bg-gray-50 rounded-lg">
                <div className="flex items-start">
                  <div className="flex-shrink-0 w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold mr-3">
                    3
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">Staff Scans</p>
                    <p className="text-sm text-gray-600 mt-1">
                      Your staff scans the customer's QR code using the merchant dashboard
                    </p>
                  </div>
                </div>
              </div>

              <div className="p-4 bg-gray-50 rounded-lg">
                <div className="flex items-start">
                  <div className="flex-shrink-0 w-8 h-8 bg-primary-600 text-white rounded-full flex items-center justify-center font-bold mr-3">
                    4
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">Auto Check-in</p>
                    <p className="text-sm text-gray-600 mt-1">
                      System validates subscription and processes check-in automatically
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default QRTemplates;
