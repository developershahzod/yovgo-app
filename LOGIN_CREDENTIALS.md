# 🔑 YuvGo - All Login Credentials

## 🌐 Application URLs

- **Admin Dashboard**: http://localhost:3000
- **Merchant Dashboard**: http://localhost:3001
- **User App**: http://localhost:3003
- **API Gateway**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

---

## 👨‍💼 Admin Login (http://localhost:3000)

**Email**: admin@yuvgo.uz  
**Password**: admin123

**Features**:
- View all users
- Manage partners/merchants
- View analytics
- Approve partners
- System administration

---

## 🏪 Merchant/Partner Login (http://localhost:3001)

### Staff Account 1 - Manager
**Phone**: +998901111111  
**PIN**: 1234  
**Partner**: Premium Car Wash  
**Role**: Manager

### Staff Account 2 - Staff
**Phone**: +998902222222  
**PIN**: 2345  
**Partner**: Quick Clean Mobile  
**Role**: Staff

### Staff Account 3 - Manager
**Phone**: +998903333333  
**PIN**: 3456  
**Partner**: Standard Auto Wash  
**Role**: Manager

### Staff Account 4 - Staff
**Phone**: +998904444444  
**PIN**: 4567  
**Partner**: Express Wash  
**Role**: Staff

**Features**:
- Scan QR codes
- View visit history
- Manage customers
- View earnings

---

## 📱 User App Login (http://localhost:3003)

### User 1
**Phone**: +998901111111  
**Email**: user1@test.com  
**Name**: Test User 1

### User 2
**Phone**: +998902222222  
**Email**: user2@test.com  
**Name**: Test User 2

### User 3
**Phone**: +998903333333  
**Email**: user3@test.com  
**Name**: Test User 3

### User 4 (Your Account)
**Phone**: +998971025595  
**Email**: megatesternumber70@gmail.com  
**Name**: Shahzod Akhmedov

### User 5 (Your Account)
**Phone**: +998971025596  
**Email**: admin@travel-erp.com  
**Name**: Shahzod Akhmedov

**Features**:
- View subscription plans
- Subscribe to plans
- Generate QR code
- View visit history
- Manage vehicles

---

## 🏢 Merchants/Partners in System

1. **Premium Car Wash**
   - Email: premium@yuvgo.uz
   - Phone: +998901234567
   - Status: Approved

2. **Quick Clean Mobile**
   - Email: mobile@yuvgo.uz
   - Phone: +998901234568
   - Status: Approved

3. **Standard Auto Wash**
   - Email: standard@yuvgo.uz
   - Phone: +998901234569
   - Status: Approved

4. **Express Wash**
   - Email: express@yuvgo.uz
   - Phone: +998901234570
   - Status: Approved

---

## 💳 Subscription Plans Available

1. **Basic Monthly**
   - Price: 99,000 UZS
   - Duration: 30 days
   - Visits: 12 per month

2. **Premium Monthly**
   - Price: 199,000 UZS
   - Duration: 30 days
   - Visits: Unlimited

3. **Basic Quarterly**
   - Price: 279,000 UZS
   - Duration: 90 days
   - Visits: 36 per quarter

4. **Premium Quarterly**
   - Price: 549,000 UZS
   - Duration: 90 days
   - Visits: Unlimited

---

## 🧪 Testing Workflow

### 1. Test Admin Dashboard
```
1. Go to http://localhost:3000
2. Login with: admin@yuvgo.uz / admin123
3. View users, partners, analytics
```

### 2. Test Merchant Dashboard
```
1. Go to http://localhost:3001
2. Login with: +998901111111 / PIN: 1234
3. Scan QR codes, view visits
```

### 3. Test User App
```
1. Go to http://localhost:3003
2. Login with: +998901111111
3. Browse subscriptions, generate QR
```

---

## 🔧 API Testing

### Get Access Token (Admin)
```bash
curl -X POST http://localhost:8000/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@yuvgo.uz","password":"admin123"}'
```

### Get Users (with token)
```bash
TOKEN="your_access_token_here"
curl http://localhost:8000/api/user/users \
  -H "Authorization: Bearer $TOKEN"
```

### Get Subscription Plans (public)
```bash
curl http://localhost:8000/api/subscription/plans
```

### Get Partners (public)
```bash
curl http://localhost:8000/api/partner/partners
```

---

## 📊 Database Summary

- **Users**: 5 test users
- **Merchants**: 4 approved partners
- **Staff**: 4 merchant staff members
- **Subscription Plans**: 4 plans
- **Admins**: 1 super admin

---

## ✅ All Systems Ready!

Everything is set up and ready for testing:
- ✅ All services running
- ✅ Database populated with test data
- ✅ Admin account working
- ✅ Merchant accounts working
- ✅ User accounts created
- ✅ Subscription plans available
- ✅ All APIs responding

**Start testing now!** 🚀

---

## 🆘 Troubleshooting

### Can't login to Admin Dashboard?
- Make sure you're using: admin@yuvgo.uz / admin123
- Check browser console for errors
- Clear browser cache and try again

### Can't login to Merchant Dashboard?
- Use phone number format: +998901111111
- PIN is 4 digits: 1234
- Make sure service is running

### Can't login to User App?
- Just enter phone number: +998901111111
- No password required (simplified auth for demo)
- User will be auto-logged in if found

### API returns "Not authenticated"?
- Get access token first via login endpoint
- Add header: `Authorization: Bearer YOUR_TOKEN`
- Token expires after 30 minutes

---

**Last Updated**: All credentials verified and working
**Status**: ✅ Ready for full testing
