from sqlalchemy import Column, String, Boolean, Integer, DECIMAL, TIMESTAMP, ForeignKey, Text, JSON, ARRAY
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
import uuid
from .database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    phone_number = Column(String(20), unique=True, nullable=False)
    email = Column(String(255))
    full_name = Column(String(255))
    is_verified = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Vehicle(Base):
    __tablename__ = "vehicles"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    license_plate = Column(String(20), nullable=False)
    brand = Column(String(100))
    model = Column(String(100))
    color = Column(String(50))
    year = Column(Integer)
    vehicle_type = Column(String(20), default='sedan')
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class SubscriptionPlan(Base):
    __tablename__ = "subscription_plans"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False)
    description = Column(Text)
    price = Column(DECIMAL(10, 2), nullable=False)
    currency = Column(String(3), default="UZS")
    duration_days = Column(Integer, nullable=False)
    visit_limit = Column(Integer)
    is_unlimited = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Subscription(Base):
    __tablename__ = "subscriptions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    plan_id = Column(UUID(as_uuid=True), ForeignKey("subscription_plans.id"))
    status = Column(String(20), default="active")
    start_date = Column(TIMESTAMP, nullable=False)
    end_date = Column(TIMESTAMP, nullable=False)
    visits_used = Column(Integer, default=0)
    visits_remaining = Column(Integer, default=0)
    is_unlimited = Column(Boolean, default=False)
    auto_renew = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Partner(Base):
    __tablename__ = "partners"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False)
    description = Column(Text)
    email = Column(String(255))
    phone_number = Column(String(20))
    address = Column(Text)
    city = Column(String(100))
    latitude = Column(DECIMAL(10, 8))
    longitude = Column(DECIMAL(11, 8))
    is_premium = Column(Boolean, default=False)
    rating = Column(DECIMAL(3, 2), default=0)
    working_hours = Column(JSON)
    logo_url = Column(Text)
    gallery_urls = Column(ARRAY(Text))
    service_type = Column(String(50), default='full_service')
    is_24_hours = Column(Boolean, default=False)
    amenities = Column(JSON, default=[])
    additional_services = Column(JSON, default=[])
    wash_time = Column(Integer, default=60)  # minutes
    phone = Column(String(50))
    status = Column(String(20), default="pending")
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class PartnerLocation(Base):
    __tablename__ = "partner_locations"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    partner_id = Column(UUID(as_uuid=True), ForeignKey("partners.id", ondelete="CASCADE"))
    name = Column(String(255), nullable=False)
    address = Column(Text, nullable=False)
    city = Column(String(100))
    latitude = Column(DECIMAL(10, 8))
    longitude = Column(DECIMAL(11, 8))
    working_hours = Column(JSON)
    phone_number = Column(String(20))
    banner_url = Column(Text)
    gallery_urls = Column(JSON, default=[])
    service_prices = Column(JSON, default=[])
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class PartnerStaff(Base):
    __tablename__ = "partner_staff"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    partner_id = Column(UUID(as_uuid=True), ForeignKey("partners.id", ondelete="CASCADE"))
    location_id = Column(UUID(as_uuid=True), ForeignKey("partner_locations.id", ondelete="SET NULL"))
    full_name = Column(String(255), nullable=False)
    phone_number = Column(String(20), unique=True, nullable=False)
    pin_code = Column(String(6))
    role = Column(String(50), default="staff")
    is_active = Column(Boolean, default=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Visit(Base):
    __tablename__ = "visits"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    subscription_id = Column(UUID(as_uuid=True), ForeignKey("subscriptions.id"))
    vehicle_id = Column(UUID(as_uuid=True), ForeignKey("vehicles.id"))
    partner_id = Column(UUID(as_uuid=True), ForeignKey("partners.id"))
    location_id = Column(UUID(as_uuid=True), ForeignKey("partner_locations.id"))
    staff_id = Column(UUID(as_uuid=True), ForeignKey("partner_staff.id"))
    check_in_time = Column(TIMESTAMP, server_default=func.now())
    status = Column(String(20), default="completed")
    notes = Column(Text)
    created_at = Column(TIMESTAMP, server_default=func.now())

class Payment(Base):
    __tablename__ = "payments"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    subscription_id = Column(UUID(as_uuid=True), ForeignKey("subscriptions.id"))
    amount = Column(DECIMAL(10, 2), nullable=False)
    currency = Column(String(3), default="UZS")
    provider = Column(String(50), nullable=False)
    transaction_id = Column(String(255))
    status = Column(String(20), default="pending")
    payment_method = Column(String(50))
    card_token = Column(String(255))
    payment_metadata = Column(JSON)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Notification(Base):
    __tablename__ = "notifications"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    title = Column(String(255), nullable=False)
    message = Column(Text, nullable=False)
    type = Column(String(50), nullable=False)
    channel = Column(String(20), default="push")
    is_read = Column(Boolean, default=False)
    sent_at = Column(TIMESTAMP)
    created_at = Column(TIMESTAMP, server_default=func.now())

class Admin(Base):
    __tablename__ = "admins"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    full_name = Column(String(255), nullable=False)
    role = Column(String(50), default="admin")
    permissions = Column(JSON, default=[])
    is_active = Column(Boolean, default=True)
    last_login = Column(TIMESTAMP)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class AdminRole(Base):
    __tablename__ = "admin_roles"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), unique=True, nullable=False)
    description = Column(Text)
    permissions = Column(JSON, default=[])
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Promotion(Base):
    __tablename__ = "promotions"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String(255), nullable=False)
    description = Column(Text)
    discount_percentage = Column(DECIMAL(5, 2))
    discount_amount = Column(DECIMAL(10, 2))
    code = Column(String(50), unique=True)
    start_date = Column(TIMESTAMP, nullable=False)
    end_date = Column(TIMESTAMP, nullable=False)
    is_active = Column(Boolean, default=True)
    usage_limit = Column(Integer)
    usage_count = Column(Integer, default=0)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class AuditLog(Base):
    __tablename__ = "audit_logs"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    admin_id = Column(UUID(as_uuid=True), ForeignKey("admins.id"))
    action = Column(String(100), nullable=False)
    entity_type = Column(String(50), nullable=False)
    entity_id = Column(UUID(as_uuid=True))
    changes = Column(JSON)
    ip_address = Column(String(45))
    user_agent = Column(Text)
    created_at = Column(TIMESTAMP, server_default=func.now())

class MerchantUser(Base):
    __tablename__ = "merchant_users"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    partner_id = Column(UUID(as_uuid=True), ForeignKey("partners.id", ondelete="CASCADE"))
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    full_name = Column(String(255), nullable=False)
    phone_number = Column(String(20))
    role = Column(String(50), default="owner")
    is_active = Column(Boolean, default=True)
    last_login = Column(TIMESTAMP)
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

class Review(Base):
    __tablename__ = "reviews"
    
    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    partner_id = Column(UUID(as_uuid=True), ForeignKey("partners.id", ondelete="CASCADE"))
    location_id = Column(UUID(as_uuid=True), ForeignKey("partner_locations.id", ondelete="SET NULL"), nullable=True)
    visit_id = Column(UUID(as_uuid=True), ForeignKey("visits.id", ondelete="SET NULL"), nullable=True)
    rating = Column(Integer, nullable=False)  # 1-5
    comment = Column(Text)
    is_visible = Column(Boolean, default=True, server_default=text('true'))
    created_at = Column(TIMESTAMP, server_default=func.now())
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

# Alias for backward compatibility
Plan = SubscriptionPlan
