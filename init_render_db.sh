#!/bin/bash

# YuvGo Render Database Initialization Script
# This script initializes the database on Render with schema and test data

echo "=================================================="
echo "YuvGo Render Database Initialization"
echo "=================================================="

# Check if DATABASE_URL is set
if [ -z "$DATABASE_URL" ]; then
    echo "Error: DATABASE_URL environment variable is not set"
    exit 1
fi

echo "Step 1: Installing PostgreSQL client..."
apt-get update && apt-get install -y postgresql-client

echo "Step 2: Running database schema initialization..."
psql $DATABASE_URL -f backend/init.sql

if [ $? -eq 0 ]; then
    echo "✓ Database schema initialized successfully"
else
    echo "✗ Failed to initialize database schema"
    exit 1
fi

echo "Step 3: Creating test data..."

# Create test users
psql $DATABASE_URL << EOF
-- Insert test users
INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998901111111', 'user1@yuvgo.uz', 'Test User 1', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998901111111');

INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998902222222', 'user2@yuvgo.uz', 'Test User 2', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998902222222');

INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998903333333', 'user3@yuvgo.uz', 'Test User 3', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998903333333');

INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998904444444', 'user4@yuvgo.uz', 'Test User 4', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998904444444');

INSERT INTO users (phone_number, email, full_name, is_verified, is_active)
SELECT '+998905555555', 'user5@yuvgo.uz', 'Test User 5', true, true
WHERE NOT EXISTS (SELECT 1 FROM users WHERE phone_number = '+998905555555');
EOF

echo "✓ Test users created"

# Create test merchants/partners
psql $DATABASE_URL << EOF
-- Insert test merchants
INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Premium Wash Center',
    'High-end car wash with premium services and professional staff',
    'premium@yuvgo.uz',
    '+998701111111',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Premium Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent Center' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'premium@yuvgo.uz');

INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Quick Clean Mobile',
    'Mobile car wash service - we come to you',
    'mobile@yuvgo.uz',
    '+998702222222',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Mobile Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent North' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'mobile@yuvgo.uz');

INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Standard Auto Wash',
    'Regular car wash services at affordable prices',
    'standard@yuvgo.uz',
    '+998703333333',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Standard Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent South' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'standard@yuvgo.uz');

INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Express Wash Yunusabad',
    'Fast and efficient car wash in Yunusabad district',
    'express@yuvgo.uz',
    '+998704444444',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Standard Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent Center' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'express@yuvgo.uz');

INSERT INTO partners (name, description, email, phone_number, status, car_wash_type_id, service_area_id)
SELECT 
    'Luxury Car Care',
    'Premium car care services for luxury vehicles',
    'luxury@yuvgo.uz',
    '+998705555555',
    'approved',
    (SELECT id FROM car_wash_types WHERE name_en = 'Premium Car Wash' LIMIT 1),
    (SELECT id FROM service_areas WHERE name_en = 'Tashkent East' LIMIT 1)
WHERE NOT EXISTS (SELECT 1 FROM partners WHERE email = 'luxury@yuvgo.uz');
EOF

echo "✓ Test merchants created"

# Create test locations
psql $DATABASE_URL << EOF
-- Insert test locations for merchants
INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours)
SELECT 
    p.id,
    'Main Branch',
    'Amir Temur Street 15, Yunusabad District',
    'Tashkent',
    41.2995,
    69.2401,
    '{"monday": "09:00-20:00", "tuesday": "09:00-20:00", "wednesday": "09:00-20:00", "thursday": "09:00-20:00", "friday": "09:00-20:00", "saturday": "10:00-18:00", "sunday": "10:00-18:00"}'::jsonb
FROM partners p
WHERE p.email = 'premium@yuvgo.uz'
AND NOT EXISTS (
    SELECT 1 FROM partner_locations pl 
    WHERE pl.partner_id = p.id AND pl.name = 'Main Branch'
);

INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours)
SELECT 
    p.id,
    'Chilanzar Branch',
    'Chilanzar Street 45, Chilanzar District',
    'Tashkent',
    41.2753,
    69.2034,
    '{"monday": "08:00-21:00", "tuesday": "08:00-21:00", "wednesday": "08:00-21:00", "thursday": "08:00-21:00", "friday": "08:00-21:00", "saturday": "09:00-19:00", "sunday": "09:00-19:00"}'::jsonb
FROM partners p
WHERE p.email = 'standard@yuvgo.uz'
AND NOT EXISTS (
    SELECT 1 FROM partner_locations pl 
    WHERE pl.partner_id = p.id AND pl.name = 'Chilanzar Branch'
);

INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours)
SELECT 
    p.id,
    'Express Location',
    'Buyuk Ipak Yuli Street 100, Yunusabad',
    'Tashkent',
    41.3111,
    69.2797,
    '{"monday": "07:00-22:00", "tuesday": "07:00-22:00", "wednesday": "07:00-22:00", "thursday": "07:00-22:00", "friday": "07:00-22:00", "saturday": "08:00-20:00", "sunday": "08:00-20:00"}'::jsonb
FROM partners p
WHERE p.email = 'express@yuvgo.uz'
AND NOT EXISTS (
    SELECT 1 FROM partner_locations pl 
    WHERE pl.partner_id = p.id AND pl.name = 'Express Location'
);
EOF

echo "✓ Test locations created"

# Create test staff for merchants
psql $DATABASE_URL << EOF
-- Insert test staff members
INSERT INTO partner_staff (partner_id, location_id, full_name, phone_number, pin_code, role)
SELECT 
    p.id,
    pl.id,
    'Akmal Karimov',
    '+998901234567',
    '123456',
    'manager'
FROM partners p
JOIN partner_locations pl ON pl.partner_id = p.id
WHERE p.email = 'premium@yuvgo.uz' AND pl.name = 'Main Branch'
AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901234567');

INSERT INTO partner_staff (partner_id, location_id, full_name, phone_number, pin_code, role)
SELECT 
    p.id,
    pl.id,
    'Bobur Alimov',
    '+998901234568',
    '234567',
    'staff'
FROM partners p
JOIN partner_locations pl ON pl.partner_id = p.id
WHERE p.email = 'premium@yuvgo.uz' AND pl.name = 'Main Branch'
AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901234568');

INSERT INTO partner_staff (partner_id, location_id, full_name, phone_number, pin_code, role)
SELECT 
    p.id,
    pl.id,
    'Davron Tursunov',
    '+998901234569',
    '345678',
    'staff'
FROM partners p
JOIN partner_locations pl ON pl.partner_id = p.id
WHERE p.email = 'standard@yuvgo.uz' AND pl.name = 'Chilanzar Branch'
AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901234569');

INSERT INTO partner_staff (partner_id, location_id, full_name, phone_number, pin_code, role)
SELECT 
    p.id,
    pl.id,
    'Eldor Rahimov',
    '+998901234570',
    '456789',
    'manager'
FROM partners p
JOIN partner_locations pl ON pl.partner_id = p.id
WHERE p.email = 'express@yuvgo.uz' AND pl.name = 'Express Location'
AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901234570');
EOF

echo "✓ Test staff created"

# Create test vehicles
psql $DATABASE_URL << EOF
-- Insert test vehicles
INSERT INTO vehicles (user_id, license_plate, brand, model, color, year)
SELECT 
    u.id,
    '01A123BC',
    'Toyota',
    'Camry',
    'White',
    2022
FROM users u
WHERE u.phone_number = '+998901111111'
AND NOT EXISTS (SELECT 1 FROM vehicles WHERE license_plate = '01A123BC');

INSERT INTO vehicles (user_id, license_plate, brand, model, color, year)
SELECT 
    u.id,
    '01B456DE',
    'Chevrolet',
    'Malibu',
    'Black',
    2021
FROM users u
WHERE u.phone_number = '+998902222222'
AND NOT EXISTS (SELECT 1 FROM vehicles WHERE license_plate = '01B456DE');

INSERT INTO vehicles (user_id, license_plate, brand, model, color, year)
SELECT 
    u.id,
    '01C789FG',
    'Hyundai',
    'Sonata',
    'Silver',
    2023
FROM users u
WHERE u.phone_number = '+998903333333'
AND NOT EXISTS (SELECT 1 FROM vehicles WHERE license_plate = '01C789FG');
EOF

echo "✓ Test vehicles created"

# Create test subscriptions
psql $DATABASE_URL << EOF
-- Insert test subscriptions
INSERT INTO subscriptions (user_id, plan_id, status, start_date, end_date, visits_used, auto_renew)
SELECT 
    u.id,
    sp.id,
    'active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    3,
    true
FROM users u
CROSS JOIN subscription_plans sp
WHERE u.phone_number = '+998901111111' 
AND sp.name = 'Premium Monthly'
AND NOT EXISTS (
    SELECT 1 FROM subscriptions s 
    WHERE s.user_id = u.id AND s.status = 'active'
);

INSERT INTO subscriptions (user_id, plan_id, status, start_date, end_date, visits_used, auto_renew)
SELECT 
    u.id,
    sp.id,
    'active',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP + INTERVAL '30 days',
    5,
    true
FROM users u
CROSS JOIN subscription_plans sp
WHERE u.phone_number = '+998902222222' 
AND sp.name = 'Basic Monthly'
AND NOT EXISTS (
    SELECT 1 FROM subscriptions s 
    WHERE s.user_id = u.id AND s.status = 'active'
);
EOF

echo "✓ Test subscriptions created"

# Create additional admin accounts
psql $DATABASE_URL << EOF
-- Insert additional admin accounts
INSERT INTO admins (email, password_hash, full_name, role, permissions)
SELECT 'support@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Support Admin', 'support', '["users.read", "subscriptions.read", "visits.read"]'
WHERE NOT EXISTS (SELECT 1 FROM admins WHERE email = 'support@yuvgo.uz');

INSERT INTO admins (email, password_hash, full_name, role, permissions)
SELECT 'finance@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Finance Admin', 'finance', '["payments.read", "payments.write", "subscriptions.read", "analytics.read"]'
WHERE NOT EXISTS (SELECT 1 FROM admins WHERE email = 'finance@yuvgo.uz');
EOF

echo "✓ Additional admin accounts created"

echo ""
echo "=================================================="
echo "Database Statistics:"
echo "=================================================="

# Get statistics
psql $DATABASE_URL << EOF
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
SELECT 'Vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'Subscriptions', COUNT(*) FROM subscriptions
UNION ALL
SELECT 'Subscription Plans', COUNT(*) FROM subscription_plans
UNION ALL
SELECT 'Car Wash Types', COUNT(*) FROM car_wash_types
UNION ALL
SELECT 'Service Areas', COUNT(*) FROM service_areas
UNION ALL
SELECT 'Admins', COUNT(*) FROM admins
ORDER BY table_name;
EOF

echo "=================================================="
echo "✓ Database initialization complete!"
echo ""
echo "Test Credentials:"
echo "=================================================="
echo "Admin Panel:"
echo "  - Super Admin: admin@yuvgo.uz / Admin@123"
echo "  - Support: support@yuvgo.uz / Admin@123"
echo "  - Finance: finance@yuvgo.uz / Admin@123"
echo ""
echo "Merchant Staff:"
echo "  - Manager: +998901234567 / PIN: 123456"
echo "  - Staff: +998901234568 / PIN: 234567"
echo "  - Staff: +998901234569 / PIN: 345678"
echo "  - Manager: +998901234570 / PIN: 456789"
echo ""
echo "Test Users:"
echo "  - User 1: +998901111111"
echo "  - User 2: +998902222222"
echo "  - User 3: +998903333333"
echo "  - User 4: +998904444444"
echo "  - User 5: +998905555555"
echo "=================================================="
