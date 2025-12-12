# YuvGo Setup Guide

## Prerequisites

- Docker & Docker Compose installed
- Node.js 18+ (for local development)
- Python 3.11+ (for local development)
- Git

## Quick Start (Docker)

### 1. Clone and Setup Environment

```bash
cd /Users/shahzodakhmedov/Documents/apps/yougo-fastapi
cp .env.example .env
```

### 2. Configure Environment Variables

Edit `.env` file and update:

```bash
# Database
DATABASE_URL=postgresql://yuvgo:yuvgo_password@postgres:5432/yuvgo_db

# JWT Secret (CHANGE IN PRODUCTION!)
JWT_SECRET=your-super-secret-key-change-this-in-production

# Payment Providers
PAYME_MERCHANT_ID=your-payme-merchant-id
PAYME_SECRET_KEY=your-payme-secret-key
CLICK_MERCHANT_ID=your-click-merchant-id
CLICK_SECRET_KEY=your-click-secret-key
PAYNET_MERCHANT_ID=your-paynet-merchant-id
PAYNET_SECRET_KEY=your-paynet-secret-key

# Firebase (for push notifications)
FIREBASE_CREDENTIALS_PATH=./firebase-credentials.json

# SMS Provider
SMS_PROVIDER_API_KEY=your-sms-provider-api-key
SMS_PROVIDER_URL=https://sms-provider.uz/api
```

### 3. Start All Services

```bash
docker-compose up -d
```

This will start:
- PostgreSQL database
- Redis cache
- Gateway API (port 8000)
- All microservices (ports 8001-8007)
- Admin Dashboard (port 3000)
- Merchant Dashboard (port 3001)
- Prometheus (port 9090)
- Grafana (port 3002)

### 4. Check Service Status

```bash
docker-compose ps
```

All services should show as "Up" and healthy.

### 5. Access the Applications

- **Gateway API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Admin Dashboard**: http://localhost:3000
- **Merchant Dashboard**: http://localhost:3001
- **Grafana Monitoring**: http://localhost:3002 (admin/admin)
- **Prometheus**: http://localhost:9090

### 6. Default Admin Credentials

```
Email: admin@yuvgo.uz
Password: Admin@123
```

**⚠️ IMPORTANT: Change this password immediately in production!**

## Service Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Gateway API (8000)                      │
│              (Rate Limiting, Auth, Routing)                  │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼────────┐   ┌───────▼────────┐   ┌───────▼────────┐
│  User Service  │   │ Partner Service│   │ Admin Service  │
│    (8001)      │   │    (8003)      │   │    (8007)      │
└────────────────┘   └────────────────┘   └────────────────┘
        │                     │                     │
┌───────▼────────┐   ┌───────▼────────┐   ┌───────▼────────┐
│Subscription Svc│   │  Visit Service │   │ Payment Service│
│    (8002)      │   │    (8004)      │   │    (8005)      │
└────────────────┘   └────────────────┘   └────────────────┘
        │                     │                     │
        └─────────────────────┼─────────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │ Notification Service│
                    │      (8006)        │
                    └────────────────────┘
```

## Database Schema

The database is automatically initialized with:
- All required tables
- Indexes for performance
- Default subscription plans
- Admin roles
- Super admin account

## Development

### Backend Development

```bash
# Navigate to a service
cd backend/services/admin

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
pip install -r ../shared/requirements.txt

# Run service
uvicorn main:app --reload --port 8007
```

### Frontend Development

```bash
# Admin Dashboard
cd frontend/admin-dashboard
npm install
npm start

# Merchant Dashboard
cd frontend/merchant-dashboard
npm install
npm start
```

## API Testing

### 1. Admin Login

```bash
curl -X POST http://localhost:8000/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@yuvgo.uz",
    "password": "Admin@123"
  }'
```

### 2. Get Analytics (with token)

```bash
curl -X GET http://localhost:8000/api/admin/analytics/overview \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 3. List Subscription Plans

```bash
curl -X GET http://localhost:8000/api/subscription/plans
```

## Monitoring

### Prometheus Metrics

Access Prometheus at http://localhost:9090

Available metrics:
- `gateway_requests_total` - Total requests by endpoint
- `gateway_request_latency_seconds` - Request latency

### Grafana Dashboards

1. Access Grafana at http://localhost:3002
2. Login with admin/admin
3. Add Prometheus data source (http://prometheus:9090)
4. Import or create dashboards

## Troubleshooting

### Services Not Starting

```bash
# Check logs
docker-compose logs -f [service_name]

# Restart specific service
docker-compose restart [service_name]

# Rebuild service
docker-compose up -d --build [service_name]
```

### Database Connection Issues

```bash
# Check PostgreSQL is running
docker-compose ps postgres

# Connect to database
docker-compose exec postgres psql -U yuvgo -d yuvgo_db

# Check tables
\dt
```

### Redis Connection Issues

```bash
# Check Redis is running
docker-compose ps redis

# Test Redis connection
docker-compose exec redis redis-cli ping
```

### Frontend Build Issues

```bash
# Clear node_modules and reinstall
cd frontend/admin-dashboard
rm -rf node_modules package-lock.json
npm install
```

## Production Deployment

### Security Checklist

- [ ] Change JWT_SECRET to a strong random value
- [ ] Change default admin password
- [ ] Update CORS origins in all services
- [ ] Configure proper SSL/TLS certificates
- [ ] Set up firewall rules
- [ ] Enable database backups
- [ ] Configure proper logging
- [ ] Set up monitoring alerts
- [ ] Review and update rate limits
- [ ] Secure Redis with password
- [ ] Use environment-specific configurations

### Environment Variables for Production

```bash
ENVIRONMENT=production
DATABASE_URL=postgresql://user:pass@prod-db:5432/yuvgo_db
REDIS_URL=redis://:password@prod-redis:6379
JWT_SECRET=very-long-random-secret-key
```

### Scaling Services

```bash
# Scale specific service
docker-compose up -d --scale user_service=3

# Use load balancer (nginx/traefik) in front of services
```

## Backup and Restore

### Database Backup

```bash
# Backup
docker-compose exec postgres pg_dump -U yuvgo yuvgo_db > backup.sql

# Restore
docker-compose exec -T postgres psql -U yuvgo yuvgo_db < backup.sql
```

### Redis Backup

```bash
# Backup
docker-compose exec redis redis-cli SAVE
docker cp yuvgo_redis:/data/dump.rdb ./redis-backup.rdb

# Restore
docker cp ./redis-backup.rdb yuvgo_redis:/data/dump.rdb
docker-compose restart redis
```

## Support

For issues and questions:
- Email: support@yuvgo.uz
- Documentation: Check README.md
- API Docs: http://localhost:8000/docs

## License

Proprietary - All rights reserved
