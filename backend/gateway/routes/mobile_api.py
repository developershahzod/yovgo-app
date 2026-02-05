"""
Mobile API Routes for Flutter App
New endpoints specifically designed for the redesigned mobile app
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, timedelta
import math
import sys
import os

# Add shared module to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from shared.database import get_db
from shared.models import Partner, User, Subscription, Visit, Plan
from shared.auth import AuthHandler

# Get current user dependency
get_current_user = AuthHandler.get_current_user

router = APIRouter(prefix="/api/mobile", tags=["Mobile App"])


# ==================== CAR WASH ENDPOINTS ====================

@router.get("/car-washes/nearby")
async def get_nearby_car_washes(
    latitude: float = Query(..., description="User latitude"),
    longitude: float = Query(..., description="User longitude"),
    limit: int = Query(10, ge=1, le=50),
    radius_km: float = Query(10.0, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get nearby car washes based on user location"""
    
    # Get all active partners
    partners = db.query(Partner).filter(Partner.is_active == True).all()
    
    # Calculate distance and filter
    nearby_partners = []
    for partner in partners:
        if partner.latitude and partner.longitude:
            # Calculate distance using Haversine formula
            distance = calculate_distance(
                latitude, longitude,
                partner.latitude, partner.longitude
            )
            
            if distance <= radius_km:
                nearby_partners.append({
                    "id": str(partner.id),
                    "name": partner.name,
                    "address": partner.address,
                    "latitude": partner.latitude,
                    "longitude": partner.longitude,
                    "distance": round(distance, 1),
                    "rating": 4.5,  # TODO: Calculate from reviews
                    "review_count": 0,  # TODO: Count reviews
                    "is_open": is_currently_open(partner),
                    "status": get_status_text(partner),
                    "images": [],  # TODO: Add partner images
                    "amenities": ["Kutish zali", "WiFi"],
                    "phone_number": partner.phone_number or "",
                    "opening_hours": "08:00 - 22:00",  # TODO: Add to model
                    "is_premium": partner.is_premium or False,
                    "is_24_hours": False,  # TODO: Add to model
                })
    
    # Sort by distance
    nearby_partners.sort(key=lambda x: x["distance"])
    
    return {
        "success": True,
        "partners": nearby_partners[:limit],
        "count": len(nearby_partners)
    }


@router.get("/car-washes/premium")
async def get_premium_car_washes(
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get premium car washes"""
    
    partners = db.query(Partner).filter(
        Partner.is_active == True,
        Partner.is_premium == True
    ).limit(limit).all()
    
    result = []
    for partner in partners:
        result.append({
            "id": str(partner.id),
            "name": partner.name,
            "address": partner.address,
            "latitude": partner.latitude,
            "longitude": partner.longitude,
            "distance": 0.0,  # TODO: Calculate if user location available
            "rating": 4.5,
            "review_count": 0,
            "is_open": is_currently_open(partner),
            "status": get_status_text(partner),
            "images": [],
            "amenities": ["Kutish zali", "Ko'ngilochar o'yinlar", "Do'kon"],
            "phone_number": partner.phone_number or "",
            "opening_hours": "08:00 - 22:00",
            "is_premium": True,
            "is_24_hours": False,
        })
    
    return {
        "success": True,
        "partners": result,
        "count": len(result)
    }


@router.get("/car-washes/{partner_id}")
async def get_car_wash_detail(
    partner_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get detailed information about a car wash"""
    
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Car wash not found")
    
    return {
        "success": True,
        "partner": {
            "id": str(partner.id),
            "name": partner.name,
            "address": partner.address,
            "latitude": partner.latitude,
            "longitude": partner.longitude,
            "rating": 4.5,
            "review_count": 0,
            "is_open": is_currently_open(partner),
            "status": get_status_text(partner),
            "images": [],
            "amenities": ["Kutish zali", "Ko'ngilochar o'yinlar", "Do'kon"],
            "phone_number": partner.phone_number or "",
            "opening_hours": "08:00 - 22:00",
            "is_premium": partner.is_premium or False,
            "is_24_hours": False,
            "description": "Premium avtomoyka xizmatlari",
        }
    }


@router.get("/car-washes/search")
async def search_car_washes(
    q: str = Query(..., min_length=1),
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Search car washes by name or address"""
    
    partners = db.query(Partner).filter(
        Partner.is_active == True,
        (Partner.name.ilike(f"%{q}%") | Partner.address.ilike(f"%{q}%"))
    ).limit(limit).all()
    
    result = []
    for partner in partners:
        result.append({
            "id": str(partner.id),
            "name": partner.name,
            "address": partner.address,
            "rating": 4.5,
            "distance": 0.0,
            "is_open": is_currently_open(partner),
        })
    
    return {
        "success": True,
        "partners": result,
        "count": len(result)
    }


# ==================== SUBSCRIPTION ENDPOINTS ====================

@router.get("/subscriptions/plans")
async def get_subscription_plans(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all available subscription plans"""
    
    plans = db.query(Plan).filter(Plan.is_active == True).all()
    
    result = []
    for plan in plans:
        result.append({
            "id": str(plan.id),
            "name": plan.name,
            "description": plan.description or "",
            "price": float(plan.price),
            "duration_days": plan.duration_days,
            "visit_limit": plan.visit_limit,
            "features": [
                f"{plan.visit_limit} ta tashrif",
                "Barcha hamkor avtomoykalar",
                "24/7 qo'llab-quvvatlash",
                "Chegirmalar va bonuslar"
            ],
            "is_popular": plan.name.lower().find("90") >= 0,  # 90-day plan is popular
            "discount": None,
        })
    
    return {
        "success": True,
        "plans": result,
        "count": len(result)
    }


@router.get("/subscriptions/active")
async def get_active_subscription(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get user's active subscription"""
    
    subscription = db.query(Subscription).filter(
        Subscription.user_id == current_user.id,
        Subscription.is_active == True,
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if not subscription:
        return {
            "success": True,
            "subscription": None
        }
    
    plan = db.query(Plan).filter(Plan.id == subscription.plan_id).first()
    
    # Count used visits
    used_visits = db.query(Visit).filter(
        Visit.user_id == current_user.id,
        Visit.subscription_id == subscription.id
    ).count()
    
    return {
        "success": True,
        "subscription": {
            "id": str(subscription.id),
            "plan_id": str(subscription.plan_id),
            "plan_name": plan.name if plan else "Unknown",
            "start_date": subscription.start_date.isoformat(),
            "end_date": subscription.end_date.isoformat(),
            "total_visits": subscription.visit_limit,
            "used_visits": used_visits,
            "is_active": subscription.is_active,
            "status": "active" if subscription.is_active else "inactive",
        }
    }


@router.get("/subscriptions/my")
async def get_my_subscriptions(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all user subscriptions"""
    
    subscriptions = db.query(Subscription).filter(
        Subscription.user_id == current_user.id
    ).order_by(Subscription.created_at.desc()).all()
    
    result = []
    for subscription in subscriptions:
        plan = db.query(Plan).filter(Plan.id == subscription.plan_id).first()
        used_visits = db.query(Visit).filter(
            Visit.user_id == current_user.id,
            Visit.subscription_id == subscription.id
        ).count()
        
        result.append({
            "id": str(subscription.id),
            "plan_id": str(subscription.plan_id),
            "plan_name": plan.name if plan else "Unknown",
            "start_date": subscription.start_date.isoformat(),
            "end_date": subscription.end_date.isoformat(),
            "total_visits": subscription.visit_limit,
            "used_visits": used_visits,
            "is_active": subscription.is_active,
            "status": "active" if subscription.is_active else "inactive",
        })
    
    return {
        "success": True,
        "subscriptions": result,
        "count": len(result)
    }


@router.post("/subscriptions/create")
async def create_subscription(
    plan_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new subscription"""
    
    plan = db.query(Plan).filter(Plan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    
    # Check if user already has active subscription
    existing = db.query(Subscription).filter(
        Subscription.user_id == current_user.id,
        Subscription.is_active == True,
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if existing:
        raise HTTPException(status_code=400, detail="You already have an active subscription")
    
    # Create new subscription
    subscription = Subscription(
        user_id=current_user.id,
        plan_id=plan_id,
        start_date=datetime.utcnow(),
        end_date=datetime.utcnow() + timedelta(days=plan.duration_days),
        visit_limit=plan.visit_limit,
        is_active=True
    )
    
    db.add(subscription)
    db.commit()
    db.refresh(subscription)
    
    return {
        "success": True,
        "message": "Subscription created successfully",
        "subscription_id": str(subscription.id)
    }


# ==================== QR & VISIT ENDPOINTS ====================

@router.post("/visits/checkin")
async def qr_checkin(
    qr_token: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Check in at a car wash using QR code"""
    
    # TODO: Validate QR token and get partner_id
    # For now, extract partner_id from token format: MERCHANT_{partner_id}_{timestamp}
    
    try:
        parts = qr_token.split("_")
        if len(parts) >= 2 and parts[0] == "MERCHANT":
            partner_id = int(parts[1])
        else:
            raise ValueError("Invalid QR format")
    except:
        raise HTTPException(status_code=400, detail="Invalid QR code")
    
    # Get partner
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Car wash not found")
    
    # Get active subscription
    subscription = db.query(Subscription).filter(
        Subscription.user_id == current_user.id,
        Subscription.is_active == True,
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=400, detail="No active subscription")
    
    # Check visit limit
    used_visits = db.query(Visit).filter(
        Visit.user_id == current_user.id,
        Visit.subscription_id == subscription.id
    ).count()
    
    if used_visits >= subscription.visit_limit:
        raise HTTPException(status_code=400, detail="Visit limit reached")
    
    # Create visit
    visit = Visit(
        user_id=current_user.id,
        partner_id=partner_id,
        subscription_id=subscription.id,
        visit_date=datetime.utcnow(),
        status="completed"
    )
    
    db.add(visit)
    db.commit()
    db.refresh(visit)
    
    return {
        "success": True,
        "message": "Tashrif muvaffaqiyatli ro'yxatdan o'tkazildi!",
        "partner_name": partner.name,
        "visit_id": str(visit.id),
        "remaining_visits": subscription.visit_limit - used_visits - 1
    }


# ==================== USER ENDPOINTS ====================

@router.get("/users/me")
async def get_my_profile(
    current_user: User = Depends(get_current_user)
):
    """Get current user profile"""
    
    return {
        "success": True,
        "user": {
            "id": str(current_user.id),
            "full_name": current_user.full_name,
            "phone_number": current_user.phone_number,
            "email": current_user.email,
            "avatar_url": None,
        }
    }


@router.get("/users/stats")
async def get_user_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get user statistics"""
    
    # Count total visits
    total_visits = db.query(Visit).filter(Visit.user_id == current_user.id).count()
    
    # Count active subscription
    active_subscription = db.query(Subscription).filter(
        Subscription.user_id == current_user.id,
        Subscription.is_active == True,
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    return {
        "success": True,
        "stats": {
            "total_car_washes": 1,  # TODO: Count unique partners
            "total_visits": total_visits,
            "total_savings": 0,  # TODO: Calculate savings
            "active_subscription": active_subscription is not None,
        }
    }


# ==================== HELPER FUNCTIONS ====================

def calculate_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Calculate distance between two coordinates in kilometers using Haversine formula"""
    R = 6371  # Earth's radius in kilometers
    
    lat1_rad = math.radians(lat1)
    lat2_rad = math.radians(lat2)
    delta_lat = math.radians(lat2 - lat1)
    delta_lon = math.radians(lon2 - lon1)
    
    a = math.sin(delta_lat/2)**2 + math.cos(lat1_rad) * math.cos(lat2_rad) * math.sin(delta_lon/2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    
    return R * c


def is_currently_open(partner: Partner) -> bool:
    """Check if partner is currently open"""
    # TODO: Implement based on opening hours
    current_hour = datetime.now().hour
    return 8 <= current_hour <= 22


def get_status_text(partner: Partner) -> str:
    """Get status text for partner"""
    if is_currently_open(partner):
        return "22:00 GACHA OCHIQ"
    else:
        return "YOPIQ 8:00 GACHA"
