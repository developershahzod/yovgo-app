#!/bin/bash

# YuvGo Quick Deploy to Render.com
# This script helps you deploy YuvGo to Render.com

echo "=================================================="
echo "🚀 YuvGo Render.com Quick Deploy"
echo "=================================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is not installed${NC}"
    exit 1
fi

# Check if requests library is installed
python3 -c "import requests" 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}📦 Installing required Python packages...${NC}"
    pip3 install requests
fi

echo ""
echo -e "${BLUE}This script will deploy YuvGo to Render.com${NC}"
echo ""
echo "What it will create:"
echo "  ✓ PostgreSQL database with schema"
echo "  ✓ Redis cache instance"
echo "  ✓ 8 microservices (Gateway + 7 services)"
echo "  ✓ Test data (users, merchants, staff)"
echo ""
echo -e "${YELLOW}Estimated cost: ~$70/month${NC}"
echo ""

read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Deployment cancelled"
    exit 0
fi

echo ""
echo -e "${YELLOW}Step 1: Running automated deployment...${NC}"
python3 deploy_render.py

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Deployment initiated successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Go to https://dashboard.render.com to monitor deployment"
    echo "2. Wait for all services to build (5-10 minutes)"
    echo "3. Once database is ready, initialize it:"
    echo ""
    echo -e "${BLUE}   # Get the database URL from Render dashboard${NC}"
    echo -e "${BLUE}   export DATABASE_URL='your-database-url'${NC}"
    echo -e "${BLUE}   bash init_render_db.sh${NC}"
    echo ""
    echo "4. Update Gateway service with other service URLs"
    echo "5. Test the deployment"
    echo ""
    echo -e "${GREEN}📋 Test Credentials (after DB init):${NC}"
    echo "   Admin: admin@yuvgo.uz / Admin@123"
    echo "   Staff: +998901234567 / PIN: 123456"
    echo "   User: +998901111111"
    echo ""
else
    echo ""
    echo -e "${RED}❌ Deployment failed${NC}"
    echo ""
    echo "Please check the error messages above."
    echo "You can also deploy manually using the Render dashboard."
    echo "See RENDER_DEPLOYMENT.md for detailed instructions."
    exit 1
fi

echo "=================================================="
