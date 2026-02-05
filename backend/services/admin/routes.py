from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional
from datetime import datetime, timedelta
from pydantic import BaseModel
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db
from shared.models import User, Partner, Subscription, SubscriptionPlan, Visit, Admin, Base
from shared.auth import AuthHandler

router = APIRouter()

# ==================== ANALYTICS ENDPOINTS ====================

class DashboardStats(BaseModel):
    total_users: int
    active_subscriptions: int
    total_partners: int
    total_visits: int
    total_revenue: float
    new_users_today: int
    new_users_this_week: int
    new_users_this_month: int

@router.get("/analytics/dashboard")
async def get_dashboard_analytics(db: Session = Depends(get_db)):
    """Get comprehensive dashboard analytics"""
    try:
        today = datetime.utcnow().date()
        week_ago = today - timedelta(days=7)
        month_ago = today - timedelta(days=30)
        
        # Total counts
        total_users = db.query(func.count(User.id)).scalar() or 0
        total_partners = db.query(func.count(Partner.id)).scalar() or 0
        total_visits = db.query(func.count(Visit.id)).scalar() or 0
        
        # Active subscriptions
        active_subscriptions = db.query(func.count(Subscription.id)).filter(
            Subscription.status == "active"
        ).scalar() or 0
        
        # New users
        new_users_today = db.query(func.count(User.id)).filter(
            func.date(User.created_at) == today
        ).scalar() or 0
        
        new_users_this_week = db.query(func.count(User.id)).filter(
            func.date(User.created_at) >= week_ago
        ).scalar() or 0
        
        new_users_this_month = db.query(func.count(User.id)).filter(
            func.date(User.created_at) >= month_ago
        ).scalar() or 0
        
        # Calculate revenue (sum of subscription plan prices * active subscriptions)
        total_revenue = 0
        subscriptions = db.query(Subscription).filter(Subscription.status == "active").all()
        for sub in subscriptions:
            plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
            if plan:
                total_revenue += plan.price
        
        return {
            "total_users": total_users,
            "active_subscriptions": active_subscriptions,
            "total_partners": total_partners,
            "total_visits": total_visits,
            "total_revenue": total_revenue,
            "new_users_today": new_users_today,
            "new_users_this_week": new_users_this_week,
            "new_users_this_month": new_users_this_month,
        }
    except Exception as e:
        return {
            "total_users": 0,
            "active_subscriptions": 0,
            "total_partners": 0,
            "total_visits": 0,
            "total_revenue": 0,
            "new_users_today": 0,
            "new_users_this_week": 0,
            "new_users_this_month": 0,
            "error": str(e)
        }

@router.get("/analytics/users")
async def get_user_analytics(
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get user growth analytics"""
    try:
        today = datetime.utcnow().date()
        
        if period == "week":
            start_date = today - timedelta(days=7)
        elif period == "month":
            start_date = today - timedelta(days=30)
        elif period == "year":
            start_date = today - timedelta(days=365)
        else:
            start_date = today - timedelta(days=30)
        
        # Daily user registrations
        daily_data = []
        current_date = start_date
        while current_date <= today:
            count = db.query(func.count(User.id)).filter(
                func.date(User.created_at) == current_date
            ).scalar() or 0
            daily_data.append({
                "date": current_date.isoformat(),
                "count": count
            })
            current_date += timedelta(days=1)
        
        return {
            "period": period,
            "data": daily_data,
            "total": sum(d["count"] for d in daily_data)
        }
    except Exception as e:
        return {"period": period, "data": [], "total": 0, "error": str(e)}

@router.get("/analytics/revenue")
async def get_revenue_analytics(
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get revenue analytics"""
    try:
        today = datetime.utcnow().date()
        
        if period == "week":
            start_date = today - timedelta(days=7)
        elif period == "month":
            start_date = today - timedelta(days=30)
        elif period == "year":
            start_date = today - timedelta(days=365)
        else:
            start_date = today - timedelta(days=30)
        
        # Get subscriptions created in period
        subscriptions = db.query(Subscription).filter(
            func.date(Subscription.created_at) >= start_date
        ).all()
        
        total_revenue = 0
        for sub in subscriptions:
            plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
            if plan:
                total_revenue += plan.price
        
        return {
            "period": period,
            "total_revenue": total_revenue,
            "subscription_count": len(subscriptions),
            "average_per_subscription": total_revenue / len(subscriptions) if subscriptions else 0
        }
    except Exception as e:
        return {"period": period, "total_revenue": 0, "error": str(e)}

@router.get("/analytics/visits")
async def get_visit_analytics(
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get visit analytics"""
    try:
        today = datetime.utcnow().date()
        
        if period == "week":
            start_date = today - timedelta(days=7)
        elif period == "month":
            start_date = today - timedelta(days=30)
        else:
            start_date = today - timedelta(days=30)
        
        # Daily visits
        daily_data = []
        current_date = start_date
        while current_date <= today:
            count = db.query(func.count(Visit.id)).filter(
                func.date(Visit.check_in_time) == current_date
            ).scalar() or 0
            daily_data.append({
                "date": current_date.isoformat(),
                "count": count
            })
            current_date += timedelta(days=1)
        
        return {
            "period": period,
            "data": daily_data,
            "total": sum(d["count"] for d in daily_data)
        }
    except Exception as e:
        return {"period": period, "data": [], "total": 0, "error": str(e)}

@router.get("/analytics/subscriptions")
async def get_subscription_analytics(
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get subscription analytics"""
    try:
        # Subscription status breakdown
        active = db.query(func.count(Subscription.id)).filter(
            Subscription.status == "active"
        ).scalar() or 0
        
        cancelled = db.query(func.count(Subscription.id)).filter(
            Subscription.status == "cancelled"
        ).scalar() or 0
        
        expired = db.query(func.count(Subscription.id)).filter(
            Subscription.status == "expired"
        ).scalar() or 0
        
        frozen = db.query(func.count(Subscription.id)).filter(
            Subscription.status == "frozen"
        ).scalar() or 0
        
        # Plan popularity
        plans = db.query(SubscriptionPlan).filter(SubscriptionPlan.is_active == True).all()
        plan_stats = []
        for plan in plans:
            count = db.query(func.count(Subscription.id)).filter(
                Subscription.plan_id == plan.id
            ).scalar() or 0
            plan_stats.append({
                "plan_id": str(plan.id),
                "plan_name": plan.name,
                "subscription_count": count,
                "price": plan.price
            })
        
        return {
            "status_breakdown": {
                "active": active,
                "cancelled": cancelled,
                "expired": expired,
                "frozen": frozen
            },
            "plan_popularity": plan_stats,
            "total": active + cancelled + expired + frozen
        }
    except Exception as e:
        return {"status_breakdown": {}, "plan_popularity": [], "error": str(e)}

# ==================== PROMOTIONS ENDPOINTS ====================

class PromotionCreate(BaseModel):
    name: str
    description: str
    discount_percent: float
    start_date: datetime
    end_date: datetime
    is_active: bool = True
    code: Optional[str] = None

# In-memory promotions storage (replace with database in production)
promotions_db = []

@router.get("/promotions")
async def get_promotions():
    """Get all promotions"""
    return promotions_db

@router.post("/promotions")
async def create_promotion(promotion: PromotionCreate):
    """Create a new promotion"""
    promo_id = len(promotions_db) + 1
    new_promo = {
        "id": promo_id,
        **promotion.dict(),
        "created_at": datetime.utcnow().isoformat()
    }
    promotions_db.append(new_promo)
    return new_promo

@router.put("/promotions/{promo_id}")
async def update_promotion(promo_id: int, promotion: PromotionCreate):
    """Update a promotion"""
    for i, promo in enumerate(promotions_db):
        if promo["id"] == promo_id:
            promotions_db[i] = {
                "id": promo_id,
                **promotion.dict(),
                "updated_at": datetime.utcnow().isoformat()
            }
            return promotions_db[i]
    raise HTTPException(status_code=404, detail="Promotion not found")

@router.delete("/promotions/{promo_id}")
async def delete_promotion(promo_id: int):
    """Delete a promotion"""
    for i, promo in enumerate(promotions_db):
        if promo["id"] == promo_id:
            promotions_db.pop(i)
            return {"message": "Promotion deleted"}
    raise HTTPException(status_code=404, detail="Promotion not found")

@router.post("/promotions/{promo_id}/activate")
async def activate_promotion(promo_id: int):
    """Activate a promotion"""
    for promo in promotions_db:
        if promo["id"] == promo_id:
            promo["is_active"] = True
            return promo
    raise HTTPException(status_code=404, detail="Promotion not found")

@router.post("/promotions/{promo_id}/deactivate")
async def deactivate_promotion(promo_id: int):
    """Deactivate a promotion"""
    for promo in promotions_db:
        if promo["id"] == promo_id:
            promo["is_active"] = False
            return promo
    raise HTTPException(status_code=404, detail="Promotion not found")

# ==================== AUDIT LOGS ENDPOINTS ====================

audit_logs_db = []

@router.get("/audit-logs")
async def get_audit_logs(
    skip: int = 0,
    limit: int = 50,
    action: Optional[str] = None
):
    """Get audit logs"""
    logs = audit_logs_db
    if action:
        logs = [log for log in logs if log.get("action") == action]
    return logs[skip:skip + limit]

@router.get("/audit-logs/{log_id}")
async def get_audit_log(log_id: int):
    """Get specific audit log"""
    for log in audit_logs_db:
        if log.get("id") == log_id:
            return log
    raise HTTPException(status_code=404, detail="Audit log not found")

# ==================== SETTINGS ENDPOINTS ====================

settings_db = {
    "app_name": "YuvGO",
    "currency": "UZS",
    "default_language": "uz",
    "maintenance_mode": False,
    "max_vehicles_per_user": 5,
    "qr_code_expiry_minutes": 30,
    "visit_cooldown_minutes": 60,
}

@router.get("/settings")
async def get_settings():
    """Get all settings"""
    return settings_db

@router.put("/settings")
async def update_settings(settings: dict):
    """Update settings"""
    settings_db.update(settings)
    return settings_db

@router.get("/settings/{key}")
async def get_setting(key: str):
    """Get specific setting"""
    if key in settings_db:
        return {"key": key, "value": settings_db[key]}
    raise HTTPException(status_code=404, detail="Setting not found")

@router.put("/settings/{key}")
async def update_setting(key: str, data: dict):
    """Update specific setting"""
    settings_db[key] = data.get("value")
    return {"key": key, "value": settings_db[key]}
