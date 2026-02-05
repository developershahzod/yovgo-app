# YuvGO Full Project Update Summary

## Overview
This document summarizes the comprehensive updates made to the YuvGO platform including:
- Flutter mobile app with pixel-perfect UI
- Admin dashboard with fully working APIs
- Merchant dashboard with fully working APIs
- Backend microservices with complete API endpoints

---

## 1. Flutter App Updates

### New API Service (`lib/services/full_api_service.dart`)
A comprehensive API service that handles all backend communication:

- **User Service**: Login, register, profile management
- **Vehicle Service**: Add, list, delete vehicles
- **Subscription Service**: Plans, status, create, cancel subscriptions
- **Partner Service**: Get car washes, locations
- **Visit Service**: Record visits, history, stats
- **Notification Service**: Get, mark as read
- **Payment Service**: Methods, process, history
- **QR Code Service**: Validate, scan
- **Weather Service**: Car wash recommendations
- **Saved Locations**: Save/remove favorite car washes

### Pixel-Perfect UI
The Flutter app follows the React examples in `examples_pages_in_react/`:
- Main screen with premium card and weather widget
- QR scanner screen with car selection
- Notifications screen with read/unread indicators
- Profile screens (new user, signed, premium)
- Subscription screens (30, 90, 365 days, FAQ, freeze)
- Saved car washes screen
- Map screen with partner locations

### Key Design Elements
- Primary color: `#00BFFE` (cyan)
- Font: Mulish
- Border radius: 20-24px for cards
- Bottom navigation with floating QR button
- iOS-style status bar

---

## 2. Admin Dashboard Updates

### New API Service (`src/services/api.js`)
Centralized API service with interceptors for:
- **Users API**: CRUD operations, stats
- **Partners API**: Management, approval, locations, staff
- **Subscriptions API**: Plans and subscription management
- **Visits API**: History, stats, daily stats
- **Payments API**: History, refunds, revenue
- **Admins API**: Admin user management
- **Promotions API**: Create, activate, deactivate
- **Notifications API**: Send, templates
- **Analytics API**: Dashboard, users, revenue, visits
- **Audit Logs API**: Activity tracking
- **Settings API**: Platform configuration

### Updated Dashboard (`src/pages/Dashboard.js`)
- Enhanced stat cards with color coding
- Secondary stats with gradient backgrounds
- Real-time data fetching from APIs
- Uzbek language support
- Refresh functionality
- Error handling

### Features
- User management with search and filters
- Partner approval workflow
- Subscription plan management
- Payment tracking
- Analytics and reporting
- Audit logging

---

## 3. Merchant Dashboard Updates

### New API Service (`src/services/api.js`)
Complete API integration for:
- **Auth API**: Login, register, logout
- **Partner API**: Profile, locations, QR codes, staff
- **Visits API**: Today's visits, history, stats
- **Clients API**: Customer list, visit history
- **Earnings API**: Summary, daily, monthly, payouts
- **QR API**: Generate, validate, scan
- **Analytics API**: Dashboard, trends, peak hours

### Updated Dashboard (`src/pages/Dashboard.js`)
- Quick action button for QR scanning
- Enhanced stat cards with navigation
- Real-time visit tracking
- Uzbek language support
- Responsive design

### Features
- QR code display for customer check-ins
- Client management
- Earnings tracking
- Visit history
- Performance analytics

---

## 4. Backend Updates

### Visit Service (`services/visit/main.py`)
New endpoints added:
- `GET /visits/today` - Today's visits
- `GET /stats` - Visit statistics
- `GET /stats/daily` - Daily stats for charts
- `GET /clients` - Client list with visit counts
- `GET /clients/stats` - Client statistics
- `POST /qr/validate` - Validate QR tokens
- `POST /qr/scan` - Process QR scans

### Admin Service (`services/admin/routes.py`)
New analytics and management endpoints:
- `GET /analytics/dashboard` - Dashboard stats
- `GET /analytics/users` - User growth
- `GET /analytics/revenue` - Revenue tracking
- `GET /analytics/visits` - Visit trends
- `GET /analytics/subscriptions` - Subscription breakdown
- Promotions CRUD
- Audit logs
- Settings management

### Gateway (`gateway/main.py`)
Enhanced with:
- Mobile API routes
- Service health check endpoint
- API documentation endpoint

---

## 5. How to Run

### Backend (Docker)
```bash
docker-compose up -d
```

### Admin Dashboard
```bash
cd frontend/admin-dashboard
npm install
npm start
# Runs on http://localhost:3001
```

### Merchant Dashboard
```bash
cd frontend/merchant-dashboard
npm install
npm start
# Runs on http://localhost:3002
```

### Flutter App
```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 6. API Endpoints Summary

### Gateway: `http://localhost:8000`

| Service | Base Path | Port |
|---------|-----------|------|
| User | /api/user | 8001 |
| Subscription | /api/subscription | 8002 |
| Partner | /api/partner | 8003 |
| Visit | /api/visit | 8004 |
| Payment | /api/payment | 8005 |
| Notification | /api/notification | 8006 |
| Admin | /api/admin | 8007 |

---

## 7. Login Credentials

### Admin Dashboard
- Email: admin@yuvgo.uz
- Password: admin123

### Merchant Dashboard
- Phone: +998901234567
- PIN: 1234

---

## 8. Key Files Modified/Created

### Flutter App
- `lib/services/full_api_service.dart` - NEW

### Admin Dashboard
- `src/services/api.js` - NEW
- `src/pages/Dashboard.js` - UPDATED

### Merchant Dashboard
- `src/services/api.js` - NEW
- `src/pages/Dashboard.js` - UPDATED

### Backend
- `services/visit/main.py` - UPDATED (new endpoints)
- `services/admin/routes.py` - NEW
- `gateway/main.py` - UPDATED

---

## 9. Next Steps

1. **Testing**: Run all services and test API integrations
2. **Database**: Ensure all migrations are applied
3. **Environment**: Configure `.env` files for production
4. **Deployment**: Use Docker Compose for deployment
5. **Monitoring**: Check Prometheus metrics at `/metrics`

---

## 10. Design Reference

The Flutter app UI is based on the React examples in:
`flutter_app/examples_pages_in_react/`

Key screens:
- `Main.tsx` - Home screen
- `QrCode.tsx` - QR scanner
- `Notifications.tsx` - Notifications
- `Profile.tsx` - Profile screens
- `Subscription.tsx` - Subscription screens
- `Saved.tsx` - Saved car washes
- `PremiumCarWashes.tsx` - Map view

---

---

## 11. Complete API Endpoints Reference

### User Service (Port 8001)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/login | User login with phone |
| POST | /users | Create user |
| GET | /users/{id} | Get user profile |
| PUT | /users/{id} | Update user |
| GET | /users | List all users (admin) |
| POST | /vehicles | Add vehicle |
| GET | /vehicles | List user vehicles |
| DELETE | /vehicles/{id} | Delete vehicle |

### Subscription Service (Port 8002)
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /plans | List subscription plans |
| POST | /plans | Create plan (admin) |
| GET | /plans/{id} | Get plan details |
| PUT | /plans/{id} | Update plan (admin) |
| DELETE | /plans/{id} | Delete plan (admin) |
| POST | /subscriptions | Create subscription |
| GET | /subscriptions/status | Get user subscription |
| POST | /subscriptions/{id}/cancel | Cancel subscription |
| GET | /subscriptions | List all (admin) |

### Partner Service (Port 8003)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /partners | Register partner |
| GET | /partners | List partners |
| GET | /partners/{id} | Get partner |
| PUT | /partners/{id} | Update partner |
| POST | /locations | Add location |
| GET | /locations | List locations |
| POST | /staff | Add staff |
| GET | /staff | List staff |
| POST | /staff/login | Staff login |
| GET | /partners/{id}/qr | Generate QR |

### Visit Service (Port 8004)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /qr/generate | Generate QR token |
| POST | /checkin | Check-in with QR |
| POST | /user-checkin | User scans merchant QR |
| GET | /visits | Visit history |
| GET | /visits/{id} | Visit details |
| GET | /visits/today | Today's visits |
| GET | /stats | Visit statistics |
| GET | /stats/daily | Daily stats |
| GET | /clients | Client list |
| GET | /clients/stats | Client stats |
| POST | /qr/validate | Validate QR |
| POST | /qr/scan | Process QR scan |

### Payment Service (Port 8005) - IpakYuliBank E-Comm
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /ipakyuli/create-payment | Create payment link |
| GET | /ipakyuli/status/{id} | Get payment status |
| POST | /ipakyuli/cancel/{id} | Cancel payment |
| POST | /ipakyuli/tokenize | Create card token |
| POST | /ipakyuli/pay-with-token | Pay with saved card |
| GET | /ipakyuli/contracts | List saved cards |
| DELETE | /ipakyuli/contracts/{id} | Delete saved card |
| POST | /webhook/ipakyuli | IpakYuliBank webhook |
| GET | /payments | List payments |
| GET | /payments/{id} | Payment details |
| POST | /payments/{id}/refund | Refund (admin) |
| GET | /history | Payment history |
| GET | /earnings | Partner earnings |
| GET | /earnings/daily | Daily earnings |
| GET | /earnings/monthly | Monthly earnings |
| GET | /payouts | Payout history |
| POST | /payouts/request | Request payout |
| GET | /stats | Payment stats |
| GET | /revenue | Revenue by period |

### Notification Service (Port 8006)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /notifications/send | Send notification |
| GET | /notifications | Get notifications |
| PUT | /notifications/{id}/read | Mark as read |
| PUT | /notifications/read-all | Mark all read |
| POST | /notifications/broadcast | Broadcast (admin) |
| GET | /templates | Get templates |
| POST | /templates | Create template |
| POST | /send | Send single |
| POST | /send-bulk | Send bulk (admin) |
| POST | /trigger/subscription-expiring | Trigger expiry |
| POST | /trigger/payment-failed | Trigger failed |
| POST | /trigger/checkin-success | Trigger success |
| GET | /stats | Notification stats |

### Admin Service (Port 8007)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/login | Admin login |
| POST | /admins | Create admin |
| GET | /admins | List admins |
| GET | /admins/{id} | Get admin |
| PUT | /admins/{id} | Update admin |
| DELETE | /admins/{id} | Deactivate admin |
| POST | /roles | Create role |
| GET | /roles | List roles |
| PUT | /partners/{id}/approve | Approve partner |
| PUT | /partners/{id}/reject | Reject partner |
| POST | /promotions | Create promotion |
| GET | /promotions | List promotions |
| PUT | /promotions/{id} | Update promotion |
| DELETE | /promotions/{id} | Delete promotion |
| GET | /analytics/overview | Analytics overview |
| GET | /analytics/users | User analytics |
| GET | /analytics/revenue | Revenue analytics |
| GET | /audit-logs | Audit logs |

---

## 12. Test Credentials

### Admin Dashboard
- **Email**: admin@yuvgo.uz
- **Password**: Admin@123

### Merchant Dashboard
- **Phone**: +998901111111
- **PIN**: 123456

### Test Users
| Phone | Name | Subscription |
|-------|------|--------------|
| +998901234567 | Alisher Karimov | Basic Monthly |
| +998901234568 | Dilshod Rahimov | Premium Monthly |
| +998901234569 | Nodira Saidova | None |

---

*Last Updated: February 5, 2026*
