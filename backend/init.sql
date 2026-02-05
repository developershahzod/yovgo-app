-- YuvGo Database Initialization Script

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255),
    full_name VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles table
CREATE TABLE IF NOT EXISTS vehicles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    license_plate VARCHAR(20) NOT NULL,
    brand VARCHAR(100),
    model VARCHAR(100),
    color VARCHAR(50),
    year INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscription plans table
CREATE TABLE IF NOT EXISTS subscription_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'UZS',
    duration_days INTEGER NOT NULL,
    visit_limit INTEGER,
    is_unlimited BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    plan_id UUID REFERENCES subscription_plans(id),
    status VARCHAR(20) DEFAULT 'active',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    visits_used INTEGER DEFAULT 0,
    visits_remaining INTEGER DEFAULT 0,
    is_unlimited BOOLEAN DEFAULT FALSE,
    auto_renew BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Car wash types table
CREATE TABLE IF NOT EXISTS car_wash_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_en VARCHAR(100) NOT NULL,
    name_ru VARCHAR(100) NOT NULL,
    name_uz VARCHAR(100) NOT NULL,
    description_en TEXT,
    description_ru TEXT,
    description_uz TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service areas table
CREATE TABLE IF NOT EXISTS service_areas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_en VARCHAR(100) NOT NULL,
    name_ru VARCHAR(100) NOT NULL,
    name_uz VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    district VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Partners (Car Washes) table
CREATE TABLE IF NOT EXISTS partners (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    email VARCHAR(255),
    phone_number VARCHAR(20),
    car_wash_type_id UUID REFERENCES car_wash_types(id),
    service_area_id UUID REFERENCES service_areas(id),
    status VARCHAR(20) DEFAULT 'pending',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Partner locations table
CREATE TABLE IF NOT EXISTS partner_locations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partner_id UUID REFERENCES partners(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100),
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    working_hours JSONB,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Partner staff table
CREATE TABLE IF NOT EXISTS partner_staff (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partner_id UUID REFERENCES partners(id) ON DELETE CASCADE,
    location_id UUID REFERENCES partner_locations(id) ON DELETE SET NULL,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    pin_code VARCHAR(6),
    role VARCHAR(50) DEFAULT 'staff',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Visits table
CREATE TABLE IF NOT EXISTS visits (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    subscription_id UUID REFERENCES subscriptions(id),
    vehicle_id UUID REFERENCES vehicles(id),
    partner_id UUID REFERENCES partners(id),
    location_id UUID REFERENCES partner_locations(id),
    staff_id UUID REFERENCES partner_staff(id),
    check_in_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'completed',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments table
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    subscription_id UUID REFERENCES subscriptions(id),
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'UZS',
    provider VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(255),
    status VARCHAR(20) DEFAULT 'pending',
    payment_method VARCHAR(50),
    card_token VARCHAR(255),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    channel VARCHAR(20) DEFAULT 'push',
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admins table
CREATE TABLE IF NOT EXISTS admins (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'admin',
    permissions JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admin roles table
CREATE TABLE IF NOT EXISTS admin_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    permissions JSONB DEFAULT '[]',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Promotions table
CREATE TABLE IF NOT EXISTS promotions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5, 2),
    discount_amount DECIMAL(10, 2),
    code VARCHAR(50) UNIQUE,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    usage_limit INTEGER,
    usage_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    admin_id UUID REFERENCES admins(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID,
    changes JSONB,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_vehicles_user_id ON vehicles(user_id);
CREATE INDEX idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_visits_user_id ON visits(user_id);
CREATE INDEX idx_visits_partner_id ON visits(partner_id);
CREATE INDEX idx_visits_check_in_time ON visits(check_in_time);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_partner_locations_partner_id ON partner_locations(partner_id);
CREATE INDEX idx_partner_staff_partner_id ON partner_staff(partner_id);

-- Insert default car wash types
INSERT INTO car_wash_types (name_en, name_ru, name_uz, description_en, description_ru, description_uz) VALUES
('Premium Car Wash', 'Премиум автомойка', 'Premium avtomoyка', 'High-end car wash with premium services', 'Автомойка премиум-класса с услугами высшего качества', 'Yuqori sifatli xizmatlar bilan premium avtomoyка'),
('Standard Car Wash', 'Обычная автомойка', 'Oddiy avtomoyка', 'Regular car wash services', 'Стандартные услуги автомойки', 'Oddiy avtomoyка xizmatlari'),
('Mobile Car Wash', 'Мобильная автомойка', 'Mobil avtomoyка', 'Mobile car wash service at your location', 'Мобильная автомойка с выездом', 'Sizning joyingizda mobil avtomoyка xizmati');

-- Insert default service areas
INSERT INTO service_areas (name_en, name_ru, name_uz, city, district) VALUES
('Tashkent Center', 'Центр Ташкента', 'Toshkent markazi', 'Tashkent', 'Yunusabad'),
('Tashkent North', 'Север Ташкента', 'Toshkent shimoli', 'Tashkent', 'Chilanzar'),
('Tashkent South', 'Юг Ташкента', 'Toshkent janubi', 'Tashkent', 'Yakkasaray'),
('Tashkent East', 'Восток Ташкента', 'Toshkent sharqi', 'Tashkent', 'Mirzo Ulugbek'),
('Tashkent West', 'Запад Ташкента', 'Toshkent g''arbi', 'Tashkent', 'Sergeli');

-- Insert default subscription plans
INSERT INTO subscription_plans (name, description, price, duration_days, visit_limit, is_unlimited) VALUES
('Basic Monthly', '12 car washes per month', 99000, 30, 12, FALSE),
('Premium Monthly', 'Unlimited car washes per month', 199000, 30, NULL, TRUE),
('Basic Quarterly', '36 car washes per quarter', 279000, 90, 36, FALSE),
('Premium Quarterly', 'Unlimited car washes per quarter', 549000, 90, NULL, TRUE);

-- Insert default admin roles
INSERT INTO admin_roles (name, description, permissions) VALUES
('super_admin', 'Full system access', '["all"]'),
('admin', 'Standard admin access', '["users.read", "users.write", "partners.read", "partners.write", "subscriptions.read", "analytics.read"]'),
('support', 'Customer support access', '["users.read", "subscriptions.read", "visits.read"]'),
('finance', 'Financial operations access', '["payments.read", "payments.write", "subscriptions.read", "analytics.read"]');

-- Insert default super admin (password: Admin@123 - CHANGE THIS IN PRODUCTION)
-- Password hash for 'Admin@123' using bcrypt
INSERT INTO admins (email, password_hash, full_name, role, permissions) VALUES
('admin@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Super Admin', 'super_admin', '["all"]');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_vehicles_updated_at BEFORE UPDATE ON vehicles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON subscription_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_partners_updated_at BEFORE UPDATE ON partners FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_partner_locations_updated_at BEFORE UPDATE ON partner_locations FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_partner_staff_updated_at BEFORE UPDATE ON partner_staff FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admins_updated_at BEFORE UPDATE ON admins FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_admin_roles_updated_at BEFORE UPDATE ON admin_roles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_promotions_updated_at BEFORE UPDATE ON promotions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==================== SEED DATA FOR TESTING ====================

-- Insert test users
INSERT INTO users (phone_number, email, full_name, is_verified, is_active) VALUES
('+998901234567', 'user1@test.com', 'Alisher Karimov', TRUE, TRUE),
('+998901234568', 'user2@test.com', 'Dilshod Rahimov', TRUE, TRUE),
('+998901234569', 'user3@test.com', 'Nodira Saidova', TRUE, TRUE),
('+998901234570', 'user4@test.com', 'Jasur Toshmatov', TRUE, TRUE),
('+998901234571', 'user5@test.com', 'Malika Umarova', TRUE, TRUE),
('+998901111111', 'demo@yuvgo.uz', 'Demo User', TRUE, TRUE),
('+998900000000', 'test@yuvgo.uz', 'Test User', TRUE, TRUE),
('+998909999999', 'admin@yuvgo.uz', 'Admin User', TRUE, TRUE)
ON CONFLICT (phone_number) DO NOTHING;

-- Insert test partners (car washes)
INSERT INTO partners (name, description, email, phone_number, status, is_active) VALUES
('Black Star Car Wash', 'Premium avtomoyка xizmati', 'blackstar@test.com', '+998712345678', 'approved', TRUE),
('Crystal Clean', 'Tez va sifatli yuvish', 'crystal@test.com', '+998712345679', 'approved', TRUE),
('Aqua Shine', 'Professional detailing', 'aqua@test.com', '+998712345680', 'approved', TRUE),
('Speed Wash', 'Express avtomoyка', 'speed@test.com', '+998712345681', 'approved', TRUE),
('Diamond Car Care', 'VIP xizmat', 'diamond@test.com', '+998712345682', 'pending', TRUE)
ON CONFLICT DO NOTHING;

-- Insert partner locations
INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours, is_active)
SELECT p.id, 'Asosiy filial', 'Yunusobod tumani, Amir Temur ko''chasi 15', 'Tashkent', 41.311081, 69.240562, 
'{"monday": "08:00-22:00", "tuesday": "08:00-22:00", "wednesday": "08:00-22:00", "thursday": "08:00-22:00", "friday": "08:00-22:00", "saturday": "09:00-20:00", "sunday": "09:00-18:00"}', TRUE
FROM partners p WHERE p.name = 'Black Star Car Wash' AND NOT EXISTS (SELECT 1 FROM partner_locations WHERE partner_id = p.id);

INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours, is_active)
SELECT p.id, 'Markaziy filial', 'Chilonzor tumani, Bunyodkor ko''chasi 45', 'Tashkent', 41.285582, 69.204672,
'{"monday": "07:00-23:00", "tuesday": "07:00-23:00", "wednesday": "07:00-23:00", "thursday": "07:00-23:00", "friday": "07:00-23:00", "saturday": "08:00-22:00", "sunday": "08:00-20:00"}', TRUE
FROM partners p WHERE p.name = 'Crystal Clean' AND NOT EXISTS (SELECT 1 FROM partner_locations WHERE partner_id = p.id);

INSERT INTO partner_locations (partner_id, name, address, city, latitude, longitude, working_hours, is_active)
SELECT p.id, 'Premium filial', 'Mirzo Ulug''bek tumani, Mirzo Ulug''bek ko''chasi 78', 'Tashkent', 41.340856, 69.334831,
'{"monday": "08:00-21:00", "tuesday": "08:00-21:00", "wednesday": "08:00-21:00", "thursday": "08:00-21:00", "friday": "08:00-21:00", "saturday": "09:00-19:00", "sunday": "10:00-17:00"}', TRUE
FROM partners p WHERE p.name = 'Aqua Shine' AND NOT EXISTS (SELECT 1 FROM partner_locations WHERE partner_id = p.id);

-- Insert partner staff
INSERT INTO partner_staff (partner_id, full_name, phone_number, pin_code, role, is_active)
SELECT p.id, 'Bobur Aliyev', '+998901111111', '123456', 'manager', TRUE
FROM partners p WHERE p.name = 'Black Star Car Wash' AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901111111');

INSERT INTO partner_staff (partner_id, full_name, phone_number, pin_code, role, is_active)
SELECT p.id, 'Sardor Karimov', '+998901111112', '123456', 'staff', TRUE
FROM partners p WHERE p.name = 'Crystal Clean' AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901111112');

INSERT INTO partner_staff (partner_id, full_name, phone_number, pin_code, role, is_active)
SELECT p.id, 'Jamshid Toshev', '+998901111113', '123456', 'manager', TRUE
FROM partners p WHERE p.name = 'Aqua Shine' AND NOT EXISTS (SELECT 1 FROM partner_staff WHERE phone_number = '+998901111113');

-- Insert merchant users (email/password login)
-- Password: Merchant@123 (bcrypt hash)
INSERT INTO merchant_users (partner_id, email, password_hash, full_name, phone_number, role, is_active)
SELECT p.id, 'merchant@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Merchant Admin', '+998901234500', 'admin', TRUE
FROM partners p WHERE p.name = 'Black Star Car Wash' AND NOT EXISTS (SELECT 1 FROM merchant_users WHERE email = 'merchant@yuvgo.uz');

INSERT INTO merchant_users (partner_id, email, password_hash, full_name, phone_number, role, is_active)
SELECT p.id, 'crystal@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Crystal Manager', '+998901234501', 'manager', TRUE
FROM partners p WHERE p.name = 'Crystal Clean' AND NOT EXISTS (SELECT 1 FROM merchant_users WHERE email = 'crystal@yuvgo.uz');

INSERT INTO merchant_users (partner_id, email, password_hash, full_name, phone_number, role, is_active)
SELECT p.id, 'aqua@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Aqua Manager', '+998901234502', 'manager', TRUE
FROM partners p WHERE p.name = 'Aqua Shine' AND NOT EXISTS (SELECT 1 FROM merchant_users WHERE email = 'aqua@yuvgo.uz');

-- Insert test vehicles for users
INSERT INTO vehicles (user_id, license_plate, brand, model, color, year, is_active)
SELECT u.id, '01A123BC', 'Chevrolet', 'Malibu', 'Oq', 2022, TRUE
FROM users u WHERE u.phone_number = '+998901234567' AND NOT EXISTS (SELECT 1 FROM vehicles WHERE license_plate = '01A123BC');

INSERT INTO vehicles (user_id, license_plate, brand, model, color, year, is_active)
SELECT u.id, '01B456DE', 'Chevrolet', 'Cobalt', 'Qora', 2021, TRUE
FROM users u WHERE u.phone_number = '+998901234568' AND NOT EXISTS (SELECT 1 FROM vehicles WHERE license_plate = '01B456DE');

INSERT INTO vehicles (user_id, license_plate, brand, model, color, year, is_active)
SELECT u.id, '01C789FG', 'Kia', 'K5', 'Kulrang', 2023, TRUE
FROM users u WHERE u.phone_number = '+998901234569' AND NOT EXISTS (SELECT 1 FROM vehicles WHERE license_plate = '01C789FG');

-- Insert test subscriptions
INSERT INTO subscriptions (user_id, plan_id, status, start_date, end_date, visits_used, visits_remaining, is_unlimited, auto_renew)
SELECT u.id, sp.id, 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 3, 9, FALSE, TRUE
FROM users u, subscription_plans sp 
WHERE u.phone_number = '+998901234567' AND sp.name = 'Basic Monthly'
AND NOT EXISTS (SELECT 1 FROM subscriptions WHERE user_id = u.id AND status = 'active');

INSERT INTO subscriptions (user_id, plan_id, status, start_date, end_date, visits_used, visits_remaining, is_unlimited, auto_renew)
SELECT u.id, sp.id, 'active', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', 5, 0, TRUE, TRUE
FROM users u, subscription_plans sp 
WHERE u.phone_number = '+998901234568' AND sp.name = 'Premium Monthly'
AND NOT EXISTS (SELECT 1 FROM subscriptions WHERE user_id = u.id AND status = 'active');

-- Insert test visits
INSERT INTO visits (user_id, subscription_id, vehicle_id, partner_id, location_id, check_in_time, status)
SELECT u.id, s.id, v.id, p.id, pl.id, CURRENT_TIMESTAMP - INTERVAL '2 days', 'completed'
FROM users u
JOIN subscriptions s ON s.user_id = u.id
JOIN vehicles v ON v.user_id = u.id
JOIN partners p ON p.name = 'Black Star Car Wash'
JOIN partner_locations pl ON pl.partner_id = p.id
WHERE u.phone_number = '+998901234567'
AND NOT EXISTS (SELECT 1 FROM visits WHERE user_id = u.id AND check_in_time > CURRENT_TIMESTAMP - INTERVAL '3 days');

-- Insert test notifications
INSERT INTO notifications (user_id, title, message, type, channel, is_read, sent_at)
SELECT u.id, 'Xush kelibsiz!', 'YuvGO ilovasiga xush kelibsiz. Obunangiz faollashtirildi.', 'welcome', 'push', TRUE, CURRENT_TIMESTAMP - INTERVAL '5 days'
FROM users u WHERE u.phone_number = '+998901234567'
AND NOT EXISTS (SELECT 1 FROM notifications WHERE user_id = u.id AND type = 'welcome');

INSERT INTO notifications (user_id, title, message, type, channel, is_read, sent_at)
SELECT u.id, 'Tashrif muvaffaqiyatli!', 'Black Star Car Wash da tashrif qayd etildi.', 'visit', 'push', FALSE, CURRENT_TIMESTAMP - INTERVAL '2 days'
FROM users u WHERE u.phone_number = '+998901234567'
AND NOT EXISTS (SELECT 1 FROM notifications WHERE user_id = u.id AND type = 'visit');

-- Insert test promotion
INSERT INTO promotions (title, description, discount_percentage, code, start_date, end_date, is_active, usage_limit)
VALUES ('Yangi yil aksiyasi', 'Barcha obunalarga 20% chegirma!', 20.00, 'NEWYEAR2026', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '30 days', TRUE, 100)
ON CONFLICT (code) DO NOTHING;

-- ==================== MERCHANT LOGIN CREDENTIALS ====================
-- Create merchant_users table for merchant dashboard login
CREATE TABLE IF NOT EXISTS merchant_users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    partner_id UUID REFERENCES partners(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(50) DEFAULT 'owner',
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER update_merchant_users_updated_at BEFORE UPDATE ON merchant_users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert merchant users for each partner (password: Merchant@123)
INSERT INTO merchant_users (partner_id, email, password_hash, full_name, phone_number, role, is_active)
SELECT p.id, 'blackstar@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Black Star Manager', '+998712345678', 'owner', TRUE
FROM partners p WHERE p.name = 'Black Star Car Wash'
ON CONFLICT (email) DO NOTHING;

INSERT INTO merchant_users (partner_id, email, password_hash, full_name, phone_number, role, is_active)
SELECT p.id, 'crystal@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Crystal Clean Manager', '+998712345679', 'owner', TRUE
FROM partners p WHERE p.name = 'Crystal Clean'
ON CONFLICT (email) DO NOTHING;

INSERT INTO merchant_users (partner_id, email, password_hash, full_name, phone_number, role, is_active)
SELECT p.id, 'aqua@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Aqua Shine Manager', '+998712345680', 'owner', TRUE
FROM partners p WHERE p.name = 'Aqua Shine'
ON CONFLICT (email) DO NOTHING;

-- Add more test admins
INSERT INTO admins (email, password_hash, full_name, role, permissions) VALUES
('manager@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Manager Admin', 'admin', '["users.read", "users.write", "partners.read", "partners.write", "subscriptions.read", "analytics.read"]'),
('support@yuvgo.uz', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyYIeWU7u3oi', 'Support Admin', 'support', '["users.read", "subscriptions.read", "visits.read"]')
ON CONFLICT (email) DO NOTHING;

-- ==================== LOGIN CREDENTIALS SUMMARY ====================
-- 
-- ADMIN DASHBOARD (admin.yuvgo.uz):
--   Email: admin@yuvgo.uz
--   Password: Admin@123
--
-- MERCHANT DASHBOARD (merchant.yuvgo.uz):
--   Email: blackstar@yuvgo.uz
--   Password: Merchant@123
--
--   Email: crystal@yuvgo.uz
--   Password: Merchant@123
--
--   Email: aqua@yuvgo.uz
--   Password: Merchant@123
--
