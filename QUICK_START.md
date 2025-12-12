# YuvGo - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Start the Services (1 minute)

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
cp .env.example .env
docker-compose up -d
```

Wait 30-60 seconds for all services to start.

### Step 2: Verify Services (30 seconds)

```bash
docker-compose ps
```

All services should show "Up" and "healthy".

### Step 3: Access Admin Dashboard (1 minute)

1. Open browser: http://localhost:3000
2. Login:
   - Email: `admin@yuvgo.uz`
   - Password: `Admin@123`
3. You're in! 🎉

### Step 4: Create a Test Staff Member (2 minutes)

In the admin dashboard:
1. Go to "Partners" → Click "Add Partner"
2. Create a test car wash
3. Go to partner details → "Add Staff"
4. Create staff with:
   - Name: Test Staff
   - Phone: +998901234567
   - PIN: 123456

### Step 5: Access Merchant Dashboard (1 minute)

1. Open browser: http://localhost:3001
2. Login:
   - Phone: `+998901234567`
   - PIN: `123456`
3. You're in the merchant dashboard! 🎉

---

## 🎯 What You Can Do Now

### As Admin (http://localhost:3000)
- ✅ View dashboard with statistics
- ✅ Manage users
- ✅ Approve car wash partners
- ✅ View payments
- ✅ Create admins with permissions
- ✅ View analytics

### As Merchant (http://localhost:3001)
- ✅ View your statistics dashboard
- ✅ Scan QR codes for check-ins
- ✅ View your clients
- ✅ Track your earnings
- ✅ Export visit history
- ✅ Download QR templates

---

## 📱 Test the Complete Flow

### 1. Create a User (via API)
```bash
curl -X POST http://localhost:8000/api/user/users \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "+998901111111",
    "email": "test@example.com",
    "full_name": "Test User"
  }'
```

### 2. Create a Subscription
```bash
# First, get subscription plans
curl http://localhost:8000/api/subscription/plans

# Then create subscription (you'll need user authentication)
```

### 3. Generate QR Code
```bash
# User generates QR token (requires authentication)
curl -X POST http://localhost:8000/api/visit/qr/generate \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 4. Scan QR (Merchant Dashboard)
1. Go to http://localhost:3001
2. Click "QR Scanner"
3. Enter the QR token
4. Click "Process Check-in"
5. ✅ Done!

---

## 🔍 Explore the Features

### Admin Dashboard Features
- **Dashboard**: Real-time statistics
- **Users**: Search, view, edit users
- **Partners**: Approve/reject car washes
- **Subscriptions**: View all subscriptions
- **Payments**: Track all payments
- **Analytics**: Revenue and user trends
- **Admins**: Create admins with specific permissions
- **Promotions**: Create discount codes
- **Audit Logs**: Track all admin actions

### Merchant Dashboard Features
- **Dashboard**: Your statistics at a glance
- **QR Scanner**: Fast check-in processing
- **Clients**: See who visits your car wash
- **Earnings**: Track your revenue
- **Visit History**: Complete records with export
- **QR Templates**: Print marketing materials

---

## 📊 View the APIs

Open http://localhost:8000/docs to see:
- All available endpoints
- Request/response formats
- Try out the APIs directly
- Authentication requirements

---

## 🛠️ Customize Your Setup

### Change Admin Password
1. Login to admin dashboard
2. Go to "Admins"
3. Edit your account
4. Update password

### Add Real Payment Providers
Edit `.env` file:
```bash
PAYME_MERCHANT_ID=your-real-id
PAYME_SECRET_KEY=your-real-key
CLICK_MERCHANT_ID=your-real-id
CLICK_SECRET_KEY=your-real-key
```

### Add More Subscription Plans
1. Login to admin dashboard
2. Go to "Subscriptions"
3. Click "Add Plan"
4. Set price, duration, visit limits

---

## 📈 Monitor Your System

### Grafana Dashboard
1. Open http://localhost:3002
2. Login: admin / admin
3. Add Prometheus data source: http://prometheus:9090
4. Create dashboards for:
   - Request rates
   - Response times
   - Error rates
   - Service health

### Prometheus Metrics
Open http://localhost:9090 to query:
- `gateway_requests_total` - Total requests
- `gateway_request_latency_seconds` - Request latency

---

## 🆘 Troubleshooting

### Services Not Starting?
```bash
# Check logs
docker-compose logs -f

# Restart specific service
docker-compose restart gateway

# Rebuild if needed
docker-compose up -d --build
```

### Can't Login?
- **Admin**: Use admin@yuvgo.uz / Admin@123
- **Merchant**: Create staff account first in admin panel

### Database Issues?
```bash
# Connect to database
docker-compose exec postgres psql -U yuvgo -d yuvgo_db

# Check tables
\dt

# View data
SELECT * FROM admins;
```

### Frontend Not Loading?
```bash
# Check if containers are running
docker-compose ps

# Restart frontend
docker-compose restart admin_dashboard merchant_dashboard
```

---

## 📚 Learn More

- **README.md** - Full project overview
- **SETUP.md** - Detailed setup guide
- **API_DOCUMENTATION.md** - Complete API reference
- **MERCHANT_DASHBOARD.md** - Merchant user guide
- **PROJECT_SUMMARY.md** - Feature summary

---

## 🎉 You're Ready!

Your YuvGo subscription-based car wash system is now running with:

✅ Admin dashboard for system management
✅ Merchant dashboard for car wash partners
✅ Complete API backend
✅ Database with sample data
✅ Monitoring and analytics
✅ Payment integration ready
✅ QR code check-in system

**Start exploring and customize it to your needs!**

---

## 💡 Quick Tips

1. **Change the default admin password immediately**
2. **Configure real payment provider credentials**
3. **Set up Firebase for push notifications**
4. **Add your SMS provider for notifications**
5. **Customize subscription plans for your market**
6. **Print QR templates for your car washes**
7. **Monitor Grafana for system health**
8. **Export visit data regularly for backup**

---

**Need Help?**
- Check the documentation files
- Review API docs at http://localhost:8000/docs
- Contact: support@yuvgo.uz

**Happy Building! 🚗✨**
