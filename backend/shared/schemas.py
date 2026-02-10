from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from uuid import UUID

# User Schemas
class UserBase(BaseModel):
    phone_number: str
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None

class UserCreate(UserBase):
    pass

class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None

class UserResponse(UserBase):
    id: UUID
    is_verified: bool
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Vehicle Schemas
class VehicleBase(BaseModel):
    license_plate: str
    brand: Optional[str] = None
    model: Optional[str] = None
    color: Optional[str] = None
    year: Optional[int] = None

class VehicleCreate(VehicleBase):
    pass

class VehicleResponse(VehicleBase):
    id: UUID
    user_id: UUID
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Subscription Plan Schemas
class SubscriptionPlanBase(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    currency: str = "UZS"
    duration_days: int
    visit_limit: Optional[int] = None
    is_unlimited: bool = False

class SubscriptionPlanCreate(SubscriptionPlanBase):
    is_active: bool = True

class SubscriptionPlanResponse(SubscriptionPlanBase):
    id: UUID
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Subscription Schemas
class SubscriptionCreate(BaseModel):
    plan_id: UUID
    auto_renew: bool = True

class SubscriptionResponse(BaseModel):
    id: UUID
    user_id: UUID
    plan_id: UUID
    status: str
    start_date: datetime
    end_date: datetime
    visits_used: int
    visits_remaining: int
    is_unlimited: bool
    auto_renew: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Partner Schemas
class PartnerBase(BaseModel):
    name: str
    description: Optional[str] = None
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    is_premium: Optional[bool] = False
    working_hours: Optional[Dict[str, Any]] = None
    logo_url: Optional[str] = None
    gallery_urls: Optional[List[str]] = None
    service_type: Optional[str] = 'full_service'
    is_24_hours: Optional[bool] = False
    amenities: Optional[List[str]] = []
    additional_services: Optional[List[str]] = []
    wash_time: Optional[int] = 60

class PartnerCreate(PartnerBase):
    pass

class PartnerUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    email: Optional[EmailStr] = None
    phone_number: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    is_premium: Optional[bool] = None
    rating: Optional[float] = None
    working_hours: Optional[Dict[str, Any]] = None
    logo_url: Optional[str] = None
    gallery_urls: Optional[List[str]] = None
    service_type: Optional[str] = None
    is_24_hours: Optional[bool] = None
    amenities: Optional[List[str]] = None
    additional_services: Optional[List[str]] = None
    wash_time: Optional[int] = None
    status: Optional[str] = None

class PartnerResponse(PartnerBase):
    id: UUID
    status: str
    is_active: bool
    rating: Optional[float] = None
    created_at: datetime
    
    class Config:
        from_attributes = True

# Partner Location Schemas
class PartnerLocationBase(BaseModel):
    name: str
    address: str
    city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    working_hours: Optional[Dict[str, Any]] = None

class PartnerLocationCreate(PartnerLocationBase):
    partner_id: UUID

class PartnerLocationResponse(PartnerLocationBase):
    id: UUID
    partner_id: UUID
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Partner Staff Schemas
class PartnerStaffBase(BaseModel):
    full_name: str
    phone_number: str
    role: str = "staff"

class PartnerStaffCreate(PartnerStaffBase):
    partner_id: UUID
    location_id: Optional[UUID] = None
    pin_code: str

class PartnerStaffResponse(PartnerStaffBase):
    id: UUID
    partner_id: UUID
    location_id: Optional[UUID]
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True

# Visit Schemas
class VisitCreate(BaseModel):
    qr_token: str
    location_id: UUID
    staff_id: UUID
    notes: Optional[str] = None

class VisitResponse(BaseModel):
    id: UUID
    user_id: UUID
    subscription_id: UUID
    vehicle_id: Optional[UUID] = None
    partner_id: UUID
    location_id: Optional[UUID] = None
    staff_id: Optional[UUID] = None
    check_in_time: datetime
    status: str
    notes: Optional[str] = None
    user_name: Optional[str] = None
    user_phone: Optional[str] = None
    user_email: Optional[str] = None
    partner_name: Optional[str] = None
    
    class Config:
        from_attributes = True

# Payment Schemas
class PaymentCreate(BaseModel):
    subscription_id: UUID
    amount: float
    provider: str
    payment_method: Optional[str] = None
    card_token: Optional[str] = None

class PaymentResponse(BaseModel):
    id: UUID
    user_id: UUID
    subscription_id: UUID
    amount: float
    currency: str
    provider: str
    transaction_id: Optional[str]
    status: str
    created_at: datetime
    
    class Config:
        from_attributes = True

# Admin Schemas
class AdminBase(BaseModel):
    email: EmailStr
    full_name: str
    role: str = "admin"

class AdminCreate(AdminBase):
    password: str
    permissions: List[str] = []

class AdminUpdate(BaseModel):
    email: Optional[EmailStr] = None
    full_name: Optional[str] = None
    role: Optional[str] = None
    permissions: Optional[List[str]] = None
    is_active: Optional[bool] = None

class AdminResponse(AdminBase):
    id: UUID
    permissions: List[str]
    is_active: bool
    last_login: Optional[datetime]
    created_at: datetime
    
    class Config:
        from_attributes = True

# Admin Role Schemas
class AdminRoleBase(BaseModel):
    name: str
    description: Optional[str] = None
    permissions: List[str] = []

class AdminRoleCreate(AdminRoleBase):
    pass

class AdminRoleResponse(AdminRoleBase):
    id: UUID
    created_at: datetime
    
    class Config:
        from_attributes = True

# Promotion Schemas
class PromotionBase(BaseModel):
    title: str
    description: Optional[str] = None
    discount_percentage: Optional[float] = None
    discount_amount: Optional[float] = None
    code: Optional[str] = None
    start_date: datetime
    end_date: datetime
    usage_limit: Optional[int] = None

class PromotionCreate(PromotionBase):
    pass

class PromotionResponse(PromotionBase):
    id: UUID
    is_active: bool
    usage_count: int
    created_at: datetime
    
    class Config:
        from_attributes = True

# Auth Schemas
class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"

class QRTokenResponse(BaseModel):
    qr_token: str
    expires_in: int
    user_id: UUID
    subscription_id: UUID

# Analytics Schemas
class AnalyticsResponse(BaseModel):
    total_users: int
    active_subscriptions: int
    total_visits: int
    revenue: float
    period: str
