from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from datetime import datetime, timedelta
from pydantic import BaseModel
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Visit, Subscription, User, Vehicle, PartnerLocation, PartnerStaff, Partner, Base
from shared.schemas import VisitCreate, VisitResponse, QRTokenResponse
from shared.auth import AuthHandler
from shared.redis_client import RedisCache
from shared.utils import generate_qr_token, check_visit_cooldown

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Visit Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

QR_TOKEN_TTL = int(os.getenv("QR_TOKEN_TTL_SECONDS", "120"))
VISIT_COOLDOWN_HOURS = int(os.getenv("VISIT_COOLDOWN_HOURS", "4"))

@app.get("/")
async def root():
    return {"service": "YuvGo Visit Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# QR Code Generation
@app.post("/qr/generate", response_model=QRTokenResponse)
async def generate_qr(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Generate QR token for check-in"""
    user_id = current_user.get("sub")
    
    # Check if user has active subscription
    subscription = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active",
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=403, detail="No active subscription found")
    
    # Check visit limit
    if not subscription.is_unlimited and subscription.visits_used >= subscription.visit_limit:
        raise HTTPException(status_code=403, detail="Visit limit reached")
    
    # Check cooldown period
    last_visit = db.query(Visit).filter(
        Visit.user_id == user_id
    ).order_by(Visit.check_in_time.desc()).first()
    
    if last_visit and not check_visit_cooldown(last_visit.check_in_time, VISIT_COOLDOWN_HOURS):
        raise HTTPException(
            status_code=403, 
            detail=f"Please wait {VISIT_COOLDOWN_HOURS} hours between visits"
        )
    
    # Generate QR token
    qr_token = generate_qr_token()
    
    # Store in Redis with TTL
    token_data = {
        "user_id": str(user_id),
        "subscription_id": str(subscription.id),
        "created_at": datetime.utcnow().isoformat()
    }
    
    RedisCache.set(f"qr_token:{qr_token}", token_data, ttl=QR_TOKEN_TTL)
    
    return {
        "qr_token": qr_token,
        "expires_in": QR_TOKEN_TTL,
        "user_id": user_id,
        "subscription_id": subscription.id
    }

# Check-in
@app.post("/checkin", response_model=VisitResponse)
async def check_in(
    visit_data: VisitCreate,
    db: Session = Depends(get_db)
):
    """Process check-in with QR token"""
    # Validate QR token
    token_key = f"qr_token:{visit_data.qr_token}"
    token_data = RedisCache.get(token_key)
    
    if not token_data:
        raise HTTPException(status_code=400, detail="Invalid or expired QR token")
    
    user_id = token_data["user_id"]
    subscription_id = token_data["subscription_id"]
    
    # Verify subscription is still active
    subscription = db.query(Subscription).filter(
        Subscription.id == subscription_id,
        Subscription.status == "active"
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=403, detail="Subscription is not active")
    
    # Check visit limit
    plan = subscription.plan
    if not plan.is_unlimited and subscription.visits_used >= plan.visit_limit:
        raise HTTPException(status_code=403, detail="Visit limit reached")
    
    # Verify location and staff
    location = db.query(PartnerLocation).filter(
        PartnerLocation.id == visit_data.location_id,
        PartnerLocation.is_active == True
    ).first()
    
    if not location:
        raise HTTPException(status_code=404, detail="Location not found")
    
    staff = db.query(PartnerStaff).filter(
        PartnerStaff.id == visit_data.staff_id,
        PartnerStaff.is_active == True
    ).first()
    
    if not staff:
        raise HTTPException(status_code=404, detail="Staff not found")
    
    # Get user's active vehicle
    vehicle = db.query(Vehicle).filter(
        Vehicle.user_id == user_id,
        Vehicle.is_active == True
    ).first()
    
    # Create visit record
    visit = Visit(
        user_id=user_id,
        subscription_id=subscription_id,
        vehicle_id=vehicle.id if vehicle else None,
        partner_id=location.partner_id,
        location_id=location.id,
        staff_id=staff.id,
        notes=visit_data.notes
    )
    
    db.add(visit)
    
    # Increment visits used
    subscription.visits_used += 1
    
    db.commit()
    db.refresh(visit)
    
    # Delete QR token (single use)
    RedisCache.delete(token_key)
    
    return visit

# Visit History
@app.get("/visits", response_model=List[VisitResponse])
async def get_visit_history(
    skip: int = 0,
    limit: int = 20,
    user_id: str = None,
    partner_id: str = None,
    db: Session = Depends(get_db)
):
    """Get visit history - can filter by user_id or partner_id"""
    query = db.query(Visit).join(User, Visit.user_id == User.id)
    
    if user_id:
        query = query.filter(Visit.user_id == user_id)
    
    if partner_id:
        query = query.filter(Visit.partner_id == partner_id)
    
    visits_data = query.order_by(Visit.check_in_time.desc()).offset(skip).limit(limit).all()
    
    # Add user info and vehicle info to each visit
    result = []
    for visit in visits_data:
        user = db.query(User).filter(User.id == visit.user_id).first()
        vehicle = db.query(Vehicle).filter(Vehicle.id == visit.vehicle_id).first() if visit.vehicle_id else None
        visit_dict = {
            "id": visit.id,
            "user_id": visit.user_id,
            "subscription_id": visit.subscription_id,
            "vehicle_id": visit.vehicle_id,
            "partner_id": visit.partner_id,
            "location_id": visit.location_id,
            "staff_id": visit.staff_id,
            "check_in_time": visit.check_in_time,
            "status": visit.status,
            "notes": visit.notes,
            "user_name": user.full_name if user else None,
            "user_phone": user.phone_number if user else None,
            "user_email": user.email if user else None,
            "vehicle_plate": vehicle.license_plate if vehicle else None,
            "vehicle_brand": vehicle.brand if vehicle else None,
            "vehicle_model": vehicle.model if vehicle else None,
            "vehicle_type": getattr(vehicle, 'vehicle_type', 'sedan') if vehicle else None,
            "vehicle_name": f"{vehicle.brand or ''} {vehicle.model or ''}".strip() if vehicle else None,
        }
        result.append(visit_dict)
    
    return result

# Today's visits for partner (MUST be before /visits/{visit_id} to avoid route conflict)
@app.get("/visits/today")
async def get_today_visits(
    partner_id: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get today's visits, optionally filtered by partner"""
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    
    query = db.query(Visit).filter(Visit.check_in_time >= today_start)
    
    if partner_id:
        query = query.filter(Visit.partner_id == partner_id)
    
    visits = query.order_by(Visit.check_in_time.desc()).all()
    
    result = []
    for visit in visits:
        user = db.query(User).filter(User.id == visit.user_id).first()
        vehicle = db.query(Vehicle).filter(Vehicle.id == visit.vehicle_id).first() if visit.vehicle_id else None
        result.append({
            "id": str(visit.id),
            "user_id": str(visit.user_id),
            "user_name": user.full_name if user else None,
            "user_phone": user.phone_number if user else None,
            "check_in_time": visit.check_in_time.isoformat(),
            "status": visit.status,
            "vehicle_plate": vehicle.license_plate if vehicle else None,
            "vehicle_brand": vehicle.brand if vehicle else None,
            "vehicle_model": vehicle.model if vehicle else None,
            "vehicle_type": getattr(vehicle, 'vehicle_type', 'sedan') if vehicle else None,
            "vehicle_name": f"{vehicle.brand or ''} {vehicle.model or ''}".strip() if vehicle else None,
        })
    
    return result

@app.get("/visits/{visit_id}", response_model=VisitResponse)
async def get_visit(
    visit_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get visit details"""
    user_id = current_user.get("sub")
    
    visit = db.query(Visit).filter(
        Visit.id == visit_id,
        Visit.user_id == user_id
    ).first()
    
    if not visit:
        raise HTTPException(status_code=404, detail="Visit not found")
    
    return visit

# Partner Visit Analytics
@app.get("/partner/{partner_id}/visits")
async def get_partner_visits(
    partner_id: str,
    start_date: datetime = None,
    end_date: datetime = None,
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db)
):
    """Get partner visit history"""
    query = db.query(Visit).filter(Visit.partner_id == partner_id)
    
    if start_date:
        query = query.filter(Visit.check_in_time >= start_date)
    if end_date:
        query = query.filter(Visit.check_in_time <= end_date)
    
    visits = query.order_by(Visit.check_in_time.desc()).offset(skip).limit(limit).all()
    
    return [
        {
            "id": str(v.id),
            "user_id": str(v.user_id),
            "location_id": str(v.location_id),
            "staff_id": str(v.staff_id),
            "check_in_time": v.check_in_time,
            "status": v.status,
            "notes": v.notes
        }
        for v in visits
    ]

# Partner Statistics
@app.get("/partner/{partner_id}/stats")
async def get_partner_stats(
    partner_id: str,
    db: Session = Depends(get_db)
):
    """Get partner statistics"""
    # Total visits
    total_visits = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id
    ).scalar()
    
    # Unique clients
    total_clients = db.query(func.count(func.distinct(Visit.user_id))).filter(
        Visit.partner_id == partner_id
    ).scalar()
    
    # Calculate average daily visits (last 30 days)
    thirty_days_ago = datetime.utcnow() - timedelta(days=30)
    recent_visits = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id,
        Visit.check_in_time >= thirty_days_ago
    ).scalar()
    avg_daily_visits = recent_visits / 30 if recent_visits else 0
    
    # Estimated monthly revenue (assuming average subscription price)
    monthly_revenue = total_visits * 3300  # Average revenue per visit
    
    return {
        "total_visits": total_visits,
        "total_clients": total_clients,
        "avg_daily_visits": round(avg_daily_visits, 1),
        "monthly_revenue": monthly_revenue
    }

# Partner Clients
@app.get("/partner/{partner_id}/clients")
async def get_partner_clients(
    partner_id: str,
    db: Session = Depends(get_db)
):
    """Get list of clients who visited this partner"""
    # Get unique users with visit counts
    clients_data = db.query(
        Visit.user_id,
        func.count(Visit.id).label('visit_count'),
        func.min(Visit.check_in_time).label('first_visit'),
        func.max(Visit.check_in_time).label('last_visit')
    ).filter(
        Visit.partner_id == partner_id
    ).group_by(Visit.user_id).all()
    
    clients = []
    for user_id, visit_count, first_visit, last_visit in clients_data:
        # Get user info
        user = db.query(User).filter(User.id == user_id).first()
        
        # Check if user has active subscription
        active_sub = db.query(Subscription).filter(
            Subscription.user_id == user_id,
            Subscription.status == 'active',
            Subscription.end_date > datetime.utcnow()
        ).first()
        
        clients.append({
            "user_id": str(user_id),
            "user_name": user.full_name if user else None,
            "phone_number": user.phone_number if user else None,
            "visit_count": visit_count,
            "first_visit": first_visit,
            "last_visit": last_visit,
            "subscription_active": active_sub is not None
        })
    
    return clients

# Partner Earnings
@app.get("/partner/{partner_id}/earnings")
async def get_partner_earnings(
    partner_id: str,
    db: Session = Depends(get_db)
):
    """Get partner earnings breakdown"""
    now = datetime.utcnow()
    
    # Today's earnings
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    today_visits = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id,
        Visit.check_in_time >= today_start
    ).scalar()
    
    # Week's earnings
    week_start = now - timedelta(days=7)
    week_visits = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id,
        Visit.check_in_time >= week_start
    ).scalar()
    
    # Month's earnings
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    month_visits = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id,
        Visit.check_in_time >= month_start
    ).scalar()
    
    # Total earnings
    total_visits = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id
    ).scalar()
    
    # Average revenue per visit
    avg_revenue_per_visit = 3300
    
    return {
        "earnings": {
            "today": today_visits * avg_revenue_per_visit,
            "week": week_visits * avg_revenue_per_visit,
            "month": month_visits * avg_revenue_per_visit,
            "total": total_visits * avg_revenue_per_visit
        },
        "breakdown": [
            {"period": "Week 1", "amount": month_visits * 0.25 * avg_revenue_per_visit},
            {"period": "Week 2", "amount": month_visits * 0.23 * avg_revenue_per_visit},
            {"period": "Week 3", "amount": month_visits * 0.27 * avg_revenue_per_visit},
            {"period": "Week 4", "amount": month_visits * 0.25 * avg_revenue_per_visit}
        ]
    }

# User Check-in (User scans merchant QR)
from pydantic import BaseModel

class UserCheckinRequest(BaseModel):
    qr_token: str
    user_id: str

@app.post("/user-checkin")
async def user_checkin(
    request: UserCheckinRequest,
    db: Session = Depends(get_db)
):
    """User scans merchant QR code to check-in"""
    
    # Validate QR token format
    if not request.qr_token.startswith('MERCHANT_'):
        raise HTTPException(status_code=400, detail="Invalid merchant QR code")
    
    # Extract partner_id from token (format: MERCHANT_partnerId_timestamp)
    try:
        parts = request.qr_token.split('_')
        partner_id = parts[1] if len(parts) > 1 else None
    except:
        raise HTTPException(status_code=400, detail="Invalid QR token format")
    
    # Check if user exists
    user = db.query(User).filter(User.id == request.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check if user has active subscription
    subscription = db.query(Subscription).filter(
        Subscription.user_id == request.user_id,
        Subscription.status == "active",
        Subscription.end_date > datetime.utcnow()
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=400, detail="No active subscription")
    
    # Check visit limits
    if subscription.visits_remaining <= 0 and not subscription.is_unlimited:
        raise HTTPException(status_code=400, detail="No visits remaining")
    
    # Check cooldown
    last_visit = db.query(Visit).filter(
        Visit.user_id == request.user_id
    ).order_by(Visit.check_in_time.desc()).first()
    
    if last_visit:
        cooldown_end = last_visit.check_in_time + timedelta(hours=VISIT_COOLDOWN_HOURS)
        if datetime.utcnow() < cooldown_end:
            remaining = (cooldown_end - datetime.utcnow()).total_seconds() / 3600
            raise HTTPException(
                status_code=400, 
                detail=f"Please wait {remaining:.1f} hours before next visit"
            )
    
    # Create visit record
    visit = Visit(
        user_id=request.user_id,
        partner_id=partner_id,
        subscription_id=subscription.id,
        check_in_time=datetime.utcnow(),
        status="completed",
        notes="User scanned merchant QR"
    )
    db.add(visit)
    
    # Update subscription visits
    if not subscription.is_unlimited:
        subscription.visits_remaining -= 1
    
    db.commit()
    db.refresh(visit)
    
    return {
        "success": True,
        "message": "Check-in successful",
        "visit_id": str(visit.id),
        "visits_remaining": subscription.visits_remaining if not subscription.is_unlimited else "unlimited"
    }

# Visit statistics
@app.get("/stats")
async def get_visit_stats(
    partner_id: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get visit statistics"""
    query = db.query(Visit)
    if partner_id:
        query = query.filter(Visit.partner_id == partner_id)
    
    total_visits = query.count()
    
    # Today's visits
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    today_visits = query.filter(Visit.check_in_time >= today_start).count()
    
    # This week's visits
    week_start = datetime.utcnow() - timedelta(days=7)
    week_visits = query.filter(Visit.check_in_time >= week_start).count()
    
    # This month's visits
    month_start = datetime.utcnow().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    month_visits = query.filter(Visit.check_in_time >= month_start).count()
    
    # Unique users
    unique_users = db.query(func.count(func.distinct(Visit.user_id))).scalar() or 0
    
    return {
        "total_visits": total_visits,
        "today_visits": today_visits,
        "week_visits": week_visits,
        "month_visits": month_visits,
        "unique_users": unique_users,
    }

# Daily stats for charts
@app.get("/stats/daily")
async def get_daily_stats(
    partner_id: Optional[str] = None,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get daily visit statistics for charts"""
    # Default to last 30 days
    if not end_date:
        end = datetime.utcnow().date()
    else:
        end = datetime.fromisoformat(end_date).date()
    
    if not start_date:
        start = end - timedelta(days=30)
    else:
        start = datetime.fromisoformat(start_date).date()
    
    daily_data = []
    current_date = start
    
    while current_date <= end:
        day_start = datetime.combine(current_date, datetime.min.time())
        day_end = datetime.combine(current_date, datetime.max.time())
        
        query = db.query(func.count(Visit.id)).filter(
            Visit.check_in_time >= day_start,
            Visit.check_in_time <= day_end
        )
        
        if partner_id:
            query = query.filter(Visit.partner_id == partner_id)
        
        count = query.scalar() or 0
        
        daily_data.append({
            "date": current_date.isoformat(),
            "count": count
        })
        
        current_date += timedelta(days=1)
    
    return daily_data

# Clients endpoint
@app.get("/clients")
async def get_clients(
    partner_id: Optional[str] = None,
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db)
):
    """Get clients list with visit counts"""
    query = db.query(
        Visit.user_id,
        func.count(Visit.id).label('visit_count'),
        func.max(Visit.check_in_time).label('last_visit')
    )
    
    if partner_id:
        query = query.filter(Visit.partner_id == partner_id)
    
    clients_data = query.group_by(Visit.user_id).offset(skip).limit(limit).all()
    
    result = []
    for user_id, visit_count, last_visit in clients_data:
        user = db.query(User).filter(User.id == user_id).first()
        if user:
            result.append({
                "id": str(user_id),
                "name": user.full_name,
                "phone": user.phone_number,
                "email": user.email,
                "visit_count": visit_count,
                "last_visit": last_visit.isoformat() if last_visit else None,
            })
    
    return result

# Client stats
@app.get("/clients/stats")
async def get_client_stats(
    partner_id: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get client statistics"""
    query = db.query(Visit)
    if partner_id:
        query = query.filter(Visit.partner_id == partner_id)
    
    total_clients = db.query(func.count(func.distinct(Visit.user_id)))
    if partner_id:
        total_clients = total_clients.filter(Visit.partner_id == partner_id)
    total_clients = total_clients.scalar() or 0
    
    # New clients this month
    month_start = datetime.utcnow().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    new_clients_query = db.query(func.count(func.distinct(Visit.user_id))).filter(
        Visit.check_in_time >= month_start
    )
    if partner_id:
        new_clients_query = new_clients_query.filter(Visit.partner_id == partner_id)
    new_clients = new_clients_query.scalar() or 0
    
    return {
        "total_clients": total_clients,
        "new_clients_this_month": new_clients,
    }

# QR validation endpoint
class QRValidateRequest(BaseModel):
    qr_token: str

@app.post("/qr/validate")
async def validate_qr(
    request: QRValidateRequest,
    db: Session = Depends(get_db)
):
    """Validate a QR token"""
    # Check if it's a merchant QR
    if request.qr_token.startswith('MERCHANT_'):
        parts = request.qr_token.split('_')
        if len(parts) >= 2:
            partner_id = parts[1]
            from shared.models import Partner
            partner = db.query(Partner).filter(Partner.id == partner_id).first()
            if partner:
                return {
                    "valid": True,
                    "type": "merchant",
                    "partner_id": partner_id,
                    "partner_name": partner.name
                }
    
    # Check Redis for user QR token
    token_data = RedisCache.get(f"qr_token:{request.qr_token}")
    if token_data:
        return {
            "valid": True,
            "type": "user",
            "user_id": token_data.get("user_id"),
            "subscription_id": token_data.get("subscription_id")
        }
    
    return {"valid": False, "message": "Invalid or expired QR token"}

# QR scan endpoint
class QRScanRequest(BaseModel):
    qr_token: str
    vehicle_id: Optional[str] = None

@app.post("/qr/scan")
async def scan_qr(
    request: QRScanRequest,
    db: Session = Depends(get_db)
):
    """Process a QR scan"""
    # Validate first
    if request.qr_token.startswith('MERCHANT_'):
        return {
            "success": False,
            "message": "This is a merchant QR code. Users should scan this to check in."
        }
    
    # Check Redis for user QR token
    token_data = RedisCache.get(f"qr_token:{request.qr_token}")
    if not token_data:
        return {"success": False, "message": "Invalid or expired QR token"}
    
    user_id = token_data.get("user_id")
    subscription_id = token_data.get("subscription_id")
    
    # Get user and subscription
    user = db.query(User).filter(User.id == user_id).first()
    subscription = db.query(Subscription).filter(Subscription.id == subscription_id).first()
    
    if not user or not subscription:
        return {"success": False, "message": "User or subscription not found"}
    
    if subscription.status != "active":
        return {"success": False, "message": "Subscription is not active"}
    
    return {
        "success": True,
        "user": {
            "id": str(user.id),
            "name": user.full_name,
            "phone": user.phone_number
        },
        "subscription": {
            "id": str(subscription.id),
            "status": subscription.status,
            "visits_remaining": subscription.visits_remaining if hasattr(subscription, 'visits_remaining') else None
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8004)
