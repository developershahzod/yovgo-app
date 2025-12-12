#!/bin/bash

# YuvGo Test Database Creation Script
# This script creates a test database and populates it with sample data

echo "=================================================="
echo "YuvGo Test Database Setup"
echo "=================================================="

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running${NC}"
    exit 1
fi

echo -e "${YELLOW}Step 1: Checking if services are running...${NC}"
if ! docker-compose ps | grep -q "Up"; then
    echo -e "${YELLOW}Starting services...${NC}"
    docker-compose up -d
    echo -e "${YELLOW}Waiting for services to be ready (30 seconds)...${NC}"
    sleep 30
else
    echo -e "${GREEN}✓ Services are already running${NC}"
fi

echo -e "\n${YELLOW}Step 2: Checking database connection...${NC}"
docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -c "SELECT 1;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database is accessible${NC}"
else
    echo -e "${RED}✗ Cannot connect to database${NC}"
    exit 1
fi

echo -e "\n${YELLOW}Step 3: Verifying database schema...${NC}"
TABLES=$(docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
echo -e "${GREEN}✓ Found $TABLES tables in database${NC}"

echo -e "\n${YELLOW}Step 4: Checking default data...${NC}"

# Check subscription plans
PLANS=$(docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -t -c "SELECT COUNT(*) FROM subscription_plans;")
echo -e "${GREEN}✓ Subscription plans: $PLANS${NC}"

# Check admin account
ADMINS=$(docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -t -c "SELECT COUNT(*) FROM admins;")
echo -e "${GREEN}✓ Admin accounts: $ADMINS${NC}"

# Check car wash types
TYPES=$(docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -t -c "SELECT COUNT(*) FROM car_wash_types;")
echo -e "${GREEN}✓ Car wash types: $TYPES${NC}"

# Check service areas
AREAS=$(docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db -t -c "SELECT COUNT(*) FROM service_areas;")
echo -e "${GREEN}✓ Service areas: $AREAS${NC}"

echo -e "\n${YELLOW}Step 5: Creating test data...${NC}"

# Create test users
echo -e "${YELLOW}Creating test users...${NC}"
docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db << EOF
-- Insert test users if they don't exist
INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998901111111', 'user1@test.com', 'Test User 1', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998901111111');

INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998902222222', 'user2@test.com', 'Test User 2', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998902222222');

INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998903333333', 'user3@test.com', 'Test User 3', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998903333333');
EOF

echo -e "${GREEN}✓ Test users created${NC}"

# Create test partners
echo -e "${YELLOW}Creating test partners...${NC}"
docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db << EOF
-- Insert test partners
INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Premium Wash Center',
    'High-end car wash with premium services',
    'premium@test.com',
    '+998701111111',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Premium Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent Center' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'premium@test.com');

INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Quick Clean Mobile',
    'Mobile car wash service',
    'mobile@test.com',
    '+998702222222',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Mobile Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent North' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'mobile@test.com');

INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Standard Auto Wash',
    'Regular car wash services',
    'standard@test.com',
    '+998703333333',
    'pending',
    (SELECT id FROM car_wash_types WHERE name_en = 'Standard Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent South' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'standard@test.com');
EOF

echo -e "${GREEN}✓ Test partners created${NC}"

# Create test locations
echo -e "${YELLOW}Creating test locations...${NC}"
docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db << EOF
-- Insert test locations
INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours)
SELECT 
    p.id,
    'Main Branch',
    'Amir Temur Street 15, Tashkent',
    'Tashkent',
    41.2995,
    69.2401,
    '{"monday": "09:00-20:00", "tuesday": "09:00-20:00", "wednesday": "09:00-20:00", "thursday": "09:00-20:00", "friday": "09:00-20:00", "saturday": "10:00-18:00", "sunday": "10:00-18:00"}'::jsonb
FROM partners p
WHERE p.email = 'premium@test.com'
AND NOT EXISTS (
    SELECT 1 FROM partner_locations pl 
    WHERE pl.partner_id = p.id AND pl.name = 'Main Branch'
);
EOF

echo -e "${GREEN}✓ Test locations created${NC}"

# Create test staff
echo -e "${YELLOW}Creating test staff...${NC}"
docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db << EOF
-- Insert test staff
INSERT INTO partner_staff (partner_id, full_name, phone_number, pin_code, role)
SELECT 
    p.id,
    'Test Staff Member',
    '+998901234567',
    '123456',
    'staff'
FROM partners p
WHERE p.email = 'premium@test.com'
AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901234567');
EOF

echo -e "${GREEN}✓ Test staff created${NC}"

echo -e "\n${YELLOW}Step 6: Database Statistics${NC}"
echo "=================================================="

# Get statistics
docker-compose exec -T postgres psql -U yuvgo -d yuvgo_db << EOF
SELECT 
    'Users' as table_name, 
    COUNT(*) as count 
FROM users
UNION ALL
SELECT 'Partners', COUNT(*) FROM partners
UNION ALL
SELECT 'Locations', COUNT(*) FROM partner_locations
UNION ALL
SELECT 'Staff', COUNT(*) FROM partner_staff
UNION ALL
SELECT 'Subscription Plans', COUNT(*) FROM subscription_plans
UNION ALL
SELECT 'Car Wash Types', COUNT(*) FROM car_wash_types
UNION ALL
SELECT 'Service Areas', COUNT(*) FROM service_areas
UNION ALL
SELECT 'Admins', COUNT(*) FROM admins;
EOF

echo "=================================================="
echo -e "\n${GREEN}✓ Test database setup complete!${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Run API tests: python3 test_api.py"
echo "2. Access admin dashboard: http://localhost:3000"
echo "3. Access merchant dashboard: http://localhost:3001"
echo "4. Access user app: http://localhost:3003"
echo ""
echo -e "${YELLOW}Test Credentials:${NC}"
echo "Admin: admin@yuvgo.uz / Admin@123"
echo "Staff: +998901234567 / PIN: 123456"
echo "User: +998901111111"
echo "=================================================="
