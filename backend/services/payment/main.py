from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
import sys
import os
import hashlib
import hmac

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Payment, Subscription, SubscriptionPlan, Base
from shared.schemas import PaymentCreate, PaymentResponse
from shared.auth import AuthHandler

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Payment Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Payment provider credentials
PAYME_MERCHANT_ID = os.getenv("PAYME_MERCHANT_ID", "")
PAYME_SECRET_KEY = os.getenv("PAYME_SECRET_KEY", "")
CLICK_MERCHANT_ID = os.getenv("CLICK_MERCHANT_ID", "")
CLICK_SECRET_KEY = os.getenv("CLICK_SECRET_KEY", "")

@app.get("/")
async def root():
    return {"service": "YuvGo Payment Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Payment Creation
@app.post("/payments", response_model=PaymentResponse)
async def create_payment(
    payment_data: PaymentCreate,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Create payment for subscription"""
    user_id = current_user.get("sub")
    
    # Get subscription
    subscription = db.query(Subscription).filter(
        Subscription.id == payment_data.subscription_id,
        Subscription.user_id == user_id
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    # Create payment record
    payment = Payment(
        user_id=user_id,
        subscription_id=subscription.id,
        amount=payment_data.amount,
        provider=payment_data.provider,
        payment_method=payment_data.payment_method,
        card_token=payment_data.card_token,
        status="pending"
    )
    
    db.add(payment)
    db.commit()
    db.refresh(payment)
    
    # In production, integrate with actual payment providers
    # For now, return payment details
    
    return payment

@app.get("/payments", response_model=List[PaymentResponse])
async def list_payments(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """List user's payments"""
    user_id = current_user.get("sub")
    
    payments = db.query(Payment).filter(
        Payment.user_id == user_id
    ).order_by(Payment.created_at.desc()).offset(skip).limit(limit).all()
    
    return payments

@app.get("/payments/{payment_id}", response_model=PaymentResponse)
async def get_payment(
    payment_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get payment details"""
    user_id = current_user.get("sub")
    
    payment = db.query(Payment).filter(
        Payment.id == payment_id,
        Payment.user_id == user_id
    ).first()
    
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    
    return payment

# Payme Webhook
@app.post("/webhook/payme")
async def payme_webhook(request: Request, db: Session = Depends(get_db)):
    """Handle Payme payment webhook"""
    data = await request.json()
    
    # Verify signature (implement proper verification)
    # signature = request.headers.get("X-Payme-Signature")
    
    # Process payment status
    transaction_id = data.get("transaction_id")
    status = data.get("status")
    
    payment = db.query(Payment).filter(
        Payment.transaction_id == transaction_id
    ).first()
    
    if payment:
        if status == "success":
            payment.status = "completed"
            
            # Activate subscription
            subscription = db.query(Subscription).filter(
                Subscription.id == payment.subscription_id
            ).first()
            if subscription:
                subscription.status = "active"
        elif status == "failed":
            payment.status = "failed"
        
        db.commit()
    
    return {"status": "ok"}

# Click Webhook
@app.post("/webhook/click")
async def click_webhook(request: Request, db: Session = Depends(get_db)):
    """Handle Click payment webhook"""
    data = await request.json()
    
    # Process payment status
    transaction_id = data.get("click_trans_id")
    status = data.get("status")
    
    payment = db.query(Payment).filter(
        Payment.transaction_id == transaction_id
    ).first()
    
    if payment:
        if status == 1:  # Success
            payment.status = "completed"
            
            # Activate subscription
            subscription = db.query(Subscription).filter(
                Subscription.id == payment.subscription_id
            ).first()
            if subscription:
                subscription.status = "active"
        elif status == -1:  # Failed
            payment.status = "failed"
        
        db.commit()
    
    return {"status": "ok"}

# Paynet Webhook
@app.post("/webhook/paynet")
async def paynet_webhook(request: Request, db: Session = Depends(get_db)):
    """Handle Paynet payment webhook"""
    data = await request.json()
    
    # Process payment status
    transaction_id = data.get("transaction_id")
    status = data.get("status")
    
    payment = db.query(Payment).filter(
        Payment.transaction_id == transaction_id
    ).first()
    
    if payment:
        if status == "completed":
            payment.status = "completed"
            
            # Activate subscription
            subscription = db.query(Subscription).filter(
                Subscription.id == payment.subscription_id
            ).first()
            if subscription:
                subscription.status = "active"
        elif status == "failed":
            payment.status = "failed"
        
        db.commit()
    
    return {"status": "ok"}

# Refund
@app.post("/payments/{payment_id}/refund")
async def refund_payment(
    payment_id: str,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Refund payment (admin only)"""
    payment = db.query(Payment).filter(Payment.id == payment_id).first()
    
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    
    if payment.status != "completed":
        raise HTTPException(status_code=400, detail="Only completed payments can be refunded")
    
    # In production, integrate with payment provider's refund API
    payment.status = "refunded"
    db.commit()
    
    return {"message": "Payment refunded successfully"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8005)
