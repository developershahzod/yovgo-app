#!/bin/bash
# Quick test script for YuvGo APIs

echo "🧪 Testing YuvGo APIs..."
echo "================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test Gateway Health
echo -e "\n${YELLOW}1. Testing Gateway Health...${NC}"
HEALTH=$(curl -s http://localhost:8000/health)
if echo "$HEALTH" | grep -q "healthy"; then
    echo -e "${GREEN}✅ Gateway is healthy${NC}"
else
    echo -e "${RED}❌ Gateway is not responding${NC}"
    exit 1
fi

# Test Subscription Plans
echo -e "\n${YELLOW}2. Testing Subscription Plans API...${NC}"
PLANS=$(curl -s http://localhost:8000/api/subscription/plans)
if echo "$PLANS" | grep -q "Basic Monthly\|Premium Monthly"; then
    echo -e "${GREEN}✅ Subscription plans API working${NC}"
    echo "Plans found: $(echo $PLANS | jq -r '.[].name' 2>/dev/null | tr '\n' ', ')"
else
    echo -e "${RED}❌ Subscription plans API failed${NC}"
    echo "Response: $PLANS"
fi

# Test Admin Login
echo -e "\n${YELLOW}3. Testing Admin Login...${NC}"
LOGIN=$(curl -s -X POST http://localhost:8000/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@yuvgo.uz","password":"Admin@123"}')
if echo "$LOGIN" | grep -q "access_token"; then
    echo -e "${GREEN}✅ Admin login working${NC}"
    TOKEN=$(echo $LOGIN | jq -r '.access_token' 2>/dev/null)
    echo "Token: ${TOKEN:0:50}..."
else
    echo -e "${RED}❌ Admin login failed${NC}"
    echo "Response: $LOGIN"
fi

# Test User Registration
echo -e "\n${YELLOW}4. Testing User Registration...${NC}"
REGISTER=$(curl -s -X POST http://localhost:8000/api/user/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"+998901234567","full_name":"Test User","email":"test@example.com"}')
if echo "$REGISTER" | grep -q "id\|phone_number\|already exists"; then
    echo -e "${GREEN}✅ User registration API working${NC}"
else
    echo -e "${RED}❌ User registration failed${NC}"
    echo "Response: $REGISTER"
fi

# Test Partner List
echo -e "\n${YELLOW}5. Testing Partner List API...${NC}"
PARTNERS=$(curl -s http://localhost:8000/api/partner/list)
if echo "$PARTNERS" | grep -q "\[\]"; then
    echo -e "${GREEN}✅ Partner list API working (empty list)${NC}"
elif echo "$PARTNERS" | grep -q "name"; then
    echo -e "${GREEN}✅ Partner list API working${NC}"
    echo "Partners found: $(echo $PARTNERS | jq -r '.[].name' 2>/dev/null | tr '\n' ', ')"
else
    echo -e "${YELLOW}⚠️  Partner list API response: $PARTNERS${NC}"
fi

# Summary
echo -e "\n================================"
echo -e "${GREEN}✅ API Testing Complete!${NC}"
echo -e "\n${YELLOW}Access Points:${NC}"
echo "  - API Gateway: http://localhost:8000"
echo "  - API Docs: http://localhost:8000/docs"
echo "  - Admin Dashboard: http://localhost:3000"
echo "  - Merchant Dashboard: http://localhost:3001"
echo "  - User App: http://localhost:3003"
echo ""
echo -e "${YELLOW}Test Credentials:${NC}"
echo "  - Admin: admin@yuvgo.uz / Admin@123"
echo "================================"
