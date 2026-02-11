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
from shared.models import Partner, PartnerLocation, User, Subscription, Visit, SubscriptionPlan, Review, Payment, Vehicle
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
    latitude: Optional[float] = Query(None, description="User latitude"),
    longitude: Optional[float] = Query(None, description="User longitude"),
    lat: Optional[float] = Query(None, description="User latitude (alias)"),
    lng: Optional[float] = Query(None, description="User longitude (alias)"),
    limit: int = Query(10, ge=1, le=50),
    radius_km: float = Query(10.0, ge=1, le=50),
    radius: Optional[float] = Query(None, description="Radius alias"),
    db: Session = Depends(get_db),
):
    """Get nearby car washes based on user location"""
    # Support both lat/lng and latitude/longitude params
    latitude = latitude or lat
    longitude = longitude or lng
    if radius is not None:
        radius_km = radius
    if latitude is None or longitude is None:
        raise HTTPException(status_code=400, detail="latitude and longitude are required")
    
    # Get all active partners
    partners = db.query(Partner).filter(Partner.is_active == True).all()
    
    # Build a set of partner IDs that already have their own coordinates
    partner_ids_with_coords = set()
    
    # Calculate distance and filter
    nearby_partners = []
    for partner in partners:
        p_lat = float(partner.latitude) if partner.latitude else None
        p_lng = float(partner.longitude) if partner.longitude else None
        p_addr = partner.address or ""
        
        if not p_lat or not p_lng:
            loc = db.query(PartnerLocation).filter(
                PartnerLocation.partner_id == partner.id,
                PartnerLocation.is_active == True
            ).first()
            if loc:
                p_lat = float(loc.latitude) if loc.latitude else None
                p_lng = float(loc.longitude) if loc.longitude else None
                p_addr = p_addr or loc.address or ""
        
        if p_lat and p_lng:
            partner_ids_with_coords.add(str(partner.id))
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
                    "banner_url": getattr(partner, 'logo_url', None) or '',
                    "amenities": partner.amenities if partner.amenities else [],
                    "additional_services": partner.additional_services if partner.additional_services else [],
                    "phone_number": partner.phone or partner.phone_number or "",
                    "phone": partner.phone or partner.phone_number or "",
                    "opening_hours": get_working_hours_str(partner),
                    "working_hours": partner.working_hours,
                    "is_premium": partner.is_premium or False,
                    "is_24_hours": getattr(partner, 'is_24_hours', False) or False,
                    "service_type": getattr(partner, 'service_type', 'full_service') or 'full_service',
                    "description": partner.description or "",
                    "wash_time": getattr(partner, 'wash_time', 60) or 60,
                    "services": partner.additional_services if partner.additional_services else [],
                    "service_prices": [],
                })
    
    # Also include partner_locations (branches) as separate entries
    locations = db.query(PartnerLocation).filter(PartnerLocation.is_active == True).all()
    for loc in locations:
        l_lat = float(loc.latitude) if loc.latitude else None
        l_lng = float(loc.longitude) if loc.longitude else None
        if not l_lat or not l_lng:
            continue
        distance = calculate_distance(latitude, longitude, l_lat, l_lng)
        if distance > radius_km:
            continue
        # Get parent partner
        partner = db.query(Partner).filter(Partner.id == loc.partner_id).first()
        if not partner or not partner.is_active:
            continue
        # Build gallery
        gallery = []
        try:
            if loc.gallery_urls:
                gallery = list(loc.gallery_urls)
            elif partner.gallery_urls:
                gallery = list(partner.gallery_urls)
        except Exception:
            pass
        # Build banner
        banner = ''
        try:
            banner = loc.banner_url or getattr(partner, 'logo_url', '') or ''
        except Exception:
            pass
        # Working hours: prefer location, fallback to partner
        loc_hours = loc.working_hours if loc.working_hours else partner.working_hours
        # Service prices from location
        svc_prices = []
        try:
            if loc.service_prices:
                svc_prices = list(loc.service_prices)
        except Exception:
            pass
        rv = _get_partner_rating(db, partner.id)
        nearby_partners.append({
            "id": str(partner.id),
            "location_id": str(loc.id),
            "name": loc.name or partner.name,
            "address": loc.address or partner.address or "",
            "latitude": l_lat,
            "longitude": l_lng,
            "distance": round(distance, 1),
            "rating": rv["rating"] if rv["review_count"] > 0 else (float(partner.rating) if partner.rating else 0),
            "review_count": rv["review_count"],
            "is_open": _is_location_open(loc_hours),
            "status": _get_location_status(loc_hours),
            "images": gallery,
            "image_url": banner,
            "logo_url": banner,
            "gallery_urls": gallery,
            "banner_url": banner,
            "amenities": partner.amenities if partner.amenities else [],
            "additional_services": partner.additional_services if partner.additional_services else [],
            "phone_number": loc.phone_number or partner.phone or partner.phone_number or "",
            "phone": loc.phone_number or partner.phone or partner.phone_number or "",
            "opening_hours": _format_hours(loc_hours),
            "working_hours": loc_hours,
            "is_premium": partner.is_premium or False,
            "is_24_hours": getattr(partner, 'is_24_hours', False) or False,
            "service_type": getattr(partner, 'service_type', 'full_service') or 'full_service',
            "description": partner.description or "",
            "wash_time": getattr(partner, 'wash_time', 60) or 60,
            "services": partner.additional_services if partner.additional_services else [],
            "service_prices": svc_prices,
        })
    
    # Deduplicate: if a partner entry exists AND a location entry for same partner, remove duplicate partner entry
    seen = set()
    deduped = []
    for p in nearby_partners:
        key = (p.get("id", ""), p.get("latitude"), p.get("longitude"))
        if key not in seen:
            seen.add(key)
            deduped.append(p)
    nearby_partners = deduped
    
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
    
    # Get branches/locations for this partner
    locations = db.query(PartnerLocation).filter(
        PartnerLocation.partner_id == partner.id,
        PartnerLocation.is_active == True
    ).all()
    
    locations_data = []
    for loc in locations:
        loc_gallery = []
        try:
            if loc.gallery_urls:
                loc_gallery = list(loc.gallery_urls)
        except Exception:
            pass
        loc_prices = []
        try:
            if loc.service_prices:
                loc_prices = list(loc.service_prices)
        except Exception:
            pass
        locations_data.append({
            "id": str(loc.id),
            "name": loc.name or "",
            "address": loc.address or "",
            "city": loc.city or "",
            "latitude": float(loc.latitude) if loc.latitude else None,
            "longitude": float(loc.longitude) if loc.longitude else None,
            "working_hours": loc.working_hours or {},
            "phone_number": loc.phone_number or "",
            "banner_url": loc.banner_url or "",
            "gallery_urls": loc_gallery,
            "service_prices": loc_prices,
        })
    
    # Get recent reviews
    reviews = db.query(Review).filter(
        Review.partner_id == partner.id,
        Review.is_visible == True
    ).order_by(Review.created_at.desc()).limit(10).all()
    
    reviews_data = []
    for review in reviews:
        user = db.query(User).filter(User.id == review.user_id).first()
        reviews_data.append({
            "id": str(review.id),
            "rating": review.rating,
            "comment": review.comment or "",
            "user_name": (user.full_name if user else None) or "Foydalanuvchi",
            "created_at": review.created_at.isoformat() if review.created_at else "",
        })
    
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
            "phone_number": partner.phone or partner.phone_number or "",
            "phone": partner.phone or partner.phone_number or "",
            "opening_hours": get_working_hours_str(partner),
            "working_hours": partner.working_hours,
            "is_premium": partner.is_premium or False,
            "is_24_hours": getattr(partner, 'is_24_hours', False) or False,
            "service_type": getattr(partner, 'service_type', 'full_service') or 'full_service',
            "description": partner.description or "Premium avtomoyka xizmatlari",
            "wash_time": getattr(partner, 'wash_time', 60) or 60,
            "services": partner.additional_services if partner.additional_services else [],
            "locations": locations_data,
            "reviews": reviews_data,
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
            "is_unlimited": plan.is_unlimited or False,
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
    
    # Validate plan_id is a valid UUID
    import uuid as _uuid
    try:
        _uuid.UUID(plan_id)
    except (ValueError, AttributeError):
        raise HTTPException(status_code=400, detail="Noto'g'ri tarif ID formati")
    
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
        # Return existing active subscription instead of blocking
        return {
            "success": True,
            "message": "Active subscription found",
            "subscription_id": str(existing.id),
            "already_active": True
        }
    
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

class CheckinRequest(BaseModel):
    qr_token: str
    vehicle_id: Optional[str] = None

@router.post("/visits/checkin")
async def qr_checkin(
    request: CheckinRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Check in at a car wash using QR code"""
    
    qr_token = request.qr_token
    vehicle_id = request.vehicle_id
    
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
    
    # If no vehicle_id provided, try to get user's first active vehicle
    if not vehicle_id:
        vehicle = db.query(Vehicle).filter(
            Vehicle.user_id == user_id,
            Vehicle.is_active == True
        ).first()
        if vehicle:
            vehicle_id = str(vehicle.id)
    
    # Create visit
    visit = Visit(
        user_id=user_id,
        partner_id=partner_id,
        subscription_id=subscription.id,
        vehicle_id=vehicle_id,
        check_in_time=datetime.utcnow(),
        status="in_progress"
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
        "partner_id": str(partner.id),
        "visit_id": str(visit.id),
        "check_in_time": visit.check_in_time.isoformat(),
        "status": "in_progress",
        "remaining_visits": subscription.visits_remaining if not subscription.is_unlimited else "unlimited"
    }


@router.post("/visits/{visit_id}/complete")
async def complete_visit(
    visit_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Complete an in-progress visit"""
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    visit = db.query(Visit).filter(Visit.id == visit_id, Visit.user_id == user_id).first()
    if not visit:
        raise HTTPException(status_code=404, detail="Visit not found")
    visit.status = "completed"
    visit.check_out_time = datetime.utcnow()
    db.commit()
    return {"success": True, "message": "Tashrif yakunlandi!", "visit_id": str(visit.id)}


@router.get("/visits/history")
async def get_visit_history(
    limit: int = Query(10, ge=1, le=50),
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Get user's visit history"""
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    visits = (
        db.query(Visit)
        .filter(Visit.user_id == user_id)
        .order_by(Visit.check_in_time.desc())
        .limit(limit)
        .all()
    )
    result = []
    for v in visits:
        partner = db.query(Partner).filter(Partner.id == v.partner_id).first() if v.partner_id else None
        location = db.query(PartnerLocation).filter(PartnerLocation.id == v.location_id).first() if v.location_id else None
        vehicle = db.query(Vehicle).filter(Vehicle.id == v.vehicle_id).first() if v.vehicle_id else None
        result.append({
            "id": str(v.id),
            "partner_name": partner.name if partner else (location.name if location else "Avtomoyka"),
            "address": (location.address if location else (partner.address if partner and hasattr(partner, 'address') else "")) or "",
            "vehicle_brand": f"{vehicle.brand or ''} {vehicle.model or ''}".strip() if vehicle else "",
            "plate_number": vehicle.plate_number if vehicle else "",
            "region": "",
            "status": v.status or "completed",
            "check_in_time": v.check_in_time.isoformat() if v.check_in_time else None,
            "check_out_time": v.check_out_time.isoformat() if v.check_out_time else None,
            "visited_at": v.check_in_time.isoformat() if v.check_in_time else None,
        })
    return {"success": True, "visits": result, "count": len(result)}


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

# ==================== PAYMENT ENDPOINTS ====================

class CreatePaymentRequest(BaseModel):
    subscription_id: str
    plan_id: Optional[str] = None
    amount: Optional[float] = None

@router.post("/payments/create")
async def create_payment_link(
    request: CreatePaymentRequest,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Create IpakYuli payment link for subscription"""
    import uuid as _uuid
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    user = db.query(User).filter(User.id == user_id).first()

    # Get or create subscription
    subscription = None
    if request.subscription_id:
        subscription = db.query(Subscription).filter(Subscription.id == request.subscription_id).first()

    if not subscription and request.plan_id:
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == request.plan_id).first()
        if not plan:
            raise HTTPException(status_code=404, detail="Tarif topilmadi")
        subscription = Subscription(
            user_id=user_id,
            plan_id=plan.id,
            status="pending",
        )
        db.add(subscription)
        db.commit()
        db.refresh(subscription)

    if not subscription:
        raise HTTPException(status_code=404, detail="Obuna topilmadi")

    # Determine amount
    amount = request.amount
    if not amount:
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
        amount = float(plan.price) if plan else 0

    if amount <= 0:
        raise HTTPException(status_code=400, detail="Noto'g'ri summa")

    order_id = f"YUVGO_{_uuid.uuid4().hex[:12]}"

    # Create payment record
    payment = Payment(
        user_id=user_id,
        subscription_id=subscription.id,
        amount=amount,
        provider="ipakyuli",
        status="pending",
        payment_metadata={"order_id": order_id},
    )
    db.add(payment)
    db.commit()
    db.refresh(payment)

    # Create payment link directly via IpakYuli EPOS API (production)
    IPAKYULI_BASE_URL = "https://ecom.ipakyulibank.uz"
    # Production token for YuvGO merchant (cashbox 188cad21, merchant a0efe278, exp ~2026-05-30)
    IPAKYULI_ACCESS_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXNoYm94SWQiOiIxODhjYWQyMS0zMGQwLTQyZDktODUxOC05ODFhYWNiNTVkOTUiLCJtZXJjaGFudElkIjoiYTBlZmUyNzgtNWUyZi00YzQ5LWIzZmItN2NlMjllOWM4ZmVkIiwiaWF0IjoxNzQ4ODYyNDI1LCJleHAiOjE3ODA0MjAwMjV9.JmfSQb_5Ei6fPLxTCCbQY6ECprq76NMJMnwT3CPFxP4"

    payload = {
        "jsonrpc": "2.0",
        "id": str(_uuid.uuid4()),
        "method": "transfer.create_token",
        "params": {
            "order_id": order_id,
            "amount": int(amount),
            "details": {
                "description": "YuvGO obuna to'lovi",
                "ofdInfo": {
                    "Items": [
                        {
                            "Name": "YuvGO Subscription",
                            "SPIC": "03304999067000000",
                            "PackageCode": "1344094",
                            "price": int(amount),
                            "count": 1,
                            "VATPercent": 0,
                            "Discount": 0,
                        }
                    ]
                },
            },
            "success_url": f"https://app.yuvgo.uz/api/mobile/payments/success?payment_id={str(payment.id)}",
            "fail_url": "https://app.yuvgo.uz/#/main",
        },
    }
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {IPAKYULI_ACCESS_TOKEN}",
    }

    # Call IpakYuli via nginx reverse proxy (avoids outbound HTTPS issues from uvicorn)
    import httpx

    try:
        async with httpx.AsyncClient(timeout=30.0) as client:
            resp = await client.post(
                "http://yuvgo_nginx:80/ipakyuli-proxy",
                json=payload,
                headers={
                    "Content-Type": "application/json",
                    "Authorization": f"Bearer {IPAKYULI_ACCESS_TOKEN}",
                    "Host": "app.yuvgo.uz",
                },
            )
            print(f"[IPAKYULI] Status: {resp.status_code}, Body: {resp.text[:500]}")
            data = resp.json()
        if "error" in data:
            print(f"[IPAKYULI] Error: {data['error']}")
            payment.status = "failed"
            db.commit()
            raise HTTPException(status_code=500, detail=f"IpakYuli xatolik: {data['error'].get('message', '')}")
        result = data.get("result", {})
        payment.transaction_id = result.get("transfer_id")
        db.commit()
        return {
            "success": True,
            "payment_id": str(payment.id),
            "payment_url": result.get("payment_url"),
            "transfer_id": result.get("transfer_id"),
            "order_id": order_id,
            "amount": amount,
        }
    except HTTPException:
        raise
    except Exception as e:
        import traceback
        traceback.print_exc()
        payment.status = "failed"
        db.commit()
        raise HTTPException(status_code=500, detail=f"To'lov yaratishda xatolik: {type(e).__name__}: {str(e)}")


@router.get("/payments/success")
async def payment_success_callback(
    payment_id: str = None,
    db: Session = Depends(get_db),
):
    """Called by IpakYuli after successful payment — activate subscription and redirect to app"""
    from starlette.responses import RedirectResponse
    if payment_id:
        payment = db.query(Payment).filter(Payment.id == payment_id).first()
        if payment and payment.status == "pending":
            payment.status = "completed"
            # Activate the subscription
            subscription = db.query(Subscription).filter(Subscription.id == payment.subscription_id).first()
            if subscription:
                plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
                subscription.status = "active"
                subscription.start_date = datetime.utcnow()
                if plan:
                    subscription.end_date = datetime.utcnow() + timedelta(days=plan.duration_days)
                    subscription.visits_remaining = plan.visit_limit or 0
                    subscription.is_unlimited = plan.is_unlimited if hasattr(plan, 'is_unlimited') else False
            db.commit()
    return RedirectResponse(url="https://app.yuvgo.uz/#/main", status_code=302)


@router.get("/payments/status/{payment_id}")
async def get_payment_status(
    payment_id: str,
    db: Session = Depends(get_db),
):
    """Check payment status — also queries IpakYuli transfer.get for real-time status"""
    import httpx
    payment = db.query(Payment).filter(Payment.id == payment_id).first()
    if not payment:
        raise HTTPException(status_code=404, detail="To'lov topilmadi")

    # If payment is still pending and has a transfer_id, check IpakYuli
    if payment.status == "pending" and payment.transaction_id:
        IPAKYULI_ACCESS_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXNoYm94SWQiOiIxODhjYWQyMS0zMGQwLTQyZDktODUxOC05ODFhYWNiNTVkOTUiLCJtZXJjaGFudElkIjoiYTBlZmUyNzgtNWUyZi00YzQ5LWIzZmItN2NlMjllOWM4ZmVkIiwiaWF0IjoxNzQ4ODYyNDI1LCJleHAiOjE3ODA0MjAwMjV9.JmfSQb_5Ei6fPLxTCCbQY6ECprq76NMJMnwT3CPFxP4"
        try:
            import uuid as _uuid
            payload = {
                "jsonrpc": "2.0",
                "id": str(_uuid.uuid4()),
                "method": "transfer.get",
                "params": {"id": payment.transaction_id},
            }
            async with httpx.AsyncClient(timeout=15.0) as client:
                resp = await client.post(
                    "http://yuvgo_nginx:80/ipakyuli-proxy",
                    json=payload,
                    headers={
                        "Content-Type": "application/json",
                        "Authorization": f"Bearer {IPAKYULI_ACCESS_TOKEN}",
                        "Host": "app.yuvgo.uz",
                    },
                )
                data = resp.json()
                result = data.get("result", {})
                ipk_status = result.get("status", "").lower()
                print(f"[IPAKYULI STATUS] transfer {payment.transaction_id}: {ipk_status}")

                if ipk_status == "success":
                    payment.status = "completed"
                    # Activate the subscription
                    if payment.subscription_id:
                        subscription = db.query(Subscription).filter(Subscription.id == payment.subscription_id).first()
                        if subscription and subscription.status != "active":
                            plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
                            subscription.status = "active"
                            subscription.start_date = datetime.utcnow()
                            if plan:
                                subscription.end_date = datetime.utcnow() + timedelta(days=plan.duration_days)
                                subscription.visits_remaining = plan.visit_limit or 0
                                subscription.is_unlimited = plan.is_unlimited if hasattr(plan, 'is_unlimited') else False
                    db.commit()
                elif ipk_status in ("failed", "cancelled", "expired"):
                    payment.status = "failed"
                    db.commit()
        except Exception as e:
            print(f"[IPAKYULI STATUS CHECK ERROR] {e}")

    return {
        "success": True,
        "payment_id": str(payment.id),
        "status": payment.status,
        "amount": float(payment.amount) if payment.amount else 0,
        "provider": payment.provider,
        "transaction_id": payment.transaction_id,
        "created_at": payment.created_at.isoformat() if payment.created_at else None,
    }


@router.get("/payments/my")
async def get_my_payments(
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Get current user's payments"""
    user_id = current_user.get("sub") if isinstance(current_user, dict) else current_user.id
    payments = (
        db.query(Payment)
        .filter(Payment.user_id == user_id)
        .order_by(Payment.created_at.desc())
        .limit(50)
        .all()
    )
    return {
        "success": True,
        "payments": [
            {
                "id": str(p.id),
                "amount": float(p.amount) if p.amount else 0,
                "currency": p.currency or "UZS",
                "status": p.status,
                "provider": p.provider,
                "transaction_id": p.transaction_id,
                "created_at": p.created_at.isoformat() if p.created_at else None,
            }
            for p in payments
        ],
    }


@router.get("/payments/all")
async def get_all_payments(
    limit: int = Query(100, ge=1, le=500),
    offset: int = Query(0, ge=0),
    status: Optional[str] = None,
    db: Session = Depends(get_db),
):
    """Get all payments (admin endpoint)"""
    from sqlalchemy import func as sqlfunc

    query = db.query(Payment)
    if status:
        query = query.filter(Payment.status == status)

    total = query.count()
    payments = query.order_by(Payment.created_at.desc()).offset(offset).limit(limit).all()

    result = []
    for p in payments:
        user = db.query(User).filter(User.id == p.user_id).first()
        plan_name = ""
        if p.subscription_id:
            sub = db.query(Subscription).filter(Subscription.id == p.subscription_id).first()
            if sub and sub.plan_id:
                plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
                plan_name = plan.name if plan else ""

        result.append({
            "id": str(p.id),
            "user_name": user.full_name if user and user.full_name else (user.phone_number if user else ""),
            "user_phone": user.phone_number if user else "",
            "amount": float(p.amount) if p.amount else 0,
            "currency": p.currency or "UZS",
            "status": p.status,
            "provider": p.provider or "ipakyuli",
            "payment_method": p.payment_method or p.provider or "ipakyuli",
            "plan_name": plan_name,
            "transaction_id": p.transaction_id or "",
            "failure_reason": (p.payment_metadata or {}).get("failure_reason") if p.payment_metadata else None,
            "created_at": p.created_at.isoformat() if p.created_at else None,
            "updated_at": p.updated_at.isoformat() if p.updated_at else None,
        })

    # Stats
    total_revenue = db.query(sqlfunc.sum(Payment.amount)).filter(Payment.status.in_(["completed", "success"])).scalar() or 0
    total_count = db.query(sqlfunc.count(Payment.id)).scalar() or 0
    success_count = db.query(sqlfunc.count(Payment.id)).filter(Payment.status.in_(["completed", "success"])).scalar() or 0
    pending_count = db.query(sqlfunc.count(Payment.id)).filter(Payment.status == "pending").scalar() or 0
    failed_count = db.query(sqlfunc.count(Payment.id)).filter(Payment.status == "failed").scalar() or 0

    return {
        "success": True,
        "payments": result,
        "total": total,
        "stats": {
            "total_revenue": float(total_revenue),
            "total_count": total_count,
            "success_count": success_count,
            "pending_count": pending_count,
            "failed_count": failed_count,
        },
    }


def _get_token_from_user(current_user) -> str:
    """Extract token string for forwarding"""
    if isinstance(current_user, dict):
        return current_user.get("token", "")
    return ""


# ==================== WEATHER ENDPOINTS ====================

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


def _get_partner_hours(partner: Partner):
    """Parse partner working hours, returns (open_hour, open_min, close_hour, close_min)"""
    wh = partner.working_hours
    open_h, open_m, close_h, close_m = 8, 0, 22, 0
    if isinstance(wh, dict):
        try:
            parts = wh.get('open', '08:00').split(':')
            open_h, open_m = int(parts[0]), int(parts[1]) if len(parts) > 1 else 0
        except: pass
        try:
            parts = wh.get('close', '22:00').split(':')
            close_h, close_m = int(parts[0]), int(parts[1]) if len(parts) > 1 else 0
        except: pass
    return open_h, open_m, close_h, close_m


def is_currently_open(partner: Partner) -> bool:
    """Check if partner is currently open based on working_hours"""
    if getattr(partner, 'is_24_hours', False):
        return True
    # Tashkent is UTC+5
    now = datetime.utcnow() + timedelta(hours=5)
    current_minutes = now.hour * 60 + now.minute
    open_h, open_m, close_h, close_m = _get_partner_hours(partner)
    open_minutes = open_h * 60 + open_m
    close_minutes = close_h * 60 + close_m
    return open_minutes <= current_minutes < close_minutes


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
    open_h, open_m, close_h, close_m = _get_partner_hours(partner)
    open_str = f"{open_h:02d}:{open_m:02d}"
    close_str = f"{close_h:02d}:{close_m:02d}"
    if is_currently_open(partner):
        return f"{close_str} GACHA OCHIQ"
    else:
        return f"YOPIQ {open_str} GACHA"


def _is_location_open(working_hours) -> bool:
    """Check if a location is currently open based on working_hours dict"""
    if not working_hours or not isinstance(working_hours, dict):
        return True
    now = datetime.utcnow() + timedelta(hours=5)
    current_minutes = now.hour * 60 + now.minute
    try:
        parts = working_hours.get('open', '08:00').split(':')
        open_m = int(parts[0]) * 60 + (int(parts[1]) if len(parts) > 1 else 0)
    except:
        open_m = 480
    try:
        parts = working_hours.get('close', '22:00').split(':')
        close_m = int(parts[0]) * 60 + (int(parts[1]) if len(parts) > 1 else 0)
    except:
        close_m = 1320
    return open_m <= current_minutes < close_m


def _get_location_status(working_hours) -> str:
    """Get status text for a location"""
    if not working_hours or not isinstance(working_hours, dict):
        return "OCHIQ"
    open_time = working_hours.get('open', '08:00')
    close_time = working_hours.get('close', '22:00')
    if _is_location_open(working_hours):
        return f"{close_time} GACHA OCHIQ"
    return f"YOPIQ {open_time} GACHA"


def _format_hours(working_hours) -> str:
    """Format working hours dict to string"""
    if not working_hours or not isinstance(working_hours, dict):
        return "08:00 - 22:00"
    return f"{working_hours.get('open', '08:00')} - {working_hours.get('close', '22:00')}"


# ==================== VEHICLES ====================

class VehicleCreate(BaseModel):
    license_plate: str
    brand: Optional[str] = None
    model: Optional[str] = None
    color: Optional[str] = None
    year: Optional[int] = None
    vehicle_type: Optional[str] = 'sedan'

class VehicleUpdate(BaseModel):
    license_plate: Optional[str] = None
    brand: Optional[str] = None
    model: Optional[str] = None
    color: Optional[str] = None
    year: Optional[int] = None
    vehicle_type: Optional[str] = None

@router.get("/vehicles/my")
async def get_my_vehicles(
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """Get current user's vehicles"""
    user_id = current_user.get("sub")
    vehicles = db.query(Vehicle).filter(
        Vehicle.user_id == user_id,
        Vehicle.is_active == True
    ).order_by(Vehicle.created_at.desc()).all()
    
    return {
        "success": True,
        "vehicles": [
            {
                "id": str(v.id),
                "license_plate": v.license_plate,
                "brand": v.brand,
                "model": v.model,
                "color": v.color,
                "year": v.year,
                "vehicle_type": getattr(v, 'vehicle_type', 'sedan') or 'sedan',
                "name": f"{v.brand or ''} {v.model or ''}".strip() or v.license_plate,
                "created_at": v.created_at.isoformat() if v.created_at else None,
            }
            for v in vehicles
        ]
    }

@router.post("/vehicles")
async def create_vehicle(
    vehicle_data: VehicleCreate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """Add a new vehicle for the current user"""
    user_id = current_user.get("sub")
    
    vehicle = Vehicle(
        user_id=user_id,
        license_plate=vehicle_data.license_plate,
        brand=vehicle_data.brand,
        model=vehicle_data.model,
        color=vehicle_data.color,
        year=vehicle_data.year,
        vehicle_type=vehicle_data.vehicle_type or 'sedan',
        is_active=True,
    )
    db.add(vehicle)
    db.commit()
    db.refresh(vehicle)
    
    return {
        "success": True,
        "vehicle": {
            "id": str(vehicle.id),
            "license_plate": vehicle.license_plate,
            "brand": vehicle.brand,
            "model": vehicle.model,
            "color": vehicle.color,
            "year": vehicle.year,
            "vehicle_type": getattr(vehicle, 'vehicle_type', 'sedan') or 'sedan',
            "name": f"{vehicle.brand or ''} {vehicle.model or ''}".strip() or vehicle.license_plate,
        }
    }

@router.put("/vehicles/{vehicle_id}")
async def update_vehicle(
    vehicle_id: str,
    vehicle_data: VehicleUpdate,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """Update a vehicle"""
    user_id = current_user.get("sub")
    vehicle = db.query(Vehicle).filter(
        Vehicle.id == vehicle_id,
        Vehicle.user_id == user_id
    ).first()
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    
    for field, value in vehicle_data.dict(exclude_unset=True).items():
        if value is not None:
            setattr(vehicle, field, value)
    
    db.commit()
    db.refresh(vehicle)
    return {"success": True, "message": "Vehicle updated"}

@router.delete("/vehicles/{vehicle_id}")
async def delete_vehicle(
    vehicle_id: str,
    db: Session = Depends(get_db),
    current_user: dict = Depends(get_current_user)
):
    """Delete (deactivate) a vehicle"""
    user_id = current_user.get("sub")
    vehicle = db.query(Vehicle).filter(
        Vehicle.id == vehicle_id,
        Vehicle.user_id == user_id
    ).first()
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    
    vehicle.is_active = False
    db.commit()
    return {"success": True, "message": "Vehicle deleted"}

@router.get("/vehicles/all")
async def get_all_vehicles(
    db: Session = Depends(get_db),
):
    """Get all vehicles (admin endpoint)"""
    vehicles = db.query(Vehicle).filter(Vehicle.is_active == True).order_by(Vehicle.created_at.desc()).all()
    
    result = []
    for v in vehicles:
        user = db.query(User).filter(User.id == v.user_id).first()
        result.append({
            "id": str(v.id),
            "license_plate": v.license_plate,
            "brand": v.brand,
            "model": v.model,
            "color": v.color,
            "year": v.year,
            "vehicle_type": getattr(v, 'vehicle_type', 'sedan') or 'sedan',
            "name": f"{v.brand or ''} {v.model or ''}".strip() or v.license_plate,
            "user_id": str(v.user_id) if v.user_id else None,
            "user_name": user.full_name if user else None,
            "user_phone": user.phone_number if user else None,
            "created_at": v.created_at.isoformat() if v.created_at else None,
        })
    
    return {
        "success": True,
        "vehicles": result,
        "total": len(result),
    }
