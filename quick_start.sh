#!/bin/bash

echo "🚀 Quick Start - YuvGo Project"
echo "=============================="

# Kill existing processes
echo "Stopping existing processes..."
lsof -ti:8000 | xargs kill -9 2>/dev/null
lsof -ti:8001 | xargs kill -9 2>/dev/null
lsof -ti:8002 | xargs kill -9 2>/dev/null
lsof -ti:8003 | xargs kill -9 2>/dev/null
lsof -ti:3000 | xargs kill -9 2>/dev/null
lsof -ti:3001 | xargs kill -9 2>/dev/null
lsof -ti:3003 | xargs kill -9 2>/dev/null

echo ""
echo "Starting Backend Services..."

# User Service
cd backend/services/user
source venv/bin/activate 2>/dev/null
nohup uvicorn main:app --host 0.0.0.0 --port 8000 --reload > ../../../logs/user-service.log 2>&1 &
echo "✓ User Service (8000)"
cd ../../..

# Admin Service
cd backend/services/admin
source venv/bin/activate 2>/dev/null
nohup uvicorn main:app --host 0.0.0.0 --port 8001 --reload > ../../../logs/admin-service.log 2>&1 &
echo "✓ Admin Service (8001)"
cd ../../..

# Subscription Service
cd backend/services/subscription
source venv/bin/activate 2>/dev/null
nohup uvicorn main:app --host 0.0.0.0 --port 8002 --reload > ../../../logs/subscription-service.log 2>&1 &
echo "✓ Subscription Service (8002)"
cd ../../..

# Partner Service
cd backend/services/partner
source venv/bin/activate 2>/dev/null
nohup uvicorn main:app --host 0.0.0.0 --port 8003 --reload > ../../../logs/partner-service.log 2>&1 &
echo "✓ Partner Service (8003)"
cd ../../..

echo ""
echo "Starting Frontend Services..."

# Admin Dashboard
cd frontend/admin-dashboard
nohup PORT=3000 npm start > ../../logs/admin-dashboard.log 2>&1 &
echo "✓ Admin Dashboard (3000)"
cd ../..

# Merchant Dashboard
cd frontend/merchant-dashboard
nohup PORT=3001 npm start > ../../logs/merchant-dashboard.log 2>&1 &
echo "✓ Merchant Dashboard (3001)"
cd ../..

# User App
cd frontend/user-app
nohup PORT=3003 npm start > ../../logs/user-app.log 2>&1 &
echo "✓ User App (3003)"
cd ../..

echo ""
echo "✅ All Services Started!"
echo ""
echo "📱 Applications:"
echo "  Admin:    http://localhost:3000"
echo "  Merchant: http://localhost:3001"
echo "  User:     http://localhost:3003"
echo ""
echo "📋 View logs: tail -f logs/*.log"
echo "🛑 Stop all:  ./stop_all_services.sh"
echo ""
