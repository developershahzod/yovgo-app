from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
import sys
import os
import random
import time
import httpx
from datetime import datetime, timedelta

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import User, Vehicle, Subscription, SubscriptionPlan, Base
from shared.schemas import UserCreate, UserUpdate, UserResponse, VehicleCreate, VehicleResponse
from shared.auth import AuthHandler
from shared.utils import format_phone_number

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="YuvGo User Service",
    description="User and vehicle management service",
    version="1.0.0"
)

auth_handler = AuthHandler()

# In-memory SMS code store: {phone: {code, expires_at}}
sms_codes = {}

# Eskiz SMS config
ESKIZ_EMAIL = "avazbek.7@gmail.com"
ESKIZ_PASSWORD = "EJNXOrDWvdHk9Xk62T9s1UKe8ftlNIn2ZTHdjRPL"
ESKIZ_AUTH_URL = "https://notify.eskiz.uz/api/auth/login"
ESKIZ_SMS_URL = "https://notify.eskiz.uz/api/message/sms/send"
ESKIZ_FROM = "4546"

async def get_eskiz_token():
    """Get Eskiz auth token"""
    async with httpx.AsyncClient() as client:
        resp = await client.post(ESKIZ_AUTH_URL, data={
            "email": ESKIZ_EMAIL,
            "password": ESKIZ_PASSWORD,
        })
        data = resp.json()
        return data.get("data", {}).get("token")

async def send_sms_eskiz(phone: str, message: str):
    """Send SMS via Eskiz"""
    token = await get_eskiz_token()
    if not token:
        raise HTTPException(status_code=500, detail="SMS service unavailable")
    
    async with httpx.AsyncClient() as client:
        resp = await client.post(ESKIZ_SMS_URL, 
            headers={"Authorization": f"Bearer {token}"},
            data={
                "mobile_phone": phone.lstrip("+"),
                "message": message,
                "from": ESKIZ_FROM,
                "callback_url": "",
            }
        )
        return resp.json()

@app.get("/")
async def root():
    return {"service": "YuvGo User Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# SMS Code Request Models
class SendCodeRequest(BaseModel):
    phone_number: str

class VerifyCodeRequest(BaseModel):
    phone_number: str
    code: str
    full_name: Optional[str] = None

# Send SMS verification code
@app.post("/auth/send-code")
async def send_verification_code(data: SendCodeRequest):
    """Send SMS verification code to phone number"""
    phone = format_phone_number(data.phone_number)
    
    # Apple test account: fixed code, no real SMS
    APPLE_TEST_PHONE = "+998000000000"
    if phone == APPLE_TEST_PHONE:
        sms_codes[phone] = {
            "code": "00000",
            "expires_at": time.time() + 99999999,
            "sent_at": time.time(),
        }
        return {"message": "Kod yuborildi", "phone": phone}
    
    # Rate limiting: don't send if code was sent less than 10s ago
    existing = sms_codes.get(phone)
    if existing and existing.get("sent_at") and (time.time() - existing["sent_at"]) < 10:
        raise HTTPException(status_code=429, detail="Iltimos, 10 soniya kuting")
    
    # Generate random 5-digit code
    code = str(random.randint(10000, 99999))
    
    # Store code with 5 min expiry
    sms_codes[phone] = {
        "code": code,
        "expires_at": time.time() + 300,
        "sent_at": time.time(),
    }
    
    # Send SMS via Eskiz (must match approved template ID 39117 exactly)
    sms_message = f"{code} — ваш код верификации для входа в мобильное приложение YuvGO"
    try:
        result = await send_sms_eskiz(phone, sms_message)
        print(f"[ESKIZ RESULT] {phone}: {result}")
    except Exception as e:
        print(f"SMS send error: {e}")
    
    print(f"[SMS CODE] {phone}: {code}")  # Log for debugging
    
    return {"message": "Kod yuborildi", "phone": phone}

# Verify SMS code and login/register
@app.post("/auth/verify-code")
async def verify_code_and_login(data: VerifyCodeRequest, db: Session = Depends(get_db)):
    """Verify SMS code. If user exists - login. If not - auto-register."""
    phone = format_phone_number(data.phone_number)
    
    # Accept universal test code 11111 (temporary while Eskiz SMS delivery is unreliable)
    if data.code == "11111":
        if phone in sms_codes:
            del sms_codes[phone]
    else:
        # Check stored code
        stored = sms_codes.get(phone)
        if not stored:
            raise HTTPException(status_code=400, detail="Kod topilmadi. Qaytadan yuboring.")
        
        if stored["expires_at"] < time.time():
            del sms_codes[phone]
            raise HTTPException(status_code=400, detail="Kod muddati tugagan. Qaytadan yuboring.")
        
        if stored["code"] != data.code:
            raise HTTPException(status_code=400, detail="Kod noto'g'ri")
        
        # Code is valid, remove it
        del sms_codes[phone]
    
    # Check if user exists
    user = db.query(User).filter(User.phone_number == phone).first()
    is_new = False
    
    if not user:
        # Auto-register new user
        is_new = True
        user = User(
            phone_number=phone,
            full_name=data.full_name or "",
            is_verified=True,
            is_active=True
        )
        db.add(user)
        db.commit()
        db.refresh(user)
    elif data.full_name and not user.full_name:
        # Update name for existing user if they didn't have one
        user.full_name = data.full_name
        db.commit()
        db.refresh(user)
    
    # Apple test account: auto-activate basic subscription
    APPLE_TEST_PHONE = "+998000000000"
    if phone == APPLE_TEST_PHONE:
        existing_sub = db.query(Subscription).filter(
            Subscription.user_id == user.id,
            Subscription.status == "active"
        ).first()
        if not existing_sub:
            # Find cheapest active plan
            plan = db.query(SubscriptionPlan).filter(
                SubscriptionPlan.is_active == True
            ).order_by(SubscriptionPlan.price.asc()).first()
            if plan:
                now = datetime.utcnow()
                sub = Subscription(
                    user_id=user.id,
                    plan_id=plan.id,
                    status="active",
                    start_date=now,
                    end_date=now + timedelta(days=plan.duration_days),
                    visits_used=0,
                    visits_remaining=plan.visit_limit or 999,
                    is_unlimited=plan.is_unlimited,
                    auto_renew=False,
                )
                db.add(sub)
                db.commit()
    
    # Create access token
    token_data = {
        "sub": str(user.id),
        "phone": user.phone_number,
        "email": user.email,
    }
    
    access_token = auth_handler.create_access_token(token_data)
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "is_new_user": is_new,
        "user": {
            "id": str(user.id),
            "phone_number": user.phone_number,
            "email": user.email,
            "full_name": user.full_name,
            "is_verified": user.is_verified,
        }
    }

# User Login Request Model
class UserLoginRequest(BaseModel):
    phone_number: str
    password: str = None

# User Register Request Model
class UserRegisterRequest(BaseModel):
    phone_number: str
    email: str = None
    full_name: str = None
    password: str = None

# User Registration
@app.post("/auth/register")
async def user_register(register_data: UserRegisterRequest, db: Session = Depends(get_db)):
    """Register new user"""
    phone = format_phone_number(register_data.phone_number)
    
    # Check if user exists
    existing = db.query(User).filter(User.phone_number == phone).first()
    if existing:
        raise HTTPException(status_code=400, detail="Phone number already registered")
    
    # Create user
    user = User(
        phone_number=phone,
        email=register_data.email,
        full_name=register_data.full_name,
        is_verified=True,
        is_active=True
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    # Create access token
    token_data = {
        "sub": str(user.id),
        "phone": user.phone_number,
        "email": user.email,
    }
    
    access_token = auth_handler.create_access_token(token_data)
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": str(user.id),
            "phone_number": user.phone_number,
            "email": user.email,
            "full_name": user.full_name,
            "is_verified": user.is_verified,
        }
    }

# User Login (simplified - just phone number)
@app.post("/auth/login")
async def user_login(login_data: UserLoginRequest, db: Session = Depends(get_db)):
    """User login with phone number"""
    phone = format_phone_number(login_data.phone_number)
    
    user = db.query(User).filter(
        User.phone_number == phone,
        User.is_active == True
    ).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Create access token
    token_data = {
        "sub": str(user.id),
        "phone": user.phone_number,
        "email": user.email,
    }
    
    access_token = auth_handler.create_access_token(token_data)
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": str(user.id),
            "phone_number": user.phone_number,
            "email": user.email,
            "full_name": user.full_name,
            "is_verified": user.is_verified,
        }
    }

# User Management
@app.post("/users", response_model=UserResponse)
async def create_user(user_data: UserCreate, db: Session = Depends(get_db)):
    """Create new user"""
    # Format phone number
    phone = format_phone_number(user_data.phone_number)
    
    # Check if user exists
    existing = db.query(User).filter(User.phone_number == phone).first()
    if existing:
        raise HTTPException(status_code=400, detail="Phone number already registered")
    
    user = User(
        phone_number=phone,
        email=user_data.email,
        full_name=user_data.full_name
    )
    
    db.add(user)
    db.commit()
    db.refresh(user)
    
    return user

@app.get("/users/stats")
async def get_user_stats_admin(db: Session = Depends(get_db)):
    """Return aggregated user stats - no auth, no limit needed"""
    from sqlalchemy import func, cast, Date
    from datetime import date, timedelta
    total = db.query(func.count(User.id)).scalar() or 0
    active = db.query(func.count(User.id)).filter(User.is_active == True).scalar() or 0
    today = date.today()
    new_today = db.query(func.count(User.id)).filter(
        cast(User.created_at, Date) == today
    ).scalar() or 0
    week_ago = today - timedelta(days=7)
    new_this_week = db.query(func.count(User.id)).filter(
        User.created_at >= week_ago
    ).scalar() or 0
    month_ago = today - timedelta(days=30)
    new_this_month = db.query(func.count(User.id)).filter(
        User.created_at >= month_ago
    ).scalar() or 0
    return {
        "total": total,
        "active": active,
        "new_today": new_today,
        "new_this_week": new_this_week,
        "new_this_month": new_this_month,
    }


@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get user by ID"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Users can only access their own data
    if str(user.id) != current_user.get("sub"):
        raise HTTPException(status_code=403, detail="Access denied")
    
    return user

@app.put("/users/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: str,
    user_data: UserUpdate,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Update user"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Users can only update their own data
    if str(user.id) != current_user.get("sub"):
        raise HTTPException(status_code=403, detail="Access denied")
    
    for field, value in user_data.dict(exclude_unset=True).items():
        if value is not None:
            setattr(user, field, value)
    
    db.commit()
    db.refresh(user)
    
    return user

@app.delete("/users/{user_id}")
async def delete_user(user_id: str, db: Session = Depends(get_db)):
    """Delete a user (admin)"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    db.delete(user)
    db.commit()
    return {"message": "User deleted successfully"}

@app.delete("/me")
async def delete_own_account(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Soft-delete own account (Apple App Store requirement). Marks as deleted, does not remove data."""
    from datetime import datetime
    user_id = current_user.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    user.is_deleted = True
    user.is_active = False
    user.deleted_at = datetime.utcnow()
    db.commit()
    return {"message": "Account deleted successfully"}

@app.put("/me")
async def update_current_user_profile(
    user_data: UserUpdate,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Update current user's own profile (full_name, email) using JWT token"""
    user_id = current_user.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    for field, value in user_data.dict(exclude_unset=True).items():
        if value is not None:
            setattr(user, field, value)

    db.commit()
    db.refresh(user)

    return {
        "id": str(user.id),
        "phone_number": user.phone_number,
        "email": user.email,
        "full_name": user.full_name,
        "is_verified": user.is_verified,
        "is_active": user.is_active,
    }

@app.get("/me")
async def get_current_user_profile(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get current user profile from JWT token"""
    user_id = current_user.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return {
        "id": str(user.id),
        "phone_number": user.phone_number,
        "email": user.email,
        "full_name": user.full_name,
        "is_verified": user.is_verified,
        "is_active": user.is_active,
        "created_at": user.created_at.isoformat() if user.created_at else None,
    }

@app.get("/users", response_model=List[UserResponse])
async def list_users(
    skip: int = 0,
    limit: int = 10000,
    search: Optional[str] = None,
    db: Session = Depends(get_db),
):
    """List all users (admin only - no auth needed, internal service)"""
    query = db.query(User)
    if search:
        query = query.filter(
            (User.phone_number.ilike(f"%{search}%")) |
            (User.full_name.ilike(f"%{search}%"))
        )
    users = query.order_by(User.created_at.desc()).offset(skip).limit(limit).all()
    return users

# Vehicle Management
@app.post("/vehicles", response_model=VehicleResponse)
async def add_vehicle(
    vehicle_data: VehicleCreate,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Add vehicle to user account"""
    user_id = current_user.get("sub")
    
    vehicle = Vehicle(
        user_id=user_id,
        **vehicle_data.dict()
    )
    
    db.add(vehicle)
    db.commit()
    db.refresh(vehicle)
    
    return vehicle

@app.get("/vehicles", response_model=List[VehicleResponse])
async def list_user_vehicles(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """List user's vehicles"""
    user_id = current_user.get("sub")
    vehicles = db.query(Vehicle).filter(
        Vehicle.user_id == user_id,
        Vehicle.is_active == True
    ).all()
    return vehicles

@app.delete("/vehicles/{vehicle_id}")
async def delete_vehicle(
    vehicle_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Delete vehicle"""
    user_id = current_user.get("sub")
    
    vehicle = db.query(Vehicle).filter(
        Vehicle.id == vehicle_id,
        Vehicle.user_id == user_id
    ).first()
    
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    
    vehicle.is_active = False
    db.commit()
    
    return {"message": "Vehicle deleted successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)
