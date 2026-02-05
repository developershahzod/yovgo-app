#!/bin/bash

# YuvGO Production Deployment Script
# Server: 207.180.198.10
# Domain: yuvgo.uz

set -e

echo "=========================================="
echo "  YuvGO Production Deployment"
echo "=========================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
SERVER_IP="207.180.198.10"
SERVER_USER="root"
DEPLOY_DIR="/opt/yuvgo"

# Check if running locally or on server
if [ "$1" == "local" ]; then
    echo -e "${YELLOW}Running local build...${NC}"
    
    # Build all images
    echo -e "${GREEN}Building Docker images...${NC}"
    docker-compose -f docker-compose.prod.yml build
    
    echo -e "${GREEN}Local build complete!${NC}"
    echo "To deploy to server, run: ./deploy.sh server"
    exit 0
fi

if [ "$1" == "server" ]; then
    echo -e "${YELLOW}Deploying to server ${SERVER_IP}...${NC}"
    
    # Create deployment package
    echo -e "${GREEN}Creating deployment package...${NC}"
    
    # Files to deploy
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
    
    echo -e "${GREEN}Uploading to server...${NC}"
    scp deploy.tar.gz ${SERVER_USER}@${SERVER_IP}:${DEPLOY_DIR}/
    
    echo -e "${GREEN}Deploying on server...${NC}"
    ssh ${SERVER_USER}@${SERVER_IP} << 'ENDSSH'
        cd /opt/yuvgo
        tar -xzvf deploy.tar.gz
        docker-compose -f docker-compose.prod.yml down
        docker-compose -f docker-compose.prod.yml up -d --build
        docker-compose -f docker-compose.prod.yml ps
ENDSSH
    
    rm deploy.tar.gz
    echo -e "${GREEN}Deployment complete!${NC}"
    exit 0
fi

# Default: Show help
echo "Usage: ./deploy.sh [command]"
echo ""
echo "Commands:"
echo "  local   - Build Docker images locally"
echo "  server  - Deploy to production server"
echo ""
echo "Before deploying, create .env.production with:"
echo "  DB_PASSWORD=your_secure_password"
echo "  JWT_SECRET=your_jwt_secret"
echo "  IPAKYULI_ACCESS_TOKEN=your_token"
echo "  IPAKYULI_CASHBOX_ID=your_cashbox_id"
echo "  IPAKYULI_MERCHANT_ID=your_merchant_id"
