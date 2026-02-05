#!/bin/bash

# YuvGO Server Setup Script
# Run this on the production server (207.180.198.10)

set -e

echo "=========================================="
echo "  YuvGO Server Setup"
echo "=========================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Update system
echo -e "${GREEN}Updating system...${NC}"
apt-get update && apt-get upgrade -y

# Install Docker
echo -e "${GREEN}Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
fi

# Install Docker Compose
echo -e "${GREEN}Installing Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Create deployment directory
echo -e "${GREEN}Creating deployment directory...${NC}"
mkdir -p /opt/yuvgo
cd /opt/yuvgo

# Install Certbot for SSL
echo -e "${GREEN}Installing Certbot for SSL...${NC}"
apt-get install -y certbot

# Create SSL directory
mkdir -p /opt/yuvgo/nginx/ssl

echo -e "${GREEN}Server setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Upload your project files to /opt/yuvgo"
echo "2. Run: docker-compose -f docker-compose.prod.yml up -d --build"
echo "3. Set up SSL certificates with certbot"
echo ""
echo "To get SSL certificates:"
echo "  certbot certonly --standalone -d yuvgo.uz -d www.yuvgo.uz -d admin.yuvgo.uz -d merchant.yuvgo.uz -d app.yuvgo.uz"
