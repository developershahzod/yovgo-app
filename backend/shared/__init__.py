# Shared module
from .database import get_db, engine, SessionLocal, Base
from .models import (
    User, Partner, Subscription, Visit, Plan, Admin, Payment,
    SubscriptionPlan, PartnerLocation, PartnerStaff, Vehicle,
    Notification, AdminRole, Promotion, AuditLog, MerchantUser
)
from .auth import AuthHandler, require_permission
from .redis_client import RedisCache
from .schemas import *
from .utils import *

# Convenience alias for get_current_user
get_current_user = AuthHandler.get_current_user
