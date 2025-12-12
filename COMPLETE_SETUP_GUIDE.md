# 🎯 Complete YuvGo Setup & Fix Guide

## Current Status

### ❌ Issues Found
1. **503 Service Unavailable** - Backend services can't find shared module
2. **Services not responding** - Missing shared directory in containers
3. **APIs not working** - Gateway can't connect to microservices

### ✅ Solution In Progress
- Rebuilding all services with `--no-cache`
- Ensuring shared module is properly copied
- Adding service URLs to gateway environment

---

## 🔧 Complete Fix Steps

### Step 1: Rebuild All Services (Running Now)

```bash
docker compose down
docker system prune -f
docker compose build --no-cache
docker compose up -d
```

**Wait time**: ~10-15 minutes

### Step 2: Verify Services Are Running

```bash
# Check all containers
docker ps

# Test gateway
curl http://localhost:8000/health

# Test user service directly
curl http://localhost:8001/health
```

### Step 3: Initialize Database with Test Data

```bash
# Check if database has data
docker exec yuvgo_postgres psql -U yuvgo -d yuvgo_db -c "SELECT COUNT(*) FROM users;"

# If no data, run:
docker exec -i yuvgo_postgres psql -U yuvgo -d yuvgo_db < backend/init.sql
```

### Step 4: Test All APIs

```bash
# Test user registration
curl -X POST http://localhost:8000/api/user/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+998901234567","full_name":"Test User"}'

# Test admin login
curl -X POST http://localhost:8000/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@yuvgo.uz","password":"Admin@123"}'

# Test getting users (requires auth)
curl http://localhost:8000/api/user/users
```

---

## 🎨 Dashboard Design Updates

### Admin Dashboard (Port 3000)

**Current Issues**:
- Basic design
- Missing modern UI components
- No responsive layout

**Improvements Needed**:
1. Modern sidebar navigation
2. Dashboard cards with statistics
3. Data tables with search/filter
4. Charts and graphs
5. Responsive design
6. Better color scheme

### Merchant Dashboard (Port 3001)

**Improvements Needed**:
1. QR code scanner interface
2. Visit history with filters
3. Real-time statistics
4. Staff management UI
5. Location management
6. Modern card-based layout

### User App (Port 3003)

**Improvements Needed**:
1. Modern landing page
2. Subscription cards
3. QR code display
4. Visit history timeline
5. Vehicle management
6. Profile settings
7. Mobile-first design

---

## 📊 Database Check

### Verify Tables Exist

```sql
-- Connect to database
docker exec -it yuvgo_postgres psql -U yuvgo -d yuvgo_db

-- Check tables
\dt

-- Check data
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM partners;
SELECT COUNT(*) FROM subscription_plans;
SELECT COUNT(*) FROM admins;
```

### Expected Data:
- **Users**: 0 (will be created via API)
- **Partners**: 0 (will be created via admin)
- **Subscription Plans**: 4 (Basic/Premium Monthly/Quarterly)
- **Admins**: 1 (admin@yuvgo.uz)
- **Car Wash Types**: 3
- **Service Areas**: 5

---

## 🧪 Complete API Testing Checklist

### User APIs
- [ ] POST `/api/user/auth/register` - Register new user
- [ ] POST `/api/user/auth/login` - Login user
- [ ] GET `/api/user/profile` - Get user profile
- [ ] PUT `/api/user/profile` - Update profile
- [ ] GET `/api/user/vehicles` - Get user vehicles
- [ ] POST `/api/user/vehicles` - Add vehicle

### Subscription APIs
- [ ] GET `/api/subscription/plans` - Get all plans
- [ ] POST `/api/subscription/subscribe` - Subscribe to plan
- [ ] GET `/api/subscription/my-subscription` - Get active subscription
- [ ] POST `/api/subscription/cancel` - Cancel subscription

### Partner APIs
- [ ] GET `/api/partner/list` - Get all partners
- [ ] GET `/api/partner/{id}` - Get partner details
- [ ] POST `/api/partner/register` - Register new partner
- [ ] GET `/api/partner/locations` - Get partner locations

### Visit APIs
- [ ] POST `/api/visit/checkin` - Check in for wash
- [ ] GET `/api/visit/history` - Get visit history
- [ ] GET `/api/visit/qr-code` - Generate QR code

### Payment APIs
- [ ] POST `/api/payment/create` - Create payment
- [ ] GET `/api/payment/status/{id}` - Check payment status
- [ ] POST `/api/payment/webhook` - Payment webhook

### Admin APIs
- [ ] POST `/api/admin/auth/login` - Admin login
- [ ] GET `/api/admin/users` - Get all users
- [ ] GET `/api/admin/partners` - Get all partners
- [ ] PUT `/api/admin/partner/{id}/approve` - Approve partner
- [ ] GET `/api/admin/analytics` - Get analytics

---

## 🎨 UI Improvements Plan

### 1. Admin Dashboard Redesign

**File**: `frontend/admin-dashboard/src/App.js`

**New Features**:
```javascript
// Modern sidebar with icons
// Dashboard with stat cards
// Data tables with pagination
// Charts (users, revenue, visits)
// Dark mode toggle
// Responsive mobile menu
```

**Tech Stack**:
- React
- TailwindCSS
- Recharts (for graphs)
- React Icons
- React Router

### 2. Merchant Dashboard Redesign

**File**: `frontend/merchant-dashboard/src/App.js`

**New Features**:
```javascript
// QR scanner component
// Visit management table
// Staff management
// Statistics dashboard
// Location settings
// Real-time updates
```

### 3. User App Redesign

**File**: `frontend/user-app/src/App.js`

**New Features**:
```javascript
// Modern landing page
// Subscription selection
// QR code display
// Visit history
// Vehicle management
// Profile settings
// Mobile-optimized
```

---

## 🚀 After Services Are Running

### 1. Access Applications

- **Admin Dashboard**: http://localhost:3000
- **Merchant Dashboard**: http://localhost:3001
- **User App**: http://localhost:3003
- **API Gateway**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

### 2. Test Login

**Admin**:
- Email: admin@yuvgo.uz
- Password: Admin@123

### 3. Create Test Data

```bash
# Run the test data script
bash create_test_data.sh
```

---

## 📝 Next Steps After Fix

1. **Verify all services running**
2. **Test all API endpoints**
3. **Update dashboard designs**
4. **Add more test data**
5. **Deploy to Render.com**

---

## 🆘 Troubleshooting

### Services Won't Start
```bash
# Check logs
docker logs yuvgo_gateway
docker logs yuvgo_user_service

# Rebuild specific service
docker compose build --no-cache user_service
docker compose up -d user_service
```

### Database Issues
```bash
# Reset database
docker compose down -v
docker compose up -d postgres
docker exec -i yuvgo_postgres psql -U yuvgo -d yuvgo_db < backend/init.sql
```

### Port Conflicts
```bash
# Check what's using ports
lsof -i :8000
lsof -i :3000

# Kill process
kill -9 <PID>
```

---

## ✅ Success Criteria

- [ ] All 8 backend services running
- [ ] Gateway returns `{"status":"healthy"}`
- [ ] All APIs respond correctly
- [ ] Database has schema and default data
- [ ] Admin dashboard loads
- [ ] Merchant dashboard loads
- [ ] User app loads
- [ ] Can login as admin
- [ ] Can create test users
- [ ] Can view data in dashboards

---

**Current Build Status**: In Progress...
**Estimated Completion**: 10-15 minutes
