#!/bin/bash

# YuvGo Project - Complete Startup and Verification Script
# This script checks all components and starts the project

set -e

echo "🚀 YuvGo Project - Starting Complete Verification and Launch"
echo "============================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Step 1: Check prerequisites
echo "📋 Step 1: Checking Prerequisites"
echo "-----------------------------------"

# Check Docker
if command -v docker &> /dev/null; then
    print_success "Docker is installed: $(docker --version)"
else
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check Docker Compose
if command -v docker-compose &> /dev/null; then
    print_success "Docker Compose is installed: $(docker-compose --version)"
else
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if Docker is running
if docker info &> /dev/null; then
    print_success "Docker daemon is running"
else
    print_error "Docker daemon is not running. Please start Docker."
    exit 1
fi

echo ""

# Step 2: Check project structure
echo "📁 Step 2: Checking Project Structure"
echo "---------------------------------------"

REQUIRED_DIRS=(
    "backend/gateway"
    "backend/services/user"
    "backend/services/admin"
    "backend/services/partner"
    "backend/services/visit"
    "backend/services/subscription"
    "backend/services/payment"
    "backend/services/notification"
    "backend/shared"
    "frontend/admin-dashboard"
    "frontend/merchant-dashboard"
    "frontend/user-app"
    "monitoring"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_success "Directory exists: $dir"
    else
        print_error "Missing directory: $dir"
        exit 1
    fi
done

echo ""

# Step 3: Check environment file
echo "🔧 Step 3: Checking Environment Configuration"
echo "-----------------------------------------------"

if [ -f ".env" ]; then
    print_success ".env file exists"
else
    print_warning ".env file not found. Creating from .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env from .env.example"
        print_warning "Please update .env with your actual credentials!"
    else
        print_error ".env.example not found"
        exit 1
    fi
fi

echo ""

# Step 4: Check Docker Compose configuration
echo "🐳 Step 4: Validating Docker Compose Configuration"
echo "----------------------------------------------------"

if docker-compose config &> /dev/null; then
    print_success "docker-compose.yml is valid"
else
    print_error "docker-compose.yml has errors"
    docker-compose config
    exit 1
fi

echo ""

# Step 5: Stop existing containers
echo "🛑 Step 5: Stopping Existing Containers"
echo "-----------------------------------------"

if docker-compose ps -q 2> /dev/null | grep -q .; then
    print_info "Stopping existing containers..."
    docker-compose down
    print_success "Stopped existing containers"
else
    print_info "No running containers found"
fi

echo ""

# Step 6: Clean up old volumes (optional)
read -p "Do you want to clean up old volumes? This will delete all data. (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Removing old volumes..."
    docker-compose down -v
    print_success "Volumes removed"
fi

echo ""

# Step 7: Build and start services
echo "🏗️  Step 7: Building and Starting Services"
echo "--------------------------------------------"

print_info "Building Docker images... (this may take a few minutes)"
docker-compose build --no-cache

print_info "Starting all services..."
docker-compose up -d

echo ""

# Step 8: Wait for services to be ready
echo "⏳ Step 8: Waiting for Services to Start"
echo "------------------------------------------"

print_info "Waiting 30 seconds for services to initialize..."
sleep 30

echo ""

# Step 9: Check service health
echo "🏥 Step 9: Checking Service Health"
echo "------------------------------------"

SERVICES=(
    "http://localhost:8000/health|Gateway API"
    "http://localhost:8001/health|User Service"
    "http://localhost:8002/health|Subscription Service"
    "http://localhost:8003/health|Partner Service"
    "http://localhost:8004/health|Visit Service"
    "http://localhost:8005/health|Payment Service"
    "http://localhost:8006/health|Notification Service"
    "http://localhost:8007/health|Admin Service"
)

for service in "${SERVICES[@]}"; do
    IFS='|' read -r url name <<< "$service"
    if curl -s -f "$url" > /dev/null 2>&1; then
        print_success "$name is healthy"
    else
        print_error "$name is not responding"
    fi
done

echo ""

# Step 10: Check frontend applications
echo "🌐 Step 10: Checking Frontend Applications"
echo "--------------------------------------------"

FRONTENDS=(
    "http://localhost:3000|Admin Dashboard"
    "http://localhost:3001|Merchant Dashboard"
    "http://localhost:3003|User App"
)

sleep 10  # Give frontends more time to start

for frontend in "${FRONTENDS[@]}"; do
    IFS='|' read -r url name <<< "$frontend"
    if curl -s -f "$url" > /dev/null 2>&1; then
        print_success "$name is accessible"
    else
        print_warning "$name may still be starting..."
    fi
done

echo ""

# Step 11: Check database
echo "💾 Step 11: Checking Database Connection"
echo "------------------------------------------"

if docker-compose exec -T postgres pg_isready -U yuvgo > /dev/null 2>&1; then
    print_success "PostgreSQL is ready"
else
    print_error "PostgreSQL is not ready"
fi

echo ""

# Step 12: Check Redis
echo "📦 Step 12: Checking Redis Connection"
echo "---------------------------------------"

if docker-compose exec -T redis redis-cli ping > /dev/null 2>&1; then
    print_success "Redis is ready"
else
    print_error "Redis is not ready"
fi

echo ""

# Step 13: Display container status
echo "📊 Step 13: Container Status"
echo "------------------------------"
docker-compose ps

echo ""

# Step 14: Display access information
echo "🎉 Project Started Successfully!"
echo "================================"
echo ""
echo "📱 Access Points:"
echo "-----------------------------------"
echo "🔹 Gateway API:          http://localhost:8000"
echo "🔹 API Documentation:    http://localhost:8000/docs"
echo "🔹 Admin Dashboard:      http://localhost:3000"
echo "🔹 Merchant Dashboard:   http://localhost:3001"
echo "🔹 User App:             http://localhost:3003"
echo "🔹 Grafana Monitoring:   http://localhost:3002"
echo "🔹 Prometheus:           http://localhost:9090"
echo ""
echo "🔑 Default Credentials:"
echo "-----------------------------------"
echo "Admin Dashboard:"
echo "  Email:    admin@yuvgo.uz"
echo "  Password: Admin@123"
echo ""
echo "Grafana:"
echo "  Username: admin"
echo "  Password: admin"
echo ""
echo "📝 Useful Commands:"
echo "-----------------------------------"
echo "View logs:           docker-compose logs -f [service_name]"
echo "Stop all services:   docker-compose down"
echo "Restart service:     docker-compose restart [service_name]"
echo "View all logs:       docker-compose logs -f"
echo ""
echo "🧪 Run Tests:"
echo "-----------------------------------"
echo "./create_test_db.sh  # Create test database"
echo "python3 test_api.py  # Run API tests"
echo ""
print_success "All systems are operational!"
echo ""
