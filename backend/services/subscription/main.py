from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
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

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"service": "YuvGo Subscription Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

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
    
    # Check if user already has active subscription
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
        status="pending",  # Will be activated after payment
        start_date=start_date,
        end_date=end_date,
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
    """Get user's current subscription status"""
    user_id = current_user.get("sub")
    
    subscription = db.query(Subscription).filter(
        Subscription.user_id == user_id,
        Subscription.status == "active"
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=404, detail="No active subscription found")
    
    return subscription

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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8002)
