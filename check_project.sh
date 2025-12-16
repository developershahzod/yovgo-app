#!/bin/bash

# YuvGo Project - Comprehensive Health Check Script
# This script performs detailed checks on all project components

set -e

echo "🔍 YuvGo Project - Comprehensive Health Check"
echo "=============================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

ERRORS=0
WARNINGS=0

# Check 1: API Gateway
echo "1️⃣  Checking Gateway API"
echo "------------------------"
if curl -s http://localhost:8000/health | grep -q "healthy"; then
    print_success "Gateway API is healthy"
    
    # Check API documentation
    if curl -s http://localhost:8000/docs | grep -q "YuvGo"; then
        print_success "API documentation is accessible"
    else
        print_warning "API documentation may not be fully loaded"
        ((WARNINGS++))
    fi
else
    print_error "Gateway API is not responding"
    ((ERRORS++))
fi
echo ""

# Check 2: Microservices
echo "2️⃣  Checking Microservices"
echo "--------------------------"

SERVICES=(
    "8001:User Service"
    "8002:Subscription Service"
    "8003:Partner Service"
    "8004:Visit Service"
    "8005:Payment Service"
    "8006:Notification Service"
    "8007:Admin Service"
)

for service in "${SERVICES[@]}"; do
    IFS=':' read -r port name <<< "$service"
    if curl -s http://localhost:$port/health | grep -q "healthy"; then
        print_success "$name (port $port) is healthy"
    else
        print_error "$name (port $port) is not responding"
        ((ERRORS++))
    fi
done
echo ""

# Check 3: Frontend Applications
echo "3️⃣  Checking Frontend Applications"
echo "-----------------------------------"

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    print_success "Admin Dashboard (port 3000) is accessible"
else
    print_error "Admin Dashboard is not accessible"
    ((ERRORS++))
fi

if curl -s http://localhost:3001 > /dev/null 2>&1; then
    print_success "Merchant Dashboard (port 3001) is accessible"
else
    print_error "Merchant Dashboard is not accessible"
    ((ERRORS++))
fi

if curl -s http://localhost:3003 > /dev/null 2>&1; then
    print_success "User App (port 3003) is accessible"
else
    print_error "User App is not accessible"
    ((ERRORS++))
fi
echo ""

# Check 4: Database
echo "4️⃣  Checking Database"
echo "---------------------"

if docker-compose exec -T postgres pg_isready -U yuvgo > /dev/null 2>&1; then
    print_success "PostgreSQL is ready"
    
    # Check database exists
    if docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -c "SELECT 1" > /dev/null 2>&1; then
        print_success "Database 'yuvgo_db' is accessible"
        
        # Check tables
        TABLE_COUNT=$(docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')
        if [ "$TABLE_COUNT" -gt 0 ]; then
            print_success "Database has $TABLE_COUNT tables"
        else
            print_warning "Database has no tables. Run init.sql to initialize."
            ((WARNINGS++))
        fi
    else
        print_error "Cannot access database 'yuvgo_db'"
        ((ERRORS++))
    fi
else
    print_error "PostgreSQL is not ready"
    ((ERRORS++))
fi
echo ""

# Check 5: Redis
echo "5️⃣  Checking Redis"
echo "------------------"

if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
    print_success "Redis is responding to PING"
    
    # Check Redis info
    REDIS_VERSION=$(docker-compose exec -T redis redis-cli INFO server | grep redis_version | cut -d: -f2 | tr -d '\r')
    print_success "Redis version: $REDIS_VERSION"
else
    print_error "Redis is not responding"
    ((ERRORS++))
fi
echo ""

# Check 6: Monitoring
echo "6️⃣  Checking Monitoring Services"
echo "---------------------------------"

if curl -s http://localhost:9090/-/healthy > /dev/null 2>&1; then
    print_success "Prometheus is healthy"
else
    print_warning "Prometheus is not accessible"
    ((WARNINGS++))
fi

if curl -s http://localhost:3002/api/health > /dev/null 2>&1; then
    print_success "Grafana is accessible"
else
    print_warning "Grafana is not accessible"
    ((WARNINGS++))
fi
echo ""

# Check 7: Container Status
echo "7️⃣  Checking Container Status"
echo "------------------------------"

EXPECTED_CONTAINERS=(
    "yuvgo_gateway"
    "yuvgo_user_service"
    "yuvgo_subscription_service"
    "yuvgo_partner_service"
    "yuvgo_visit_service"
    "yuvgo_payment_service"
    "yuvgo_notification_service"
    "yuvgo_admin_service"
    "yuvgo_admin_dashboard"
    "yuvgo_merchant_dashboard"
    "yuvgo_user_app"
    "yuvgo_postgres"
    "yuvgo_redis"
    "yuvgo_prometheus"
    "yuvgo_grafana"
)

for container in "${EXPECTED_CONTAINERS[@]}"; do
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        STATUS=$(docker inspect --format='{{.State.Status}}' "$container")
        if [ "$STATUS" = "running" ]; then
            print_success "Container $container is running"
        else
            print_error "Container $container exists but is $STATUS"
            ((ERRORS++))
        fi
    else
        print_error "Container $container not found"
        ((ERRORS++))
    fi
done
echo ""

# Check 8: Network Connectivity
echo "8️⃣  Checking Network Connectivity"
echo "----------------------------------"

if docker network ls | grep -q "yuvgo_network"; then
    print_success "Docker network 'yuvgo_network' exists"
    
    NETWORK_CONTAINERS=$(docker network inspect yuvgo_network -f '{{range .Containers}}{{.Name}} {{end}}' 2>/dev/null | wc -w)
    print_success "$NETWORK_CONTAINERS containers connected to network"
else
    print_error "Docker network 'yuvgo_network' not found"
    ((ERRORS++))
fi
echo ""

# Check 9: Volumes
echo "9️⃣  Checking Docker Volumes"
echo "---------------------------"

EXPECTED_VOLUMES=(
    "yougo-fastapi_postgres_data"
    "yougo-fastapi_redis_data"
    "yougo-fastapi_prometheus_data"
    "yougo-fastapi_grafana_data"
)

for volume in "${EXPECTED_VOLUMES[@]}"; do
    if docker volume ls | grep -q "$volume"; then
        print_success "Volume $volume exists"
    else
        print_warning "Volume $volume not found"
        ((WARNINGS++))
    fi
done
echo ""

# Check 10: API Endpoints Test
echo "🔟 Testing Key API Endpoints"
echo "-----------------------------"

# Test Gateway root
if curl -s http://localhost:8000/ | grep -q "YuvGo Gateway"; then
    print_success "Gateway root endpoint working"
else
    print_error "Gateway root endpoint not working"
    ((ERRORS++))
fi

# Test metrics endpoint
if curl -s http://localhost:8000/metrics | grep -q "gateway_requests_total"; then
    print_success "Prometheus metrics endpoint working"
else
    print_warning "Metrics endpoint not working properly"
    ((WARNINGS++))
fi
echo ""

# Check 11: Environment Configuration
echo "1️⃣1️⃣  Checking Environment Configuration"
echo "----------------------------------------"

if [ -f ".env" ]; then
    print_success ".env file exists"
    
    # Check critical variables
    if grep -q "JWT_SECRET=your-secret-key-change-in-production" .env; then
        print_warning "JWT_SECRET is still using default value - CHANGE IN PRODUCTION!"
        ((WARNINGS++))
    else
        print_success "JWT_SECRET has been customized"
    fi
    
    if grep -q "DATABASE_URL" .env; then
        print_success "DATABASE_URL is configured"
    else
        print_error "DATABASE_URL is missing"
        ((ERRORS++))
    fi
else
    print_error ".env file not found"
    ((ERRORS++))
fi
echo ""

# Check 12: Logs for Errors
echo "1️⃣2️⃣  Checking Recent Logs for Errors"
echo "--------------------------------------"

ERROR_COUNT=$(docker-compose logs --tail=100 2>&1 | grep -i "error" | wc -l)
if [ "$ERROR_COUNT" -eq 0 ]; then
    print_success "No errors found in recent logs"
else
    print_warning "Found $ERROR_COUNT error messages in recent logs"
    print_info "Run 'docker-compose logs -f' to view detailed logs"
    ((WARNINGS++))
fi
echo ""

# Summary
echo "📊 Health Check Summary"
echo "======================="
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    print_success "All checks passed! ✨"
    echo ""
    echo "🎉 Your YuvGo project is fully operational!"
elif [ $ERRORS -eq 0 ]; then
    print_warning "All critical checks passed with $WARNINGS warnings"
    echo ""
    echo "⚠️  Please review the warnings above"
else
    print_error "Found $ERRORS errors and $WARNINGS warnings"
    echo ""
    echo "❌ Please fix the errors above before using the system"
    exit 1
fi

echo ""
echo "📱 Quick Access Links:"
echo "  Admin Dashboard:    http://localhost:3000"
echo "  Merchant Dashboard: http://localhost:3001"
echo "  User App:           http://localhost:3003"
echo "  API Docs:           http://localhost:8000/docs"
echo ""
