from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Subscription, SubscriptionPlan, User, Base
from shared.schemas import (
    SubscriptionPlanCreate, SubscriptionPlanResponse,
    SubscriptionCreate, SubscriptionResponse
)
from shared.auth import AuthHandler
from shared.utils import calculate_subscription_end_date

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Subscription Service", version="1.0.0")


def _check_and_expire(subscription: Subscription, db: Session) -> Subscription:
    """
    Auto-expire a subscription if:
      1. end_date has passed (time expired)
      2. visits_remaining == 0 AND not unlimited (visits exhausted)
    Saves to DB if status changed. Returns the updated subscription.
    """
    if subscription.status != "active":
        return subscription

    now = datetime.utcnow()
    expired = False

    # Condition 1: time expired
    if subscription.end_date and subscription.end_date < now:
        expired = True

    # Condition 2: visits exhausted (non-unlimited)
    if not subscription.is_unlimited:
        remaining = subscription.visits_remaining or 0
        if remaining <= 0:
            expired = True

    if expired:
        subscription.status = "expired"
        db.commit()
        db.refresh(subscription)
        print(f"⏰ Subscription {subscription.id} auto-expired: "
              f"end_date={subscription.end_date}, "
              f"visits_remaining={subscription.visits_remaining}, "
              f"is_unlimited={subscription.is_unlimited}")

    return subscription

@app.get("/")
async def root():
    return {"service": "YuvGo Subscription Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Stats endpoint — must be before /subscriptions/* routes to avoid conflicts
@app.get("/stats")
async def get_subscription_stats(db: Session = Depends(get_db)):
    """Return aggregated subscription stats - no limit needed"""
    from sqlalchemy import func
    total = db.query(func.count(Subscription.id)).scalar() or 0
    active = db.query(func.count(Subscription.id)).filter(Subscription.status == 'active').scalar() or 0
    expired = db.query(func.count(Subscription.id)).filter(Subscription.status == 'expired').scalar() or 0
    pending = db.query(func.count(Subscription.id)).filter(Subscription.status == 'pending').scalar() or 0
    cancelled = db.query(func.count(Subscription.id)).filter(Subscription.status == 'cancelled').scalar() or 0
    return {
        "total": total,
        "active": active,
        "expired": expired,
        "pending": pending,
        "cancelled": cancelled,
    }


# Subscription Plans
@app.get("/plans", response_model=List[SubscriptionPlanResponse])
async def list_plans(db: Session = Depends(get_db)):
    """List all active subscription plans"""
    plans = db.query(SubscriptionPlan).filter(
        SubscriptionPlan.is_active == True
    ).all()
    return plans

@app.post("/plans", response_model=SubscriptionPlanResponse)
async def create_plan(
    plan_data: SubscriptionPlanCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Create subscription plan (admin only)"""
    plan = SubscriptionPlan(**plan_data.dict())
    db.add(plan)
    db.commit()
    db.refresh(plan)
    return plan

@app.get("/plans/{plan_id}", response_model=SubscriptionPlanResponse)
async def get_plan(plan_id: str, db: Session = Depends(get_db)):
    """Get subscription plan details"""
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    return plan

@app.put("/plans/{plan_id}", response_model=SubscriptionPlanResponse)
async def update_plan(
    plan_id: str,
    plan_data: SubscriptionPlanCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Update subscription plan (admin only)"""
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    
    # Update plan fields
    for key, value in plan_data.dict().items():
        setattr(plan, key, value)
    
    db.commit()
    db.refresh(plan)
    return plan

@app.delete("/plans/{plan_id}")
async def delete_plan(
    plan_id: str,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Delete subscription plan (admin only)"""
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    
    # Soft delete by setting is_active to False
    plan.is_active = False
    db.commit()
    return {"message": "Plan deleted successfully"}

# Subscriptions
@app.post("/subscriptions", response_model=SubscriptionResponse)
async def create_subscription(
    subscription_data: SubscriptionCreate,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Create new subscription"""
    user_id = current_user.get("sub")
    
    # Check if user exists
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Auto-expire any active subscriptions that have run out before blocking new purchase
    active_subs = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active"
    ).all()
    for sub in active_subs:
        _check_and_expire(sub, db)

    # Now check if user still has a genuinely active subscription
    existing = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active"
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="User already has active subscription")
    
    # Get plan
    plan = db.query(SubscriptionPlan).filter(
        SubscriptionPlan.id == subscription_data.plan_id
    ).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    
    # Create subscription
    start_date = datetime.utcnow()
    end_date = calculate_subscription_end_date(start_date, plan.duration_days)
    
    subscription = Subscription(
        user_id=user_id,
        plan_id=plan.id,
        status="active",  # Активируем сразу для тестирования
        start_date=start_date,
        end_date=end_date,
        visits_remaining=plan.visit_limit if plan.visit_limit else 0,
        is_unlimited=plan.is_unlimited if hasattr(plan, 'is_unlimited') else False,
        auto_renew=subscription_data.auto_renew
    )
    
    db.add(subscription)
    db.commit()
    db.refresh(subscription)
    
    return subscription

@app.get("/subscriptions/status", response_model=SubscriptionResponse)
async def get_subscription_status(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get user's current subscription status — auto-expires if time or visits exhausted"""
    user_id = current_user.get("sub")

    # Check all active subscriptions for this user and auto-expire if needed
    active_subs = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active"
    ).all()

    valid = None
    for sub in active_subs:
        sub = _check_and_expire(sub, db)
        if sub.status == "active":
            valid = sub
            break

    if not valid:
        raise HTTPException(status_code=404, detail="No active subscription found")

    return valid

@app.post("/subscriptions/{subscription_id}/cancel")
async def cancel_subscription(
    subscription_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Cancel subscription (effective at end of billing cycle)"""
    user_id = current_user.get("sub")
    
    subscription = db.query(Subscription).filter(
        Subscription.id == subscription_id,
        Subscription.user_id == user_id
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    subscription.auto_renew = False
    subscription.status = "cancelled"
    db.commit()
    
    return {"message": "Subscription cancelled successfully"}

@app.get("/subscriptions", response_model=List[SubscriptionResponse])
async def list_subscriptions(
    skip: int = 0,
    limit: int = 20,
    status: str = None,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """List all subscriptions (admin only)"""
    query = db.query(Subscription)
    
    if status:
        query = query.filter(Subscription.status == status)
    
    return query.offset(skip).limit(limit).all()

@app.get("/subscriptions/all")
async def list_all_subscriptions_with_users(
    skip: int = 0,
    limit: int = 200,
    status: str = None,
    db: Session = Depends(get_db),
):
    """List all subscriptions with user and plan info (admin, no auth for internal calls)"""
    query = db.query(Subscription)
    if status:
        query = query.filter(Subscription.status == status)
    
    subs = query.order_by(Subscription.created_at.desc()).offset(skip).limit(limit).all()
    
    result = []
    for sub in subs:
        user = db.query(User).filter(User.id == sub.user_id).first()
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
        result.append({
            "id": str(sub.id),
            "user_id": str(sub.user_id),
            "plan_id": str(sub.plan_id) if sub.plan_id else None,
            "status": sub.status,
            "start_date": sub.start_date.isoformat() if sub.start_date else None,
            "end_date": sub.end_date.isoformat() if sub.end_date else None,
            "visits_used": sub.visits_used or 0,
            "visits_remaining": sub.visits_remaining or 0,
            "is_unlimited": sub.is_unlimited,
            "auto_renew": sub.auto_renew,
            "created_at": sub.created_at.isoformat() if sub.created_at else None,
            "user": {
                "id": str(user.id),
                "full_name": user.full_name,
                "phone_number": user.phone_number,
                "email": user.email,
            } if user else None,
            "plan": {
                "id": str(plan.id),
                "name": plan.name,
                "price": float(plan.price),
                "currency": plan.currency,
                "duration_days": plan.duration_days,
                "visit_limit": plan.visit_limit,
                "is_unlimited": plan.is_unlimited,
            } if plan else None,
        })
    
    return result


@app.put("/subscriptions/{subscription_id}")
async def update_subscription(
    subscription_id: str,
    db: Session = Depends(get_db),
    status: str = None,
    plan_id: str = None,
    start_date: str = None,
    end_date: str = None,
    visits_used: int = None,
    visits_remaining: int = None,
    is_unlimited: bool = None,
    auto_renew: bool = None,
):
    """Update subscription (admin) — change status, plan, dates, visits"""
    subscription = db.query(Subscription).filter(Subscription.id == subscription_id).first()
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    if status is not None:
        subscription.status = status
    if plan_id is not None:
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
        if not plan:
            raise HTTPException(status_code=404, detail="Plan not found")
        subscription.plan_id = plan.id
    if start_date is not None:
        subscription.start_date = datetime.fromisoformat(start_date)
    if end_date is not None:
        subscription.end_date = datetime.fromisoformat(end_date)
    if visits_used is not None:
        subscription.visits_used = visits_used
    if visits_remaining is not None:
        subscription.visits_remaining = visits_remaining
    if is_unlimited is not None:
        subscription.is_unlimited = is_unlimited
    if auto_renew is not None:
        subscription.auto_renew = auto_renew
    
    db.commit()
    db.refresh(subscription)
    return {"message": "Subscription updated", "id": str(subscription.id), "status": subscription.status}


@app.post("/subscriptions/{subscription_id}/approve")
async def approve_subscription(
    subscription_id: str,
    db: Session = Depends(get_db),
):
    """Approve/confirm a pending subscription (admin)"""
    subscription = db.query(Subscription).filter(Subscription.id == subscription_id).first()
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    subscription.status = "active"
    if not subscription.start_date:
        subscription.start_date = datetime.utcnow()
    if not subscription.end_date and subscription.plan_id:
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == subscription.plan_id).first()
        if plan:
            subscription.end_date = calculate_subscription_end_date(subscription.start_date, plan.duration_days)
    
    db.commit()
    return {"message": "Subscription approved", "id": str(subscription.id), "status": "active"}


@app.post("/subscriptions/admin-create")
async def admin_create_subscription(
    user_id: str,
    plan_id: str,
    status: str = "active",
    db: Session = Depends(get_db),
):
    """Create subscription for a user (admin-initiated, no user auth needed)"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == plan_id).first()
    if not plan:
        raise HTTPException(status_code=404, detail="Plan not found")
    
    start_date = datetime.utcnow()
    end_date = calculate_subscription_end_date(start_date, plan.duration_days)
    
    subscription = Subscription(
        user_id=user_id,
        plan_id=plan.id,
        status=status,
        start_date=start_date,
        end_date=end_date,
        visits_remaining=plan.visit_limit if plan.visit_limit else 0,
        is_unlimited=plan.is_unlimited if hasattr(plan, 'is_unlimited') else False,
        auto_renew=False,
    )
    db.add(subscription)
    db.commit()
    db.refresh(subscription)
    
    return {
        "message": "Subscription created",
        "id": str(subscription.id),
        "status": subscription.status,
        "user_id": str(subscription.user_id),
        "plan_id": str(subscription.plan_id),
    }


@app.get("/subscriptions/by-user/{user_id}")
async def get_user_subscriptions(
    user_id: str,
    db: Session = Depends(get_db),
):
    """Get all subscriptions for a specific user (admin)"""
    subs = db.query(Subscription).filter(Subscription.user_id == user_id).order_by(Subscription.created_at.desc()).all()
    result = []
    for sub in subs:
        plan = db.query(SubscriptionPlan).filter(SubscriptionPlan.id == sub.plan_id).first()
        result.append({
            "id": str(sub.id),
            "plan_id": str(sub.plan_id) if sub.plan_id else None,
            "status": sub.status,
            "start_date": sub.start_date.isoformat() if sub.start_date else None,
            "end_date": sub.end_date.isoformat() if sub.end_date else None,
            "visits_used": sub.visits_used or 0,
            "visits_remaining": sub.visits_remaining or 0,
            "is_unlimited": sub.is_unlimited,
            "auto_renew": sub.auto_renew,
            "created_at": sub.created_at.isoformat() if sub.created_at else None,
            "plan": {
                "id": str(plan.id),
                "name": plan.name,
                "price": float(plan.price),
                "currency": plan.currency,
                "duration_days": plan.duration_days,
                "visit_limit": plan.visit_limit,
                "is_unlimited": plan.is_unlimited,
            } if plan else None,
        })
    return result


@app.delete("/subscriptions/{subscription_id}")
async def delete_subscription(subscription_id: str, db: Session = Depends(get_db)):
    """Delete a subscription (admin)"""
    subscription = db.query(Subscription).filter(Subscription.id == subscription_id).first()
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    db.delete(subscription)
    db.commit()
    return {"message": "Subscription deleted successfully"}



@app.post("/subscriptions/expire-check")
async def run_expiry_check(db: Session = Depends(get_db)):
    """
    Bulk check all active subscriptions and expire those that have:
    - Passed their end_date
    - Exhausted visits (non-unlimited)
    Can be called by a cron job or admin.
    """
    active_subs = db.query(Subscription).filter(
        Subscription.status == "active"
    ).all()

    expired_ids = []
    for sub in active_subs:
        before = sub.status
        _check_and_expire(sub, db)
        if sub.status == "expired":
            expired_ids.append(str(sub.id))

    return {
        "checked": len(active_subs),
        "expired": len(expired_ids),
        "expired_ids": expired_ids
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)
