#!/bin/bash

# Simple Render.com Deployment Script
# This script uses curl instead of Python to deploy to Render

echo "=================================================="
echo "🚀 YuvGo Render.com Deployment"
echo "=================================================="

# Configuration
RENDER_API_KEY="rnd_jDQRMm6OV26Eo1IJC8gRpSr1pp9I"
RENDER_API_BASE="https://api.render.com/v1"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}This will deploy YuvGo to Render.com${NC}"
echo ""
echo "What will be created:"
echo "  ✓ PostgreSQL database"
echo "  ✓ Redis instance"
echo "  ✓ 8 microservices"
echo ""
echo -e "${YELLOW}Note: You'll need to configure services manually in Render dashboard${NC}"
echo ""

read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled"
    exit 0
fi

# Step 1: Create PostgreSQL Database
echo ""
echo -e "${YELLOW}Step 1: Creating PostgreSQL database...${NC}"

DB_RESPONSE=$(curl -s -X POST "${RENDER_API_BASE}/postgres" \
  -H "Authorization: Bearer ${RENDER_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "yov-go",
    "databaseName": "yov_go_db",
    "databaseUser": "admin",
    "plan": "starter",
    "region": "oregon",
    "version": "16"
  }')

if echo "$DB_RESPONSE" | grep -q '"id"'; then
    echo -e "${GREEN}✅ Database created successfully${NC}"
    DB_ID=$(echo "$DB_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "Database ID: $DB_ID"
    
    # Extract connection string (if available in response)
    DB_URL=$(echo "$DB_RESPONSE" | grep -o '"connectionString":"[^"]*"' | cut -d'"' -f4)
    if [ ! -z "$DB_URL" ]; then
        echo -e "${BLUE}Database URL: $DB_URL${NC}"
    fi
else
    echo -e "${RED}❌ Failed to create database${NC}"
    echo "Response: $DB_RESPONSE"
    exit 1
fi

sleep 3

# Step 2: Create Redis
echo ""
echo -e "${YELLOW}Step 2: Creating Redis instance...${NC}"

REDIS_RESPONSE=$(curl -s -X POST "${RENDER_API_BASE}/redis" \
  -H "Authorization: Bearer ${RENDER_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "yuvgo-redis",
    "plan": "starter",
    "region": "oregon",
    "maxmemoryPolicy": "allkeys-lru"
  }')

if echo "$REDIS_RESPONSE" | grep -q '"id"'; then
    echo -e "${GREEN}✅ Redis created successfully${NC}"
    REDIS_ID=$(echo "$REDIS_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
    echo "Redis ID: $REDIS_ID"
else
    echo -e "${RED}❌ Failed to create Redis${NC}"
    echo "Response: $REDIS_RESPONSE"
    exit 1
fi

echo ""
echo "=================================================="
echo -e "${GREEN}✅ Infrastructure created!${NC}"
echo "=================================================="
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. Go to https://dashboard.render.com"
echo ""
echo "2. Find your PostgreSQL database and get the Internal Connection String"
echo ""
echo "3. Initialize the database:"
echo -e "   ${BLUE}export DATABASE_URL='<your-internal-db-url>'${NC}"
echo -e "   ${BLUE}bash init_render_db.sh${NC}"
echo ""
echo "4. Create web services manually in Render dashboard:"
echo ""
echo "   For each service, use these settings:"
echo "   - Repository: https://github.com/developershahzod/yovgo-app"
echo "   - Branch: main"
echo "   - Region: Oregon"
echo "   - Plan: Starter"
echo ""
echo "   Services to create:"
echo "   a) yuvgo-gateway"
echo "      Build: pip install -r backend/gateway/requirements.txt"
echo "      Start: cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   b) yuvgo-user-service"
echo "      Build: pip install -r backend/services/user/requirements.txt"
echo "      Start: cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   c) yuvgo-partner-service"
echo "      Build: pip install -r backend/services/partner/requirements.txt"
echo "      Start: cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   d) yuvgo-subscription-service"
echo "      Build: pip install -r backend/services/subscription/requirements.txt"
echo "      Start: cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   e) yuvgo-payment-service"
echo "      Build: pip install -r backend/services/payment/requirements.txt"
echo "      Start: cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   f) yuvgo-visit-service"
echo "      Build: pip install -r backend/services/visit/requirements.txt"
echo "      Start: cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   g) yuvgo-notification-service"
echo "      Build: pip install -r backend/services/notification/requirements.txt"
echo "      Start: cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "   h) yuvgo-admin-service"
echo "      Build: pip install -r backend/services/admin/requirements.txt"
echo "      Start: cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port \$PORT"
echo ""
echo "5. Add environment variables to each service (see RENDER_DEPLOYMENT.md)"
echo ""
echo "=================================================="
echo -e "${BLUE}📖 Full guide: RENDER_DEPLOYMENT.md${NC}"
echo "=================================================="
