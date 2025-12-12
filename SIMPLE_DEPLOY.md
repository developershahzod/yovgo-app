# ✅ Simple Render.com Deployment Guide

## 🎯 Manual Deployment (Easiest & Most Reliable)

Since the API script isn't working, follow these simple steps in the Render dashboard.

---

## Step 1: Create PostgreSQL Database (2 minutes)

1. Go to https://dashboard.render.com
2. Click **"New +"** → **"PostgreSQL"**
3. Fill in:
   - **Name**: `yuvgo-postgres`
   - **Database**: `yuvgo_db`
   - **User**: `yuvgo`
   - **Region**: Oregon (US West)
   - **PostgreSQL Version**: 16
   - **Plan**: Starter ($7/month)
4. Click **"Create Database"**
5. ⚠️ **IMPORTANT**: Once created, click on the database and copy the **"Internal Database URL"** (starts with `postgresql://`)

---

## Step 2: Create Redis (1 minute)

1. Click **"New +"** → **"Redis"**
2. Fill in:
   - **Name**: `yuvgo-redis`
   - **Region**: Oregon (US West)
   - **Plan**: Starter ($7/month)
   - **Maxmemory Policy**: allkeys-lru
3. Click **"Create Redis"**
4. ⚠️ **IMPORTANT**: Copy the **"Internal Redis URL"** (starts with `redis://`)

---

## Step 3: Initialize Database (5 minutes)

### Option A: Using Render Shell (Easiest)

1. Go to your `yuvgo-postgres` database
2. Click **"Shell"** tab at the top
3. Copy the entire contents of `backend/init.sql` file
4. Paste into the shell and press Enter
5. Wait for it to complete (you'll see "CREATE TABLE", "INSERT", etc.)

### Option B: Using Local psql

```bash
# Use the External Connection URL from Render
export DATABASE_URL="postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db"
psql $DATABASE_URL -f backend/init.sql
```

---

## Step 4: Create Web Services (30 minutes)

You need to create 8 web services. For each one:

### 🔹 Service 1: Gateway (API Gateway)

1. Click **"New +"** → **"Web Service"**
2. **Connect Repository**: `https://github.com/developershahzod/yovgo-app`
3. Fill in:
   - **Name**: `yuvgo-gateway`
   - **Region**: Oregon
   - **Branch**: `main`
   - **Root Directory**: (leave empty)
   - **Runtime**: Python 3
   - **Build Command**: `pip install -r backend/gateway/requirements.txt`
   - **Start Command**: `cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Plan**: Starter
4. **Environment Variables** (click "Add Environment Variable"):
   ```
   DATABASE_URL = <paste-internal-database-url>
   REDIS_URL = <paste-internal-redis-url>
   JWT_SECRET = super-secret-key-change-this-in-production-12345
   JWT_ALGORITHM = HS256
   ACCESS_TOKEN_EXPIRE_MINUTES = 30
   REFRESH_TOKEN_EXPIRE_DAYS = 7
   ENVIRONMENT = production
   ```
5. Click **"Create Web Service"**
6. ⚠️ **Save the service URL** (e.g., `https://yuvgo-gateway.onrender.com`)

---

### 🔹 Service 2: User Service

1. **New +** → **Web Service**
2. Same repo: `https://github.com/developershahzod/yovgo-app`
3. Settings:
   - **Name**: `yuvgo-user-service`
   - **Build Command**: `pip install -r backend/services/user/requirements.txt`
   - **Start Command**: `cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port $PORT`
4. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   JWT_SECRET = <same-as-gateway>
   SMS_PROVIDER_API_KEY = your-sms-api-key
   SMS_PROVIDER_URL = https://sms-provider.uz/api
   ```
5. Create and **save the URL**

---

### 🔹 Service 3: Partner Service

1. **New +** → **Web Service**
2. Settings:
   - **Name**: `yuvgo-partner-service`
   - **Build Command**: `pip install -r backend/services/partner/requirements.txt`
   - **Start Command**: `cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   JWT_SECRET = <same-as-gateway>
   QR_TOKEN_TTL_SECONDS = 120
   VISIT_COOLDOWN_HOURS = 4
   ```
4. Create and **save the URL**

---

### 🔹 Service 4: Subscription Service

1. **New +** → **Web Service**
2. Settings:
   - **Name**: `yuvgo-subscription-service`
   - **Build Command**: `pip install -r backend/services/subscription/requirements.txt`
   - **Start Command**: `cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   ```
4. Create and **save the URL**

---

### 🔹 Service 5: Payment Service

1. **New +** → **Web Service**
2. Settings:
   - **Name**: `yuvgo-payment-service`
   - **Build Command**: `pip install -r backend/services/payment/requirements.txt`
   - **Start Command**: `cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   PAYME_MERCHANT_ID = your-payme-merchant-id
   PAYME_SECRET_KEY = your-payme-secret-key
   CLICK_MERCHANT_ID = your-click-merchant-id
   CLICK_SECRET_KEY = your-click-secret-key
   ```
4. Create and **save the URL**

---

### 🔹 Service 6: Visit Service

1. **New +** → **Web Service**
2. Settings:
   - **Name**: `yuvgo-visit-service`
   - **Build Command**: `pip install -r backend/services/visit/requirements.txt`
   - **Start Command**: `cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   ```
4. Create and **save the URL**

---

### 🔹 Service 7: Notification Service

1. **New +** → **Web Service**
2. Settings:
   - **Name**: `yuvgo-notification-service`
   - **Build Command**: `pip install -r backend/services/notification/requirements.txt`
   - **Start Command**: `cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   FIREBASE_CREDENTIALS_PATH = ./firebase-credentials.json
   ```
4. Create and **save the URL**

---

### 🔹 Service 8: Admin Service

1. **New +** → **Web Service**
2. Settings:
   - **Name**: `yuvgo-admin-service`
   - **Build Command**: `pip install -r backend/services/admin/requirements.txt`
   - **Start Command**: `cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port $PORT`
3. **Environment Variables**:
   ```
   DATABASE_URL = <same-as-gateway>
   REDIS_URL = <same-as-gateway>
   JWT_SECRET = <same-as-gateway>
   ```
4. Create and **save the URL**

---

## Step 5: Update Gateway with Service URLs (5 minutes)

After all services are deployed:

1. Go to **yuvgo-gateway** service
2. Click **"Environment"** tab
3. Add these new variables (use your actual service URLs):
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
5. Gateway will automatically redeploy

---

## Step 6: Add Test Data (5 minutes)

Run the test data script:

```bash
# Use External Connection URL from Render
export DATABASE_URL="postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db"
bash init_render_db.sh
```

Or manually in Render Shell:
1. Go to database → Shell
2. Copy contents of `init_render_db.sh` SQL commands
3. Paste and execute

---

## ✅ Verification

Test your deployment:

```bash
# Check gateway health
curl https://yuvgo-gateway.onrender.com/health

# Test admin login
curl -X POST https://yuvgo-gateway.onrender.com/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@yuvgo.uz", "password": "Admin@123"}'
```

---

## 🔑 Test Credentials

### Admin Accounts
- Super Admin: `admin@yuvgo.uz` / `Admin@123`
- Support: `support@yuvgo.uz` / `Admin@123`
- Finance: `finance@yuvgo.uz` / `Admin@123`

### Merchant Staff
- Manager: `+998901234567` / PIN: `123456`
- Staff: `+998901234568` / PIN: `234567`

### Test Users
- User 1: `+998901111111` (Premium subscription)
- User 2: `+998902222222` (Basic subscription)
- User 3-5: `+998903333333` to `+998905555555`

### Test Merchants
- Premium Wash Center: `premium@yuvgo.uz`
- Quick Clean Mobile: `mobile@yuvgo.uz`
- Standard Auto Wash: `standard@yuvgo.uz`
- Express Wash: `express@yuvgo.uz`
- Luxury Car Care: `luxury@yuvgo.uz`

---

## 💰 Total Cost

- PostgreSQL: $7/month
- Redis: $7/month
- 8 Web Services: $56/month (8 × $7)
- **Total: ~$70/month**

---

## 🎉 You're Done!

Your YuvGo application is now live on Render.com with:
- ✅ Complete database schema
- ✅ 5 test merchants with locations
- ✅ 4 staff members
- ✅ 5 test users (2 with active subscriptions)
- ✅ Admin accounts
- ✅ All microservices running

**Gateway URL**: `https://yuvgo-gateway.onrender.com`

Start building your frontend apps!
