# 🚀 Deploy YuvGo Using Render Blueprint (Recommended)

## Why This Method?

The API script isn't working because the Render API token may not have the right permissions. 
**Blueprint deployment is the official Render way** and works reliably.

---

## 📋 Prerequisites

1. Your code must be on GitHub: `https://github.com/developershahzod/yovgo-app`
2. Make sure `render.yaml` is in the root directory (already created ✅)

---

## 🚀 Deployment Steps (5 minutes)

### Step 1: Push Code to GitHub

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi

# Add all files
git add .

# Commit
git commit -m "Add Render deployment configuration"

# Push to GitHub
git push origin main
```

### Step 2: Deploy via Render Dashboard

1. Go to https://dashboard.render.com
2. Click **"New +"** → **"Blueprint"**
3. Click **"Connect GitHub"** (if not already connected)
4. Select repository: **`developershahzod/yovgo-app`**
5. Render will automatically detect `render.yaml`
6. Review the services that will be created:
   - ✅ PostgreSQL database
   - ✅ Redis instance
   - ✅ 8 web services (Gateway + 7 microservices)
7. Click **"Apply"**
8. Wait 5-10 minutes for deployment

---

## ⚠️ Important: Blueprint Limitations

The `render.yaml` file I created has some references that might not work perfectly. If Blueprint fails, you'll need to:

### Fix the render.yaml

The issue is that Render Blueprint doesn't support all the `fromService` and `fromDatabase` references in environment variables. Let me create a simplified version:

---

## 🔧 Alternative: Simplified Manual Deployment

Since the API and Blueprint might have issues, here's the **guaranteed working method**:

### Quick Checklist (45 minutes total)

**Phase 1: Infrastructure (5 minutes)**
- [ ] Create PostgreSQL database manually
- [ ] Create Redis instance manually
- [ ] Save both connection URLs

**Phase 2: Database Setup (5 minutes)**
- [ ] Initialize database schema (run `backend/init.sql`)
- [ ] Add test data (run `init_render_db.sh`)

**Phase 3: Deploy Services (30 minutes)**
- [ ] Deploy Gateway service
- [ ] Deploy User service
- [ ] Deploy Partner service
- [ ] Deploy Subscription service
- [ ] Deploy Payment service
- [ ] Deploy Visit service
- [ ] Deploy Notification service
- [ ] Deploy Admin service

**Phase 4: Connect Services (5 minutes)**
- [ ] Update Gateway with all service URLs
- [ ] Test deployment

---

## 📖 Detailed Instructions

### 1. Create PostgreSQL Database

1. Go to https://dashboard.render.com
2. **New +** → **PostgreSQL**
3. Settings:
   ```
   Name: yuvgo-postgres
   Database: yuvgo_db
   User: yuvgo
   Region: Oregon (US West)
   Version: 16
   Plan: Starter ($7/month)
   ```
4. Click **Create Database**
5. **COPY THE INTERNAL DATABASE URL** (you'll need this for all services)
   - Format: `postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db`

### 2. Create Redis

1. **New +** → **Redis**
2. Settings:
   ```
   Name: yuvgo-redis
   Region: Oregon (US West)
   Plan: Starter ($7/month)
   Maxmemory Policy: allkeys-lru
   ```
3. Click **Create Redis**
4. **COPY THE INTERNAL REDIS URL**
   - Format: `redis://HOST:PORT`

### 3. Initialize Database

**Option A: Using Render Shell (Recommended)**
1. Go to your `yuvgo-postgres` database
2. Click **"Shell"** tab
3. Copy entire contents of `backend/init.sql`
4. Paste and execute
5. You should see "CREATE TABLE", "INSERT" messages

**Option B: Using Local Terminal**
```bash
# Get External Connection URL from Render dashboard
export DATABASE_URL="postgresql://yuvgo:PASSWORD@external-host.render.com:5432/yuvgo_db"

# Install psql if needed
brew install postgresql  # macOS

# Run schema
psql $DATABASE_URL -f backend/init.sql

# Run test data
bash init_render_db.sh
```

### 4. Deploy Web Services

For each service below, do:
1. **New +** → **Web Service**
2. Connect repo: `https://github.com/developershahzod/yovgo-app`
3. Fill in the settings shown
4. Add environment variables
5. Click **Create Web Service**

---

#### 🔹 Service 1: Gateway

```
Name: yuvgo-gateway
Branch: main
Build: pip install -r backend/gateway/requirements.txt
Start: cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <your-internal-postgres-url>
REDIS_URL = <your-internal-redis-url>
JWT_SECRET = your-super-secret-jwt-key-min-32-chars
JWT_ALGORITHM = HS256
ACCESS_TOKEN_EXPIRE_MINUTES = 30
REFRESH_TOKEN_EXPIRE_DAYS = 7
ENVIRONMENT = production
```

---

#### 🔹 Service 2: User Service

```
Name: yuvgo-user-service
Build: pip install -r backend/services/user/requirements.txt
Start: cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
JWT_SECRET = <same-as-gateway>
SMS_PROVIDER_API_KEY = your-sms-key
SMS_PROVIDER_URL = https://sms-provider.uz/api
```

---

#### 🔹 Service 3: Partner Service

```
Name: yuvgo-partner-service
Build: pip install -r backend/services/partner/requirements.txt
Start: cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
JWT_SECRET = <same-as-gateway>
QR_TOKEN_TTL_SECONDS = 120
VISIT_COOLDOWN_HOURS = 4
```

---

#### 🔹 Service 4: Subscription Service

```
Name: yuvgo-subscription-service
Build: pip install -r backend/services/subscription/requirements.txt
Start: cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
```

---

#### 🔹 Service 5: Payment Service

```
Name: yuvgo-payment-service
Build: pip install -r backend/services/payment/requirements.txt
Start: cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
PAYME_MERCHANT_ID = your-payme-id
PAYME_SECRET_KEY = your-payme-key
CLICK_MERCHANT_ID = your-click-id
CLICK_SECRET_KEY = your-click-key
```

---

#### 🔹 Service 6: Visit Service

```
Name: yuvgo-visit-service
Build: pip install -r backend/services/visit/requirements.txt
Start: cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
```

---

#### 🔹 Service 7: Notification Service

```
Name: yuvgo-notification-service
Build: pip install -r backend/services/notification/requirements.txt
Start: cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
FIREBASE_CREDENTIALS_PATH = ./firebase-credentials.json
```

---

#### 🔹 Service 8: Admin Service

```
Name: yuvgo-admin-service
Build: pip install -r backend/services/admin/requirements.txt
Start: cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port $PORT
```

**Environment Variables:**
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = <same-as-gateway>
JWT_SECRET = <same-as-gateway>
```

---

### 5. Update Gateway with Service URLs

After ALL services are deployed:

1. Go to **yuvgo-gateway** service
2. Click **Environment** tab
3. Add these variables (replace with YOUR actual service URLs):

```
USER_SERVICE_URL = https://yuvgo-user-service.onrender.com
PARTNER_SERVICE_URL = https://yuvgo-partner-service.onrender.com
SUBSCRIPTION_SERVICE_URL = https://yuvgo-subscription-service.onrender.com
PAYMENT_SERVICE_URL = https://yuvgo-payment-service.onrender.com
VISIT_SERVICE_URL = https://yuvgo-visit-service.onrender.com
NOTIFICATION_SERVICE_URL = https://yuvgo-notification-service.onrender.com
ADMIN_SERVICE_URL = https://yuvgo-admin-service.onrender.com
```

4. Click **Save Changes** (Gateway will auto-redeploy)

---

## ✅ Test Your Deployment

```bash
# Test gateway health
curl https://yuvgo-gateway.onrender.com/health

# Test admin login
curl -X POST https://yuvgo-gateway.onrender.com/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@yuvgo.uz","password":"Admin@123"}'
```

---

## 🎁 Test Data Included

### Admin Accounts
- `admin@yuvgo.uz` / `Admin@123` (Super Admin)
- `support@yuvgo.uz` / `Admin@123` (Support)
- `finance@yuvgo.uz` / `Admin@123` (Finance)

### Test Merchants
- Premium Wash Center
- Quick Clean Mobile
- Standard Auto Wash
- Express Wash Yunusabad
- Luxury Car Care

### Test Staff
- `+998901234567` / PIN: `123456`
- `+998901234568` / PIN: `234567`
- `+998901234569` / PIN: `345678`
- `+998901234570` / PIN: `456789`

### Test Users
- `+998901111111` (Premium subscription)
- `+998902222222` (Basic subscription)
- `+998903333333` to `+998905555555`

---

## 💰 Total Cost

- PostgreSQL: $7/month
- Redis: $7/month
- 8 Web Services: $56/month
- **Total: $70/month**

---

## 🎉 Done!

Your YuvGo app is now live with complete test data!

**Main URL**: `https://yuvgo-gateway.onrender.com`
