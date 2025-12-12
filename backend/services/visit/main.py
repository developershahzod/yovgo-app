from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime, timedelta
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Visit, Subscription, User, Vehicle, PartnerLocation, PartnerStaff, Base
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
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get user's visit history"""
    user_id = current_user.get("sub")
    
    visits = db.query(Visit).filter(
        Visit.user_id == user_id
    ).order_by(Visit.check_in_time.desc()).offset(skip).limit(limit).all()
    
    return visits

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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8004)
