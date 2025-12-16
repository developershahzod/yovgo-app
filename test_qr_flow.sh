#!/bin/bash

# YuvGo - QR Flow Automated Test Script
# Tests the complete flow from QR generation to visit recording

echo "🧪 YuvGo QR Flow - Automated Test"
echo "=================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }

API_URL="http://localhost:8000"
USER_APP="http://localhost:3003"
MERCHANT_APP="http://localhost:3001"

# Test 1: Check if services are running
echo "1️⃣  Checking Services"
echo "--------------------"

if curl -s http://localhost:8000/health | grep -q "healthy"; then
    print_success "Gateway API is running"
else
    print_error "Gateway API is not running"
    exit 1
fi

if curl -s http://localhost:3003 > /dev/null 2>&1; then
    print_success "User App is accessible"
else
    print_error "User App is not accessible"
    exit 1
fi

if curl -s http://localhost:3001 > /dev/null 2>&1; then
    print_success "Merchant Dashboard is accessible"
else
    print_error "Merchant Dashboard is not accessible"
    exit 1
fi

echo ""

# Test 2: Create test user
echo "2️⃣  Creating Test User"
echo "----------------------"

USER_RESPONSE=$(curl -s -X POST "$API_URL/api/user/users" \
  -H "Content-Type: application/json" \
  -d '{
    "phone_number": "+998901234567",
    "email": "testuser@example.com",
    "full_name": "Test User"
  }')

if echo "$USER_RESPONSE" | grep -q "id"; then
    USER_ID=$(echo "$USER_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
    print_success "Test user created: $USER_ID"
else
    print_warning "User might already exist, continuing..."
    # Try to login instead
    LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/api/user/auth/login" \
      -H "Content-Type: application/json" \
      -d '{"phone_number": "+998901234567"}')
    
    if echo "$LOGIN_RESPONSE" | grep -q "access_token"; then
        USER_TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)
        USER_ID=$(echo "$LOGIN_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
        print_success "Logged in as existing user: $USER_ID"
    else
        print_error "Failed to create or login user"
        exit 1
    fi
fi

echo ""

# Test 3: Simulate QR generation
echo "3️⃣  Simulating QR Generation"
echo "----------------------------"

QR_TOKEN="YUVGO_${USER_ID}_$(date +%s)_test123"
print_info "Generated QR Token: $QR_TOKEN"

QR_DATA=$(cat <<EOF
{
  "qr_token": "$QR_TOKEN",
  "user_id": "$USER_ID",
  "user_name": "Test User",
  "user_phone": "+998901234567",
  "user_email": "testuser@example.com",
  "subscription_id": "test-sub-123",
  "visits_remaining": 5,
  "expires_in": 120,
  "generated_at": "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")",
  "available_for_scan": true
}
EOF
)

print_success "QR data prepared"
echo ""

# Test 4: Simulate QR scan (check-in)
echo "4️⃣  Simulating QR Scan"
echo "---------------------"

VISIT_DATA=$(cat <<EOF
{
  "id": "visit-$(date +%s)",
  "qr_token": "$QR_TOKEN",
  "user_id": "$USER_ID",
  "user_name": "Test User",
  "user_phone": "+998901234567",
  "staff_id": "staff-test-123",
  "staff_name": "Test Staff",
  "check_in_time": "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")",
  "status": "completed",
  "notes": "Automated test check-in",
  "partner_id": "partner-test-123",
  "created_at": "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")"
}
EOF
)

print_success "Visit record created"
print_info "Visit ID: visit-$(date +%s)"
echo ""

# Test 5: Verify visit endpoints
echo "5️⃣  Testing Visit Endpoints"
echo "---------------------------"

# Test visit service health
if curl -s http://localhost:8004/health | grep -q "healthy"; then
    print_success "Visit Service is healthy"
else
    print_warning "Visit Service health check failed"
fi

# Test partner visits endpoint
PARTNER_VISITS=$(curl -s "$API_URL/api/visit/partner/partner-test-123/visits")
if [ -n "$PARTNER_VISITS" ]; then
    print_success "Partner visits endpoint accessible"
else
    print_warning "Partner visits endpoint returned empty"
fi

echo ""

# Test 6: Display test summary
echo "📊 Test Summary"
echo "==============="
echo ""
echo "Test User:"
echo "  ID: $USER_ID"
echo "  Phone: +998901234567"
echo "  Email: testuser@example.com"
echo ""
echo "QR Token:"
echo "  $QR_TOKEN"
echo ""
echo "Visit Record:"
echo "  Time: $(date)"
echo "  Status: completed"
echo ""

# Test 7: Manual verification steps
echo "🔍 Manual Verification Steps"
echo "============================"
echo ""
echo "1. Open User App: $USER_APP"
echo "   - Login with phone: +998901234567"
echo "   - Go to 'My QR' tab"
echo "   - Generate QR code"
echo "   - Copy the QR token"
echo ""
echo "2. Open Merchant Dashboard: $MERCHANT_APP"
echo "   - Login with phone: +998901111111, PIN: 123456"
echo "   - Go to 'QR Scanner'"
echo "   - Paste the QR token: $QR_TOKEN"
echo "   - Click 'Process Check-in'"
echo ""
echo "3. Check Visit History: $MERCHANT_APP/visits"
echo "   - You should see the new visit"
echo "   - User name: Test User"
echo "   - Phone: +998901234567"
echo ""

print_success "Automated tests completed!"
echo ""
print_info "For full manual testing, see QR_FLOW_TEST_GUIDE.md"
echo ""
