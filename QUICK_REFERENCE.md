# YuvGo Quick Reference Card

## 🚀 Start Everything
```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
docker-compose up -d
```

## 🌐 Access URLs

| Interface | URL | Credentials |
|-----------|-----|-------------|
| **Admin Dashboard** | http://localhost:3000 | admin@yuvgo.uz / Admin@123 |
| **Merchant Dashboard** | http://localhost:3001 | Phone + PIN (create in admin) |
| **User App** 📱 | http://localhost:3003 | Register or Login |
| **API Gateway** | http://localhost:8000 | - |
| **API Docs** | http://localhost:8000/docs | - |
| **Grafana** | http://localhost:3002 | admin / admin |
| **Prometheus** | http://localhost:9090 | - |

## 📱 User App Features

### Pages
- **Welcome** - Onboarding screen
- **Register** - Create account
- **Login** - Sign in
- **Home** - Dashboard with subscription status
- **Map** 🗺️ - Find car wash locations
- **Plans** 💳 - Browse and buy subscriptions
- **My QR** 📱 - Generate QR code
- **Profile** - Account settings

### Key Features
✅ Mobile-first design
✅ Interactive map with markers
✅ QR code with 2-min timer
✅ Subscription purchase
✅ Visit history
✅ Touch-optimized

## 🏪 Merchant Dashboard Features

### Pages
- **Dashboard** - Statistics overview
- **QR Scanner** - Check-in customers
- **Clients** - Customer list
- **Earnings** - Revenue tracking
- **Visit History** - Complete records
- **QR Templates** - Print materials

### Key Stats
- Today's visits
- Total clients
- Monthly revenue
- Performance metrics

## 🎛️ Admin Dashboard Features

### Pages
- **Dashboard** - System overview
- **Users** - User management
- **Partners** - Car wash approval
- **Subscriptions** - Plan management
- **Payments** - Transaction tracking
- **Analytics** - Reports
- **Admins** - Role management
- **Promotions** - Discount codes
- **Audit Logs** - Activity tracking

## 🔑 Default Accounts

### Super Admin
```
Email: admin@yuvgo.uz
Password: Admin@123
Permissions: All
```

### Test User (Create via app)
```
Phone: +998901234567
Name: Test User
```

### Test Staff (Create in admin)
```
Phone: +998901234567
PIN: 123456
```

## 📊 Database Info

### Connection
```
Host: localhost
Port: 5432
Database: yuvgo_db
User: yuvgo
Password: yuvgo_password
```

### Tables (15 total)
- users, vehicles
- subscription_plans, subscriptions
- partners, partner_locations, partner_staff
- visits, payments
- admins, admin_roles
- promotions, notifications, audit_logs

## 🔧 Common Commands

### Docker
```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Restart service
docker-compose restart [service_name]

# Check status
docker-compose ps
```

### Database
```bash
# Connect to database
docker-compose exec postgres psql -U yuvgo -d yuvgo_db

# View tables
\dt

# View admins
SELECT * FROM admins;

# View subscription plans
SELECT * FROM subscription_plans;
```

### Backend
```bash
# View gateway logs
docker-compose logs -f gateway

# Restart user service
docker-compose restart user_service
```

### Frontend
```bash
# Rebuild admin dashboard
docker-compose up -d --build admin_dashboard

# View user app logs
docker-compose logs -f user_app
```

## 🎯 Quick Test Flow

### 1. Test Admin Dashboard
```
1. Go to localhost:3000
2. Login: admin@yuvgo.uz / Admin@123
3. View dashboard
4. Create a partner
5. Create staff member
```

### 2. Test Merchant Dashboard
```
1. Go to localhost:3001
2. Login with staff phone + PIN
3. View statistics
4. Open QR scanner
```

### 3. Test User App
```
1. Go to localhost:3003
2. Click "Get Started"
3. Register account
4. Browse plans
5. View map
6. Generate QR code
```

## 🔐 Security Notes

### QR Codes
- Valid for 120 seconds
- Single use only
- 4-hour cooldown between washes

### Passwords
- Admin: bcrypt hashed
- Staff: 6-digit PIN
- Users: Token-based

### Rate Limiting
- 60 requests per minute per IP
- Configurable in .env

## 📱 Mobile Testing

### Browser Testing
```
Chrome DevTools:
1. F12 to open DevTools
2. Click device toolbar (Ctrl+Shift+M)
3. Select iPhone/Android
4. Test user app
```

### Real Device
```
1. Find your local IP: ifconfig
2. Update REACT_APP_API_URL
3. Access from phone: http://YOUR_IP:3003
```

## 🐛 Troubleshooting

### Services won't start
```bash
docker-compose down
docker-compose up -d --build
```

### Can't login
```bash
# Check if admin exists
docker-compose exec postgres psql -U yuvgo -d yuvgo_db -c "SELECT * FROM admins;"
```

### Map not loading
```
Check browser console
Ensure internet connection
Verify Leaflet CSS loaded
```

### QR generation fails
```
Check subscription status
Verify Redis is running
Check API logs
```

## 📈 Monitoring

### Prometheus Queries
```
# Total requests
gateway_requests_total

# Request latency
gateway_request_latency_seconds

# Service health
up{job="gateway"}
```

### Grafana Dashboards
```
1. Login to localhost:3002
2. Add Prometheus datasource
3. Create dashboard
4. Add panels for metrics
```

## 🎨 Customization

### Change Colors
```
Edit: frontend/*/tailwind.config.js
Update: primary color values
Rebuild: docker-compose up -d --build
```

### Add Subscription Plan
```
1. Login to admin dashboard
2. Go to Subscriptions
3. Click "Add Plan"
4. Set price, duration, limits
5. Save
```

### Add Car Wash Location
```
1. Login to admin dashboard
2. Go to Partners
3. Select partner
4. Add location
5. Set coordinates
6. Add working hours
```

## 📞 Quick Support

### Check Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs gateway

# Follow logs
docker-compose logs -f user_app
```

### Health Checks
```bash
# Gateway
curl http://localhost:8000/health

# User service
curl http://localhost:8001/health

# Check all
docker-compose ps
```

### Reset Everything
```bash
docker-compose down -v
docker-compose up -d
```

## 🎯 Production Checklist

- [ ] Change JWT_SECRET in .env
- [ ] Update admin password
- [ ] Configure payment providers
- [ ] Add Firebase credentials
- [ ] Set up SMS provider
- [ ] Configure CORS origins
- [ ] Enable SSL/TLS
- [ ] Set up backups
- [ ] Configure monitoring alerts
- [ ] Update API URLs

## 📚 Documentation

- **README.md** - Overview
- **SETUP.md** - Setup guide
- **API_DOCUMENTATION.md** - API reference
- **MERCHANT_DASHBOARD.md** - Merchant guide
- **USER_APP_GUIDE.md** - User app guide
- **FINAL_SUMMARY.md** - Complete summary
- **QUICK_REFERENCE.md** - This file

---

**Keep this card handy for quick reference! 📋**
