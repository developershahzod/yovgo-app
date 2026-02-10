"""
Mobile API Routes for Flutter App
New endpoints specifically designed for the redesigned mobile app
"""
from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta
import math
import sys
import os

# Add shared module to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from shared.database import get_db
from shared.models import Partner, PartnerLocation, User, Subscription, Visit, SubscriptionPlan, Review
from shared.auth import AuthHandler

# Get current user dependency
get_current_user = AuthHandler.get_current_user

router = APIRouter(tags=["Mobile App"])


def _get_partner_rating(db: Session, partner_id) -> dict:
    """Get real average rating and review count from reviews table"""
    from sqlalchemy import func as sqlfunc
    avg = db.query(sqlfunc.avg(Review.rating)).filter(
        Review.partner_id == partner_id, Review.is_visible == True
    ).scalar()
    count = db.query(sqlfunc.count(Review.id)).filter(
        Review.partner_id == partner_id, Review.is_visible == True
    ).scalar() or 0
    return {
        "rating": round(float(avg), 1) if avg else 0,
        "review_count": count,
    }


# ==================== CAR WASH ENDPOINTS ====================

@router.get("/car-washes/nearby")
async def get_nearby_car_washes(
    latitude: float = Query(..., description="User latitude"),
    longitude: float = Query(..., description="User longitude"),
    limit: int = Query(10, ge=1, le=50),
    radius_km: float = Query(10.0, ge=1, le=50),
    db: Session = Depends(get_db),
):
    """Get nearby car washes based on user location"""
    
    # Get all active partners
    partners = db.query(Partner).filter(Partner.is_active == True).all()
    
    # Calculate distance and filter
    nearby_partners = []
    for partner in partners:
        # Use partner's own lat/lng or fall back to first location
        p_lat = float(partner.latitude) if partner.latitude else None
        p_lng = float(partner.longitude) if partner.longitude else None
        p_addr = partner.address or ""
        
        if not p_lat or not p_lng:
            # Try to get from first location
            loc = db.query(PartnerLocation).filter(
                PartnerLocation.partner_id == partner.id,
                PartnerLocation.is_active == True
            ).first()
            if loc:
                p_lat = float(loc.latitude) if loc.latitude else None
                p_lng = float(loc.longitude) if loc.longitude else None
                p_addr = p_addr or loc.address or ""
        
        if p_lat and p_lng:
            distance = calculate_distance(latitude, longitude, p_lat, p_lng)
            
            if distance <= radius_km:
                gallery = []
                try:
                    if partner.gallery_urls:
                        gallery = list(partner.gallery_urls)
                except Exception:
                    pass
                rv = _get_partner_rating(db, partner.id)
                nearby_partners.append({
                    "id": str(partner.id),
                    "name": partner.name,
                    "address": p_addr,
                    "latitude": p_lat,
                    "longitude": p_lng,
                    "distance": round(distance, 1),
                    "rating": rv["rating"] if rv["review_count"] > 0 else (float(partner.rating) if partner.rating else 0),
                    "review_count": rv["review_count"],
                    "is_open": is_currently_open(partner),
                    "status": get_status_text(partner),
                    "images": gallery,
                    "image_url": getattr(partner, 'logo_url', None) or '',
                    "logo_url": getattr(partner, 'logo_url', None) or '',
                    "gallery_urls": gallery,
                    "amenities": partner.amenities if partner.amenities else [],
                    "additional_services": partner.additional_services if partner.additional_services else [],
                    "phone_number": partner.phone_number or "",
                    "opening_hours": get_working_hours_str(partner),
                    "working_hours": partner.working_hours,
                    "is_premium": partner.is_premium or False,
                    "is_24_hours": getattr(partner, 'is_24_hours', False) or False,
                    "service_type": getattr(partner, 'service_type', 'full_service') or 'full_service',
                    "description": partner.description or "",
                    "wash_time": getattr(partner, 'wash_time', 60) or 60,
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
):
    """Get premium car washes"""
    
    partners = db.query(Partner).filter(
        Partner.is_active == True,
        Partner.is_premium == True
    ).limit(limit).all()
    
    result = []
    for partner in partners:
        gallery = []
        try:
            if partner.gallery_urls:
                gallery = list(partner.gallery_urls)
        except Exception:
            pass
        rv = _get_partner_rating(db, partner.id)
        result.append({
            "id": str(partner.id),
            "name": partner.name,
            "address": partner.address or "",
            "latitude": float(partner.latitude) if partner.latitude else None,
            "longitude": float(partner.longitude) if partner.longitude else None,
            "distance": 0.0,
            "rating": rv["rating"] if rv["review_count"] > 0 else (float(partner.rating) if partner.rating else 0),
            "review_count": rv["review_count"],
            "is_open": is_currently_open(partner),
            "status": get_status_text(partner),
            "images": gallery,
            "image_url": getattr(partner, 'logo_url', None) or '',
            "logo_url": getattr(partner, 'logo_url', None) or '',
            "gallery_urls": gallery,
            "amenities": partner.amenities if partner.amenities else [],
            "additional_services": partner.additional_services if partner.additional_services else [],
            "phone_number": partner.phone_number or "",
            "opening_hours": get_working_hours_str(partner),
            "working_hours": partner.working_hours,
            "is_premium": True,
            "is_24_hours": getattr(partner, 'is_24_hours', False) or False,
            "service_type": getattr(partner, 'service_type', 'full_service') or 'full_service',
            "description": partner.description or "",
            "wash_time": getattr(partner, 'wash_time', 60) or 60,
        })
    
    return {
        "success": True,
        "partners": result,
        "count": len(result)
    }


@router.get("/car-washes/search")
async def search_car_washes(
    q: str = Query(..., min_length=1),
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db),
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
            "address": partner.address or "",
            "rating": float(partner.rating) if partner.rating else 0,
            "is_open": is_currently_open(partner),
            "image_url": getattr(partner, 'logo_url', None) or '',
        })
    
    return {
        "success": True,
        "partners": result,
        "count": len(result)
    }


@router.get("/car-washes/{partner_id}")
async def get_car_wash_detail(
    partner_id: str,
    db: Session = Depends(get_db),
):
    """Get detailed information about a car wash"""
    
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Car wash not found")
    
    gallery = []
    try:
        if partner.gallery_urls:
            gallery = list(partner.gallery_urls)
    except Exception:
        pass
    rv = _get_partner_rating(db, partner.id)
    return {
        "success": True,
        "partner": {
            "id": str(partner.id),
            "name": partner.name,
            "address": partner.address or "",
            "latitude": float(partner.latitude) if partner.latitude else None,
            "longitude": float(partner.longitude) if partner.longitude else None,
            "rating": rv["rating"] if rv["review_count"] > 0 else (float(partner.rating) if partner.rating else 0),
            "review_count": rv["review_count"],
            "is_open": is_currently_open(partner),
            "status": get_status_text(partner),
            "images": gallery,
            "image_url": getattr(partner, 'logo_url', None) or '',
            "logo_url": getattr(partner, 'logo_url', None) or '',
            "gallery_urls": gallery,
            "amenities": partner.amenities if partner.amenities else [],
            "additional_services": partner.additional_services if partner.additional_services else [],
            "phone_number": partner.phone_number or "",
            "opening_hours": get_working_hours_str(partner),
            "working_hours": partner.working_hours,
            "is_premium": partner.is_premium or False,
            "is_24_hours": getattr(partner, 'is_24_hours', False) or False,
            "service_type": getattr(partner, 'service_type', 'full_service') or 'full_service',
            "description": partner.description or "Premium avtomoyka xizmatlari",
            "wash_time": getattr(partner, 'wash_time', 60) or 60,
        }
    }


# ==================== SUBSCRIPTION ENDPOINTS ====================

@router.get("/subscriptions/plans")
async def get_subscription_plans(
    db: Session = Depends(get_db),
):
    """Get all available subscription plans"""
    
    plans = db.query(SubscriptionPlan).filter(SubscriptionPlan.is_active == True).all()
    
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
                f"{plan.visit_limit} ta tashrif" if plan.visit_limit else "Cheksiz tashrif",
                "Barcha hamkor avtomoykalar",
                "24/7 qo'llab-quvvatlash",
                "Chegirmalar va bonuslar"
            ],
            "is_popular": "premium" in plan.name.lower() or "90" in str(plan.duration_days),
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
    
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    
    subscription = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active",
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if not subscription:
        return {
            "success": True,
            "subscription": None
        }
    
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
    
    return {
        "success": True,
        "subscription": {
            "id": str(subscription.id),
            "plan_id": str(subscription.plan_id),
            "plan_name": plan.name if plan else "Unknown",
            "start_date": subscription.start_date.isoformat(),
            "end_date": subscription.end_date.isoformat(),
            "total_visits": plan.visit_limit if plan else 0,
            "used_visits": subscription.visits_used or 0,
            "remaining_visits": subscription.visits_remaining or 0,
            "is_unlimited": subscription.is_unlimited or False,
            "is_active": subscription.status == "active",
            "status": subscription.status,
        }
    }


@router.get("/subscriptions/my")
async def get_my_subscriptions(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all user subscriptions"""
    
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    
    subscriptions = db.query(Subscription).filter(
        Subscription.user_id == user_id
    ).order_by(Subscription.created_at.desc()).all()
    
    result = []
    for subscription in subscriptions:
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
        
        result.append({
            "id": str(subscription.id),
            "plan_id": str(subscription.plan_id),
            "plan_name": plan.name if plan else "Unknown",
            "start_date": subscription.start_date.isoformat(),
            "end_date": subscription.end_date.isoformat(),
            "total_visits": plan.visit_limit if plan else 0,
            "used_visits": subscription.visits_used or 0,
            "remaining_visits": subscription.visits_remaining or 0,
            "is_unlimited": subscription.is_unlimited or False,
            "is_active": subscription.status == "active",
            "status": subscription.status,
        })
    
    return {
        "success": True,
        "subscriptions": result,
        "count": len(result)
    }


class CreateSubscriptionRequest(BaseModel):
    plan_id: str
    auto_renew: bool = False

@router.post("/subscriptions/create")
async def create_subscription(
    request: CreateSubscriptionRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new subscription"""
    plan_id = request.plan_id
    
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    
    # Check if user already has active subscription
    existing = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active",
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if existing:
        raise HTTPException(status_code=400, detail="You already have an active subscription")
    
    # Create new subscription
    subscription = Subscription(
        user_id=user_id,
        plan_id=plan_id,
        start_date=datetime.utcnow(),
        end_date=datetime.utcnow() + timedelta(days=plan.duration_days),
        status="pending",
        visits_used=0,
        visits_remaining=plan.visit_limit or 0,
        is_unlimited=plan.is_unlimited if hasattr(plan, 'is_unlimited') else False,
        auto_renew=False
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
    
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    
    try:
        parts = qr_token.split("_")
        if len(parts) >= 2 and parts[0] == "MERCHANT":
            partner_id = parts[1]  # UUID string, not int
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
        Subscription.user_id == user_id,
        Subscription.status == "active",
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=400, detail="No active subscription")
    
    # Check visit limit
    if not subscription.is_unlimited and subscription.visits_remaining is not None and subscription.visits_remaining <= 0:
        raise HTTPException(status_code=400, detail="Visit limit reached")
    
    # Create visit
    visit = Visit(
        user_id=user_id,
        partner_id=partner_id,
        subscription_id=subscription.id,
        check_in_time=datetime.utcnow(),
        status="completed"
    )
    
    db.add(visit)
    
    # Update subscription counters
    subscription.visits_used = (subscription.visits_used or 0) + 1
    if not subscription.is_unlimited and subscription.visits_remaining is not None:
        subscription.visits_remaining -= 1
    
    db.commit()
    db.refresh(visit)
    
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
    
    return {
        "success": True,
        "message": "Tashrif muvaffaqiyatli ro'yxatdan o'tkazildi!",
        "partner_name": partner.name,
        "visit_id": str(visit.id),
        "remaining_visits": subscription.visits_remaining if not subscription.is_unlimited else "unlimited"
    }


# ==================== USER ENDPOINTS ====================

@router.get("/users/me")
async def get_my_profile(
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user)
):
    """Get current user profile"""
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return {
        "success": True,
        "user": {
            "id": str(user.id),
            "full_name": user.full_name,
            "phone_number": user.phone_number,
            "email": user.email,
            "avatar_url": None,
        }
    }


@router.get("/users/stats")
async def get_user_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get user statistics"""
    
    from sqlalchemy import func as sqlfunc
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    
    # Count total visits
    total_visits = db.query(Visit).filter(Visit.user_id == user_id).count()
    
    # Count unique car washes visited
    unique_partners = db.query(sqlfunc.count(sqlfunc.distinct(Visit.partner_id))).filter(
        Visit.user_id == user_id
    ).scalar() or 0
    
    # Count active subscription
    active_subscription = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active",
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    # Calculate savings (avg car wash = 50,000 UZS, subscription gives discount)
    total_savings = total_visits * 15000  # ~15,000 UZS saved per visit vs pay-per-wash
    
    return {
        "success": True,
        "stats": {
            "total_car_washes": unique_partners,
            "total_visits": total_visits,
            "total_savings": total_savings,
            "active_subscription": active_subscription is not None,
        }
    }


# ==================== REVIEW ENDPOINTS ====================

class CreateReviewRequest(BaseModel):
    partner_id: str
    rating: int  # 1-5
    comment: Optional[str] = None
    visit_id: Optional[str] = None

@router.post("/reviews")
async def create_review(
    request: CreateReviewRequest,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Submit a review for a car wash"""
    from sqlalchemy import func as sqlfunc

    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id

    if request.rating < 1 or request.rating > 5:
        raise HTTPException(status_code=400, detail="Reyting 1 dan 5 gacha bo'lishi kerak")

    # Check partner exists
    partner = db.query(Partner).filter(Partner.id == request.partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Avtomoyka topilmadi")

    # Check if user already reviewed this partner (allow one review per partner, update if exists)
    existing = db.query(Review).filter(
        Review.user_id == user_id,
        Review.partner_id == request.partner_id,
    ).first()

    if existing:
        existing.rating = request.rating
        existing.comment = request.comment or existing.comment
        if request.visit_id:
            existing.visit_id = request.visit_id
        db.commit()
        db.refresh(existing)
        review_id = str(existing.id)
    else:
        review = Review(
            user_id=user_id,
            partner_id=request.partner_id,
            visit_id=request.visit_id if request.visit_id else None,
            rating=request.rating,
            comment=request.comment,
        )
        db.add(review)
        db.commit()
        db.refresh(review)
        review_id = str(review.id)

    # Update partner average rating
    avg = db.query(sqlfunc.avg(Review.rating)).filter(
        Review.partner_id == request.partner_id,
        Review.is_visible == True,
    ).scalar()
    if avg is not None:
        partner.rating = round(float(avg), 2)
        db.commit()

    return {
        "success": True,
        "message": "Bahoingiz qabul qilindi!",
        "review_id": review_id,
    }


@router.get("/reviews/partner/{partner_id}")
async def get_partner_reviews(
    partner_id: str,
    limit: int = Query(20, ge=1, le=100),
    offset: int = Query(0, ge=0),
    db: Session = Depends(get_db),
):
    """Get reviews for a car wash"""
    from sqlalchemy import func as sqlfunc

    reviews = (
        db.query(Review)
        .filter(Review.partner_id == partner_id, Review.is_visible == True)
        .order_by(Review.created_at.desc())
        .offset(offset)
        .limit(limit)
        .all()
    )

    total = db.query(sqlfunc.count(Review.id)).filter(
        Review.partner_id == partner_id, Review.is_visible == True
    ).scalar() or 0

    avg_rating = db.query(sqlfunc.avg(Review.rating)).filter(
        Review.partner_id == partner_id, Review.is_visible == True
    ).scalar()

    # Rating distribution
    dist = {}
    for star in range(1, 6):
        cnt = db.query(sqlfunc.count(Review.id)).filter(
            Review.partner_id == partner_id,
            Review.is_visible == True,
            Review.rating == star,
        ).scalar() or 0
        dist[str(star)] = cnt

    result = []
    for r in reviews:
        user = db.query(User).filter(User.id == r.user_id).first()
        result.append({
            "id": str(r.id),
            "rating": r.rating,
            "comment": r.comment or "",
            "user_name": user.full_name if user and user.full_name else "Foydalanuvchi",
            "user_phone": _mask_phone(user.phone_number) if user else "",
            "created_at": r.created_at.isoformat() if r.created_at else None,
        })

    return {
        "success": True,
        "reviews": result,
        "total": total,
        "average_rating": round(float(avg_rating), 1) if avg_rating else 0,
        "distribution": dist,
    }


@router.get("/reviews/my")
async def get_my_reviews(
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Get current user's reviews"""
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id

    reviews = (
        db.query(Review)
        .filter(Review.user_id == user_id)
        .order_by(Review.created_at.desc())
        .all()
    )

    result = []
    for r in reviews:
        partner = db.query(Partner).filter(Partner.id == r.partner_id).first()
        result.append({
            "id": str(r.id),
            "partner_id": str(r.partner_id),
            "partner_name": partner.name if partner else "",
            "rating": r.rating,
            "comment": r.comment or "",
            "created_at": r.created_at.isoformat() if r.created_at else None,
        })

    return {"success": True, "reviews": result}


def _mask_phone(phone: str) -> str:
    """Mask phone number: +998 90 *** ** 61"""
    if not phone or len(phone) < 9:
        return ""
    return phone[:7] + " *** ** " + phone[-2:]


# ==================== WEATHER ENDPOINT ====================

import httpx

# WMO Weather interpretation codes -> our weather types
def _wmo_to_weather_type(code: int) -> str:
    """Convert WMO weather code to our weather type string"""
    if code <= 1:
        return "sunny"
    if code <= 3:
        return "cloudy"
    if code in (45, 48):
        return "fog"
    if code in (51, 53, 55, 56, 57):
        return "drizzle"
    if code in (61, 63, 65, 66, 67, 80, 81, 82):
        return "rain"
    if code in (71, 73, 75, 77, 85, 86):
        return "snow"
    if code in (95, 96, 99):
        return "thunderstorm"
    return "cloudy"

def _calc_wash_rating(precip_prob: int, wmo_code: int) -> int:
    """Calculate wash rating 0-100. Higher = better time to wash car.
    Based on precipitation probability and weather condition."""
    base = max(0, 100 - precip_prob)
    # Penalize bad conditions even if probability is low
    if wmo_code in (95, 96, 99):  # thunderstorm
        base = min(base, 15)
    elif wmo_code in (61, 63, 65, 66, 67, 80, 81, 82):  # rain
        base = min(base, 25)
    elif wmo_code in (71, 73, 75, 77, 85, 86):  # snow
        base = min(base, 20)
    elif wmo_code in (51, 53, 55, 56, 57):  # drizzle
        base = min(base, 40)
    elif wmo_code in (45, 48):  # fog
        base = max(base - 15, 10)
    return max(0, min(100, base))

def _wash_recommendation(rating: int, lang: str = "uz") -> str:
    if lang == "ru":
        if rating >= 80: return "Отличная погода для мойки автомобиля!"
        if rating >= 50: return "Хорошая погода, можно помыть машину."
        if rating >= 30: return "Возможен дождь, лучше подождать."
        return "Плохая погода для мойки. Ожидаются осадки."
    elif lang == "en":
        if rating >= 80: return "Perfect weather to wash your car!"
        if rating >= 50: return "Good weather, you can wash your car."
        if rating >= 30: return "Rain possible, better to wait."
        return "Bad weather for washing. Precipitation expected."
    else:
        if rating >= 80: return "Avtomobil yuvish uchun ajoyib ob-havo!"
        if rating >= 50: return "Yaxshi ob-havo, mashinani yuvish mumkin."
        if rating >= 30: return "Yomg'ir yog'ishi mumkin, kutgan ma'qul."
        return "Yuvish uchun yomon ob-havo. Yog'ingarchilik kutilmoqda."

_WEEKDAY_NAMES = {
    "uz": ["Du", "Se", "Cho", "Pa", "Ju", "Sha", "Ya"],
    "ru": ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
    "en": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
}

@router.get("/weather")
async def get_weather(
    latitude: float = Query(41.311, description="Latitude"),
    longitude: float = Query(69.279, description="Longitude"),
    lang: str = Query("uz", description="Language: uz, ru, en"),
):
    """Get real weather data + wash rating from Open-Meteo (free, no API key)"""
    
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            resp = await client.get(
                "https://api.open-meteo.com/v1/forecast",
                params={
                    "latitude": latitude,
                    "longitude": longitude,
                    "current": "temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m",
                    "daily": "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max",
                    "timezone": "Asia/Tashkent",
                    "forecast_days": 7,
                },
            )
        
        if resp.status_code != 200:
            return _fallback_weather(lang)
        
        data = resp.json()
        
        # Current weather
        cur = data.get("current", {})
        cur_temp = round(cur.get("temperature_2m", 0))
        cur_wmo = cur.get("weather_code", 0)
        cur_humidity = cur.get("relative_humidity_2m", 0)
        cur_wind = round(cur.get("wind_speed_10m", 0), 1)
        cur_type = _wmo_to_weather_type(cur_wmo)
        
        # Daily forecast
        daily = data.get("daily", {})
        times = daily.get("time", [])
        codes = daily.get("weather_code", [])
        t_max = daily.get("temperature_2m_max", [])
        t_min = daily.get("temperature_2m_min", [])
        precip_probs = daily.get("precipitation_probability_max", [])
        
        weekday_names = _WEEKDAY_NAMES.get(lang, _WEEKDAY_NAMES["uz"])
        
        forecast_days = []
        rain_free_days = 0
        checked_rain = True
        
        for i in range(min(len(times), 6)):
            dt = datetime.strptime(times[i], "%Y-%m-%d")
            wmo = codes[i] if i < len(codes) else 0
            prob = precip_probs[i] if i < len(precip_probs) else 0
            temp_hi = round(t_max[i]) if i < len(t_max) else 0
            temp_lo = round(t_min[i]) if i < len(t_min) else 0
            
            weather_type = _wmo_to_weather_type(wmo)
            day_rating = _calc_wash_rating(prob, wmo)
            
            if checked_rain and day_rating >= 60:
                rain_free_days += 1
            else:
                checked_rain = False
            
            weekday = weekday_names[dt.weekday()]
            temp_str = f"+{temp_hi}°" if temp_hi >= 0 else f"{temp_hi}°"
            
            forecast_days.append({
                "day": str(dt.day),
                "weekday": weekday,
                "weather": weather_type,
                "temp": temp_str,
                "temp_min": f"+{temp_lo}°" if temp_lo >= 0 else f"{temp_lo}°",
                "wash_rating": day_rating,
                "precip_prob": prob,
            })
        
        # Today's wash rating
        today_prob = precip_probs[0] if precip_probs else 0
        today_wmo = codes[0] if codes else 0
        today_rating = _calc_wash_rating(today_prob, today_wmo)
        
        # Recommendation
        recommendation = _wash_recommendation(today_rating, lang)
        if rain_free_days >= 3 and today_rating >= 70:
            if lang == "ru":
                recommendation = f"{rain_free_days} дней без дождя. Отличное время для мойки!"
            elif lang == "en":
                recommendation = f"{rain_free_days} rain-free days ahead. Great time to wash!"
            else:
                recommendation = f"{rain_free_days} kun davomida yog'ingarchilik kutilmaydi. Yuvish uchun ajoyib vaqt!"
        
        return {
            "success": True,
            "wash_rating": today_rating,
            "recommendation": recommendation,
            "current": {
                "temperature": cur_temp,
                "weather_type": cur_type,
                "humidity": cur_humidity,
                "wind_speed": cur_wind,
                "city": "Toshkent",
            },
            "forecast": forecast_days,
        }
        
    except Exception as e:
        print(f"Weather API error: {e}")
        return _fallback_weather(lang)


def _fallback_weather(lang: str = "uz"):
    """Fallback weather data when API is unavailable"""
    now = datetime.now()
    weekday_names = _WEEKDAY_NAMES.get(lang, _WEEKDAY_NAMES["uz"])
    days = []
    for i in range(6):
        d = now + timedelta(days=i)
        days.append({
            "day": str(d.day),
            "weekday": weekday_names[d.weekday()],
            "weather": "sunny" if i < 3 else ("cloudy" if i < 5 else "rain"),
            "temp": f"+{12 + i}°",
            "temp_min": f"+{5 + i}°",
            "wash_rating": max(10, 90 - i * 15),
            "precip_prob": min(90, i * 18),
        })
    
    rec = "Ob-havo ma'lumotlari vaqtincha mavjud emas."
    if lang == "ru": rec = "Данные о погоде временно недоступны."
    if lang == "en": rec = "Weather data temporarily unavailable."
    
    return {
        "success": True,
        "wash_rating": 75,
        "recommendation": rec,
        "current": {
            "temperature": 14,
            "weather_type": "sunny",
            "humidity": 45,
            "wind_speed": 3.5,
            "city": "Toshkent",
        },
        "forecast": days,
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


def get_working_hours_str(partner: Partner) -> str:
    """Get working hours string from partner"""
    wh = partner.working_hours
    if isinstance(wh, dict):
        open_time = wh.get('open', '08:00')
        close_time = wh.get('close', '22:00')
        return f"{open_time} - {close_time}"
    if isinstance(wh, str) and wh:
        return wh
    return "08:00 - 22:00"


def get_status_text(partner: Partner) -> str:
    """Get status text for partner"""
    if is_currently_open(partner):
        return "22:00 GACHA OCHIQ"
    else:
        return "YOPIQ 8:00 GACHA"
