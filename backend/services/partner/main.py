from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime, timedelta
import sys
import os
import uuid

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Partner, PartnerLocation, PartnerStaff, MerchantUser, Visit, User, Base
from shared.schemas import (
    PartnerCreate, PartnerUpdate, PartnerResponse,
    PartnerLocationCreate, PartnerLocationResponse,
    PartnerStaffCreate, PartnerStaffResponse
)
from shared.auth import AuthHandler
from shared.utils import generate_pin_code

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Partner Service", version="1.0.0")

@app.get("/")
async def root():
    return {"service": "YuvGo Partner Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Partner Management
@app.post("/partners", response_model=PartnerResponse)
async def register_partner(partner_data: PartnerCreate, db: Session = Depends(get_db)):
    """Register new partner (car wash)"""
    partner = Partner(**partner_data.dict(), status="pending")
    db.add(partner)
    db.commit()
    db.refresh(partner)
    return partner

@app.get("/partners", response_model=List[PartnerResponse])
async def list_partners(
    skip: int = 0,
    limit: int = 20,
    status: str = None,
    db: Session = Depends(get_db)
):
    """List partners"""
    query = db.query(Partner)
    if status:
        query = query.filter(Partner.status == status)
    return query.offset(skip).limit(limit).all()

@app.get("/partners/{partner_id}", response_model=PartnerResponse)
async def get_partner(partner_id: str, db: Session = Depends(get_db)):
    """Get partner details"""
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    return partner

@app.put("/partners/{partner_id}", response_model=PartnerResponse)
async def update_partner(
    partner_id: str,
    partner_data: PartnerUpdate,
    db: Session = Depends(get_db)
):
    """Update partner"""
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    
    for field, value in partner_data.dict(exclude_unset=True).items():
        if value is not None:
            setattr(partner, field, value)
    
    db.commit()
    db.refresh(partner)
    return partner

@app.delete("/partners/{partner_id}")
async def delete_partner(partner_id: str, db: Session = Depends(get_db)):
    """Delete a partner"""
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    db.delete(partner)
    db.commit()
    return {"message": "Partner deleted successfully"}

# Location Management
@app.post("/locations", response_model=PartnerLocationResponse)
async def add_location(
    location_data: PartnerLocationCreate,
    db: Session = Depends(get_db)
):
    """Add partner location"""
    location = PartnerLocation(**location_data.dict())
    db.add(location)
    db.commit()
    db.refresh(location)
    return location

@app.get("/locations", response_model=List[PartnerLocationResponse])
async def list_locations(
    partner_id: str = None,
    city: str = None,
    db: Session = Depends(get_db)
):
    """List partner locations"""
    query = db.query(PartnerLocation).filter(PartnerLocation.is_active == True)
    
    if partner_id:
        query = query.filter(PartnerLocation.partner_id == partner_id)
    if city:
        query = query.filter(PartnerLocation.city == city)
    
    return query.all()

# Staff Management
@app.post("/staff", response_model=PartnerStaffResponse)
async def add_staff(
    staff_data: PartnerStaffCreate,
    db: Session = Depends(get_db)
):
    """Add partner staff member"""
    # Check if phone exists
    existing = db.query(PartnerStaff).filter(
        PartnerStaff.phone_number == staff_data.phone_number
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Phone number already registered")
    
    staff = PartnerStaff(**staff_data.dict())
    db.add(staff)
    db.commit()
    db.refresh(staff)
    return staff

@app.get("/staff", response_model=List[PartnerStaffResponse])
async def list_staff(
    partner_id: str = None,
    location_id: str = None,
    db: Session = Depends(get_db)
):
    """List partner staff"""
    query = db.query(PartnerStaff).filter(PartnerStaff.is_active == True)
    
    if partner_id:
        query = query.filter(PartnerStaff.partner_id == partner_id)
    if location_id:
        query = query.filter(PartnerStaff.location_id == location_id)
    
    return query.all()

@app.get("/partners/{partner_id}/staff", response_model=List[PartnerStaffResponse])
async def get_partner_staff(partner_id: str, db: Session = Depends(get_db)):
    """Get staff for a specific partner"""
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.partner_id == partner_id,
        PartnerStaff.is_active == True
    ).all()
    return staff

# Staff Update Model
class StaffUpdateRequest(BaseModel):
    full_name: str = None
    phone_number: str = None
    pin_code: str = None

@app.put("/partners/{partner_id}/staff")
async def update_partner_staff(
    partner_id: str,
    staff_data: StaffUpdateRequest,
    db: Session = Depends(get_db)
):
    """Update staff credentials for a partner"""
    # Get first active staff for this partner
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.partner_id == partner_id,
        PartnerStaff.is_active == True
    ).first()
    
    if not staff:
        # Create new staff if none exists
        staff = PartnerStaff(
            partner_id=partner_id,
            full_name=staff_data.full_name or "Manager",
            phone_number=staff_data.phone_number,
            pin_code=staff_data.pin_code or generate_pin_code(),
            role="manager",
            is_active=True
        )
        db.add(staff)
    else:
        # Update existing staff
        if staff_data.full_name:
            staff.full_name = staff_data.full_name
        if staff_data.phone_number:
            # Check if phone is already used by another staff
            existing = db.query(PartnerStaff).filter(
                PartnerStaff.phone_number == staff_data.phone_number,
                PartnerStaff.id != staff.id
            ).first()
            if existing:
                raise HTTPException(status_code=400, detail="Phone number already in use")
            staff.phone_number = staff_data.phone_number
        if staff_data.pin_code:
            staff.pin_code = staff_data.pin_code
    
    db.commit()
    db.refresh(staff)
    
    return {
        "message": "Staff credentials updated successfully",
        "staff": {
            "id": str(staff.id),
            "full_name": staff.full_name,
            "phone_number": staff.phone_number,
            "role": staff.role
        }
    }

# Staff Login Request Model
class StaffLoginRequest(BaseModel):
    phone_number: str
    pin_code: str

# Staff Login
@app.post("/staff/login")
async def staff_login(
    login_data: StaffLoginRequest,
    db: Session = Depends(get_db)
):
    """Staff login with phone and PIN"""
    from shared.auth import AuthHandler
    
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.phone_number == login_data.phone_number,
        PartnerStaff.is_active == True
    ).first()
    
    if not staff or staff.pin_code != login_data.pin_code:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    # Get partner and location info
    partner = db.query(Partner).filter(Partner.id == staff.partner_id).first()
    location = None
    if staff.location_id:
        location = db.query(PartnerLocation).filter(
            PartnerLocation.id == staff.location_id
        ).first()
    
    # Create access token
    auth_handler = AuthHandler()
    token_data = {
        "sub": str(staff.id),
        "phone": staff.phone_number,
        "role": staff.role,
        "partner_id": str(staff.partner_id)
    }
    
    access_token = auth_handler.create_access_token(token_data)
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "staff": {
            "id": str(staff.id),
            "full_name": staff.full_name,
            "phone_number": staff.phone_number,
            "role": staff.role
        },
        "partner": {
            "id": str(partner.id),
            "name": partner.name
        } if partner else None,
        "location": {
            "id": str(location.id),
            "name": location.name,
            "address": location.address
        } if location else None
    }

# Generate Merchant QR Code
@app.get("/partners/{partner_id}/qr")
async def generate_merchant_qr(partner_id: str, db: Session = Depends(get_db)):
    """Generate QR code for merchant location"""
    import time
    
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    
    # Generate merchant QR token
    qr_token = f"MERCHANT_{partner_id}_{int(time.time())}"
    
    return {
        "qr_token": qr_token,
        "partner_id": partner_id,
        "partner_name": partner.name,
        "generated_at": time.time()
    }

# Merchant User Create Request Model
class MerchantUserCreateRequest(BaseModel):
    email: str
    password: str
    full_name: str
    phone_number: str = None
    role: str = "owner"

# Create Merchant User for a Partner
@app.post("/partners/{partner_id}/merchant-users")
async def create_merchant_user(
    partner_id: str,
    user_data: MerchantUserCreateRequest,
    db: Session = Depends(get_db)
):
    """Create a merchant user for a partner (used by admin panel)"""
    from shared.auth import AuthHandler
    auth_handler = AuthHandler()

    # Verify partner exists
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")

    # Check if email already exists
    existing = db.query(MerchantUser).filter(MerchantUser.email == user_data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")

    merchant_user = MerchantUser(
        partner_id=partner_id,
        email=user_data.email,
        password_hash=auth_handler.hash_password(user_data.password),
        full_name=user_data.full_name,
        phone_number=user_data.phone_number,
        role=user_data.role,
        is_active=True
    )
    db.add(merchant_user)
    db.commit()
    db.refresh(merchant_user)

    return {
        "id": str(merchant_user.id),
        "email": merchant_user.email,
        "full_name": merchant_user.full_name,
        "role": merchant_user.role,
        "partner_id": str(partner_id),
        "message": "Merchant user created successfully"
    }

# Get Merchant Users for a Partner
@app.get("/partners/{partner_id}/merchant-users")
async def get_merchant_users(partner_id: str, db: Session = Depends(get_db)):
    """Get all merchant users for a partner"""
    users = db.query(MerchantUser).filter(
        MerchantUser.partner_id == partner_id,
        MerchantUser.is_active == True
    ).all()
    
    return [{
        "id": str(u.id),
        "email": u.email,
        "full_name": u.full_name,
        "phone_number": u.phone_number,
        "role": u.role,
    } for u in users]

# Update Merchant User Request Model
class MerchantUserUpdateRequest(BaseModel):
    email: str = None
    password: str = None
    full_name: str = None
    phone_number: str = None

# Update Merchant User for a Partner
@app.put("/partners/{partner_id}/merchant-users")
async def update_merchant_user(
    partner_id: str,
    user_data: MerchantUserUpdateRequest,
    db: Session = Depends(get_db)
):
    """Update merchant user for a partner (used by admin panel)"""
    from shared.auth import AuthHandler
    auth_handler = AuthHandler()

    # Find existing merchant user for this partner
    merchant_user = db.query(MerchantUser).filter(
        MerchantUser.partner_id == partner_id,
        MerchantUser.is_active == True
    ).first()
    
    if not merchant_user:
        raise HTTPException(status_code=404, detail="No merchant user found for this partner")

    if user_data.email:
        # Check email uniqueness (exclude current user)
        existing = db.query(MerchantUser).filter(
            MerchantUser.email == user_data.email,
            MerchantUser.id != merchant_user.id
        ).first()
        if existing:
            raise HTTPException(status_code=400, detail="Email already registered by another user")
        merchant_user.email = user_data.email
    
    if user_data.password:
        merchant_user.password_hash = auth_handler.hash_password(user_data.password)
    
    if user_data.full_name:
        merchant_user.full_name = user_data.full_name
    
    if user_data.phone_number:
        merchant_user.phone_number = user_data.phone_number
    
    db.commit()
    db.refresh(merchant_user)

    return {
        "id": str(merchant_user.id),
        "email": merchant_user.email,
        "full_name": merchant_user.full_name,
        "phone_number": merchant_user.phone_number,
        "message": "Merchant user updated successfully"
    }

# Merchant User Login Request Model
class MerchantLoginRequest(BaseModel):
    email: str
    password: str

# Merchant User Login (Email/Password)
@app.post("/merchant/login")
async def merchant_login(
    login_data: MerchantLoginRequest,
    db: Session = Depends(get_db)
):
    """Merchant user login with email and password"""
    from shared.auth import AuthHandler
    
    auth_handler = AuthHandler()
    
    # Find merchant user by email
    user = db.query(MerchantUser).filter(
        MerchantUser.email == login_data.email,
        MerchantUser.is_active == True
    ).first()
    
    if not user:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    # Verify password
    if not auth_handler.verify_password(login_data.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
    # Get partner info
    partner = db.query(Partner).filter(Partner.id == user.partner_id).first()
    
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    
    # Create access token
    token_data = {
        "sub": str(user.id),
        "email": user.email,
        "role": user.role,
        "partner_id": str(user.partner_id)
    }
    
    access_token = auth_handler.create_access_token(token_data)
    
    # Update last login
    from datetime import datetime
    user.last_login = datetime.utcnow()
    db.commit()
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": str(user.id),
            "email": user.email,
            "full_name": user.full_name,
            "phone_number": user.phone_number,
            "role": user.role
        },
        "partner": {
            "id": str(partner.id),
            "name": partner.name
        }
    }

# ============ BRANCH MANAGEMENT API ============

class BranchCreate(BaseModel):
    name: str
    address: str
    city: str = "Tashkent"
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    working_hours: Optional[dict] = None
    phone_number: Optional[str] = None
    banner_url: Optional[str] = None
    gallery_urls: Optional[list] = []
    service_prices: Optional[list] = []

class BranchUpdate(BaseModel):
    name: Optional[str] = None
    address: Optional[str] = None
    city: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    working_hours: Optional[dict] = None
    phone_number: Optional[str] = None
    banner_url: Optional[str] = None
    gallery_urls: Optional[list] = None
    service_prices: Optional[list] = None
    is_active: Optional[bool] = None

@app.get("/merchant/branches")
async def get_merchant_branches(partner_id: str, db: Session = Depends(get_db)):
    """Get all branches for a merchant"""
    branches = db.query(PartnerLocation).filter(
        PartnerLocation.partner_id == partner_id
    ).all()
    
    result = []
    for branch in branches:
        # Get visit count for this branch
        visit_count = db.query(func.count(Visit.id)).filter(
            Visit.location_id == branch.id
        ).scalar() or 0
        
        # Get staff count for this branch
        staff_count = db.query(func.count(PartnerStaff.id)).filter(
            PartnerStaff.location_id == branch.id,
            PartnerStaff.is_active == True
        ).scalar() or 0
        
        result.append({
            "id": str(branch.id),
            "name": branch.name,
            "address": branch.address,
            "city": branch.city,
            "latitude": float(branch.latitude) if branch.latitude else None,
            "longitude": float(branch.longitude) if branch.longitude else None,
            "working_hours": branch.working_hours,
            "phone_number": branch.phone_number,
            "banner_url": branch.banner_url,
            "gallery_urls": branch.gallery_urls or [],
            "service_prices": branch.service_prices or [],
            "is_active": branch.is_active,
            "visit_count": visit_count,
            "staff_count": staff_count,
            "qr_code": f"BRANCH_{branch.id}",
            "created_at": branch.created_at.isoformat() if branch.created_at else None
        })
    
    return result

@app.post("/merchant/branches")
async def create_branch(partner_id: str, branch_data: BranchCreate, db: Session = Depends(get_db)):
    """Create a new branch for a merchant"""
    # Verify partner exists
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    
    branch = PartnerLocation(
        partner_id=partner_id,
        name=branch_data.name,
        address=branch_data.address,
        city=branch_data.city,
        latitude=branch_data.latitude,
        longitude=branch_data.longitude,
        working_hours=branch_data.working_hours or {"open": "08:00", "close": "22:00"},
        phone_number=branch_data.phone_number,
        banner_url=branch_data.banner_url,
        gallery_urls=branch_data.gallery_urls or [],
        service_prices=branch_data.service_prices or [],
        is_active=True
    )
    
    db.add(branch)
    db.commit()
    db.refresh(branch)
    
    return {
        "id": str(branch.id),
        "name": branch.name,
        "address": branch.address,
        "city": branch.city,
        "phone_number": branch.phone_number,
        "banner_url": branch.banner_url,
        "gallery_urls": branch.gallery_urls or [],
        "service_prices": branch.service_prices or [],
        "working_hours": branch.working_hours,
        "qr_code": f"BRANCH_{branch.id}",
        "is_active": True,
        "visit_count": 0,
        "staff_count": 0,
        "message": "Branch created successfully"
    }

@app.put("/merchant/branches/{branch_id}")
async def update_branch(branch_id: str, branch_data: BranchUpdate, db: Session = Depends(get_db)):
    """Update a branch"""
    branch = db.query(PartnerLocation).filter(PartnerLocation.id == branch_id).first()
    if not branch:
        raise HTTPException(status_code=404, detail="Branch not found")
    
    for field, value in branch_data.dict(exclude_unset=True).items():
        if value is not None:
            setattr(branch, field, value)
    
    db.commit()
    db.refresh(branch)
    
    return {
        "id": str(branch.id),
        "name": branch.name,
        "address": branch.address,
        "city": branch.city,
        "phone_number": branch.phone_number,
        "banner_url": branch.banner_url,
        "gallery_urls": branch.gallery_urls or [],
        "service_prices": branch.service_prices or [],
        "working_hours": branch.working_hours,
        "is_active": branch.is_active,
        "message": "Branch updated successfully"
    }

@app.delete("/merchant/branches/{branch_id}")
async def delete_branch(branch_id: str, db: Session = Depends(get_db)):
    """Delete (deactivate) a branch"""
    branch = db.query(PartnerLocation).filter(PartnerLocation.id == branch_id).first()
    if not branch:
        raise HTTPException(status_code=404, detail="Branch not found")
    
    branch.is_active = False
    db.commit()
    
    return {"message": "Branch deleted successfully"}

@app.get("/merchant/branches/{branch_id}/qr")
async def get_branch_qr(branch_id: str, db: Session = Depends(get_db)):
    """Get QR code for a specific branch"""
    branch = db.query(PartnerLocation).filter(PartnerLocation.id == branch_id).first()
    if not branch:
        raise HTTPException(status_code=404, detail="Branch not found")
    
    partner = db.query(Partner).filter(Partner.id == branch.partner_id).first()
    
    return {
        "qr_token": f"BRANCH_{branch_id}",
        "branch_id": str(branch.id),
        "branch_name": branch.name,
        "partner_name": partner.name if partner else "Unknown",
        "address": branch.address
    }

# ============ BRANCH STAFF MANAGEMENT ============

class BranchStaffCreate(BaseModel):
    full_name: str
    phone_number: str
    pin_code: Optional[str] = None
    role: str = "staff"

@app.get("/merchant/branches/{branch_id}/staff")
async def get_branch_staff(branch_id: str, db: Session = Depends(get_db)):
    """Get all staff for a branch"""
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.location_id == branch_id,
        PartnerStaff.is_active == True
    ).all()
    
    return [{
        "id": str(s.id),
        "full_name": s.full_name,
        "phone_number": s.phone_number,
        "role": s.role,
        "created_at": s.created_at.isoformat() if s.created_at else None
    } for s in staff]

@app.post("/merchant/branches/{branch_id}/staff")
async def add_branch_staff(
    branch_id: str, 
    staff_data: BranchStaffCreate, 
    db: Session = Depends(get_db)
):
    """Add staff to a branch"""
    branch = db.query(PartnerLocation).filter(PartnerLocation.id == branch_id).first()
    if not branch:
        raise HTTPException(status_code=404, detail="Branch not found")
    
    # Check if phone exists
    existing = db.query(PartnerStaff).filter(
        PartnerStaff.phone_number == staff_data.phone_number
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Phone number already registered")
    
    staff = PartnerStaff(
        partner_id=branch.partner_id,
        location_id=branch_id,
        full_name=staff_data.full_name,
        phone_number=staff_data.phone_number,
        pin_code=staff_data.pin_code or generate_pin_code(),
        role=staff_data.role,
        is_active=True
    )
    
    db.add(staff)
    db.commit()
    db.refresh(staff)
    
    return {
        "id": str(staff.id),
        "full_name": staff.full_name,
        "phone_number": staff.phone_number,
        "pin_code": staff.pin_code,
        "message": "Staff added successfully"
    }

@app.delete("/merchant/branches/{branch_id}/staff/{staff_id}")
async def remove_branch_staff(branch_id: str, staff_id: str, db: Session = Depends(get_db)):
    """Remove staff from a branch"""
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.id == staff_id,
        PartnerStaff.location_id == branch_id
    ).first()
    
    if not staff:
        raise HTTPException(status_code=404, detail="Staff not found")
    
    staff.is_active = False
    db.commit()
    
    return {"message": "Staff removed successfully"}

# ============ MERCHANT ANALYTICS API ============

@app.get("/merchant/analytics")
async def get_merchant_analytics(partner_id: str, period: str = "week", db: Session = Depends(get_db)):
    """Get analytics for a merchant"""
    now = datetime.utcnow()
    
    if period == "today":
        start_date = now.replace(hour=0, minute=0, second=0, microsecond=0)
    elif period == "week":
        start_date = now - timedelta(days=7)
    elif period == "month":
        start_date = now - timedelta(days=30)
    else:  # year
        start_date = now - timedelta(days=365)
    
    # Get visits for the period
    visits = db.query(Visit).filter(
        Visit.partner_id == partner_id,
        Visit.check_in_time >= start_date
    ).all()
    
    total_visits = len(visits)
    unique_users = len(set(v.user_id for v in visits if v.user_id))
    
    # Calculate daily average
    days = max(1, (now - start_date).days)
    avg_daily = round(total_visits / days, 1)
    
    # Get hourly distribution
    hourly_dist = {}
    for v in visits:
        if v.check_in_time:
            hour = v.check_in_time.hour
            hourly_dist[hour] = hourly_dist.get(hour, 0) + 1
    
    peak_hours = []
    max_visits = max(hourly_dist.values()) if hourly_dist else 1
    for hour in range(8, 22, 2):
        count = hourly_dist.get(hour, 0) + hourly_dist.get(hour + 1, 0)
        peak_hours.append({
            "hour": f"{hour:02d}:00",
            "percentage": round((count / max(1, max_visits * 2)) * 100)
        })
    
    # Get daily breakdown for the week
    daily_data = []
    day_names = ['Dush', 'Sesh', 'Chor', 'Pay', 'Jum', 'Shan', 'Yak']
    for i in range(7):
        day = now - timedelta(days=6-i)
        day_visits = len([v for v in visits if v.check_in_time and v.check_in_time.date() == day.date()])
        daily_data.append({
            "day": day_names[day.weekday()],
            "visits": day_visits
        })
    
    # Top clients - group visits by user, get names
    from sqlalchemy import func as sqlfunc
    top_users_q = db.query(
        Visit.user_id,
        sqlfunc.count(Visit.id).label("visit_count"),
        sqlfunc.max(Visit.check_in_time).label("last_visit")
    ).filter(
        Visit.partner_id == partner_id,
        Visit.user_id.isnot(None)
    ).group_by(Visit.user_id).order_by(sqlfunc.count(Visit.id).desc()).limit(10).all()
    
    top_clients = []
    for row in top_users_q:
        user = db.query(User).filter(User.id == row.user_id).first()
        if user:
            last_visit_str = ""
            if row.last_visit:
                diff = now - row.last_visit
                if diff.days == 0:
                    hours = diff.seconds // 3600
                    last_visit_str = f"{hours} soat oldin" if hours > 0 else "Hozirgina"
                elif diff.days == 1:
                    last_visit_str = "1 kun oldin"
                elif diff.days < 7:
                    last_visit_str = f"{diff.days} kun oldin"
                elif diff.days < 30:
                    last_visit_str = f"{diff.days // 7} hafta oldin"
                else:
                    last_visit_str = f"{diff.days // 30} oy oldin"
            top_clients.append({
                "name": user.full_name or user.phone_number or "Noma'lum",
                "visits": row.visit_count,
                "lastVisit": last_visit_str
            })
    
    return {
        "total_visits": total_visits,
        "unique_clients": unique_users,
        "avg_daily": avg_daily,
        "avg_time": "25 min",
        "weekly_data": daily_data,
        "peak_hours": peak_hours,
        "top_clients": top_clients,
        "period": period
    }

# ============ MERCHANT EARNINGS API ============

@app.get("/merchant/earnings")
async def get_merchant_earnings(partner_id: str, db: Session = Depends(get_db)):
    """Get earnings for a merchant"""
    now = datetime.utcnow()
    
    # Get all visits for this partner
    all_visits = db.query(Visit).filter(Visit.partner_id == partner_id).all()
    
    # Calculate earnings (50,000 UZS per visit)
    rate_per_visit = 50000
    
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    week_start = now - timedelta(days=7)
    month_start = now - timedelta(days=30)
    
    today_visits = len([v for v in all_visits if v.check_in_time and v.check_in_time >= today_start])
    week_visits = len([v for v in all_visits if v.check_in_time and v.check_in_time >= week_start])
    month_visits = len([v for v in all_visits if v.check_in_time and v.check_in_time >= month_start])
    total_visits = len(all_visits)
    
    # Weekly breakdown
    weekly_breakdown = []
    for i in range(4):
        week_end = now - timedelta(days=i*7)
        week_begin = week_end - timedelta(days=7)
        week_count = len([v for v in all_visits if v.check_in_time and week_begin <= v.check_in_time < week_end])
        weekly_breakdown.append({
            "period": f"Week {4-i}",
            "amount": week_count * rate_per_visit
        })
    
    return {
        "today": today_visits * rate_per_visit,
        "week": week_visits * rate_per_visit,
        "month": month_visits * rate_per_visit,
        "total": total_visits * rate_per_visit,
        "weekly_breakdown": weekly_breakdown,
        "rate_per_visit": rate_per_visit
    }

# ============ MERCHANT DASHBOARD STATS ============

@app.get("/merchant/dashboard")
async def get_merchant_dashboard(partner_id: str, db: Session = Depends(get_db)):
    """Get dashboard stats for a merchant"""
    now = datetime.utcnow()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    month_start = now - timedelta(days=30)
    
    # Get visits
    all_visits = db.query(Visit).filter(Visit.partner_id == partner_id).all()
    today_visits = len([v for v in all_visits if v.check_in_time and v.check_in_time >= today_start])
    month_visits = len([v for v in all_visits if v.check_in_time and v.check_in_time >= month_start])
    
    # Get unique clients
    unique_clients = len(set(v.user_id for v in all_visits if v.user_id))
    
    # Get branches count
    branches = db.query(func.count(PartnerLocation.id)).filter(
        PartnerLocation.partner_id == partner_id,
        PartnerLocation.is_active == True
    ).scalar() or 0
    
    # Recent visits
    recent = db.query(Visit).filter(
        Visit.partner_id == partner_id
    ).order_by(Visit.check_in_time.desc()).limit(5).all()
    
    recent_visits = [{
        "id": str(v.id),
        "check_in_time": v.check_in_time.isoformat() if v.check_in_time else None,
        "status": v.status
    } for v in recent]
    
    return {
        "today_visits": today_visits,
        "total_visits": len(all_visits),
        "total_clients": unique_clients,
        "monthly_earnings": month_visits * 50000,
        "branches_count": branches,
        "recent_visits": recent_visits
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8003)
