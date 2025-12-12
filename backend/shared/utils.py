import secrets
import string
from datetime import datetime, timedelta
from typing import Optional
import qrcode
from io import BytesIO
import base64

def generate_qr_token(length: int = 32) -> str:
    """Generate a secure random token for QR codes"""
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def generate_pin_code(length: int = 6) -> str:
    """Generate a numeric PIN code"""
    return ''.join(secrets.choice(string.digits) for _ in range(length))

def generate_qr_code(data: str) -> str:
    """Generate QR code image and return as base64 string"""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)
    
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Convert to base64
    buffered = BytesIO()
    img.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    
    return f"data:image/png;base64,{img_str}"

def calculate_subscription_end_date(start_date: datetime, duration_days: int) -> datetime:
    """Calculate subscription end date"""
    return start_date + timedelta(days=duration_days)

def is_subscription_active(end_date: datetime) -> bool:
    """Check if subscription is still active"""
    return datetime.utcnow() < end_date

def check_visit_cooldown(last_visit_time: Optional[datetime], cooldown_hours: int = 4) -> bool:
    """Check if enough time has passed since last visit"""
    if not last_visit_time:
        return True
    
    cooldown_end = last_visit_time + timedelta(hours=cooldown_hours)
    return datetime.utcnow() >= cooldown_end

def format_phone_number(phone: str) -> str:
    """Format phone number to standard format"""
    # Remove all non-digit characters
    digits = ''.join(filter(str.isdigit, phone))
    
    # Add +998 prefix for Uzbekistan if not present
    if not digits.startswith('998'):
        digits = '998' + digits
    
    return '+' + digits

def validate_license_plate(plate: str) -> bool:
    """Validate Uzbekistan license plate format"""
    # Basic validation - can be enhanced based on actual format
    plate = plate.replace(' ', '').upper()
    return len(plate) >= 6 and len(plate) <= 10

def calculate_discount(original_price: float, discount_percentage: Optional[float] = None, 
                       discount_amount: Optional[float] = None) -> float:
    """Calculate discounted price"""
    if discount_percentage:
        return original_price * (1 - discount_percentage / 100)
    elif discount_amount:
        return max(0, original_price - discount_amount)
    return original_price

def paginate(query, page: int = 1, page_size: int = 20):
    """Paginate SQLAlchemy query"""
    offset = (page - 1) * page_size
    return query.offset(offset).limit(page_size)

def get_date_range(period: str = "month") -> tuple:
    """Get date range for analytics"""
    now = datetime.utcnow()
    
    if period == "day":
        start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    elif period == "week":
        start = now - timedelta(days=now.weekday())
        start = start.replace(hour=0, minute=0, second=0, microsecond=0)
    elif period == "month":
        start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    elif period == "year":
        start = now.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
    else:
        start = now - timedelta(days=30)
    
    return start, now
