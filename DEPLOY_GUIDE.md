# YuvGO Production Deployment Guide

## Server Information
- **IP**: 207.180.198.10
- **Password**: Shaha2001.Shaha2001
- **Domain**: yuvgo.uz

## Subdomains Configuration

Add these DNS records in Cloudflare:

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | yuvgo.uz | 207.180.198.10 | Proxied |
| A | www | 207.180.198.10 | Proxied |
| A | admin | 207.180.198.10 | Proxied |
| A | merchant | 207.180.198.10 | Proxied |
| A | app | 207.180.198.10 | Proxied |
| A | api | 207.180.198.10 | Proxied |

## Deployment Steps

### 1. Connect to Server
```bash
ssh root@207.180.198.10
# Password: Shaha2001.Shaha2001
```

### 2. Install Docker (if not installed)
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

### 3. Create Project Directory
```bash
mkdir -p /opt/yuvgo
cd /opt/yuvgo
```

### 4. Upload Project Files
From your local machine:
```bash
# Create deployment archive
tar -czvf deploy.tar.gz \
    docker-compose.prod.yml \
    nginx/ \
    backend/ \
    frontend/ \
    landing-page/ \
    .env.production \
    --exclude='node_modules' \
    --exclude='__pycache__' \
    --exclude='.git' \
    --exclude='*.pyc' \
    --exclude='.DS_Store'

# Upload to server
scp deploy.tar.gz root@207.180.198.10:/opt/yuvgo/
```

### 5. Deploy on Server
```bash
ssh root@207.180.198.10
cd /opt/yuvgo
tar -xzvf deploy.tar.gz

# Rename production compose file
cp docker-compose.prod.yml docker-compose.yml

# Start all services
docker-compose up -d --build

# Check status
docker-compose ps
```

### 6. Verify Services
```bash
# Check all containers are running
docker-compose ps

# Check logs
docker-compose logs -f gateway
docker-compose logs -f nginx

# Test API
curl http://localhost:8000/health
```

## URLs After Deployment

| Service | URL |
|---------|-----|
| Landing Page | https://yuvgo.uz |
| Admin Dashboard | https://admin.yuvgo.uz |
| Merchant Dashboard | https://merchant.yuvgo.uz |
| Flutter App API | https://app.yuvgo.uz |
| API (alternative) | https://api.yuvgo.uz |

## SSL Certificates (Optional - Cloudflare handles this)

If not using Cloudflare proxy, install Certbot:
```bash
apt-get install -y certbot
certbot certonly --standalone -d yuvgo.uz -d www.yuvgo.uz -d admin.yuvgo.uz -d merchant.yuvgo.uz -d app.yuvgo.uz
```

## Troubleshooting

### Check container logs
```bash
docker-compose logs -f [service_name]
```

### Restart a service
```bash
docker-compose restart [service_name]
```

### Rebuild and restart
```bash
docker-compose up -d --build [service_name]
```

### Check database
```bash
docker-compose exec postgres psql -U yuvgo -d yuvgo_db
```

### Check Redis
```bash
docker-compose exec redis redis-cli ping
```

## Environment Variables

The `.env.production` file contains:
- `DB_PASSWORD` - Database password
- `JWT_SECRET` - JWT signing secret
- `IPAKYULI_ACCESS_TOKEN` - Payment gateway token
- `IPAKYULI_CASHBOX_ID` - Payment cashbox ID
- `IPAKYULI_MERCHANT_ID` - Payment merchant ID

## Flutter App Configuration

Update the Flutter app to use production API:
```dart
// lib/config/api_config.dart
const String baseUrl = 'https://app.yuvgo.uz';
```

## Monitoring

Check service health:
```bash
curl https://app.yuvgo.uz/health
```

View metrics:
```bash
curl https://app.yuvgo.uz/metrics
```
