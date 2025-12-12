# 🧪 Quick Test Guide

## Run All Tests in 3 Steps

### Step 1: Setup Test Database
```bash
./create_test_db.sh
```

### Step 2: Run API Tests
```bash
python3 test_api.py
```

### Step 3: Manual Testing
- Admin: http://localhost:3000 (admin@yuvgo.uz / Admin@123)
- Merchant: http://localhost:3001 (+998901234567 / 123456)
- User App: http://localhost:3003

---

## Test Credentials

### Admin Dashboard
- Email: `admin@yuvgo.uz`
- Password: `Admin@123`

### Merchant Dashboard
- Phone: `+998901234567`
- PIN: `123456`

### Test Users
- `+998901111111` (user1@test.com)
- `+998902222222` (user2@test.com)
- `+998903333333` (user3@test.com)

---

## Quick Health Check

```bash
# Check all services
curl http://localhost:8000/
curl http://localhost:8000/api/user/
curl http://localhost:8000/api/partner/
curl http://localhost:8000/api/subscription/
```

---

## Database Quick Check

```bash
# Connect to database
docker-compose exec postgres psql -U yuvgo -d yuvgo_db

# Check data
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM partners;
SELECT COUNT(*) FROM car_wash_types;
SELECT COUNT(*) FROM service_areas;
```

---

## Troubleshooting

### Services not running?
```bash
docker-compose up -d
sleep 30
```

### Database issues?
```bash
docker-compose restart postgres
./create_test_db.sh
```

### API tests failing?
```bash
pip3 install requests
python3 test_api.py
```

---

## Expected Results

✅ **15 API tests** should pass
✅ **3 test users** in database
✅ **3 test partners** created
✅ **3 car wash types** available
✅ **5 service areas** configured
✅ **All dashboards** accessible

---

## Full Documentation

See **TESTING_GUIDE.md** for complete testing instructions.
