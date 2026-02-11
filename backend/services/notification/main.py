from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import Notification, User, Base
from shared.auth import AuthHandler

Base.metadata.create_all(bind=engine)

app = FastAPI(title="YuvGo Notification Service", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"service": "YuvGo Notification Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Send Notification
@app.post("/notifications/send")
async def send_notification(
    user_id: str,
    title: str,
    message: str,
    notification_type: str,
    channel: str = "push",
    db: Session = Depends(get_db)
):
    """Send notification to user"""
    # Verify user exists
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Create notification record
    notification = Notification(
        user_id=user_id,
        title=title,
        message=message,
        type=notification_type,
        channel=channel,
        sent_at=datetime.utcnow()
    )
    
    db.add(notification)
    db.commit()
    db.refresh(notification)
    
    # In production, integrate with:
    # - Firebase Cloud Messaging for push notifications
    # - SMS provider for SMS
    # - Email service for emails
    
    return {
        "id": str(notification.id),
        "status": "sent",
        "message": "Notification sent successfully"
    }

# Get User Notifications
@app.get("/notifications")
async def get_notifications(
    skip: int = 0,
    limit: int = 20,
    unread_only: bool = False,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Get user's notifications"""
    user_id = current_user.get("sub")
    
    query = db.query(Notification).filter(Notification.user_id == user_id)
    
    if unread_only:
        query = query.filter(Notification.is_read == False)
    
    notifications = query.order_by(
        Notification.created_at.desc()
    ).offset(skip).limit(limit).all()
    
    return [
        {
            "id": str(n.id),
            "title": n.title,
            "message": n.message,
            "type": n.type,
            "is_read": n.is_read,
            "sent_at": n.sent_at,
            "created_at": n.created_at
        }
        for n in notifications
    ]

# Mark as Read
@app.put("/notifications/{notification_id}/read")
async def mark_as_read(
    notification_id: str,
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Mark notification as read"""
    user_id = current_user.get("sub")
    
    notification = db.query(Notification).filter(
        Notification.id == notification_id,
        Notification.user_id == user_id
    ).first()
    
    if not notification:
        raise HTTPException(status_code=404, detail="Notification not found")
    
    notification.is_read = True
    db.commit()
    
    return {"message": "Notification marked as read"}

# Mark All as Read
@app.put("/notifications/read-all")
async def mark_all_as_read(
    db: Session = Depends(get_db),
    current_user = Depends(AuthHandler.get_current_user)
):
    """Mark all notifications as read"""
    user_id = current_user.get("sub")
    
    db.query(Notification).filter(
        Notification.user_id == user_id,
        Notification.is_read == False
    ).update({"is_read": True})
    
    db.commit()
    
    return {"message": "All notifications marked as read"}

# Bulk Send (Admin)
@app.post("/notifications/broadcast")
async def broadcast_notification(
    title: str,
    message: str,
    notification_type: str,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Broadcast notification to all users (admin only)"""
    users = db.query(User).filter(User.is_active == True).all()
    
    notifications = []
    for user in users:
        notification = Notification(
            user_id=user.id,
            title=title,
            message=message,
            type=notification_type,
            channel="push",
            sent_at=datetime.utcnow()
        )
        notifications.append(notification)
    
    db.bulk_save_objects(notifications)
    db.commit()
    
    return {
        "message": f"Notification broadcast to {len(users)} users",
        "count": len(users)
    }

# ==================== NOTIFICATION TEMPLATES ====================

from pydantic import BaseModel
from typing import Optional, List as TypingList

notification_templates = [
    {
        "id": "1",
        "name": "subscription_expiring",
        "title": "Obuna tugayapti!",
        "message": "Sizning obunangiz {days} kundan keyin tugaydi. Yangilang!",
        "type": "subscription"
    },
    {
        "id": "2",
        "name": "payment_failed",
        "title": "To'lov amalga oshmadi",
        "message": "Sizning to'lovingiz amalga oshmadi. Iltimos, qayta urinib ko'ring.",
        "type": "payment"
    },
    {
        "id": "3",
        "name": "checkin_success",
        "title": "Tashrif muvaffaqiyatli!",
        "message": "{partner_name}da tashrif muvaffaqiyatli qayd etildi.",
        "type": "visit"
    },
    {
        "id": "4",
        "name": "new_carwash",
        "title": "Yangi avtomoyka!",
        "message": "Sizning yaqiningizda yangi avtomoyka ochildi: {partner_name}",
        "type": "promo"
    },
    {
        "id": "5",
        "name": "promo",
        "title": "Maxsus taklif!",
        "message": "{promo_text}",
        "type": "promo"
    }
]

@app.get("/templates")
async def get_notification_templates():
    """Get all notification templates"""
    return notification_templates

class TemplateCreate(BaseModel):
    name: str
    title: str
    message: str
    type: str

@app.post("/templates")
async def create_template(
    template: TemplateCreate,
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Create notification template (admin only)"""
    new_template = {
        "id": str(len(notification_templates) + 1),
        **template.dict()
    }
    notification_templates.append(new_template)
    return new_template

# ==================== SEND NOTIFICATIONS ====================

class SendNotificationRequest(BaseModel):
    user_id: str
    title: str
    message: str
    type: str = "general"
    channel: str = "push"

@app.post("/send")
async def send_single_notification(
    request: SendNotificationRequest,
    db: Session = Depends(get_db)
):
    """Send notification to a single user"""
    # Verify user exists
    user = db.query(User).filter(User.id == request.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Create notification record
    notification = Notification(
        user_id=request.user_id,
        title=request.title,
        message=request.message,
        type=request.type,
        channel=request.channel,
        sent_at=datetime.utcnow()
    )
    
    db.add(notification)
    db.commit()
    db.refresh(notification)
    
    # Send via appropriate channel
    send_result = await _send_notification(
        user=user,
        title=request.title,
        message=request.message,
        channel=request.channel
    )
    
    return {
        "id": str(notification.id),
        "status": "sent" if send_result else "queued",
        "channel": request.channel
    }

class BulkNotificationRequest(BaseModel):
    user_ids: TypingList[str]
    title: str
    message: str
    type: str = "general"
    channel: str = "push"

@app.post("/send-bulk")
async def send_bulk_notification(
    request: BulkNotificationRequest,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """Send notification to multiple users (admin only)"""
    sent_count = 0
    failed_count = 0
    
    for user_id in request.user_ids:
        try:
            user = db.query(User).filter(User.id == user_id).first()
            if user:
                notification = Notification(
                    user_id=user_id,
                    title=request.title,
                    message=request.message,
                    type=request.type,
                    channel=request.channel,
                    sent_at=datetime.utcnow()
                )
                db.add(notification)
                sent_count += 1
            else:
                failed_count += 1
        except Exception:
            failed_count += 1
    
    db.commit()
    
    return {
        "sent": sent_count,
        "failed": failed_count,
        "total": len(request.user_ids)
    }

# ==================== FIREBASE PUSH NOTIFICATIONS ====================

FIREBASE_SERVER_KEY = os.getenv("FIREBASE_SERVER_KEY", "")

async def _send_firebase_push(device_token: str, title: str, message: str, data: dict = None):
    """Send push notification via Firebase Cloud Messaging"""
    if not FIREBASE_SERVER_KEY:
        return False
    
    import httpx
    
    payload = {
        "to": device_token,
        "notification": {
            "title": title,
            "body": message,
            "sound": "default"
        },
        "data": data or {}
    }
    
    headers = {
        "Authorization": f"key={FIREBASE_SERVER_KEY}",
        "Content-Type": "application/json"
    }
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://fcm.googleapis.com/fcm/send",
                json=payload,
                headers=headers
            )
            return response.status_code == 200
    except Exception as e:
        print(f"Firebase push error: {e}")
        return False

# ==================== SMS NOTIFICATIONS ====================

SMS_API_URL = os.getenv("SMS_API_URL", "")
SMS_API_KEY = os.getenv("SMS_API_KEY", "")

async def _send_sms(phone_number: str, message: str):
    """Send SMS via local provider"""
    if not SMS_API_URL or not SMS_API_KEY:
        return False
    
    import httpx
    
    payload = {
        "phone": phone_number,
        "message": message
    }
    
    headers = {
        "Authorization": f"Bearer {SMS_API_KEY}",
        "Content-Type": "application/json"
    }
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                SMS_API_URL,
                json=payload,
                headers=headers
            )
            return response.status_code == 200
    except Exception as e:
        print(f"SMS send error: {e}")
        return False

# ==================== HELPER FUNCTION ====================

async def _send_notification(user, title: str, message: str, channel: str):
    """Send notification via appropriate channel"""
    if channel == "push":
        # In production, get device token from user record
        device_token = getattr(user, 'device_token', None)
        if device_token:
            return await _send_firebase_push(device_token, title, message)
        return True  # Stored in DB, will be fetched by app
    elif channel == "sms":
        return await _send_sms(user.phone_number, message)
    elif channel == "email":
        # Email integration would go here
        return True
    return True

# ==================== TRIGGER NOTIFICATIONS ====================

@app.post("/trigger/subscription-expiring")
async def trigger_subscription_expiring(
    db: Session = Depends(get_db)
):
    """Trigger notifications for expiring subscriptions"""
    from shared.models import Subscription
    from datetime import timedelta
    
    # Find subscriptions expiring in 3 days
    expiry_date = datetime.utcnow() + timedelta(days=3)
    
    expiring_subs = db.query(Subscription).filter(
        Subscription.status == "active",
        Subscription.end_date <= expiry_date,
        Subscription.end_date > datetime.utcnow()
    ).all()
    
    sent_count = 0
    for sub in expiring_subs:
        user = db.query(User).filter(User.id == sub.user_id).first()
        if user:
            days_left = (sub.end_date - datetime.utcnow()).days
            
            notification = Notification(
                user_id=sub.user_id,
                title="Obuna tugayapti!",
                message=f"Sizning obunangiz {days_left} kundan keyin tugaydi. Yangilang!",
                type="subscription",
                channel="push",
                sent_at=datetime.utcnow()
            )
            db.add(notification)
            sent_count += 1
    
    db.commit()
    
    return {"sent": sent_count, "message": f"Sent {sent_count} expiry notifications"}

@app.post("/trigger/payment-failed")
async def trigger_payment_failed(
    user_id: str,
    db: Session = Depends(get_db)
):
    """Trigger payment failed notification"""
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    notification = Notification(
        user_id=user_id,
        title="To'lov amalga oshmadi",
        message="Sizning to'lovingiz amalga oshmadi. Iltimos, qayta urinib ko'ring.",
        type="payment",
        channel="push",
        sent_at=datetime.utcnow()
    )
    db.add(notification)
    db.commit()
    
    # Also send SMS as fallback
    await _send_sms(user.phone_number, "YuvGO: To'lov amalga oshmadi. Ilovani oching.")
    
    return {"status": "sent"}

@app.post("/trigger/checkin-success")
async def trigger_checkin_success(
    user_id: str,
    partner_name: str,
    db: Session = Depends(get_db)
):
    """Trigger check-in success notification"""
    notification = Notification(
        user_id=user_id,
        title="Tashrif muvaffaqiyatli!",
        message=f"{partner_name}da tashrif muvaffaqiyatli qayd etildi.",
        type="visit",
        channel="push",
        sent_at=datetime.utcnow()
    )
    db.add(notification)
    db.commit()
    
    return {"status": "sent"}

# ==================== NOTIFICATION STATS ====================

@app.get("/stats")
async def get_notification_stats(
    db: Session = Depends(get_db)
):
    """Get notification statistics"""
    from sqlalchemy import func
    
    total = db.query(func.count(Notification.id)).scalar() or 0
    unread = db.query(func.count(Notification.id)).filter(
        Notification.is_read == False
    ).scalar() or 0
    
    # By type
    by_type = db.query(
        Notification.type,
        func.count(Notification.id)
    ).group_by(Notification.type).all()
    
    return {
        "total": total,
        "unread": unread,
        "read": total - unread,
        "by_type": {t: c for t, c in by_type}
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8006)
