# YuvGo - Subscription-Based Car Wash Marketplace

YuvGo is a subscription-based marketplace that allows car owners to access partner car washes using QR codes, similar to the 1Fit model.

## 🏗️ Architecture

### Microservices
- **Gateway API** - Request routing, authentication, rate limiting
- **User Service** - Profile, vehicles, subscription state
- **Subscription Service** - Plans, billing cycles, status management
- **Partner Service** - Car wash registration, staff accounts, locations
- **Visit Service** - QR validation, check-in, usage limits
- **Payment Service** - Payme, Click, Paynet integration
- **Notification Service** - Push notifications, email, SMS
- **Admin Service** - Dashboards, analytics, CMS

### Frontend Dashboards
- **Admin Dashboard** - Full system management with role-based access control
  - User management
  - Partner approval workflow
  - Subscription management
  - Payment tracking
  - Analytics and reporting
  - Admin role management
  - Audit logging
  
- **Merchant Dashboard** - Complete partner admin panel with:
  - Real-time statistics dashboard
  - QR code scanner for check-ins
  - Client management and tracking
  - Earnings and revenue analytics
  - Complete visit history
  - QR code templates for printing
  - Staff authentication with PIN

- **User App** - Mobile-first customer interface with: ⭐ NEW
  - Beautiful welcome and onboarding
  - Registration and login
  - Interactive map with car wash locations
  - Subscription plan browsing and purchase
  - QR code generation with timer
  - Visit history tracking
  - User profile management
  - Bottom navigation bar
  - Touch-optimized design

## 🔄 QR Code Flow (Correct Implementation)

### How It Works:
1. **User generates QR code** on their phone (User App)
2. **User shows QR code** to car wash staff
3. **Merchant scans QR code** from user's phone (Merchant Dashboard)
4. **System validates** subscription, limits, and cooldown
5. **Visit recorded** and counter incremented

**✅ Users DON'T scan anything - they only show their QR code!**

See **QR_FLOW_EXPLANATION.md** and **CORRECT_QR_FLOW.md** for detailed diagrams.

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Node.js 18+ (for local frontend development)
- Python 3.11+ (for local backend development)

### Setup

1. **Clone and navigate to the project:**
```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
```

2. **Copy environment variables:**
```bash
cp .env.example .env
```

3. **Update `.env` with your credentials:**
   - Database credentials
   - JWT secret key
   - Payment provider keys (Payme, Click, Paynet)
   - Firebase credentials
   - SMS provider API key

4. **Start all services:**
```bash
docker-compose up -d
```

5. **Check service health:**
```bash
docker-compose ps
```

### Access Points

- **Gateway API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Admin Dashboard**: http://localhost:3000 (admin@yuvgo.uz / Admin@123)
- **Merchant Dashboard**: http://localhost:3001 (Staff phone + PIN)
- **User App**: http://localhost:3003 (Mobile-first interface) ⭐ NEW
- **Grafana Monitoring**: http://localhost:3002 (admin/admin)
- **Prometheus**: http://localhost:9090

## 📁 Project Structure

```
yougo-fastapi/
├── backend/
│   ├── gateway/              # API Gateway
│   ├── services/
│   │   ├── user/            # User management
│   │   ├── subscription/    # Subscription logic
│   │   ├── partner/         # Partner management
│   │   ├── visit/           # QR check-in system
│   │   ├── payment/         # Payment integration
│   │   ├── notification/    # Notifications
│   │   └── admin/           # Admin operations
│   ├── shared/              # Shared utilities
│   └── init.sql             # Database initialization
├── frontend/
│   ├── admin-dashboard/     # React admin panel
│   └── merchant-dashboard/  # React merchant panel
├── monitoring/
│   └── prometheus.yml       # Monitoring config
├── docker-compose.yml
├── .env.example
└── README.md
```

## 🔑 Key Features

### User Features
- Phone number verification
- Multiple vehicle management
- Subscription management
- QR code generation for check-ins
- Visit history

### Partner Features
- Car wash registration
- Multiple location management
- Staff account management
- QR code scanning and validation
- Visit analytics

### Admin Features
- User management
- Partner approval
- Subscription plan management
- Analytics and reporting
- Access control management
- Promotion management

### Payment Integration
- Payme
- Click
- Paynet
- UzCard/Humo acquiring
- Auto-renewal
- Refund handling

## 🔒 Security Features

- JWT-based authentication
- Token refresh mechanism
- Rate limiting
- Device fingerprinting
- Single-use QR tokens (120s TTL)
- OWASP API Top 10 compliance
- Encrypted credentials

## 📊 Monitoring

- Prometheus metrics collection
- Grafana dashboards
- Service health checks
- Error tracking with Sentry (configure separately)

## 🧪 Development

### Backend Development

```bash
# Install dependencies
cd backend/gateway
pip install -r requirements.txt

# Run service locally
uvicorn main:app --reload --port 8000
```

### Frontend Development

```bash
# Admin Dashboard
cd frontend/admin-dashboard
npm install
npm start

# Merchant Dashboard
cd frontend/merchant-dashboard
npm install
npm start
```

## 📝 API Documentation

Once the services are running, visit:
- Gateway API Docs: http://localhost:8000/docs
- User Service Docs: http://localhost:8001/docs
- Subscription Service Docs: http://localhost:8002/docs
- Partner Service Docs: http://localhost:8003/docs
- Visit Service Docs: http://localhost:8004/docs
- Payment Service Docs: http://localhost:8005/docs
- Notification Service Docs: http://localhost:8006/docs
- Admin Service Docs: http://localhost:8007/docs

## 📚 Documentation Files

- **README.md** - Project overview and features
- **SETUP.md** - Detailed setup instructions
- **API_DOCUMENTATION.md** - Complete API reference with examples
- **MERCHANT_DASHBOARD.md** - Merchant dashboard user guide
- **USER_APP_GUIDE.md** - User app guide and features
- **TESTING_GUIDE.md** - Complete testing guide ⭐ NEW
- **RUN_TESTS.md** - Quick test reference ⭐ NEW

## 🧪 Testing

### Quick Test

```bash
# Setup test database
./create_test_db.sh

# Run API tests
python3 test_api.py
```

### What Gets Tested
- ✅ All service health checks
- ✅ Database connectivity
- ✅ Redis functionality
- ✅ Admin authentication
- ✅ User management
- ✅ Partner management
- ✅ Subscription system
- ✅ Analytics endpoints
- ✅ Multilingual support (EN/RU/UZ)

### Test Database Includes
- 3 test users
- 3 test partners (Premium, Mobile, Standard)
- 3 car wash types
- 5 service areas (Tashkent regions)
- 1 test staff member
- Default subscription plans

See **TESTING_GUIDE.md** for complete testing instructions.

## 🔧 Configuration

### Database Migrations

```bash
# Run migrations
docker-compose exec gateway alembic upgrade head

# Create new migration
docker-compose exec gateway alembic revision --autogenerate -m "description"
```

### Scaling Services

```bash
# Scale specific service
docker-compose up -d --scale user_service=3
```

## 📈 Performance Requirements

- Latency: <150ms per API call
- Availability: 99.5%
- Support: 100k MAU

## 🤝 Contributing

1. Create feature branch
2. Make changes
3. Write tests
4. Submit pull request

## 📄 License

Proprietary - All rights reserved

## 📞 Support

For support, contact: support@yuvgo.uz
