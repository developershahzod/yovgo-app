#!/bin/bash

# YuvGo Project - Fix Common Issues Script
# This script fixes common problems that may occur

set -e

echo "🔧 YuvGo Project - Fix Common Issues"
echo "====================================="
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

# Issue 1: Port conflicts
echo "1️⃣  Checking for Port Conflicts"
echo "--------------------------------"

PORTS=(5433 6379 8000 8001 8002 8003 8004 8005 8006 8007 3000 3001 3003 9090 3002)

for port in "${PORTS[@]}"; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        print_warning "Port $port is in use"
        read -p "Kill process on port $port? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            lsof -ti:$port | xargs kill -9 2>/dev/null || true
            print_success "Killed process on port $port"
        fi
    else
        print_success "Port $port is available"
    fi
done
echo ""

# Issue 2: Orphaned containers
echo "2️⃣  Cleaning Up Orphaned Containers"
echo "------------------------------------"

print_info "Removing orphaned containers..."
docker-compose down --remove-orphans
print_success "Orphaned containers removed"
echo ""

# Issue 3: Dangling images
echo "3️⃣  Cleaning Up Dangling Images"
echo "--------------------------------"

DANGLING=$(docker images -f "dangling=true" -q | wc -l)
if [ "$DANGLING" -gt 0 ]; then
    print_warning "Found $DANGLING dangling images"
    read -p "Remove dangling images? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker image prune -f
        print_success "Dangling images removed"
    fi
else
    print_success "No dangling images found"
fi
echo ""

# Issue 4: Network issues
echo "4️⃣  Fixing Network Issues"
echo "--------------------------"

if docker network ls | grep -q "yuvgo_network"; then
    print_info "Recreating network..."
    docker network rm yuvgo_network 2>/dev/null || true
fi
docker network create yuvgo_network 2>/dev/null || true
print_success "Network configured"
echo ""

# Issue 5: Volume permissions
echo "5️⃣  Checking Volume Permissions"
echo "--------------------------------"

print_info "Checking Docker volumes..."
docker volume ls | grep yougo-fastapi || print_warning "No volumes found"
print_success "Volume check complete"
echo ""

# Issue 6: Environment file
echo "6️⃣  Checking Environment File"
echo "------------------------------"

if [ ! -f ".env" ]; then
    print_warning ".env file not found"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env from .env.example"
    else
        print_error ".env.example not found"
    fi
else
    print_success ".env file exists"
fi
echo ""

# Issue 7: Database initialization
echo "7️⃣  Checking Database Initialization"
echo "--------------------------------------"

read -p "Reinitialize database? This will delete all data! (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Stopping containers..."
    docker-compose down -v
    
    print_info "Starting database..."
    docker-compose up -d postgres
    
    print_info "Waiting for PostgreSQL to be ready..."
    sleep 10
    
    print_info "Initializing database..."
    docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -f /docker-entrypoint-initdb.d/init.sql 2>/dev/null || true
    
    print_success "Database reinitialized"
else
    print_info "Skipping database reinitialization"
fi
echo ""

# Issue 8: Rebuild containers
echo "8️⃣  Rebuild Containers"
echo "-----------------------"

read -p "Rebuild all containers? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Rebuilding containers..."
    docker-compose build --no-cache
    print_success "Containers rebuilt"
else
    print_info "Skipping container rebuild"
fi
echo ""

# Issue 9: Clear Redis cache
echo "9️⃣  Clear Redis Cache"
echo "----------------------"

if docker ps | grep -q yuvgo_redis; then
    read -p "Clear Redis cache? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        docker-compose exec -T redis redis-cli FLUSHALL
        print_success "Redis cache cleared"
    fi
else
    print_info "Redis container not running"
fi
echo ""

# Issue 10: Fix file permissions
echo "🔟 Fixing File Permissions"
echo "--------------------------"

print_info "Fixing script permissions..."
chmod +x *.sh 2>/dev/null || true
print_success "Script permissions fixed"
echo ""

# Issue 11: Docker system prune
echo "1️⃣1️⃣  Docker System Cleanup"
echo "---------------------------"

read -p "Run Docker system prune? This removes unused data. (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    docker system prune -f
    print_success "Docker system cleaned"
else
    print_info "Skipping system prune"
fi
echo ""

# Summary
echo "✅ Common Issues Fixed!"
echo "======================="
echo ""
print_success "You can now start the project with: ./start_project.sh"
echo ""
