from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from pydantic import BaseModel
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import User, Vehicle, Base
from shared.schemas import UserCreate, UserUpdate, UserResponse, VehicleCreate, VehicleResponse
from shared.auth import AuthHandler
from shared.utils import format_phone_number

Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="YuvGo User Service",
    description="User and vehicle management service",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

auth_handler = AuthHandler()

@app.get("/")
async def root():
    return {"service": "YuvGo User Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# User Login Request Model
class UserLoginRequest(BaseModel):
    phone_number: str

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

@app.get("/users", response_model=List[UserResponse])
async def list_users(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """List all users (admin only)"""
    users = db.query(User).offset(skip).limit(limit).all()
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
