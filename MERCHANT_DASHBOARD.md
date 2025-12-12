# YuvGo Merchant Dashboard Documentation

## Overview

The Merchant Dashboard is a comprehensive admin panel for car wash partners to manage their operations, track statistics, view clients, monitor earnings, and process customer check-ins.

## Features

### 1. **Dashboard** 📊
- Real-time statistics overview
- Today's visits count
- Total visits and clients
- Monthly revenue tracking
- Recent check-ins feed
- Performance metrics
- Peak hours analysis
- Quick action buttons

### 2. **QR Scanner** 📱
- Fast QR code scanning interface
- Real-time validation
- Instant check-in processing
- Success/error feedback
- Keyboard support (Enter to scan)
- Auto-focus input field
- Usage instructions

### 3. **Clients Management** 👥
- Complete client list
- Search functionality
- Visit count per client
- Last visit tracking
- Subscription status
- Client statistics:
  - New clients this month
  - Active subscriptions
  - Average visits per client

### 4. **Earnings Tracking** 💰
- Today's earnings
- Weekly earnings
- Monthly earnings
- Total earnings (all-time)
- Weekly breakdown charts
- Revenue sources analysis
- Payment method distribution
- Monthly comparison graphs

### 5. **Visit History** 📅
- Complete visit records
- Date/time filtering
- Export to CSV
- Pagination support
- Search and filter options
- Staff tracking
- Status monitoring

### 6. **QR Templates** 🎨
- Multiple template sizes:
  - Standard (256x256)
  - Large Print (512x512)
  - Small/Card (128x128)
- Download as PNG
- Print functionality
- Copy QR data
- Usage instructions
- Marketing materials

## Access & Authentication

### Login Credentials
Merchants log in using:
- **Phone Number**: Staff member's registered phone
- **PIN Code**: 6-digit security PIN

### User Roles
- **Staff**: Basic check-in access
- **Manager**: Full dashboard access
- **Owner**: Complete control

## Getting Started

### 1. First Login
```
1. Navigate to http://localhost:3001/login
2. Enter your phone number (e.g., +998901234567)
3. Enter your 6-digit PIN code
4. Click "Sign In"
```

### 2. Dashboard Navigation
The sidebar contains:
- 📊 Dashboard - Overview and statistics
- 📱 QR Scanner - Process check-ins
- 👥 Clients - Customer management
- 💰 Earnings - Revenue tracking
- 📅 Visit History - Complete records
- 🎨 QR Templates - Marketing materials

### 3. Processing Check-ins

**Method 1: Manual Entry**
```
1. Go to QR Scanner page
2. Customer shows their QR code from YuvGo app
3. Enter the QR token in the input field
4. Press Enter or click "Process Check-in"
5. System validates and processes
```

**Method 2: Barcode Scanner**
```
1. Connect USB barcode scanner
2. Go to QR Scanner page
3. Scan customer's QR code
4. System automatically processes
```

### 4. Viewing Statistics

**Dashboard Metrics:**
- Today's Visits
- Total Visits
- Total Clients
- Monthly Revenue
- Average Daily Visits
- Peak Hours

**Earnings Breakdown:**
- Daily, Weekly, Monthly totals
- Revenue trends
- Payment method distribution
- Subscription vs. Direct customers

### 5. Managing Clients

**View Client List:**
- All customers who visited
- Total visits per client
- Last visit date
- Subscription status

**Search Clients:**
- By name
- By phone number
- Filter by status

### 6. Exporting Data

**Visit History Export:**
```
1. Go to Visit History
2. Apply filters (optional)
3. Click "Export CSV"
4. File downloads automatically
```

**CSV Format:**
```
Date, Time, Customer, Status
2024-01-15, 10:30:00, uuid-123..., completed
```

### 7. Printing QR Codes

**Steps:**
```
1. Go to QR Templates
2. Select template size
3. Click "Print"
4. Print dialog opens
5. Select printer and print
```

**Download QR Code:**
```
1. Select template
2. Click "Download PNG"
3. Save to your device
4. Use for marketing materials
```

## API Endpoints Used

### Authentication
```
POST /api/partner/staff/login
Body: { phone_number, pin_code }
Response: { access_token, staff, partner, location }
```

### Statistics
```
GET /api/visit/partner/{partner_id}/stats
Response: {
  total_visits,
  total_clients,
  avg_daily_visits,
  monthly_revenue
}
```

### Clients
```
GET /api/visit/partner/{partner_id}/clients
Response: [{
  user_id,
  user_name,
  phone_number,
  visit_count,
  last_visit,
  subscription_active
}]
```

### Earnings
```
GET /api/visit/partner/{partner_id}/earnings
Response: {
  earnings: { today, week, month, total },
  breakdown: [...]
}
```

### Visits
```
GET /api/visit/partner/{partner_id}/visits
Query: start_date, end_date, skip, limit
Response: [{ id, user_id, check_in_time, status }]
```

### Check-in
```
POST /api/visit/checkin
Body: {
  qr_token,
  location_id,
  staff_id,
  notes
}
Response: { id, status, check_in_time }
```

## Troubleshooting

### Login Issues
**Problem**: "Invalid credentials"
**Solution**: 
- Verify phone number format (+998...)
- Check PIN code (6 digits)
- Contact administrator to reset PIN

### QR Scan Fails
**Problem**: "Invalid or expired QR token"
**Solution**:
- QR tokens expire after 120 seconds
- Ask customer to generate new QR code
- Check internet connection

### Statistics Not Loading
**Problem**: Dashboard shows loading spinner
**Solution**:
- Check internet connection
- Refresh the page
- Clear browser cache
- Contact support

### Export Not Working
**Problem**: CSV download fails
**Solution**:
- Check browser popup blocker
- Try different browser
- Ensure visits exist in selected period

## Best Practices

### 1. Security
- ✅ Never share your PIN code
- ✅ Log out when leaving workstation
- ✅ Use strong, unique PIN codes
- ✅ Report suspicious activity

### 2. Check-in Process
- ✅ Verify customer identity
- ✅ Check subscription status on screen
- ✅ Confirm successful check-in
- ✅ Thank the customer

### 3. QR Code Display
- ✅ Print in high quality
- ✅ Display at eye level
- ✅ Keep clean and visible
- ✅ Replace if damaged

### 4. Data Management
- ✅ Export data regularly
- ✅ Review statistics weekly
- ✅ Monitor peak hours
- ✅ Track client retention

## Support

### Contact Information
- **Email**: merchant-support@yuvgo.uz
- **Phone**: +998 71 123 4567
- **Hours**: 9:00 AM - 6:00 PM (Mon-Fri)

### Common Questions

**Q: How do I add new staff members?**
A: Contact your administrator or YuvGo support to add staff accounts.

**Q: Can I see individual customer details?**
A: Yes, click on any client in the Clients page to view their visit history.

**Q: How is revenue calculated?**
A: Revenue is estimated based on average subscription value per visit (3,300 UZS per visit).

**Q: Can I filter visits by date?**
A: Yes, use the filter dropdown in Visit History to select time periods.

**Q: How do I change my PIN code?**
A: Contact your administrator to reset your PIN code.

## Updates & Changelog

### Version 1.0.0 (Current)
- ✅ Dashboard with real-time statistics
- ✅ QR Scanner for check-ins
- ✅ Client management
- ✅ Earnings tracking
- ✅ Visit history with export
- ✅ QR code templates
- ✅ Role-based authentication

### Upcoming Features
- 🔄 Push notifications
- 🔄 Advanced analytics
- 🔄 Customer feedback system
- 🔄 Appointment scheduling
- 🔄 Inventory management
- 🔄 Staff performance reports

## Technical Requirements

### Browser Support
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

### Device Requirements
- Desktop/Laptop recommended
- Tablet supported
- Mobile responsive
- Minimum 1024x768 resolution

### Internet Connection
- Stable internet required
- Minimum 1 Mbps
- 4G/LTE or WiFi recommended

---

**Last Updated**: December 13, 2024
**Version**: 1.0.0
**Support**: merchant-support@yuvgo.uz
