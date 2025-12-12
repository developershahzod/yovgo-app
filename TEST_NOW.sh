#!/bin/bash

echo "🧪 YuvGo Quick Test"
echo "===================="
echo ""

# Check if services are running
if ! docker-compose ps | grep -q "Up"; then
    echo "⚠️  Services not running. Starting..."
    docker-compose up -d
    echo "⏳ Waiting 30 seconds for services..."
    sleep 30
fi

echo "✅ Services are running"
echo ""

# Setup test database
echo "📊 Setting up test database..."
./create_test_db.sh
echo ""

# Run API tests
echo "🔍 Running API tests..."
python3 test_api.py
echo ""

# Show access URLs
echo "===================="
echo "🌐 Access Your Dashboards:"
echo "===================="
echo "Admin:    http://localhost:3000"
echo "          Email: admin@yuvgo.uz"
echo "          Password: Admin@123"
echo ""
echo "Merchant: http://localhost:3001"
echo "          Phone: +998901234567"
echo "          PIN: 123456"
echo ""
echo "User App: http://localhost:3003"
echo "          Register or use test users"
echo ""
echo "API Docs: http://localhost:8000/docs"
echo "===================="
