from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import func, and_, or_
from typing import List, Optional
from datetime import datetime, timedelta
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from shared.database import get_db, engine
from shared.models import (
    Admin, AdminRole, User, Partner, Subscription, Visit, Payment, 
    AuditLog, Promotion, SubscriptionPlan, Base
)
from shared.schemas import (
    AdminCreate, AdminUpdate, AdminResponse, AdminRoleCreate, AdminRoleResponse,
    LoginRequest, TokenResponse, PromotionCreate, PromotionResponse, AnalyticsResponse
)
from shared.auth import AuthHandler, require_permission

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="YuvGo Admin Service",
    description="Admin management and analytics service",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

auth_handler = AuthHandler()

@app.get("/")
async def root():
    return {"service": "YuvGo Admin Service", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

# Authentication
@app.post("/auth/login", response_model=TokenResponse)
async def admin_login(login_data: LoginRequest, db: Session = Depends(get_db)):
    """Admin login"""
    admin = db.query(Admin).filter(Admin.email == login_data.email).first()
    
    if not admin or not auth_handler.verify_password(login_data.password, admin.password_hash):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    if not admin.is_active:
        raise HTTPException(status_code=403, detail="Account is deactivated")
    
    # Update last login
    admin.last_login = datetime.utcnow()
    db.commit()
    
    # Create tokens
    token_data = {
        "sub": str(admin.id),
        "email": admin.email,
        "role": admin.role,
        "permissions": admin.permissions
    }
    
    access_token = auth_handler.create_access_token(token_data)
    refresh_token = auth_handler.create_refresh_token(token_data)
    
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

# Admin Management
@app.post("/admins", response_model=AdminResponse)
async def create_admin(
    admin_data: AdminCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("admins.write"))
):
    """Create new admin (requires admins.write permission)"""
    # Check if email already exists
    existing = db.query(Admin).filter(Admin.email == admin_data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Create admin
    admin = Admin(
        email=admin_data.email,
        password_hash=auth_handler.hash_password(admin_data.password),
        full_name=admin_data.full_name,
        role=admin_data.role,
        permissions=admin_data.permissions
    )
    
    db.add(admin)
    db.commit()
    db.refresh(admin)
    
    # Log action
    log_audit(db, current_admin["sub"], "create", "admin", admin.id, {"email": admin.email})
    
    return admin

@app.get("/admins", response_model=List[AdminResponse])
async def list_admins(
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("admins.read"))
):
    """List all admins (requires admins.read permission)"""
    admins = db.query(Admin).offset(skip).limit(limit).all()
    return admins

@app.get("/admins/{admin_id}", response_model=AdminResponse)
async def get_admin(
    admin_id: str,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("admins.read"))
):
    """Get admin by ID"""
    admin = db.query(Admin).filter(Admin.id == admin_id).first()
    if not admin:
        raise HTTPException(status_code=404, detail="Admin not found")
    return admin

@app.put("/admins/{admin_id}", response_model=AdminResponse)
async def update_admin(
    admin_id: str,
    admin_data: AdminUpdate,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("admins.write"))
):
    """Update admin (requires admins.write permission)"""
    admin = db.query(Admin).filter(Admin.id == admin_id).first()
    if not admin:
        raise HTTPException(status_code=404, detail="Admin not found")
    
    changes = {}
    for field, value in admin_data.dict(exclude_unset=True).items():
        if value is not None:
            changes[field] = value
            setattr(admin, field, value)
    
    db.commit()
    db.refresh(admin)
    
    # Log action
    log_audit(db, current_admin["sub"], "update", "admin", admin.id, changes)
    
    return admin

@app.delete("/admins/{admin_id}")
async def delete_admin(
    admin_id: str,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("admins.write"))
):
    """Deactivate admin (requires admins.write permission)"""
    admin = db.query(Admin).filter(Admin.id == admin_id).first()
    if not admin:
        raise HTTPException(status_code=404, detail="Admin not found")
    
    admin.is_active = False
    db.commit()
    
    # Log action
    log_audit(db, current_admin["sub"], "deactivate", "admin", admin.id, {})
    
    return {"message": "Admin deactivated successfully"}

# Admin Roles
@app.post("/roles", response_model=AdminRoleResponse)
async def create_role(
    role_data: AdminRoleCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("admins.write"))
):
    """Create admin role"""
    role = AdminRole(**role_data.dict())
    db.add(role)
    db.commit()
    db.refresh(role)
    
    log_audit(db, current_admin["sub"], "create", "admin_role", role.id, {"name": role.name})
    
    return role

@app.get("/roles", response_model=List[AdminRoleResponse])
async def list_roles(
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """List all admin roles"""
    roles = db.query(AdminRole).all()
    return roles

# Partner Approval
@app.put("/partners/{partner_id}/approve")
async def approve_partner(
    partner_id: str,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("partners.write"))
):
    """Approve partner application"""
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    
    partner.status = "approved"
    partner.is_active = True
    db.commit()
    
    log_audit(db, current_admin["sub"], "approve", "partner", partner.id, {})
    
    return {"message": "Partner approved successfully"}

@app.put("/partners/{partner_id}/reject")
async def reject_partner(
    partner_id: str,
    reason: Optional[str] = None,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("partners.write"))
):
    """Reject partner application"""
    partner = db.query(Partner).filter(Partner.id == partner_id).first()
    if not partner:
        raise HTTPException(status_code=404, detail="Partner not found")
    
    partner.status = "rejected"
    db.commit()
    
    log_audit(db, current_admin["sub"], "reject", "partner", partner.id, {"reason": reason})
    
    return {"message": "Partner rejected"}

# Promotions
@app.post("/promotions", response_model=PromotionResponse)
async def create_promotion(
    promotion_data: PromotionCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("promotions.write"))
):
    """Create promotion"""
    promotion = Promotion(**promotion_data.dict())
    db.add(promotion)
    db.commit()
    db.refresh(promotion)
    
    log_audit(db, current_admin["sub"], "create", "promotion", promotion.id, {"title": promotion.title})
    
    return promotion

@app.get("/promotions", response_model=List[PromotionResponse])
async def list_promotions(
    skip: int = 0,
    limit: int = 20,
    active_only: bool = False,
    db: Session = Depends(get_db),
    current_admin = Depends(AuthHandler.get_current_admin)
):
    """List promotions"""
    query = db.query(Promotion)
    
    if active_only:
        now = datetime.utcnow()
        query = query.filter(
            and_(
                Promotion.is_active == True,
                Promotion.start_date <= now,
                Promotion.end_date >= now
            )
        )
    
    promotions = query.offset(skip).limit(limit).all()
    return promotions

@app.put("/promotions/{promotion_id}", response_model=PromotionResponse)
async def update_promotion(
    promotion_id: str,
    promotion_data: PromotionCreate,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("promotions.write"))
):
    """Update promotion"""
    promotion = db.query(Promotion).filter(Promotion.id == promotion_id).first()
    if not promotion:
        raise HTTPException(status_code=404, detail="Promotion not found")
    
    # Update promotion fields
    for key, value in promotion_data.dict().items():
        setattr(promotion, key, value)
    
    db.commit()
    db.refresh(promotion)
    
    log_audit(db, current_admin["sub"], "update", "promotion", promotion.id, promotion_data.dict())
    
    return promotion

@app.delete("/promotions/{promotion_id}")
async def delete_promotion(
    promotion_id: str,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("promotions.write"))
):
    """Delete promotion"""
    promotion = db.query(Promotion).filter(Promotion.id == promotion_id).first()
    if not promotion:
        raise HTTPException(status_code=404, detail="Promotion not found")
    
    # Soft delete by setting is_active to False
    promotion.is_active = False
    db.commit()
    
    log_audit(db, current_admin["sub"], "delete", "promotion", promotion.id, {"code": promotion.code})
    
    return {"message": "Promotion deleted successfully"}

# Analytics
@app.get("/analytics/overview", response_model=AnalyticsResponse)
async def get_analytics_overview(
    period: str = "month",
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("analytics.read"))
):
    """Get analytics overview"""
    from shared.utils import get_date_range
    
    start_date, end_date = get_date_range(period)
    
    # Total users
    total_users = db.query(func.count(User.id)).scalar()
    
    # Active subscriptions
    active_subscriptions = db.query(func.count(Subscription.id)).filter(
        Subscription.status == "active"
    ).scalar()
    
    # Total visits in period
    total_visits = db.query(func.count(Visit.id)).filter(
        Visit.check_in_time.between(start_date, end_date)
    ).scalar()
    
    # Revenue in period
    revenue = db.query(func.sum(Payment.amount)).filter(
        and_(
            Payment.status == "completed",
            Payment.created_at.between(start_date, end_date)
        )
    ).scalar() or 0
    
    return {
        "total_users": total_users,
        "active_subscriptions": active_subscriptions,
        "total_visits": total_visits,
        "revenue": float(revenue),
        "period": period
    }

@app.get("/analytics/users")
async def get_user_analytics(
    period: str = "month",
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("analytics.read"))
):
    """Get user analytics"""
    from shared.utils import get_date_range
    
    start_date, end_date = get_date_range(period)
    
    # New users
    new_users = db.query(func.count(User.id)).filter(
        User.created_at.between(start_date, end_date)
    ).scalar()
    
    # Active users (users with visits)
    active_users = db.query(func.count(func.distinct(Visit.user_id))).filter(
        Visit.check_in_time.between(start_date, end_date)
    ).scalar()
    
    return {
        "new_users": new_users,
        "active_users": active_users,
        "period": period
    }

@app.get("/analytics/revenue")
async def get_revenue_analytics(
    period: str = "month",
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("analytics.read"))
):
    """Get revenue analytics"""
    from shared.utils import get_date_range
    
    start_date, end_date = get_date_range(period)
    
    # Total revenue
    total_revenue = db.query(func.sum(Payment.amount)).filter(
        and_(
            Payment.status == "completed",
            Payment.created_at.between(start_date, end_date)
        )
    ).scalar() or 0
    
    # Revenue by provider
    revenue_by_provider = db.query(
        Payment.provider,
        func.sum(Payment.amount).label("total")
    ).filter(
        and_(
            Payment.status == "completed",
            Payment.created_at.between(start_date, end_date)
        )
    ).group_by(Payment.provider).all()
    
    return {
        "total_revenue": float(total_revenue),
        "by_provider": [{"provider": p, "amount": float(a)} for p, a in revenue_by_provider],
        "period": period
    }

# Audit Logs
@app.get("/audit-logs")
async def get_audit_logs(
    skip: int = 0,
    limit: int = 50,
    entity_type: Optional[str] = None,
    admin_id: Optional[str] = None,
    db: Session = Depends(get_db),
    current_admin = Depends(require_permission("audit.read"))
):
    """Get audit logs"""
    query = db.query(AuditLog)
    
    if entity_type:
        query = query.filter(AuditLog.entity_type == entity_type)
    
    if admin_id:
        query = query.filter(AuditLog.admin_id == admin_id)
    
    logs = query.order_by(AuditLog.created_at.desc()).offset(skip).limit(limit).all()
    
    return [
        {
            "id": str(log.id),
            "admin_id": str(log.admin_id) if log.admin_id else None,
            "action": log.action,
            "entity_type": log.entity_type,
            "entity_id": str(log.entity_id) if log.entity_id else None,
            "changes": log.changes,
            "created_at": log.created_at
        }
        for log in logs
    ]

def log_audit(db: Session, admin_id: str, action: str, entity_type: str, 
              entity_id: str, changes: dict):
    """Helper function to log audit trail"""
    audit_log = AuditLog(
        admin_id=admin_id,
        action=action,
        entity_type=entity_type,
        entity_id=entity_id,
        changes=changes
    )
    db.add(audit_log)
    db.commit()

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8007)
