from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Partner, PartnerLocation, PartnerStaff, Base
from shared.schemas import (
    PartnerCreate, PartnerUpdate, PartnerResponse,
    PartnerLocationCreate, PartnerLocationResponse,
    PartnerStaffCreate, PartnerStaffResponse
)
from shared.auth import AuthHandler
from shared.utils import generate_pin_code

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Partner Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

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

# Staff Login
@app.post("/staff/login")
async def staff_login(
    phone_number: str,
    pin_code: str,
    db: Session = Depends(get_db)
):
    """Staff login with phone and PIN"""
    from shared.auth import AuthHandler
    
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.phone_number == phone_number,
        PartnerStaff.is_active == True
    ).first()
    
    if not staff or staff.pin_code != pin_code:
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8003)
