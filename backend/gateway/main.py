from fastapi import FastAPI, Request, HTTPException, Depends, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from prometheus_client import Counter, Histogram, generate_latest
from starlette.responses import Response
import httpx
import time
import os
import sys
import uuid
import shutil
import asyncio

# Add parent directory to path for shared imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from shared.redis_client import RedisCache
from shared.auth import AuthHandler
from shared.database import SessionLocal
from routes import mobile_api

app = FastAPI(
    title="YuvGo Gateway API",
    description="API Gateway for YuvGo Subscription-Based Car Wash Marketplace",
    version="1.0.0"
)

# GZip Compression for responses > 500 bytes
app.add_middleware(GZipMiddleware, minimum_size=500)

# CORS middleware for cross-origin requests from admin/merchant dashboards
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://admin.yuvgo.uz",
        "https://merchant.yuvgo.uz",
        "https://app.yuvgo.uz",
        "https://yuvgo.uz",
        "http://localhost:3000",
        "http://localhost:3001",
        "http://localhost:3002",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Prometheus Metrics
REQUEST_COUNT = Counter('gateway_requests_total', 'Total requests', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('gateway_request_latency_seconds', 'Request latency', ['method', 'endpoint'])

# Service URLs
SERVICES = {
    "user": os.getenv("USER_SERVICE_URL", "http://user_service:8001"),
    "subscription": os.getenv("SUBSCRIPTION_SERVICE_URL", "http://subscription_service:8002"),
    "partner": os.getenv("PARTNER_SERVICE_URL", "http://partner_service:8003"),
    "visit": os.getenv("VISIT_SERVICE_URL", "http://visit_service:8004"),
    "payment": os.getenv("PAYMENT_SERVICE_URL", "http://payment_service:8005"),
    "notification": os.getenv("NOTIFICATION_SERVICE_URL", "http://notification_service:8006"),
    "admin": os.getenv("ADMIN_SERVICE_URL", "http://admin_service:8007"),
    "merchant": os.getenv("MERCHANT_SERVICE_URL", "http://partner_service:8003"),
}

# Rate Limiting
RATE_LIMIT_PER_MINUTE = int(os.getenv("RATE_LIMIT_PER_MINUTE", "60"))

async def rate_limit_check(request: Request):
    """Check rate limiting for requests"""
    client_ip = request.client.host
    key = f"rate_limit:{client_ip}"
    
    current_count = RedisCache.get(key)
    if current_count is None:
        RedisCache.set(key, 1, ttl=60)
    else:
        if int(current_count) >= RATE_LIMIT_PER_MINUTE:
            raise HTTPException(status_code=429, detail="Rate limit exceeded")
        RedisCache.increment(key)

@app.middleware("http")
async def log_requests(request: Request, call_next):
    """Log and monitor all requests"""
    start_time = time.time()
    
    # Rate limiting
    if not request.url.path.startswith("/metrics"):
        try:
            await rate_limit_check(request)
        except HTTPException as e:
            return JSONResponse(status_code=e.status_code, content={"detail": e.detail})
    
    response = await call_next(request)
    
    # Record metrics
    duration = time.time() - start_time
    REQUEST_COUNT.labels(method=request.method, endpoint=request.url.path, status=response.status_code).inc()
    REQUEST_LATENCY.labels(method=request.method, endpoint=request.url.path).observe(duration)
    
    return response

async def _bulk_expire_subscriptions():
    """Background task: expire subscriptions where time or visits exhausted."""
    from datetime import datetime as _dt
    while True:
        try:
            db = SessionLocal()
            try:
                now = _dt.utcnow()
                updated = db.execute(
                    __import__('sqlalchemy').text(
                        "UPDATE subscriptions SET status='expired' "
                        "WHERE status='active' AND ("
                        "  end_date < :now "
                        "  OR (is_unlimited = false AND visits_remaining <= 0)"
                        ") RETURNING id"
                    ),
                    {"now": now}
                ).rowcount
                if updated:
                    db.commit()
                    print(f"⏰ Bulk expired {updated} subscription(s)")
            finally:
                db.close()
        except Exception as e:
            print(f"⚠️ Bulk expire error: {e}")
        await asyncio.sleep(60)


@app.on_event("startup")
async def startup_event():
    asyncio.create_task(_bulk_expire_subscriptions())


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "service": "YuvGo Gateway API",
        "version": "1.0.0",
        "status": "running"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy"}

@app.get("/metrics")
async def metrics():
    """Prometheus metrics endpoint"""
    return Response(content=generate_latest(), media_type="text/plain")

# Proxy function for forwarding requests
async def proxy_request(service: str, path: str, request: Request):
    """Proxy request to microservice"""
    service_url = SERVICES.get(service)
    if not service_url:
        raise HTTPException(status_code=404, detail=f"Service '{service}' not found")
    
    url = f"{service_url}{path}"
    
    # Get headers
    headers = dict(request.headers)
    headers.pop("host", None)
    
    # Get body if present
    body = None
    if request.method in ["POST", "PUT", "PATCH"]:
        body = await request.body()
    
    async with httpx.AsyncClient(timeout=30.0) as client:
        try:
            response = await client.request(
                method=request.method,
                url=url,
                headers=headers,
                content=body,
                params=request.query_params
            )
            try:
                content = response.json() if response.text else {}
            except Exception:
                content = {"detail": response.text or "Service error"}
            return JSONResponse(
                content=content,
                status_code=response.status_code
            )
        except httpx.RequestError as e:
            raise HTTPException(status_code=503, detail=f"Service unavailable: {str(e)}")

# ==================== VEHICLE ROUTES (served from gateway DB) ====================

from sqlalchemy.orm import Session as _Session
from shared.models import Vehicle as _Vehicle
from shared.auth import AuthHandler as _AuthHandler
from shared.database import get_db as _get_db
import uuid as _uuid

_get_current_user = _AuthHandler.get_current_user

@app.get("/api/user/vehicles")
async def get_user_vehicles(
    db: _Session = Depends(_get_db),
    current_user: dict = Depends(_get_current_user)
):
    user_id = current_user.get("sub")
    vehicles = db.query(_Vehicle).filter(
        _Vehicle.user_id == user_id,
        _Vehicle.is_active == True
    ).order_by(_Vehicle.created_at.desc()).all()
    return JSONResponse(content=[
        {
            "id": str(v.id),
            "license_plate": v.license_plate,
            "plate_number": v.license_plate,
            "brand": v.brand,
            "model": v.model,
            "color": v.color,
            "year": v.year,
            "vehicle_type": getattr(v, 'vehicle_type', 'sedan') or 'sedan',
            "name": f"{v.brand or ''} {v.model or ''}".strip() or v.license_plate,
            "is_active": v.is_active,
        }
        for v in vehicles
    ])

@app.post("/api/user/vehicles")
async def add_user_vehicle(
    request: Request,
    db: _Session = Depends(_get_db),
    current_user: dict = Depends(_get_current_user)
):
    user_id = current_user.get("sub")
    body = await request.json()
    plate = body.get("license_plate") or body.get("plate_number", "")
    vehicle = _Vehicle(
        id=_uuid.uuid4(),
        user_id=user_id,
        license_plate=plate,
        brand=body.get("brand"),
        model=body.get("model"),
        color=body.get("color"),
        year=body.get("year"),
        is_active=True,
    )
    try:
        setattr(vehicle, 'vehicle_type', body.get("vehicle_type", "sedan"))
    except Exception:
        pass
    db.add(vehicle)
    db.commit()
    db.refresh(vehicle)
    return JSONResponse(content={
        "id": str(vehicle.id),
        "license_plate": vehicle.license_plate,
        "plate_number": vehicle.license_plate,
        "brand": vehicle.brand,
        "model": vehicle.model,
        "color": vehicle.color,
        "year": vehicle.year,
        "vehicle_type": getattr(vehicle, 'vehicle_type', 'sedan') or 'sedan',
        "name": f"{vehicle.brand or ''} {vehicle.model or ''}".strip() or vehicle.license_plate,
    }, status_code=201)

@app.delete("/api/user/vehicles/{vehicle_id}")
async def delete_user_vehicle(
    vehicle_id: str,
    db: _Session = Depends(_get_db),
    current_user: dict = Depends(_get_current_user)
):
    user_id = current_user.get("sub")
    vehicle = db.query(_Vehicle).filter(
        _Vehicle.id == vehicle_id,
        _Vehicle.user_id == user_id
    ).first()
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    vehicle.is_active = False
    db.commit()
    return JSONResponse(content={"success": True})

# User Service Routes (generic proxy — vehicles handled above)
@app.api_route("/api/user/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def user_service(path: str, request: Request):
    return await proxy_request("user", f"/{path}", request)

# Subscription Service Routes
@app.api_route("/api/subscription/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def subscription_service(path: str, request: Request):
    return await proxy_request("subscription", f"/{path}", request)

# Partner Reviews — served from gateway DB (not partner service)
@app.get("/api/partner/reviews")
async def admin_get_all_reviews():
    from shared.database import SessionLocal as _SL
    from shared.models import Review, User, Partner
    db = _SL()
    try:
        reviews = db.query(Review).order_by(Review.created_at.desc()).limit(500).all()
        result = []
        for r in reviews:
            user = db.query(User).filter(User.id == r.user_id).first()
            partner = db.query(Partner).filter(Partner.id == r.partner_id).first()
            result.append({
                "id": str(r.id),
                "partner_id": str(r.partner_id),
                "partner_name": partner.name if partner else "",
                "location_id": str(r.location_id) if r.location_id else None,
                "user_id": str(r.user_id),
                "user_name": user.full_name if user and user.full_name else "Foydalanuvchi",
                "user_phone": user.phone_number if user else "",
                "rating": r.rating,
                "comment": r.comment or "",
                "is_visible": r.is_visible,
                "created_at": r.created_at.isoformat() if r.created_at else None,
            })
        return JSONResponse(result)
    finally:
        db.close()

@app.delete("/api/partner/reviews/{review_id}")
async def admin_delete_review(review_id: str):
    from shared.database import SessionLocal as _SL
    from shared.models import Review
    db = _SL()
    try:
        r = db.query(Review).filter(Review.id == review_id).first()
        if not r:
            raise HTTPException(status_code=404, detail="Review not found")
        db.delete(r)
        db.commit()
        return JSONResponse({"success": True})
    finally:
        db.close()

# Partner Service Routes
@app.api_route("/api/partner/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def partner_service(path: str, request: Request):
    return await proxy_request("partner", f"/{path}", request)

# Visit Service Routes
@app.api_route("/api/visit/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def visit_service(path: str, request: Request):
    return await proxy_request("visit", f"/{path}", request)

# Payment Service Routes
@app.api_route("/api/payment/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def payment_service(path: str, request: Request):
    return await proxy_request("payment", f"/{path}", request)

# Notification Service Routes
@app.api_route("/api/notification/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def notification_service(path: str, request: Request):
    return await proxy_request("notification", f"/{path}", request)

# Admin Service Routes
@app.api_route("/api/admin/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def admin_service(path: str, request: Request):
    return await proxy_request("admin", f"/{path}", request)

# Merchant Service Routes (uses partner service for merchant auth)
@app.api_route("/api/merchant/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def merchant_service(path: str, request: Request):
    return await proxy_request("merchant", f"/merchant/{path}", request)

# Include mobile API routes
app.include_router(mobile_api.router, prefix="/api/mobile", tags=["Mobile API"])

# ==================== IMAGE UPLOAD ====================

UPLOAD_DIR = "/app/uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)
os.makedirs(f"{UPLOAD_DIR}/logos", exist_ok=True)
os.makedirs(f"{UPLOAD_DIR}/gallery", exist_ok=True)

# Serve uploaded files as static
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

def _compress_image(filepath: str, max_bytes: int = 100 * 1024):
    """Compress image in-place to stay under max_bytes (default 100KB)."""
    try:
        from PIL import Image as _Image
        import io as _io
        if os.path.getsize(filepath) <= max_bytes:
            return
        img = _Image.open(filepath)
        if img.mode in ('RGBA', 'P'):
            img = img.convert('RGB')
        # Try progressively lower quality until under limit
        for quality in (75, 60, 45, 30):
            buf = _io.BytesIO()
            img.save(buf, format='JPEG', quality=quality, optimize=True)
            if buf.tell() <= max_bytes:
                with open(filepath, 'wb') as fout:
                    fout.write(buf.getvalue())
                return
        # Last resort: also resize to 800px wide
        img.thumbnail((800, 800), _Image.LANCZOS)
        buf = _io.BytesIO()
        img.save(buf, format='JPEG', quality=30, optimize=True)
        with open(filepath, 'wb') as fout:
            fout.write(buf.getvalue())
    except Exception:
        pass  # If PIL not available or error, keep original

@app.post("/api/upload/image")
async def upload_image(
    file: UploadFile = File(...),
    category: str = Form("gallery"),
):
    """Upload an image file. Returns the public URL."""
    # Validate file type
    allowed = ["image/jpeg", "image/png", "image/webp", "image/gif"]
    if file.content_type not in allowed:
        raise HTTPException(status_code=400, detail="Only JPEG, PNG, WebP, GIF images are allowed")
    
    # Validate file size (max 5MB)
    contents = await file.read()
    if len(contents) > 5 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="File too large. Max 5MB.")
    
    # Generate unique filename
    ext = file.filename.rsplit(".", 1)[-1] if "." in file.filename else "jpg"
    filename = f"{uuid.uuid4().hex}.{ext}"
    
    subfolder = "logos" if category == "logo" else "gallery"
    filepath = f"{UPLOAD_DIR}/{subfolder}/{filename}"
    
    with open(filepath, "wb") as f:
        f.write(contents)
    _compress_image(filepath)

    # Return the public URL
    url = f"/uploads/{subfolder}/{filename}"
    
    return {
        "success": True,
        "url": url,
        "full_url": f"https://app.yuvgo.uz{url}",
        "filename": filename
    }

@app.post("/api/upload/images")
async def upload_multiple_images(
    files: list[UploadFile] = File(...),
    category: str = Form("gallery"),
):
    """Upload multiple image files. Returns list of public URLs."""
    allowed = ["image/jpeg", "image/png", "image/webp", "image/gif"]
    urls = []
    
    for file in files:
        if file.content_type not in allowed:
            continue
        
        contents = await file.read()
        if len(contents) > 5 * 1024 * 1024:
            continue
        
        ext = file.filename.rsplit(".", 1)[-1] if "." in file.filename else "jpg"
        filename = f"{uuid.uuid4().hex}.{ext}"
        
        subfolder = "logos" if category == "logo" else "gallery"
        filepath = f"{UPLOAD_DIR}/{subfolder}/{filename}"
        
        with open(filepath, "wb") as f:
            f.write(contents)
        _compress_image(filepath)

        url = f"https://app.yuvgo.uz/uploads/{subfolder}/{filename}"
        urls.append(url)
    
    return {
        "success": True,
        "urls": urls,
        "count": len(urls)
    }

# Health check for all services
@app.get("/api/services/health")
async def check_all_services():
    """Check health of all microservices"""
    import httpx
    
    results = {}
    async with httpx.AsyncClient(timeout=5.0) as client:
        for service_name, service_url in SERVICES.items():
            try:
                response = await client.get(f"{service_url}/health")
                results[service_name] = {
                    "status": "healthy" if response.status_code == 200 else "unhealthy",
                    "code": response.status_code
                }
            except Exception as e:
                results[service_name] = {
                    "status": "unreachable",
                    "error": str(e)
                }
    
    return {
        "gateway": "healthy",
        "services": results
    }

# API Documentation
@app.get("/api/docs")
async def api_documentation():
    """Get API documentation summary"""
    return {
        "version": "1.0.0",
        "services": {
            "user": "/api/user - User management and authentication",
            "subscription": "/api/subscription - Subscription plans and management",
            "partner": "/api/partner - Partner (car wash) management",
            "visit": "/api/visit - Visit tracking and QR code handling",
            "payment": "/api/payment - Payment processing",
            "notification": "/api/notification - Push notifications",
            "admin": "/api/admin - Admin dashboard APIs",
        },
        "endpoints": {
            "health": "/health",
            "metrics": "/metrics",
            "services_health": "/api/services/health",
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
