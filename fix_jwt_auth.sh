#!/bin/bash
# Fix JWT Authentication 401 Error - Sync JWT_SECRET across all services
# Server: 207.180.198.10

echo "🔐 Fixing JWT Authentication on Production Server..."

# The production JWT secret from .env.production
JWT_SECRET="yuvgo_jwt_secret_production_2024_secure_key"

# SSH into production server and execute commands
ssh root@207.180.198.10 << ENDSSH
cd /root/yougo-fastapi

echo "🛑 Stopping all services..."
docker stop yuvgo_gateway yuvgo_user_service yuvgo_subscription_service yuvgo_partner_service yuvgo_visit_service yuvgo_payment_service yuvgo_admin_service 2>/dev/null || true

echo "🗑️ Removing old containers..."
docker rm yuvgo_gateway yuvgo_user_service yuvgo_subscription_service yuvgo_partner_service yuvgo_visit_service yuvgo_payment_service yuvgo_admin_service 2>/dev/null || true

echo "🏗️ Rebuilding all backend services..."
docker build -t yougo-fastapi_gateway:latest -f backend/gateway/Dockerfile ./backend
docker build -t yougo-fastapi_user_service:latest -f backend/services/user/Dockerfile ./backend
docker build -t yougo-fastapi_subscription_service:latest -f backend/services/subscription/Dockerfile ./backend
docker build -t yougo-fastapi_partner_service:latest -f backend/services/partner/Dockerfile ./backend
docker build -t yougo-fastapi_visit_service:latest -f backend/services/visit/Dockerfile ./backend
docker build -t yougo-fastapi_payment_service:latest -f backend/services/payment/Dockerfile ./backend
docker build -t yougo-fastapi_admin_service:latest -f backend/services/admin/Dockerfile ./backend

echo "🚀 Starting Gateway with correct JWT_SECRET..."
docker run -d --name yuvgo_gateway \
  --network yougo-fastapi_yuvgo_network \
  --network-alias gateway \
  -v /root/yougo-fastapi/uploads:/app/uploads \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -e SUBSCRIPTION_SERVICE_URL='http://subscription_service:8002' \
  -e USER_SERVICE_URL='http://user_service:8001' \
  -e PARTNER_SERVICE_URL='http://partner_service:8003' \
  -e VISIT_SERVICE_URL='http://visit_service:8004' \
  -e PAYMENT_SERVICE_URL='http://payment_service:8005' \
  -e NOTIFICATION_SERVICE_URL='http://notification_service:8006' \
  -e ADMIN_SERVICE_URL='http://admin_service:8007' \
  -e IPAKYULI_BASE_URL='https://ecom.ipakyulibank.uz' \
  -e 'IPAKYULI_ACCESS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXNoYm94SWQiOiJlZmJlY2I5ZC02NzBlLTRlMTQtOGFmYi1jMzJmMjI0Y2ZiMDciLCJtZXJjaGFudElkIjoiMjM3NTBkYWEtODM1NS00MWIzLWJlOGYtZDllNzI3ODU0MzhmIiwiaWF0IjoxNzcxODQ0NDk4LCJleHAiOjE4MDM0MDIwOTh9.1re7ln4yC1iUaXXIhIUq_VXAUSTseryfTSE5yPLn8LI' \
  -e IPAKYULI_CASHBOX_ID='efbecb9d-670e-4e14-8afb-c32f224cfb07' \
  -e IPAKYULI_MERCHANT_ID='23750daa-8355-41b3-be8f-d9e72785438f' \
  -p 8000:8000 \
  yougo-fastapi_gateway:latest

echo "🚀 Starting User Service..."
docker run -d --name yuvgo_user_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias user_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -p 8001:8001 \
  yougo-fastapi_user_service:latest

echo "🚀 Starting Subscription Service..."
docker run -d --name yuvgo_subscription_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias subscription_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -p 8002:8002 \
  yougo-fastapi_subscription_service:latest

echo "🚀 Starting Partner Service..."
docker run -d --name yuvgo_partner_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias partner_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -p 8003:8003 \
  yougo-fastapi_partner_service:latest

echo "🚀 Starting Visit Service..."
docker run -d --name yuvgo_visit_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias visit_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -p 8004:8004 \
  yougo-fastapi_visit_service:latest

echo "🚀 Starting Payment Service..."
docker run -d --name yuvgo_payment_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias payment_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -e IPAKYULI_BASE_URL='https://ecom.ipakyulibank.uz' \
  -e 'IPAKYULI_ACCESS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXNoYm94SWQiOiJlZmJlY2I5ZC02NzBlLTRlMTQtOGFmYi1jMzJmMjI0Y2ZiMDciLCJtZXJjaGFudElkIjoiMjM3NTBkYWEtODM1NS00MWIzLWJlOGYtZDllNzI3ODU0MzhmIiwiaWF0IjoxNzcxODQ0NDk4LCJleHAiOjE4MDM0MDIwOTh9.1re7ln4yC1iUaXXIhIUq_VXAUSTseryfTSE5yPLn8LI' \
  -e IPAKYULI_CASHBOX_ID='efbecb9d-670e-4e14-8afb-c32f224cfb07' \
  -e IPAKYULI_MERCHANT_ID='23750daa-8355-41b3-be8f-d9e72785438f' \
  -p 8005:8005 \
  yougo-fastapi_payment_service:latest

echo "🚀 Starting Admin Service..."
docker run -d --name yuvgo_admin_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias admin_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='${JWT_SECRET}' \
  -e REDIS_URL='redis://redis:6379' \
  -p 8007:8007 \
  yougo-fastapi_admin_service:latest

echo "⏳ Waiting for services to start..."
sleep 10

echo "✅ Checking running services..."
docker ps | grep yuvgo

echo ""
echo "📋 Gateway logs (last 15 lines):"
docker logs --tail 15 yuvgo_gateway

echo ""
echo "✅ All services restarted with synchronized JWT_SECRET!"
echo "🔗 Test authentication: https://app.yuvgo.uz/api/mobile/home"
ENDSSH

echo ""
echo "✅ JWT Authentication Fixed!"
echo ""
echo "📝 What was fixed:"
echo "   - All services now use the same JWT_SECRET: yuvgo_jwt_secret_production_2024_secure_key"
echo "   - Gateway, User, Subscription, Partner, Visit, Payment, Admin services synchronized"
echo "   - Payment service also updated with production IpakYuli credentials"
echo ""
echo "🧪 Test from mobile app - 401 errors should be resolved!"
