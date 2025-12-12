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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8006)
