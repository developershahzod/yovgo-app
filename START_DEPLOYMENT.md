# 🚀 START HERE - Deploy YuvGo to Render.com (FREE)

## Quick Start Guide - 30 Minutes Total

### ✅ Prerequisites
- [ ] GitHub account
- [ ] Render.com account (sign up at https://render.com)
- [ ] Code pushed to GitHub repository

---

## 📦 Step 1: Push to GitHub (5 minutes)

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi

# Initialize git (if not done)
git init

# Add all files
git add .

# Commit
git commit -m "Deploy to Render.com"

# Add your GitHub repository
git remote add origin https://github.com/developershahzod/yovgo-app.git

# Push
git branch -M main
git push -u origin main
```

**✅ Checkpoint**: Code is on GitHub at https://github.com/developershahzod/yovgo-app

---

## 🗄️ Step 2: Create Database (3 minutes)

1. Go to https://dashboard.render.com
2. Click **"New +"** → **"PostgreSQL"**
3. Fill in:
   - Name: `yuvgo-db`
   - Database: `yuvgo_db`
   - User: `yuvgo`
   - Region: **Oregon (US West)**
   - Plan: **FREE**
4. Click **"Create Database"**
5. Wait for database to be created (~2 minutes)
6. **COPY** the **Internal Database URL** - you'll need this for ALL services

**Example URL**: `postgresql://yuvgo:PASSWORD@dpg-xxxxx-a.oregon-postgres.render.com/yuvgo_db`

**✅ Checkpoint**: Database created, URL copied

---

## 📊 Step 3: Initialize Database (5 minutes)

### Option A: Using Render Shell (Easiest)

1. Click on your `yuvgo-db` database
2. Click **"Shell"** tab at the top
3. Open `backend/init.sql` in your editor
4. Copy ALL contents (Ctrl+A, Ctrl+C)
5. Paste into Render Shell
6. Press Enter and wait for completion
7. You should see "CREATE TABLE", "INSERT" messages

### Option B: Using Local Terminal

```bash
# Use the External Connection URL from Render
export DATABASE_URL="postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db"

# Run schema
psql $DATABASE_URL -f backend/init.sql
```

**✅ Checkpoint**: Database has tables and default data

---

## 🌐 Step 4: Deploy Services (15 minutes)

### Deploy Each Service Using This Template:

For **EACH** of the 8 services below:

1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repo: `developershahzod/yovgo-app`
3. Use the configuration below
4. Click **"Create Web Service"**
5. **SAVE the service URL** (you'll need it later)

---

### 🔹 Service 1: Gateway

```
Name: yuvgo-gateway
Region: Oregon
Branch: main
Build Command: pip install -r backend/gateway/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables** (click "Add Environment Variable"):
```
DATABASE_URL = <paste-your-internal-database-url>
REDIS_URL = memory://localhost
JWT_SECRET = my-super-secret-jwt-key-change-this-12345
JWT_ALGORITHM = HS256
ACCESS_TOKEN_EXPIRE_MINUTES = 30
REFRESH_TOKEN_EXPIRE_DAYS = 7
ENVIRONMENT = production
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-gateway.onrender.com

---

### 🔹 Service 2: User Service

```
Name: yuvgo-user-service
Build Command: pip install -r backend/services/user/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
JWT_SECRET = <same-as-gateway>
SMS_PROVIDER_API_KEY = test-key
SMS_PROVIDER_URL = https://sms-provider.uz/api
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-user-service.onrender.com

---

### 🔹 Service 3: Partner Service

```
Name: yuvgo-partner-service
Build Command: pip install -r backend/services/partner/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port $PORT
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

**Save URL**: https://yuvgo-partner-service.onrender.com

---

### 🔹 Service 4: Subscription Service

```
Name: yuvgo-subscription-service
Build Command: pip install -r backend/services/subscription/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-subscription-service.onrender.com

---

### 🔹 Service 5: Payment Service

```
Name: yuvgo-payment-service
Build Command: pip install -r backend/services/payment/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
PAYME_MERCHANT_ID = test-id
PAYME_SECRET_KEY = test-key
CLICK_MERCHANT_ID = test-id
CLICK_SECRET_KEY = test-key
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-payment-service.onrender.com

---

### 🔹 Service 6: Visit Service

```
Name: yuvgo-visit-service
Build Command: pip install -r backend/services/visit/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-visit-service.onrender.com

---

### 🔹 Service 7: Notification Service

```
Name: yuvgo-notification-service
Build Command: pip install -r backend/services/notification/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
FIREBASE_CREDENTIALS_PATH = ./firebase-credentials.json
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-notification-service.onrender.com

---

### 🔹 Service 8: Admin Service

```
Name: yuvgo-admin-service
Build Command: pip install -r backend/services/admin/requirements.txt && pip install -r backend/shared/requirements.txt
Start Command: cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port $PORT
Plan: FREE
```

**Environment Variables**:
```
DATABASE_URL = <same-as-gateway>
REDIS_URL = memory://localhost
JWT_SECRET = <same-as-gateway>
PYTHONPATH = /opt/render/project/src/backend
```

**Save URL**: https://yuvgo-admin-service.onrender.com

---

## 🔗 Step 5: Connect Services (2 minutes)

After ALL 8 services are deployed:

1. Go to **yuvgo-gateway** service
2. Click **"Environment"** tab
3. Click **"Add Environment Variable"**
4. Add these 7 new variables:

```
USER_SERVICE_URL = https://yuvgo-user-service.onrender.com
PARTNER_SERVICE_URL = https://yuvgo-partner-service.onrender.com
SUBSCRIPTION_SERVICE_URL = https://yuvgo-subscription-service.onrender.com
PAYMENT_SERVICE_URL = https://yuvgo-payment-service.onrender.com
VISIT_SERVICE_URL = https://yuvgo-visit-service.onrender.com
NOTIFICATION_SERVICE_URL = https://yuvgo-notification-service.onrender.com
ADMIN_SERVICE_URL = https://yuvgo-admin-service.onrender.com
```

5. Click **"Save Changes"**
6. Gateway will automatically redeploy

**✅ Checkpoint**: All services connected

---

## 🧪 Step 6: Add Test Data (5 minutes)

```bash
# Use External Connection URL from Render dashboard
export DATABASE_URL="postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db"

# Run test data script
bash init_render_db.sh
```

**✅ Checkpoint**: Test users, merchants, and staff created

---

## ✅ Step 7: Test Deployment (2 minutes)

```bash
# Test gateway health
curl https://yuvgo-gateway.onrender.com/health

# Expected: {"status":"healthy"}

# Test admin login
curl -X POST https://yuvgo-gateway.onrender.com/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@yuvgo.uz","password":"Admin@123"}'

# Expected: JSON with access_token
```

---

## 🎉 SUCCESS!

Your YuvGo application is now live on Render.com!

### 🌐 Your URLs:
- **API Gateway**: https://yuvgo-gateway.onrender.com
- **API Docs**: https://yuvgo-gateway.onrender.com/docs

### 🔑 Login Credentials:
- **Admin**: admin@yuvgo.uz / Admin@123
- **Staff**: +998901234567 / PIN: 123456
- **User**: +998901111111

### 📊 What You Have:
- ✅ 8 Backend Services (FREE)
- ✅ PostgreSQL Database (FREE for 90 days)
- ✅ 5 Test Users
- ✅ 5 Test Merchants
- ✅ 4 Staff Members
- ✅ Complete API Documentation

---

## 💡 Important Notes

### Cold Starts
- Free services sleep after 15 minutes
- First request takes ~30 seconds to wake up
- Subsequent requests are fast

### Database Expiry
- Free PostgreSQL expires after 90 days
- Export data or upgrade to paid plan ($7/month)

### Keep Services Warm (Optional)
Use a service like UptimeRobot to ping your services every 14 minutes

---

## 📱 Next Steps

1. **Deploy Frontend Apps** (Admin Dashboard, Merchant Dashboard, User App)
2. **Set up Custom Domain** (optional)
3. **Configure CI/CD** (auto-deploy on git push)
4. **Monitor Logs** in Render dashboard

---

## 🆘 Need Help?

- Check `RENDER_FREE_DEPLOY.md` for detailed guide
- View logs in Render dashboard
- Check service status in Render dashboard

---

## 🎊 Congratulations!

You've successfully deployed YuvGo to Render.com for FREE!

**Total Cost**: $0/month
**Total Time**: ~30 minutes
**Services Running**: 8 microservices + database

Start building your frontend and testing the APIs! 🚀
