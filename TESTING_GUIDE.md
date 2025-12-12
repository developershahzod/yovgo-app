# YuvGo Testing Guide

## 🧪 Complete Testing Suite

This guide will help you test all functions and APIs in the YuvGo system.

---

## 🚀 Quick Start

### 1. Setup Test Database

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
./create_test_db.sh
```

This script will:
- ✅ Check if services are running
- ✅ Verify database connection
- ✅ Check database schema
- ✅ Create test users
- ✅ Create test partners (Premium, Mobile, Standard)
- ✅ Create test locations
- ✅ Create test staff
- ✅ Display database statistics

### 2. Run API Tests

```bash
python3 test_api.py
```

This will test:
- ✅ All service health checks
- ✅ Database connectivity
- ✅ Redis connectivity
- ✅ Admin authentication
- ✅ User management
- ✅ Partner management
- ✅ Subscription plans
- ✅ Analytics endpoints
- ✅ API documentation

---

## 📊 Test Database Contents

After running `create_test_db.sh`, you'll have:

### Test Users
| Phone | Email | Name |
|-------|-------|------|
| +998901111111 | user1@test.com | Test User 1 |
| +998902222222 | user2@test.com | Test User 2 |
| +998903333333 | user3@test.com | Test User 3 |

### Test Partners
| Name | Type | Area | Status |
|------|------|------|--------|
| Premium Wash Center | Premium | Tashkent Center | Approved |
| Quick Clean Mobile | Mobile | Tashkent North | Approved |
| Standard Auto Wash | Standard | Tashkent South | Pending |

### Test Staff
| Name | Phone | PIN | Partner |
|------|-------|-----|---------|
| Test Staff Member | +998901234567 | 123456 | Premium Wash Center |

### Default Data
- **4 Subscription Plans** (Basic/Premium Monthly/Quarterly)
- **3 Car Wash Types** (Premium, Standard, Mobile)
- **5 Service Areas** (Tashkent Center/North/South/East/West)
- **1 Admin Account** (admin@yuvgo.uz)

---

## 🔍 Manual Testing

### Test Admin Dashboard

1. **Access**: http://localhost:3000
2. **Login**: admin@yuvgo.uz / Admin@123
3. **Test Features**:
   - ✅ View dashboard statistics
   - ✅ List users (should see 3 test users)
   - ✅ List partners (should see 3 test partners)
   - ✅ Approve pending partner
   - ✅ View analytics
   - ✅ Create new admin
   - ✅ View audit logs

### Test Merchant Dashboard

1. **Access**: http://localhost:3001
2. **Login**: +998901234567 / PIN: 123456
3. **Test Features**:
   - ✅ View statistics dashboard
   - ✅ Open QR scanner
   - ✅ View clients list
   - ✅ Check earnings
   - ✅ View visit history
   - ✅ Download QR templates

### Test User App

1. **Access**: http://localhost:3003
2. **Register**: Create new account or login with test user
3. **Test Features**:
   - ✅ View home dashboard
   - ✅ Browse subscription plans
   - ✅ View map with car wash locations
   - ✅ Generate QR code
   - ✅ View profile

---

## 🔧 API Testing with cURL

### Health Checks

```bash
# Gateway
curl http://localhost:8000/

# User Service
curl http://localhost:8000/api/user/

# Partner Service
curl http://localhost:8000/api/partner/

# All services should return 200 OK
```

### Admin Login

```bash
curl -X POST http://localhost:8000/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@yuvgo.uz",
    "password": "Admin@123"
  }'
```

Save the `access_token` from response.

### List Users

```bash
curl http://localhost:8000/api/user/users \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Get Subscription Plans

```bash
curl http://localhost:8000/api/subscription/plans
```

### List Partners

```bash
curl http://localhost:8000/api/partner/partners
```

### Get Analytics

```bash
curl http://localhost:8000/api/admin/analytics/overview?period=month \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### List Car Wash Types

```bash
curl http://localhost:8000/api/partner/car-wash-types
```

### List Service Areas

```bash
curl http://localhost:8000/api/partner/service-areas
```

---

## 🗄️ Database Testing

### Connect to Database

```bash
docker-compose exec postgres psql -U yuvgo -d yuvgo_db
```

### Useful SQL Queries

```sql
-- Count all users
SELECT COUNT(*) FROM users;

-- List all partners with types and areas
SELECT 
    p.name,
    cwt.name_en as car_wash_type,
    sa.name_en as service_area,
    p.status
FROM partners p
LEFT JOIN car_wash_types cwt ON p.car_wash_type_id = cwt.id
LEFT JOIN service_areas sa ON p.service_area_id = sa.id;

-- Count subscriptions by status
SELECT status, COUNT(*) 
FROM subscriptions 
GROUP BY status;

-- Recent visits
SELECT 
    v.check_in_time,
    u.full_name as user_name,
    p.name as partner_name
FROM visits v
JOIN users u ON v.user_id = u.id
JOIN partners p ON v.partner_id = p.id
ORDER BY v.check_in_time DESC
LIMIT 10;

-- Car wash types with translations
SELECT name_en, name_ru, name_uz 
FROM car_wash_types;

-- Service areas
SELECT name_en, name_ru, city, district 
FROM service_areas;
```

---

## 📈 Performance Testing

### Load Test with Apache Bench

```bash
# Install Apache Bench
# macOS: brew install httpd
# Ubuntu: sudo apt-get install apache2-utils

# Test health endpoint
ab -n 1000 -c 10 http://localhost:8000/

# Test subscription plans
ab -n 500 -c 5 http://localhost:8000/api/subscription/plans
```

### Expected Results
- **Latency**: < 150ms per request
- **Success Rate**: 100%
- **Concurrent Users**: Handle 10+ simultaneous requests

---

## 🔐 Security Testing

### Test Rate Limiting

```bash
# Make 100 requests quickly
for i in {1..100}; do
  curl http://localhost:8000/ &
done
wait

# Should see some 429 (Too Many Requests) responses
```

### Test Authentication

```bash
# Try accessing protected endpoint without token
curl http://localhost:8000/api/admin/analytics/overview

# Should return 401 Unauthorized
```

### Test Invalid Credentials

```bash
curl -X POST http://localhost:8000/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@yuvgo.uz",
    "password": "wrong_password"
  }'

# Should return 401 Unauthorized
```

---

## 🐛 Troubleshooting Tests

### Services Not Responding

```bash
# Check service status
docker-compose ps

# View logs
docker-compose logs -f gateway

# Restart services
docker-compose restart
```

### Database Connection Failed

```bash
# Check PostgreSQL
docker-compose logs postgres

# Verify connection
docker-compose exec postgres psql -U yuvgo -d yuvgo_db -c "SELECT 1;"
```

### Test Script Fails

```bash
# Install required Python packages
pip3 install requests

# Check Python version (need 3.6+)
python3 --version

# Run with verbose output
python3 test_api.py -v
```

---

## ✅ Test Checklist

### Infrastructure
- [ ] All services are running
- [ ] Database is accessible
- [ ] Redis is working
- [ ] API documentation loads

### Authentication
- [ ] Admin can login
- [ ] Invalid credentials rejected
- [ ] JWT tokens work
- [ ] Token refresh works

### User Management
- [ ] Create user
- [ ] List users
- [ ] Update user
- [ ] User can login

### Partner Management
- [ ] Create partner
- [ ] List partners
- [ ] Approve partner
- [ ] Reject partner
- [ ] Add location
- [ ] Add staff

### Subscriptions
- [ ] List plans
- [ ] Create subscription
- [ ] Check subscription status
- [ ] Cancel subscription

### Visits
- [ ] Generate QR code
- [ ] Process check-in
- [ ] View visit history
- [ ] Partner statistics

### Payments
- [ ] Create payment
- [ ] List payments
- [ ] Process refund

### Analytics
- [ ] Get overview
- [ ] User analytics
- [ ] Revenue analytics
- [ ] Partner analytics

### Multilingual
- [ ] Car wash types (EN/RU/UZ)
- [ ] Service areas (EN/RU/UZ)
- [ ] Translations load correctly

---

## 📊 Test Results Format

After running tests, you should see:

```
==============================================================
YuvGo API Test Suite
==============================================================
Base URL: http://localhost:8000
Started at: 2024-12-13 01:46:00

==============================================================
Testing: Health Checks
==============================================================
  ✓ Gateway is healthy
  ✓ User Service is healthy
  ✓ Subscription Service is healthy
  ...
✓ Health Checks - PASSED

...

==============================================================
Test Summary
==============================================================
Total Tests: 15
Passed: 15
Failed: 0
Success Rate: 100.0%
==============================================================

🎉 All tests passed! Your API is working correctly!
```

---

## 🎯 Next Steps

After successful testing:

1. **Review Results**: Check all tests passed
2. **Fix Issues**: Address any failed tests
3. **Performance**: Run load tests
4. **Security**: Verify authentication
5. **Documentation**: Update API docs
6. **Deploy**: Ready for production

---

## 📞 Support

If tests fail:
1. Check service logs: `docker-compose logs`
2. Verify database: `./create_test_db.sh`
3. Restart services: `docker-compose restart`
4. Review error messages in test output

---

**Happy Testing! 🧪✨**
