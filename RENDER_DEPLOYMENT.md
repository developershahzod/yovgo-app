# YuvGo Render.com Deployment Guide

This guide will help you deploy the complete YuvGo application to Render.com with database setup, admin accounts, test merchants, and test users.

## Prerequisites

- Render.com account
- GitHub repository with your code
- Render API token: `rnd_jDQRMm6OV26Eo1IJC8gRpSr1pp9I`

## Deployment Options

### Option 1: Automated Deployment (Recommended)

1. **Run the deployment script:**
```bash
python3 deploy_render.py
```

This will automatically:
- Create PostgreSQL database
- Create Redis instance
- Deploy all microservices
- Set up environment variables

### Option 2: Manual Deployment via Render Dashboard

Follow these steps to deploy manually through the Render dashboard.

## Step-by-Step Manual Deployment

### 1. Create PostgreSQL Database

1. Go to Render Dashboard → New → PostgreSQL
2. Configure:
   - **Name**: `yuvgo-postgres`
   - **Database**: `yuvgo_db`
   - **User**: `yuvgo`
   - **Region**: Oregon (US West)
   - **Plan**: Starter ($7/month)
3. Click "Create Database"
4. **Save the Internal Database URL** (you'll need this)

### 2. Create Redis Instance

1. Go to Render Dashboard → New → Redis
2. Configure:
   - **Name**: `yuvgo-redis`
   - **Region**: Oregon (US West)
   - **Plan**: Starter ($7/month)
   - **Maxmemory Policy**: allkeys-lru
3. Click "Create Redis"
4. **Save the Internal Redis URL**

### 3. Initialize Database Schema and Test Data

After the database is created, initialize it:

1. Go to your PostgreSQL database in Render dashboard
2. Click "Connect" → "External Connection"
3. Run the initialization script locally:

```bash
# Set the database URL (use External Connection URL from Render)
export DATABASE_URL="postgresql://yuvgo:PASSWORD@HOST:PORT/yuvgo_db"

# Install PostgreSQL client if needed
brew install postgresql  # macOS
# or
apt-get install postgresql-client  # Linux

# Run initialization script
psql $DATABASE_URL -f backend/init.sql

# Run test data script
bash init_render_db.sh
```

Or use Render's Shell:
1. Go to database → Shell tab
2. Copy contents of `backend/init.sql` and paste
3. Execute

### 4. Deploy Microservices

Deploy each service in this order:

#### A. Gateway Service

1. Go to Render Dashboard → New → Web Service
2. Connect your GitHub repository
3. Configure:
   - **Name**: `yuvgo-gateway`
   - **Region**: Oregon (US West)
   - **Branch**: main
   - **Root Directory**: (leave empty)
   - **Runtime**: Python 3
   - **Build Command**: `pip install -r backend/gateway/requirements.txt`
   - **Start Command**: `cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port $PORT`
   - **Plan**: Starter ($7/month)

4. Add Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
JWT_SECRET=<generate-random-secret>
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
REFRESH_TOKEN_EXPIRE_DAYS=7
ENVIRONMENT=production
```

5. Click "Create Web Service"

#### B. User Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-user-service`
   - **Build Command**: `pip install -r backend/services/user/requirements.txt`
   - **Start Command**: `cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
JWT_SECRET=<same-as-gateway>
SMS_PROVIDER_API_KEY=your-sms-api-key
SMS_PROVIDER_URL=https://sms-provider.uz/api
```

#### C. Partner Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-partner-service`
   - **Build Command**: `pip install -r backend/services/partner/requirements.txt`
   - **Start Command**: `cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
JWT_SECRET=<same-as-gateway>
QR_TOKEN_TTL_SECONDS=120
VISIT_COOLDOWN_HOURS=4
```

#### D. Subscription Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-subscription-service`
   - **Build Command**: `pip install -r backend/services/subscription/requirements.txt`
   - **Start Command**: `cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
```

#### E. Payment Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-payment-service`
   - **Build Command**: `pip install -r backend/services/payment/requirements.txt`
   - **Start Command**: `cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
PAYME_MERCHANT_ID=your-payme-merchant-id
PAYME_SECRET_KEY=your-payme-secret-key
CLICK_MERCHANT_ID=your-click-merchant-id
CLICK_SECRET_KEY=your-click-secret-key
```

#### F. Visit Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-visit-service`
   - **Build Command**: `pip install -r backend/services/visit/requirements.txt`
   - **Start Command**: `cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
```

#### G. Notification Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-notification-service`
   - **Build Command**: `pip install -r backend/services/notification/requirements.txt`
   - **Start Command**: `cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json
```

#### H. Admin Service

1. New → Web Service
2. Configure:
   - **Name**: `yuvgo-admin-service`
   - **Build Command**: `pip install -r backend/services/admin/requirements.txt`
   - **Start Command**: `cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. Environment Variables:
```
DATABASE_URL=<your-postgres-internal-url>
REDIS_URL=<your-redis-internal-url>
JWT_SECRET=<same-as-gateway>
```

### 5. Update Gateway Service URLs

After all services are deployed, update the Gateway service environment variables with the internal URLs of each service:

```
USER_SERVICE_URL=https://yuvgo-user-service.onrender.com
PARTNER_SERVICE_URL=https://yuvgo-partner-service.onrender.com
SUBSCRIPTION_SERVICE_URL=https://yuvgo-subscription-service.onrender.com
PAYMENT_SERVICE_URL=https://yuvgo-payment-service.onrender.com
VISIT_SERVICE_URL=https://yuvgo-visit-service.onrender.com
NOTIFICATION_SERVICE_URL=https://yuvgo-notification-service.onrender.com
ADMIN_SERVICE_URL=https://yuvgo-admin-service.onrender.com
```

## Test Data Included

After running the initialization script, you'll have:

### Admin Accounts
- **Super Admin**: admin@yuvgo.uz / Admin@123
- **Support**: support@yuvgo.uz / Admin@123
- **Finance**: finance@yuvgo.uz / Admin@123

### Test Merchants (Partners)
1. **Premium Wash Center**
   - Email: premium@yuvgo.uz
   - Phone: +998701111111
   - Status: Approved
   - Location: Amir Temur Street 15, Tashkent

2. **Quick Clean Mobile**
   - Email: mobile@yuvgo.uz
   - Phone: +998702222222
   - Status: Approved

3. **Standard Auto Wash**
   - Email: standard@yuvgo.uz
   - Phone: +998703333333
   - Status: Approved

4. **Express Wash Yunusabad**
   - Email: express@yuvgo.uz
   - Phone: +998704444444
   - Status: Approved

5. **Luxury Car Care**
   - Email: luxury@yuvgo.uz
   - Phone: +998705555555
   - Status: Approved

### Test Staff Members
- **Manager**: +998901234567 / PIN: 123456
- **Staff**: +998901234568 / PIN: 234567
- **Staff**: +998901234569 / PIN: 345678
- **Manager**: +998901234570 / PIN: 456789

### Test Users
- User 1: +998901111111 (with Premium subscription)
- User 2: +998902222222 (with Basic subscription)
- User 3: +998903333333
- User 4: +998904444444
- User 5: +998905555555

### Test Vehicles
- 01A123BC - Toyota Camry 2022 (User 1)
- 01B456DE - Chevrolet Malibu 2021 (User 2)
- 01C789FG - Hyundai Sonata 2023 (User 3)

### Subscription Plans
- Basic Monthly: 99,000 UZS (12 washes/month)
- Premium Monthly: 199,000 UZS (unlimited)
- Basic Quarterly: 279,000 UZS (36 washes)
- Premium Quarterly: 549,000 UZS (unlimited)

## Verification

After deployment, verify everything is working:

1. **Check Gateway Health**:
```bash
curl https://yuvgo-gateway.onrender.com/health
```

2. **Test Admin Login**:
```bash
curl -X POST https://yuvgo-gateway.onrender.com/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@yuvgo.uz", "password": "Admin@123"}'
```

3. **Check Database**:
   - Go to Render dashboard → PostgreSQL → Shell
   - Run: `SELECT COUNT(*) FROM users;`
   - Should show 5 users

## Troubleshooting

### Service won't start
- Check logs in Render dashboard
- Verify all environment variables are set
- Ensure DATABASE_URL and REDIS_URL are correct

### Database connection failed
- Use Internal Database URL (not External)
- Check if database is in the same region as services

### Services can't communicate
- Use internal URLs (*.onrender.com)
- Ensure all services are deployed in the same region

## Cost Estimate

- PostgreSQL Starter: $7/month
- Redis Starter: $7/month
- 8 Web Services × $7: $56/month
- **Total**: ~$70/month

## Security Notes

1. **Change default passwords** in production
2. **Update JWT_SECRET** to a strong random value
3. **Configure payment provider credentials**
4. **Set up proper SMS provider**
5. **Add Firebase credentials** for notifications
6. **Enable SSL** (Render provides this automatically)

## Next Steps

1. Set up custom domain
2. Configure CI/CD pipeline
3. Set up monitoring and alerts
4. Configure backup strategy
5. Set up staging environment

## Support

For issues or questions:
- Check Render documentation: https://render.com/docs
- Review service logs in Render dashboard
- Check database connectivity
