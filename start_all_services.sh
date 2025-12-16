#!/bin/bash

echo "🚀 Starting All YuvGo Services..."
echo "=================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Kill existing processes
echo -e "${BLUE}Stopping existing processes...${NC}"
lsof -ti:8000 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 8000" || echo "Port 8000 is free"
lsof -ti:8001 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 8001" || echo "Port 8001 is free"
lsof -ti:8002 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 8002" || echo "Port 8002 is free"
lsof -ti:8003 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 8003" || echo "Port 8003 is free"
lsof -ti:3000 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 3000" || echo "Port 3000 is free"
lsof -ti:3001 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 3001" || echo "Port 3001 is free"
lsof -ti:3003 | xargs kill -9 2>/dev/null && echo "✓ Killed process on port 3003" || echo "Port 3003 is free"

echo ""
echo -e "${BLUE}Starting Backend Services...${NC}"

# Start User Service
echo "Starting User Service (port 8000)..."
cd backend/services/user
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -q -r requirements.txt
nohup uvicorn main:app --host 0.0.0.0 --port 8000 --reload > ../../../logs/user-service.log 2>&1 &
echo -e "${GREEN}✓ User Service started${NC}"
cd ../../..

# Start Admin Service
echo "Starting Admin Service (port 8001)..."
cd backend/services/admin
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -q -r requirements.txt
nohup uvicorn main:app --host 0.0.0.0 --port 8001 --reload > ../../../logs/admin-service.log 2>&1 &
echo -e "${GREEN}✓ Admin Service started${NC}"
cd ../../..

# Start Subscription Service
echo "Starting Subscription Service (port 8002)..."
cd backend/services/subscription
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -q -r requirements.txt
nohup uvicorn main:app --host 0.0.0.0 --port 8002 --reload > ../../../logs/subscription-service.log 2>&1 &
echo -e "${GREEN}✓ Subscription Service started${NC}"
cd ../../..

# Start Partner Service
echo "Starting Partner Service (port 8003)..."
cd backend/services/partner
source venv/bin/activate 2>/dev/null || python3 -m venv venv && source venv/bin/activate
pip install -q -r requirements.txt
nohup uvicorn main:app --host 0.0.0.0 --port 8003 --reload > ../../../logs/partner-service.log 2>&1 &
echo -e "${GREEN}✓ Partner Service started${NC}"
cd ../../..

echo ""
echo -e "${BLUE}Starting Frontend Services...${NC}"

# Start Admin Dashboard
echo "Starting Admin Dashboard (port 3000)..."
cd frontend/admin-dashboard
npm install --silent
nohup PORT=3000 npm start > ../../logs/admin-dashboard.log 2>&1 &
echo -e "${GREEN}✓ Admin Dashboard started${NC}"
cd ../..

# Start Merchant Dashboard
echo "Starting Merchant Dashboard (port 3001)..."
cd frontend/merchant-dashboard
npm install --silent
nohup PORT=3001 npm start > ../../logs/merchant-dashboard.log 2>&1 &
echo -e "${GREEN}✓ Merchant Dashboard started${NC}"
cd ../..

# Start User App
echo "Starting User App (port 3003)..."
cd frontend/user-app
npm install --silent
nohup PORT=3003 npm start > ../../logs/user-app.log 2>&1 &
echo -e "${GREEN}✓ User App started${NC}"
cd ../..

echo ""
echo -e "${GREEN}=================================="
echo "✅ All Services Started!"
echo "==================================${NC}"
echo ""
echo "📱 Applications:"
echo "  Admin Dashboard:    http://localhost:3000"
echo "  Merchant Dashboard: http://localhost:3001"
echo "  User App:           http://localhost:3003"
echo ""
echo "🔧 Backend Services:"
echo "  User Service:         http://localhost:8000"
echo "  Admin Service:        http://localhost:8001"
echo "  Subscription Service: http://localhost:8002"
echo "  Partner Service:      http://localhost:8003"
echo ""
echo "📋 Logs:"
echo "  tail -f logs/*.log"
echo ""
echo "🛑 To stop all services:"
echo "  ./stop_all_services.sh"
echo ""
