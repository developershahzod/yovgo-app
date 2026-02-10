from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime, timedelta
import sys
import os
import uuid

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Payment, Subscription, SubscriptionPlan, User, Base
from shared.schemas import PaymentCreate, PaymentResponse
from shared.auth import AuthHandler

# Import IpakYuliBank client - use relative import for Docker
try:
    from .ipakyuli_client import (
        IpakYuliClient, 
        IpakYuliError, 
        IpakYuliWebhookPayload,
        amount_to_tiyin,
        tiyin_to_uzs
    )
except ImportError:
    from ipakyuli_client import (
        IpakYuliClient, 
        IpakYuliError, 
        IpakYuliWebhookPayload,
        amount_to_tiyin,
        tiyin_to_uzs
    )

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Payment Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# IpakYuliBank E-Comm credentials
IPAKYULI_ACCESS_TOKEN = os.getenv("IPAKYULI_ACCESS_TOKEN", "")
IPAKYULI_CASHBOX_ID = os.getenv("IPAKYULI_CASHBOX_ID", "")

# Initialize IpakYuliBank client
ipakyuli_client = IpakYuliClient()

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

@app.delete("/payments/{payment_id}")
async def delete_payment(payment_id: str, db: Session = Depends(get_db)):
    """Delete a payment record (admin)"""
    payment = db.query(Payment).filter(Payment.id == payment_id).first()
    if not payment:
        raise HTTPException(status_code=404, detail="Payment not found")
    db.delete(payment)
    db.commit()
    return {"message": "Payment deleted successfully"}

# ==================== IPAKYULIBANK E-COMM INTEGRATION ====================

from pydantic import BaseModel
from typing import Optional

class CreatePaymentLinkRequest(BaseModel):
    """Request to create IpakYuliBank payment link"""
    subscription_id: str
    amount: float  # Amount in UZS
    description: Optional[str] = None
    success_url: Optional[str] = None
    fail_url: Optional[str] = None

@app.post("/ipakyuli/create-payment")
async def create_ipakyuli_payment(
    request: CreatePaymentLinkRequest,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """
    Create IpakYuliBank payment link for subscription
    
    Returns payment_url to redirect user to IpakYuliBank's secure payment page.
    """
    user_id = current_user.get("sub")
    
    # Get subscription
    subscription = db.query(Subscription).filter(
        Subscription.id == request.subscription_id
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    # Get user
    user = db.query(User).filter(User.id == user_id).first()
    
    # Generate unique order ID
    order_id = f"YUVGO_{uuid.uuid4().hex[:12]}"
    
    # Create payment record
    payment = Payment(
        user_id=user_id,
        subscription_id=subscription.id,
        amount=request.amount,
        provider="ipakyuli",
        status="pending"
    )
    db.add(payment)
    db.commit()
    db.refresh(payment)
    
    try:
        # Create payment link via IpakYuliBank
        result = await ipakyuli_client.create_payment_link(
            order_id=order_id,
            amount=amount_to_tiyin(request.amount),  # Convert to tiyin
            description=request.description or f"YuvGO obuna to'lovi - {subscription.id}",
            customer_id=str(user_id),
            customer_phone=user.phone_number if user else None,
            success_url=request.success_url,
            fail_url=request.fail_url
        )
        
        # Update payment with transfer_id
        payment.transaction_id = result.get("transfer_id")
        payment.payment_metadata = {"order_id": order_id, "ipakyuli_response": result}
        db.commit()
        
        return {
            "payment_id": str(payment.id),
            "transfer_id": result.get("transfer_id"),
            "payment_url": result.get("payment_url"),
            "order_id": order_id,
            "amount": request.amount,
            "status": result.get("status", "await_payment")
        }
        
    except IpakYuliError as e:
        payment.status = "failed"
        payment.payment_metadata = {"error_code": e.code, "error_message": e.message}
        db.commit()
        raise HTTPException(status_code=400, detail=f"Payment creation failed: {e.message}")

@app.get("/ipakyuli/status/{transfer_id}")
async def get_ipakyuli_payment_status(
    transfer_id: str,
    db: Session = Depends(get_db)
):
    """Get payment status from IpakYuliBank"""
    try:
        result = await ipakyuli_client.get_transfer_status(transfer_id)
        
        # Update local payment record
        payment = db.query(Payment).filter(
            Payment.transaction_id == transfer_id
        ).first()
        
        if payment:
            status = result.get("status")
            if status == "success":
                payment.status = "completed"
                # Activate subscription
                subscription = db.query(Subscription).filter(
                    Subscription.id == payment.subscription_id
                ).first()
                if subscription:
                    subscription.status = "active"
            elif status in ["failed", "canceled", "expired"]:
                payment.status = "failed"
            db.commit()
        
        return result
        
    except IpakYuliError as e:
        raise HTTPException(status_code=400, detail=f"Status check failed: {e.message}")

@app.post("/ipakyuli/cancel/{transfer_id}")
async def cancel_ipakyuli_payment(
    transfer_id: str,
    reason: Optional[str] = None,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Cancel a pending IpakYuliBank payment"""
    try:
        result = await ipakyuli_client.cancel_transfer(transfer_id, reason)
        
        # Update local payment record
        payment = db.query(Payment).filter(
            Payment.transaction_id == transfer_id
        ).first()
        
        if payment:
            payment.status = "cancelled"
            db.commit()
        
        return result
        
    except IpakYuliError as e:
        raise HTTPException(status_code=400, detail=f"Cancellation failed: {e.message}")

# ==================== TOKENIZED PAYMENTS (SUBSCRIPTIONS) ====================

class CreateTokenRequest(BaseModel):
    """Request to create tokenization contract"""
    success_url: Optional[str] = None
    fail_url: Optional[str] = None

@app.post("/ipakyuli/tokenize")
async def create_tokenization_contract(
    request: CreateTokenRequest,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """
    Create tokenization contract for recurring payments
    
    User will be redirected to enter card details.
    Card will be saved for future automatic subscription renewals.
    """
    user_id = current_user.get("sub")
    user = db.query(User).filter(User.id == user_id).first()
    
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    try:
        result = await ipakyuli_client.create_tokenization_contract(
            customer_id=str(user_id),
            customer_phone=user.phone_number,
            description="YuvGO avtomatik to'lov uchun karta",
            success_url=request.success_url,
            fail_url=request.fail_url
        )
        
        return {
            "contract_id": result.get("contract_id"),
            "payment_url": result.get("payment_url"),
            "status": result.get("status")
        }
        
    except IpakYuliError as e:
        raise HTTPException(status_code=400, detail=f"Tokenization failed: {e.message}")

@app.post("/ipakyuli/pay-with-token")
async def pay_with_tokenized_card(
    contract_id: str,
    subscription_id: str,
    amount: float,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """
    Make payment using tokenized card
    
    Used for automatic subscription renewals.
    """
    user_id = current_user.get("sub")
    
    # Get subscription
    subscription = db.query(Subscription).filter(
        Subscription.id == subscription_id,
        Subscription.user_id == user_id
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    order_id = f"YUVGO_AUTO_{uuid.uuid4().hex[:12]}"
    
    # Create payment record
    payment = Payment(
        user_id=user_id,
        subscription_id=subscription.id,
        amount=amount,
        provider="ipakyuli_token",
        status="pending"
    )
    db.add(payment)
    db.commit()
    db.refresh(payment)
    
    try:
        result = await ipakyuli_client.pay_with_token(
            contract_id=contract_id,
            order_id=order_id,
            amount=amount_to_tiyin(amount),
            description=f"YuvGO obuna yangilash - {subscription.id}"
        )
        
        payment.transaction_id = result.get("transfer_id")
        
        if result.get("status") == "success":
            payment.status = "completed"
            # Extend subscription
            subscription.status = "active"
            subscription.end_date = subscription.end_date + timedelta(days=30)
        else:
            payment.status = "failed"
        
        db.commit()
        
        return {
            "payment_id": str(payment.id),
            "transfer_id": result.get("transfer_id"),
            "status": result.get("status"),
            "amount": amount
        }
        
    except IpakYuliError as e:
        payment.status = "failed"
        db.commit()
        raise HTTPException(status_code=400, detail=f"Token payment failed: {e.message}")

@app.get("/ipakyuli/contracts")
async def list_user_contracts(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """List user's tokenized cards"""
    user_id = current_user.get("sub")
    
    try:
        result = await ipakyuli_client.list_contracts(str(user_id))
        return result
    except IpakYuliError as e:
        raise HTTPException(status_code=400, detail=f"Failed to list contracts: {e.message}")

@app.delete("/ipakyuli/contracts/{contract_id}")
async def delete_contract(
    contract_id: str,
    current_user = Depends(AuthHandler.get_current_user)
):
    """Delete a tokenized card"""
    try:
        result = await ipakyuli_client.cancel_contract(contract_id)
        return result
    except IpakYuliError as e:
        raise HTTPException(status_code=400, detail=f"Failed to delete contract: {e.message}")

# ==================== IPAKYULIBANK WEBHOOK ====================

@app.post("/webhook/ipakyuli")
async def ipakyuli_webhook(request: Request, db: Session = Depends(get_db)):
    """
    Handle IpakYuliBank payment webhook notifications
    
    IpakYuliBank will POST to this endpoint when payment status changes.
    """
    data = await request.json()
    
    transfer_id = data.get("transfer_id")
    status = data.get("status")
    order_id = data.get("order_id")
    
    print(f"📥 IpakYuli Webhook: transfer_id={transfer_id}, status={status}")
    
    # Find payment by transfer_id
    payment = db.query(Payment).filter(
        Payment.transaction_id == transfer_id
    ).first()
    
    if not payment:
        # Try to find by order_id in metadata
        payments = db.query(Payment).filter(
            Payment.provider.in_(["ipakyuli", "ipakyuli_token"])
        ).all()
        
        for p in payments:
            if p.payment_metadata and p.payment_metadata.get("order_id") == order_id:
                payment = p
                break
    
    if payment:
        if status == "success":
            payment.status = "completed"
            
            # Activate subscription
            subscription = db.query(Subscription).filter(
                Subscription.id == payment.subscription_id
            ).first()
            
            if subscription:
                subscription.status = "active"
                # If subscription was pending, set dates
                if not subscription.start_date:
                    subscription.start_date = datetime.utcnow()
                    plan = db.query(SubscriptionPlan).filter(
                        SubscriptionPlan.id == subscription.plan_id
                    ).first()
                    if plan:
                        subscription.end_date = subscription.start_date + timedelta(days=plan.duration_days)
                        subscription.visits_remaining = plan.visit_limit or 0
                        subscription.is_unlimited = plan.is_unlimited
                
                # Send success notification
                try:
                    from shared.models import Notification
                    notification = Notification(
                        user_id=payment.user_id,
                        title="To'lov muvaffaqiyatli!",
                        message="Sizning obunangiz faollashtirildi. YuvGO dan foydalanishingiz mumkin!",
                        type="payment",
                        channel="push",
                        sent_at=datetime.utcnow()
                    )
                    db.add(notification)
                except Exception as e:
                    print(f"Failed to create notification: {e}")
            
        elif status in ["failed", "canceled", "expired"]:
            payment.status = "failed"
            payment.payment_metadata = {
                **(payment.payment_metadata or {}),
                "failure_reason": status,
                "error_code": data.get("error_code"),
                "error_message": data.get("error_message")
            }
        
        db.commit()
    
    # IMPORTANT: Return {"code": 0} to acknowledge webhook
    # Otherwise IpakYuliBank will retry the webhook
    return {"code": 0, "message": "OK"}

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

# ==================== PAYMENT METHODS ====================

from pydantic import BaseModel
from typing import Optional

class PaymentMethodCreate(BaseModel):
    card_number: str
    expiry_date: str
    card_holder_name: str
    card_type: Optional[str] = None

# In-memory storage for payment methods (use database in production)
payment_methods_db = {}

@app.get("/methods")
async def get_payment_methods(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get user's saved payment methods"""
    user_id = current_user.get("sub")
    methods = payment_methods_db.get(user_id, [])
    return methods

@app.post("/methods")
async def add_payment_method(
    method: PaymentMethodCreate,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Add payment method"""
    user_id = current_user.get("sub")
    
    # Mask card number
    masked_card = f"**** **** **** {method.card_number[-4:]}"
    
    # Detect card type
    card_type = "unknown"
    if method.card_number.startswith("8600"):
        card_type = "uzcard"
    elif method.card_number.startswith("9860"):
        card_type = "humo"
    elif method.card_number.startswith("4"):
        card_type = "visa"
    elif method.card_number.startswith("5"):
        card_type = "mastercard"
    
    new_method = {
        "id": str(len(payment_methods_db.get(user_id, [])) + 1),
        "masked_card": masked_card,
        "card_type": card_type,
        "expiry_date": method.expiry_date,
        "card_holder_name": method.card_holder_name,
        "is_default": len(payment_methods_db.get(user_id, [])) == 0,
        "created_at": datetime.utcnow().isoformat()
    }
    
    if user_id not in payment_methods_db:
        payment_methods_db[user_id] = []
    payment_methods_db[user_id].append(new_method)
    
    return new_method

@app.delete("/methods/{method_id}")
async def delete_payment_method(
    method_id: str,
    current_user = Depends(AuthHandler.get_current_user)
):
    """Delete payment method"""
    user_id = current_user.get("sub")
    methods = payment_methods_db.get(user_id, [])
    payment_methods_db[user_id] = [m for m in methods if m["id"] != method_id]
    return {"message": "Payment method deleted"}

# ==================== PAYMENT PROCESSING ====================

class ProcessPaymentRequest(BaseModel):
    subscription_id: str
    payment_method_id: Optional[str] = None
    amount: float
    provider: str = "payme"

@app.post("/process")
async def process_payment(
    request: ProcessPaymentRequest,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Process payment for subscription"""
    user_id = current_user.get("sub")
    
    # Verify subscription
    subscription = db.query(Subscription).filter(
        Subscription.id == request.subscription_id
    ).first()
    
    if not subscription:
        raise HTTPException(status_code=404, detail="Subscription not found")
    
    # Create payment record
    import uuid
    transaction_id = f"{request.provider.upper()}_{uuid.uuid4().hex[:16]}"
    
    payment = Payment(
        user_id=user_id,
        subscription_id=subscription.id,
        amount=request.amount,
        provider=request.provider,
        transaction_id=transaction_id,
        status="pending"
    )
    
    db.add(payment)
    db.commit()
    db.refresh(payment)
    
    # Generate payment URL based on provider
    payment_url = None
    if request.provider == "payme":
        payment_url = f"https://checkout.paycom.uz/{PAYME_MERCHANT_ID}"
    elif request.provider == "click":
        payment_url = f"https://my.click.uz/services/pay?merchant_id={CLICK_MERCHANT_ID}"
    
    return {
        "payment_id": str(payment.id),
        "transaction_id": transaction_id,
        "amount": request.amount,
        "provider": request.provider,
        "status": "pending",
        "payment_url": payment_url
    }

# ==================== PAYMENT HISTORY ====================

@app.get("/history")
async def get_payment_history(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get user's payment history"""
    user_id = current_user.get("sub")
    
    payments = db.query(Payment).filter(
        Payment.user_id == user_id
    ).order_by(Payment.created_at.desc()).offset(skip).limit(limit).all()
    
    return [
        {
            "id": str(p.id),
            "amount": float(p.amount),
            "currency": p.currency,
            "provider": p.provider,
            "status": p.status,
            "transaction_id": p.transaction_id,
            "created_at": p.created_at.isoformat() if p.created_at else None
        }
        for p in payments
    ]

# ==================== EARNINGS (FOR PARTNERS) ====================

from sqlalchemy import func

@app.get("/earnings")
async def get_partner_earnings(
    partner_id: str,
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get partner earnings summary"""
    from shared.models import Visit
    
    now = datetime.utcnow()
    
    if period == "day":
        start_date = now.replace(hour=0, minute=0, second=0, microsecond=0)
    elif period == "week":
        start_date = now - timedelta(days=7)
    elif period == "month":
        start_date = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    elif period == "year":
        start_date = now.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
    else:
        start_date = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    
    # Count visits for this partner in period
    visit_count = db.query(func.count(Visit.id)).filter(
        Visit.partner_id == partner_id,
        Visit.check_in_time >= start_date
    ).scalar() or 0
    
    # Calculate earnings (average revenue per visit)
    avg_revenue_per_visit = 3300  # UZS
    total_earnings = visit_count * avg_revenue_per_visit
    
    return {
        "partner_id": partner_id,
        "period": period,
        "visit_count": visit_count,
        "total_earnings": total_earnings,
        "currency": "UZS"
    }

@app.get("/earnings/daily")
async def get_daily_earnings(
    partner_id: str,
    start_date: Optional[str] = None,
    end_date: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get daily earnings breakdown"""
    from shared.models import Visit
    
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
    avg_revenue_per_visit = 3300
    
    while current_date <= end:
        day_start = datetime.combine(current_date, datetime.min.time())
        day_end = datetime.combine(current_date, datetime.max.time())
        
        visit_count = db.query(func.count(Visit.id)).filter(
            Visit.partner_id == partner_id,
            Visit.check_in_time >= day_start,
            Visit.check_in_time <= day_end
        ).scalar() or 0
        
        daily_data.append({
            "date": current_date.isoformat(),
            "visits": visit_count,
            "earnings": visit_count * avg_revenue_per_visit
        })
        
        current_date += timedelta(days=1)
    
    return daily_data

@app.get("/earnings/monthly")
async def get_monthly_earnings(
    partner_id: str,
    year: int = None,
    db: Session = Depends(get_db)
):
    """Get monthly earnings for a year"""
    from shared.models import Visit
    
    if not year:
        year = datetime.utcnow().year
    
    monthly_data = []
    avg_revenue_per_visit = 3300
    
    for month in range(1, 13):
        start_date = datetime(year, month, 1)
        if month == 12:
            end_date = datetime(year + 1, 1, 1)
        else:
            end_date = datetime(year, month + 1, 1)
        
        visit_count = db.query(func.count(Visit.id)).filter(
            Visit.partner_id == partner_id,
            Visit.check_in_time >= start_date,
            Visit.check_in_time < end_date
        ).scalar() or 0
        
        monthly_data.append({
            "month": month,
            "year": year,
            "visits": visit_count,
            "earnings": visit_count * avg_revenue_per_visit
        })
    
    return monthly_data

# ==================== PAYOUTS ====================

payouts_db = []

@app.get("/payouts")
async def get_payouts(partner_id: str):
    """Get partner payout history"""
    return [p for p in payouts_db if p.get("partner_id") == partner_id]

class PayoutRequest(BaseModel):
    partner_id: str
    amount: float

@app.post("/payouts/request")
async def request_payout(request: PayoutRequest):
    """Request payout for partner"""
    import uuid
    
    payout = {
        "id": str(uuid.uuid4()),
        "partner_id": request.partner_id,
        "amount": request.amount,
        "status": "pending",
        "requested_at": datetime.utcnow().isoformat()
    }
    
    payouts_db.append(payout)
    
    return payout

# ==================== PAYMENT STATS (ADMIN) ====================

@app.get("/stats")
async def get_payment_stats(
    db: Session = Depends(get_db)
):
    """Get payment statistics (admin)"""
    total_payments = db.query(func.count(Payment.id)).scalar() or 0
    completed_payments = db.query(func.count(Payment.id)).filter(
        Payment.status == "completed"
    ).scalar() or 0
    
    total_revenue = db.query(func.sum(Payment.amount)).filter(
        Payment.status == "completed"
    ).scalar() or 0
    
    return {
        "total_payments": total_payments,
        "completed_payments": completed_payments,
        "failed_payments": total_payments - completed_payments,
        "total_revenue": float(total_revenue),
        "currency": "UZS"
    }

@app.get("/revenue")
async def get_revenue(
    period: str = "month",
    db: Session = Depends(get_db)
):
    """Get revenue by period"""
    now = datetime.utcnow()
    
    if period == "day":
        start_date = now.replace(hour=0, minute=0, second=0, microsecond=0)
    elif period == "week":
        start_date = now - timedelta(days=7)
    elif period == "month":
        start_date = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    elif period == "year":
        start_date = now.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
    else:
        start_date = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    
    revenue = db.query(func.sum(Payment.amount)).filter(
        Payment.status == "completed",
        Payment.created_at >= start_date
    ).scalar() or 0
    
    payment_count = db.query(func.count(Payment.id)).filter(
        Payment.status == "completed",
        Payment.created_at >= start_date
    ).scalar() or 0
    
    return {
        "period": period,
        "revenue": float(revenue),
        "payment_count": payment_count,
        "currency": "UZS"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8005)
