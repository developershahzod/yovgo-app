#!/bin/bash

# YuvGO Production Deployment Script
# Server: 207.180.198.10
# Domains: yuvgo.uz, admin.yuvgo.uz, merchant.yuvgo.uz, app.yuvgo.uz

set -e

SERVER_IP="207.180.198.10"
SERVER_USER="root"
DEPLOY_DIR="/opt/yuvgo"

echo "🚀 YuvGO Production Deployment"
echo "================================"

# Step 1: Build all images locally
echo "📦 Building Docker images..."
docker-compose -f docker-compose.prod.yml build

# Step 2: Save images to tar files
echo "💾 Saving Docker images..."
docker save yougo-fastapi-gateway > /tmp/gateway.tar
docker save yougo-fastapi-admin_dashboard > /tmp/admin_dashboard.tar
docker save yougo-fastapi-merchant_dashboard > /tmp/merchant_dashboard.tar
docker save yougo-fastapi-landing_page > /tmp/landing_page.tar

# Step 3: Copy files to server
echo "📤 Copying files to server..."
scp -r docker-compose.prod.yml $SERVER_USER@$SERVER_IP:$DEPLOY_DIR/
scp -r nginx/ $SERVER_USER@$SERVER_IP:$DEPLOY_DIR/
scp -r backend/init.sql $SERVER_USER@$SERVER_IP:$DEPLOY_DIR/backend/
scp /tmp/*.tar $SERVER_USER@$SERVER_IP:$DEPLOY_DIR/images/

# Step 4: Deploy on server
echo "🔧 Deploying on server..."
ssh $SERVER_USER@$SERVER_IP << 'EOF'
cd /opt/yuvgo

# Load Docker images
docker load < images/gateway.tar
docker load < images/admin_dashboard.tar
docker load < images/merchant_dashboard.tar
docker load < images/landing_page.tar

# Stop existing containers
docker-compose -f docker-compose.prod.yml down

# Start new containers
docker-compose -f docker-compose.prod.yml up -d

# Check status
docker-compose -f docker-compose.prod.yml ps

echo "✅ Deployment complete!"
EOF

echo ""
echo "🎉 Deployment finished!"
echo ""
echo "URLs:"
echo "  - Landing Page: https://yuvgo.uz"
echo "  - Admin Dashboard: https://admin.yuvgo.uz"
echo "  - Merchant Dashboard: https://merchant.yuvgo.uz"
echo "  - Flutter API: https://app.yuvgo.uz"
