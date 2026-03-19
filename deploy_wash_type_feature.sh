#!/bin/bash
# Deploy Wash Type Selection Feature
# Server: 207.180.198.10
# Date: 2026-03-19

echo "🚀 Deploying Wash Type Selection Feature..."

# SSH into production server and execute commands
ssh root@207.180.198.10 << 'ENDSSH'
cd /root/yougo-fastapi

echo "📊 Step 1: Running database migration..."
docker exec -i yuvgo_postgres psql -U yuvgo -d yuvgo_db << 'EOSQL'
-- Add wash_type column to visits table
ALTER TABLE visits 
ADD COLUMN IF NOT EXISTS wash_type VARCHAR(20) DEFAULT 'sedan';

-- Add comment to the column
COMMENT ON COLUMN visits.wash_type IS 'Type of wash service: express, sedan, krossover, minivan, suv';

-- Create index for faster queries on wash_type
CREATE INDEX IF NOT EXISTS idx_visits_wash_type ON visits(wash_type);

-- Update existing records to have default wash_type
UPDATE visits 
SET wash_type = 'sedan' 
WHERE wash_type IS NULL;

-- Verify the migration
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'visits' AND column_name = 'wash_type';
EOSQL

echo "✅ Database migration completed!"

echo ""
echo "🛑 Step 2: Stopping gateway service..."
docker stop yuvgo_gateway 2>/dev/null || true
docker rm yuvgo_gateway 2>/dev/null || true

echo ""
echo "🏗️ Step 3: Rebuilding gateway with updated code..."
docker build -t yougo-fastapi_gateway:latest -f backend/gateway/Dockerfile ./backend

echo ""
echo "🚀 Step 4: Starting gateway with correct JWT_SECRET..."
docker run -d --name yuvgo_gateway \
  --network yougo-fastapi_yuvgo_network \
  --network-alias gateway \
  -v /root/yougo-fastapi/uploads:/app/uploads \
  -e DATABASE_URL='postgresql://yuvgo:yuvgo_secure_password_2024@postgres:5432/yuvgo_db' \
  -e JWT_SECRET='yuvgo_jwt_secret_production_2024_secure_key' \
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

echo ""
echo "⏳ Waiting for gateway to start..."
sleep 5

echo ""
echo "✅ Checking gateway status..."
docker ps | grep yuvgo_gateway

echo ""
echo "📋 Gateway logs (last 20 lines):"
docker logs --tail 20 yuvgo_gateway

echo ""
echo "🎉 Deployment Complete!"
echo ""
echo "📝 Changes deployed:"
echo "   ✅ Database: Added wash_type column to visits table"
echo "   ✅ Backend: Updated API to accept wash_type parameter"
echo "   ✅ Backend: Updated Visit model with wash_type field"
echo "   ✅ Gateway: Restarted with latest code"
echo ""
echo "📱 Flutter app changes (deploy separately):"
echo "   - New wash type selection screen"
echo "   - Updated QR scanner flow"
echo "   - Added localization strings (uz, ru, en)"
echo ""
echo "🧪 Test the feature:"
echo "   1. Scan QR code in mobile app"
echo "   2. Select wash type (Express, Sedan, Krossover, Minivan, SUV)"
echo "   3. Confirm selection"
echo "   4. Verify visit is recorded with wash_type"
ENDSSH

echo ""
echo "✅ Server deployment complete!"
echo ""
echo "📱 Next steps:"
echo "   1. Build and deploy Flutter app with new wash type selection feature"
echo "   2. Test QR scanning flow with wash type selection"
echo "   3. Verify wash_type is stored in database"
