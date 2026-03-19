#!/bin/bash
# Fix Payment Service - Deploy to Production Server
# Server: 207.180.198.10

echo "🔧 Fixing Payment Service on Production Server..."

# SSH into production server and execute commands
ssh root@207.180.198.10 << 'ENDSSH'
cd /root/yougo-fastapi

echo "📦 Stopping current payment service..."
docker stop yuvgo_payment_service 2>/dev/null || true
docker rm yuvgo_payment_service 2>/dev/null || true

echo "🏗️ Rebuilding payment service with fixes..."
docker build -t yougo-fastapi_payment_service:latest -f backend/services/payment/Dockerfile ./backend

echo "🚀 Starting payment service with production credentials..."
docker run -d --name yuvgo_payment_service \
  --network yougo-fastapi_yuvgo_network \
  --network-alias payment_service \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='your-production-secret-key-change-this' \
  -e REDIS_URL='redis://redis:6379' \
  -e IPAKYULI_BASE_URL='https://ecom.ipakyulibank.uz' \
  -e 'IPAKYULI_ACCESS_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXNoYm94SWQiOiJlZmJlY2I5ZC02NzBlLTRlMTQtOGFmYi1jMzJmMjI0Y2ZiMDciLCJtZXJjaGFudElkIjoiMjM3NTBkYWEtODM1NS00MWIzLWJlOGYtZDllNzI3ODU0MzhmIiwiaWF0IjoxNzcxODQ0NDk4LCJleHAiOjE4MDM0MDIwOTh9.1re7ln4yC1iUaXXIhIUq_VXAUSTseryfTSE5yPLn8LI' \
  -e IPAKYULI_CASHBOX_ID='efbecb9d-670e-4e14-8afb-c32f224cfb07' \
  -e IPAKYULI_MERCHANT_ID='23750daa-8355-41b3-be8f-d9e72785438f' \
  -p 8005:8005 \
  yougo-fastapi_payment_service:latest

echo "⏳ Waiting for service to start..."
sleep 5

echo "✅ Checking payment service status..."
docker ps | grep yuvgo_payment_service

echo "📋 Payment service logs (last 20 lines):"
docker logs --tail 20 yuvgo_payment_service

echo ""
echo "✅ Payment service has been fixed and restarted!"
echo "🔗 Test endpoint: https://app.yuvgo.uz/api/payment/health"
ENDSSH

echo ""
echo "✅ Deployment complete!"
echo "📝 Changes made:"
echo "   1. Fixed SSL verification (verify=True)"
echo "   2. Updated to production IpakYuli credentials"
echo "   3. Restarted payment service with correct environment variables"
echo ""
echo "🧪 Test the payment system:"
echo "   curl https://app.yuvgo.uz/api/payment/health"
