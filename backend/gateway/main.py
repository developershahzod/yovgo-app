from fastapi import FastAPI, Request, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.responses import JSONResponse
from prometheus_client import Counter, Histogram, generate_latest
from starlette.responses import Response
import httpx
import time
import os
import sys

# Add parent directory to path for shared imports
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from shared.redis_client import RedisCache
from shared.auth import AuthHandler
from routes import mobile_api

app = FastAPI(
    title="YuvGo Gateway API",
    description="API Gateway for YuvGo Subscription-Based Car Wash Marketplace",
    version="1.0.0"
)

# GZip Compression for responses > 500 bytes
app.add_middleware(GZipMiddleware, minimum_size=500)

# CORS is handled by nginx - no middleware needed here

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
            return JSONResponse(
                content=response.json() if response.text else {},
                status_code=response.status_code
            )
        except httpx.RequestError as e:
            raise HTTPException(status_code=503, detail=f"Service unavailable: {str(e)}")

# User Service Routes
@app.api_route("/api/user/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def user_service(path: str, request: Request):
    return await proxy_request("user", f"/{path}", request)

# Subscription Service Routes
@app.api_route("/api/subscription/{path:path}", methods=["GET", "POST", "PUT", "DELETE", "PATCH"])
async def subscription_service(path: str, request: Request):
    return await proxy_request("subscription", f"/{path}", request)

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

# Include mobile API routes
app.include_router(mobile_api.router, prefix="/api/mobile", tags=["Mobile API"])

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
