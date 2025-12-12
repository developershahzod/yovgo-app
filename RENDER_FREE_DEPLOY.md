# 🆓 Deploy YuvGo to Render.com - FREE PLAN

## Complete Free Deployment Guide

### ⚠️ Important Notes About Free Plans

**Free Plan Limitations:**
- Web services spin down after 15 minutes of inactivity (cold starts ~30 seconds)
- PostgreSQL Free: 90 days trial, then requires paid plan
- Redis Free: Not available (we'll use alternative)
- 750 hours/month of runtime per service

**Recommended Approach for Free:**
1. Deploy only essential services
2. Use in-memory caching instead of Redis
3. Combine some services to reduce service count

---

## 📋 Step-by-Step Free Deployment

### Step 1: Push Code to GitHub

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi

# Initialize git if not already done
git init
git add .
git commit -m "Initial commit for Render deployment"

# Add your GitHub repository
git remote add origin https://github.com/developershahzod/yovgo-app.git
git branch -M main
git push -u origin main
```

### Step 2: Create PostgreSQL Database (FREE - 90 days)

1. Go to https://dashboard.render.com
2. Click **"New +"** → **"PostgreSQL"**
3. Settings:
   ```
   Name: yuvgo-db
   Database: yuvgo_db
   User: yuvgo
   Region: Oregon (US West)
   PostgreSQL Version: 16
   Plan: FREE (90 days)
   ```
4. Click **"Create Database"**
5. **SAVE** the **Internal Database URL** (starts with `postgresql://`)

### Step 3: Initialize Database

**Option A: Using Render Shell (Recommended)**

1. Go to your database in Render dashboard
2. Click **"Shell"** tab
3. Copy entire contents of `backend/init.sql`
4. Paste into shell and execute
5. Wait for completion

**Option B: Using Local psql**

```bash
# Get External Connection URL from Render
export DATABASE_URL="postgresql://yuvgo:DKm883iMc6BjTMNAHBca2CZb1a7RCx8L@dpg-d4u9cbggjchc73c4j2bg-a.virginia-postgres.render.com/yuvgo_db_ixmi"

# Run schema
psql $DATABASE_URL -f backend/init.sql

# Add test data
bash init_render_db.sh
```

### Step 4: Deploy Gateway Service (FREE)

1. Click **"New +"** → **"Web Service"**
2. Connect GitHub: `developershahzod/yovgo-app`
3. Configure:
   ```
   Name: yuvgo-gateway
   Region: Oregon (US West)
   Branch: main
   Root Directory: (leave empty)
   Runtime: Python 3
   Build Command: pip install -r backend/gateway/requirements.txt && pip install -r backend/shared/requirements.txt
   Start Command: cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port $PORT
   Plan: FREE
   ```

4. **Environment Variables**:
   ```
   DATABASE_URL = <your-internal-postgres-url>
   REDIS_URL = memory://localhost
   JWT_SECRET = your-super-secret-jwt-key-change-this-now-12345
   JWT_ALGORITHM = HS256
   ACCESS_TOKEN_EXPIRE_MINUTES = 30
   REFRESH_TOKEN_EXPIRE_DAYS = 7
   ENVIRONMENT = production
   PYTHONPATH = /opt/render/project/src/backend
   ```

5. Click **"Create Web Service"**
6. **SAVE the URL**: `https://yuvgo-gateway.onrender.com`

### Step 5: Deploy User Service (FREE)

1. **New +** → **Web Service**
2. Same repo: `developershahzod/yovgo-app`
3. Configure:
   ```
   Name: yuvgo-user-service
   Build Command: pip install -r backend/services/user/requirements.txt && pip install -r backend/shared/requirements.txt
   Start Command: cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port $PORT
   Plan: FREE
   ```

4. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = memory://localhost
   JWT_SECRET = <same-as-gateway>
   SMS_PROVIDER_API_KEY = test-key
   SMS_PROVIDER_URL = https://sms-provider.uz/api
   PYTHONPATH = /opt/render/project/src/backend
   ```

5. Create and **save URL**

### Step 6: Deploy Partner Service (FREE)

```
Name: yuvgo-partner-service
Build: pip install -r backend/services/partner/requirements.txt && pip install -r backend/shared/requirements.txt
Start: cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
JWT_SECRET = <same-as-gateway>
QR_TOKEN_TTL_SECONDS = 120
VISIT_COOLDOWN_HOURS = 4
PYTHONPATH = /opt/render/project/src/backend
```

### Step 7: Deploy Subscription Service (FREE)

```
Name: yuvgo-subscription-service
Build: pip install -r backend/services/subscription/requirements.txt && pip install -r backend/shared/requirements.txt
Start: cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
PYTHONPATH = /opt/render/project/src/backend
```

### Step 8: Deploy Payment Service (FREE)

```
Name: yuvgo-payment-service
Build: pip install -r backend/services/payment/requirements.txt && pip install -r backend/shared/requirements.txt
Start: cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
PAYME_MERCHANT_ID = test-merchant-id
PAYME_SECRET_KEY = test-secret-key
CLICK_MERCHANT_ID = test-merchant-id
CLICK_SECRET_KEY = test-secret-key
PYTHONPATH = /opt/render/project/src/backend
```

### Step 9: Deploy Visit Service (FREE)

```
Name: yuvgo-visit-service
Build: pip install -r backend/services/visit/requirements.txt && pip install -r backend/shared/requirements.txt
Start: cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
PYTHONPATH = /opt/render/project/src/backend
```

### Step 10: Deploy Notification Service (FREE)

```
Name: yuvgo-notification-service
Build: pip install -r backend/services/notification/requirements.txt && pip install -r backend/shared/requirements.txt
Start: cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
FIREBASE_CREDENTIALS_PATH = ./firebase-credentials.json
PYTHONPATH = /opt/render/project/src/backend
```

### Step 11: Deploy Admin Service (FREE)

```
Name: yuvgo-admin-service
Build: pip install -r backend/services/admin/requirements.txt && pip install -r backend/shared/requirements.txt
Start: cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
JWT_SECRET = <same-as-gateway>
PYTHONPATH = /opt/render/project/src/backend
```

### Step 12: Update Gateway with Service URLs

After ALL services are deployed, update Gateway environment variables:

1. Go to **yuvgo-gateway** service
2. Click **"Environment"** tab
3. Add these variables:

```
USER_SERVICE_URL = https://yuvgo-user-service.onrender.com
PARTNER_SERVICE_URL = https://yuvgo-partner-service.onrender.com
SUBSCRIPTION_SERVICE_URL = https://yuvgo-subscription-service.onrender.com
PAYMENT_SERVICE_URL = https://yuvgo-payment-service.onrender.com
VISIT_SERVICE_URL = https://yuvgo-visit-service.onrender.com
NOTIFICATION_SERVICE_URL = https://yuvgo-notification-service.onrender.com
ADMIN_SERVICE_URL = https://yuvgo-admin-service.onrender.com
```

4. Click **"Save Changes"**

---

## 🧪 Add Test Data

Once database is initialized, add test data:

```bash
# Use External Connection URL from Render
export DATABASE_URL="postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db"

# Run test data script
bash init_render_db.sh
```

Or manually in Render Shell - copy SQL from `init_render_db.sh`

---

## ✅ Verify Deployment

```bash
# Test gateway
curl https://yuvgo-gateway.onrender.com/health

# Test admin login
curl -X POST https://yuvgo-gateway.onrender.com/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@yuvgo.uz","password":"Admin@123"}'
```

---

## 🔑 Test Credentials

### Admin Accounts
- **Super Admin**: admin@yuvgo.uz / Admin@123
- **Support**: support@yuvgo.uz / Admin@123
- **Finance**: finance@yuvgo.uz / Admin@123

### Merchant Staff
- **Manager**: +998901234567 / PIN: 123456
- **Staff**: +998901234568 / PIN: 234567
- **Staff**: +998901234569 / PIN: 345678
- **Manager**: +998901234570 / PIN: 456789

### Test Users
- User 1: +998901111111 (Premium subscription)
- User 2: +998902222222 (Basic subscription)
- User 3-5: +998903333333 to +998905555555

### Test Merchants
- Premium Wash Center
- Quick Clean Mobile
- Standard Auto Wash
- Express Wash Yunusabad
- Luxury Car Care

---

## 💰 Cost: $0/month (FREE)

- PostgreSQL: FREE for 90 days
- 8 Web Services: FREE (with cold starts)
- **Total: $0/month**

---

## ⚠️ Free Plan Considerations

### Cold Starts
- Services sleep after 15 minutes of inactivity
- First request after sleep takes ~30 seconds
- Subsequent requests are fast

### Solutions:
1. **Keep services warm**: Use a cron job to ping services every 14 minutes
2. **Upgrade later**: Move to paid plans ($7/service) when needed
3. **Combine services**: Merge some microservices to reduce count

### Database Limitation
- After 90 days, PostgreSQL requires paid plan ($7/month)
- Export data before expiry or upgrade

---

## 🎯 Deployment Checklist

- [ ] Push code to GitHub
- [ ] Create PostgreSQL database (FREE)
- [ ] Initialize database schema
- [ ] Deploy Gateway service
- [ ] Deploy User service
- [ ] Deploy Partner service
- [ ] Deploy Subscription service
- [ ] Deploy Payment service
- [ ] Deploy Visit service
- [ ] Deploy Notification service
- [ ] Deploy Admin service
- [ ] Update Gateway with service URLs
- [ ] Add test data
- [ ] Test all endpoints
- [ ] Share URLs with team

---

## 🚀 Your Deployed URLs

After deployment, you'll have:

- **API Gateway**: https://yuvgo-gateway.onrender.com
- **Admin API**: https://yuvgo-admin-service.onrender.com
- **User API**: https://yuvgo-user-service.onrender.com
- **Partner API**: https://yuvgo-partner-service.onrender.com

---

## 📝 Next Steps

1. **Deploy Frontend Apps** (separate guide)
2. **Set up monitoring** (use Render's built-in logs)
3. **Configure custom domain** (optional)
4. **Set up CI/CD** (auto-deploy on git push)

---

## 🆘 Troubleshooting

### Service won't start
- Check logs in Render dashboard
- Verify all environment variables are set
- Ensure `PYTHONPATH` is set correctly

### Module not found errors
- Add `PYTHONPATH=/opt/render/project/src/backend` to environment
- Verify build command installs both service and shared requirements

### Database connection failed
- Use **Internal Database URL** (not External)
- Check if database is in same region as services

### Cold start too slow
- Upgrade to paid plan ($7/month per service)
- Or use cron job to keep services warm

---

## 🎉 Success!

Once all services are deployed and test data is added, your YuvGo application will be live and accessible from anywhere!

**Main API**: https://yuvgo-gateway.onrender.com

Start testing with the provided credentials! 🚀
