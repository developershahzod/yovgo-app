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
