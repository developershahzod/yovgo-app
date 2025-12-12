#!/usr/bin/env python3
"""
YuvGo Render.com Deployment Script
This script deploys the YuvGo application to Render.com using their API
"""

import os
import sys
import json
import requests
import time
from typing import Dict, List, Optional

# Render API Configuration
RENDER_API_KEY = "rnd_jDQRMm6OV26Eo1IJC8gRpSr1pp9I"
RENDER_API_BASE = "https://api.render.com/v1"

headers = {
    "Authorization": f"Bearer {RENDER_API_KEY}",
    "Content-Type": "application/json"
}

def create_postgres_database():
    """Create PostgreSQL database on Render"""
    print("📦 Creating PostgreSQL database...")
    
    payload = {
        "name": "yuvgo-postgres",
        "databaseName": "yuvgo_db",
        "databaseUser": "yuvgo",
        "plan": "starter",
        "region": "oregon",
        "version": "16"
    }
    
    response = requests.post(
        f"{RENDER_API_BASE}/postgres",
        headers=headers,
        json=payload
    )
    
    if response.status_code in [200, 201]:
        db_data = response.json()
        print(f"✅ Database created: {db_data.get('name')}")
        return db_data
    else:
        print(f"❌ Failed to create database: {response.text}")
        return None

def create_redis():
    """Create Redis instance on Render"""
    print("📦 Creating Redis instance...")
    
    payload = {
        "name": "yuvgo-redis",
        "plan": "starter",
        "region": "oregon",
        "maxmemoryPolicy": "allkeys-lru"
    }
    
    response = requests.post(
        f"{RENDER_API_BASE}/redis",
        headers=headers,
        json=payload
    )
    
    if response.status_code in [200, 201]:
        redis_data = response.json()
        print(f"✅ Redis created: {redis_data.get('name')}")
        return redis_data
    else:
        print(f"❌ Failed to create Redis: {response.text}")
        return None

def create_web_service(name: str, build_command: str, start_command: str, env_vars: List[Dict]):
    """Create a web service on Render"""
    print(f"🚀 Creating web service: {name}...")
    
    payload = {
        "name": name,
        "type": "web_service",
        "repo": "https://github.com/developershahzod/yougo-app",  # Update with your repo
        "autoDeploy": "yes",
        "branch": "main",
        "buildCommand": build_command,
        "startCommand": start_command,
        "plan": "starter",
        "region": "oregon",
        "envVars": env_vars,
        "healthCheckPath": "/health"
    }
    
    response = requests.post(
        f"{RENDER_API_BASE}/services",
        headers=headers,
        json=payload
    )
    
    if response.status_code in [200, 201]:
        service_data = response.json()
        print(f"✅ Service created: {service_data.get('name')}")
        return service_data
    else:
        print(f"❌ Failed to create service {name}: {response.text}")
        return None

def initialize_database(db_connection_string: str):
    """Initialize database with schema and test data"""
    print("🗄️  Initializing database...")
    
    # This would be run as a one-off job on Render
    # For now, we'll create a script that can be run manually
    print("⚠️  Please run the init_render_db.sh script manually after deployment")
    print(f"   DATABASE_URL={db_connection_string} bash init_render_db.sh")

def deploy_all():
    """Deploy all services to Render"""
    print("=" * 60)
    print("🚀 YuvGo Render.com Deployment")
    print("=" * 60)
    
    # Step 1: Create PostgreSQL database
    db = create_postgres_database()
    if not db:
        print("❌ Deployment failed: Could not create database")
        return
    
    db_connection_string = db.get('connectionString', '')
    db_id = db.get('id', '')
    
    time.sleep(2)
    
    # Step 2: Create Redis
    redis = create_redis()
    if not redis:
        print("❌ Deployment failed: Could not create Redis")
        return
    
    redis_connection_string = redis.get('connectionString', '')
    
    time.sleep(2)
    
    # Step 3: Generate JWT secret
    import secrets
    jwt_secret = secrets.token_urlsafe(32)
    
    # Common environment variables
    common_env = [
        {"key": "DATABASE_URL", "value": db_connection_string},
        {"key": "REDIS_URL", "value": redis_connection_string},
        {"key": "JWT_SECRET", "value": jwt_secret},
        {"key": "ENVIRONMENT", "value": "production"}
    ]
    
    # Step 4: Create Gateway Service
    gateway_env = common_env + [
        {"key": "JWT_ALGORITHM", "value": "HS256"},
        {"key": "ACCESS_TOKEN_EXPIRE_MINUTES", "value": "30"},
        {"key": "REFRESH_TOKEN_EXPIRE_DAYS", "value": "7"}
    ]
    
    gateway = create_web_service(
        name="yuvgo-gateway",
        build_command="pip install -r backend/gateway/requirements.txt",
        start_command="cd backend/gateway && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=gateway_env
    )
    
    time.sleep(2)
    
    # Step 5: Create User Service
    user_env = common_env + [
        {"key": "SMS_PROVIDER_API_KEY", "value": "your-sms-api-key"},
        {"key": "SMS_PROVIDER_URL", "value": "https://sms-provider.uz/api"}
    ]
    
    user_service = create_web_service(
        name="yuvgo-user-service",
        build_command="pip install -r backend/services/user/requirements.txt",
        start_command="cd backend/services/user && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=user_env
    )
    
    time.sleep(2)
    
    # Step 6: Create Partner Service
    partner_env = common_env + [
        {"key": "QR_TOKEN_TTL_SECONDS", "value": "120"},
        {"key": "VISIT_COOLDOWN_HOURS", "value": "4"}
    ]
    
    partner_service = create_web_service(
        name="yuvgo-partner-service",
        build_command="pip install -r backend/services/partner/requirements.txt",
        start_command="cd backend/services/partner && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=partner_env
    )
    
    time.sleep(2)
    
    # Step 7: Create Subscription Service
    subscription_service = create_web_service(
        name="yuvgo-subscription-service",
        build_command="pip install -r backend/services/subscription/requirements.txt",
        start_command="cd backend/services/subscription && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=common_env
    )
    
    time.sleep(2)
    
    # Step 8: Create Payment Service
    payment_env = common_env + [
        {"key": "PAYME_MERCHANT_ID", "value": "your-payme-merchant-id"},
        {"key": "PAYME_SECRET_KEY", "value": "your-payme-secret-key"},
        {"key": "CLICK_MERCHANT_ID", "value": "your-click-merchant-id"},
        {"key": "CLICK_SECRET_KEY", "value": "your-click-secret-key"}
    ]
    
    payment_service = create_web_service(
        name="yuvgo-payment-service",
        build_command="pip install -r backend/services/payment/requirements.txt",
        start_command="cd backend/services/payment && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=payment_env
    )
    
    time.sleep(2)
    
    # Step 9: Create Visit Service
    visit_service = create_web_service(
        name="yuvgo-visit-service",
        build_command="pip install -r backend/services/visit/requirements.txt",
        start_command="cd backend/services/visit && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=common_env
    )
    
    time.sleep(2)
    
    # Step 10: Create Notification Service
    notification_env = common_env + [
        {"key": "FIREBASE_CREDENTIALS_PATH", "value": "./firebase-credentials.json"}
    ]
    
    notification_service = create_web_service(
        name="yuvgo-notification-service",
        build_command="pip install -r backend/services/notification/requirements.txt",
        start_command="cd backend/services/notification && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=notification_env
    )
    
    time.sleep(2)
    
    # Step 11: Create Admin Service
    admin_service = create_web_service(
        name="yuvgo-admin-service",
        build_command="pip install -r backend/services/admin/requirements.txt",
        start_command="cd backend/services/admin && uvicorn main:app --host 0.0.0.0 --port $PORT",
        env_vars=common_env
    )
    
    print("\n" + "=" * 60)
    print("✅ Deployment initiated successfully!")
    print("=" * 60)
    print("\n📋 Next Steps:")
    print("1. Wait for all services to build and deploy (check Render dashboard)")
    print("2. Initialize the database:")
    print(f"   DATABASE_URL='{db_connection_string}' bash init_render_db.sh")
    print("3. Update service URLs in gateway environment variables")
    print("\n🔑 Important Information:")
    print(f"   Database Connection: {db_connection_string}")
    print(f"   Redis Connection: {redis_connection_string}")
    print(f"   JWT Secret: {jwt_secret}")
    print("\n⚠️  Save these credentials securely!")
    print("=" * 60)

if __name__ == "__main__":
    try:
        deploy_all()
    except Exception as e:
        print(f"\n❌ Deployment failed with error: {str(e)}")
        sys.exit(1)
