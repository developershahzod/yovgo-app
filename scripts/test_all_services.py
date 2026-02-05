#!/usr/bin/env python3
"""
YuvGO Comprehensive System Test Script
Tests all APIs, database connections, and services
"""

import requests
import json
import sys
from datetime import datetime

BASE_URL = "http://localhost:8000"
ADMIN_EMAIL = "admin@yuvgo.uz"
ADMIN_PASSWORD = "Admin@123"

class Colors:
    GREEN = '\033[92m'
    RED = '\033[91m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    END = '\033[0m'

def print_header(text):
    print(f"\n{Colors.BLUE}{'='*60}{Colors.END}")
    print(f"{Colors.BLUE}{text}{Colors.END}")
    print(f"{Colors.BLUE}{'='*60}{Colors.END}")

def print_success(text):
    print(f"{Colors.GREEN}✓ {text}{Colors.END}")

def print_error(text):
    print(f"{Colors.RED}✗ {text}{Colors.END}")

def print_warning(text):
    print(f"{Colors.YELLOW}⚠ {text}{Colors.END}")

def test_gateway_health():
    """Test Gateway API health"""
    print_header("Testing Gateway API")
    
    try:
        # Root endpoint
        response = requests.get(f"{BASE_URL}/", timeout=5)
        if response.status_code == 200:
            print_success(f"Gateway root: {response.json()}")
        else:
            print_error(f"Gateway root failed: {response.status_code}")
        
        # Health endpoint
        response = requests.get(f"{BASE_URL}/health", timeout=5)
        if response.status_code == 200:
            print_success(f"Gateway health: {response.json()}")
        else:
            print_error(f"Gateway health failed: {response.status_code}")
            
        return True
    except requests.exceptions.ConnectionError:
        print_error("Gateway not reachable - is it running?")
        return False

def test_services_health():
    """Test all microservices health"""
    print_header("Testing Microservices Health")
    
    try:
        response = requests.get(f"{BASE_URL}/api/services/health", timeout=10)
        if response.status_code == 200:
            data = response.json()
            print_success(f"Gateway: {data.get('gateway', 'unknown')}")
            
            services = data.get('services', {})
            for service, status in services.items():
                if status.get('status') == 'healthy':
                    print_success(f"{service}: {status}")
                else:
                    print_warning(f"{service}: {status}")
            return True
        else:
            print_error(f"Services health check failed: {response.status_code}")
            return False
    except Exception as e:
        print_error(f"Error checking services: {e}")
        return False

def test_admin_login():
    """Test admin authentication"""
    print_header("Testing Admin Authentication")
    
    try:
        response = requests.post(
            f"{BASE_URL}/api/admin/auth/login",
            json={"email": ADMIN_EMAIL, "password": ADMIN_PASSWORD},
            timeout=10
        )
        
        if response.status_code == 200:
            data = response.json()
            print_success(f"Admin login successful")
            print_success(f"Token type: {data.get('token_type')}")
            return data.get('access_token')
        else:
            print_error(f"Admin login failed: {response.status_code} - {response.text}")
            return None
    except Exception as e:
        print_error(f"Error during admin login: {e}")
        return None

def test_admin_endpoints(token):
    """Test admin API endpoints"""
    print_header("Testing Admin API Endpoints")
    
    headers = {"Authorization": f"Bearer {token}"}
    
    endpoints = [
        ("GET", "/api/admin/admins", "List admins"),
        ("GET", "/api/admin/roles", "List roles"),
        ("GET", "/api/admin/promotions", "List promotions"),
        ("GET", "/api/admin/analytics/overview", "Analytics overview"),
        ("GET", "/api/admin/audit-logs", "Audit logs"),
    ]
    
    for method, endpoint, description in endpoints:
        try:
            if method == "GET":
                response = requests.get(f"{BASE_URL}{endpoint}", headers=headers, timeout=10)
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list):
                    print_success(f"{description}: {len(data)} items")
                else:
                    print_success(f"{description}: {data}")
            else:
                print_warning(f"{description}: {response.status_code}")
        except Exception as e:
            print_error(f"{description}: {e}")

def test_user_endpoints():
    """Test user API endpoints"""
    print_header("Testing User API Endpoints")
    
    endpoints = [
        ("GET", "/api/user/health", "User service health"),
    ]
    
    for method, endpoint, description in endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}", timeout=10)
            if response.status_code == 200:
                print_success(f"{description}: {response.json()}")
            else:
                print_warning(f"{description}: {response.status_code}")
        except Exception as e:
            print_error(f"{description}: {e}")

def test_partner_endpoints():
    """Test partner API endpoints"""
    print_header("Testing Partner API Endpoints")
    
    try:
        response = requests.get(f"{BASE_URL}/api/partner/health", timeout=10)
        if response.status_code == 200:
            print_success(f"Partner service health: {response.json()}")
        else:
            print_warning(f"Partner service: {response.status_code}")
    except Exception as e:
        print_error(f"Partner service: {e}")

def test_subscription_endpoints():
    """Test subscription API endpoints"""
    print_header("Testing Subscription API Endpoints")
    
    try:
        response = requests.get(f"{BASE_URL}/api/subscription/health", timeout=10)
        if response.status_code == 200:
            print_success(f"Subscription service health: {response.json()}")
        else:
            print_warning(f"Subscription service: {response.status_code}")
            
        # Test plans endpoint
        response = requests.get(f"{BASE_URL}/api/subscription/plans", timeout=10)
        if response.status_code == 200:
            plans = response.json()
            print_success(f"Subscription plans: {len(plans) if isinstance(plans, list) else plans}")
        else:
            print_warning(f"Subscription plans: {response.status_code}")
    except Exception as e:
        print_error(f"Subscription service: {e}")

def test_mobile_api():
    """Test mobile API endpoints"""
    print_header("Testing Mobile API Endpoints")
    
    endpoints = [
        "/api/mobile/health",
        "/api/mobile/car-washes",
        "/api/mobile/subscription-plans",
    ]
    
    for endpoint in endpoints:
        try:
            response = requests.get(f"{BASE_URL}{endpoint}", timeout=10)
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list):
                    print_success(f"{endpoint}: {len(data)} items")
                else:
                    print_success(f"{endpoint}: OK")
            else:
                print_warning(f"{endpoint}: {response.status_code}")
        except Exception as e:
            print_error(f"{endpoint}: {e}")

def test_database_data(token):
    """Test database has seed data"""
    print_header("Testing Database Seed Data")
    
    headers = {"Authorization": f"Bearer {token}"} if token else {}
    
    # Check users via admin API
    try:
        response = requests.get(f"{BASE_URL}/api/admin/analytics/overview", headers=headers, timeout=10)
        if response.status_code == 200:
            data = response.json()
            print_success(f"Total users: {data.get('total_users', 0)}")
            print_success(f"Active subscriptions: {data.get('active_subscriptions', 0)}")
            print_success(f"Total visits: {data.get('total_visits', 0)}")
            print_success(f"Revenue: {data.get('revenue', 0)} UZS")
        else:
            print_warning(f"Analytics: {response.status_code}")
    except Exception as e:
        print_error(f"Database check: {e}")

def main():
    print(f"\n{Colors.BLUE}YuvGO System Test - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{Colors.END}")
    
    # Test gateway
    if not test_gateway_health():
        print_error("\nGateway is not running. Please start services first:")
        print("  docker-compose up -d")
        sys.exit(1)
    
    # Test services health
    test_services_health()
    
    # Test admin login
    token = test_admin_login()
    
    if token:
        # Test admin endpoints
        test_admin_endpoints(token)
        
        # Test database data
        test_database_data(token)
    
    # Test other services
    test_user_endpoints()
    test_partner_endpoints()
    test_subscription_endpoints()
    test_mobile_api()
    
    print_header("Test Complete")
    print(f"\nTo start all services: docker-compose up -d")
    print(f"Admin Dashboard: http://localhost:3000")
    print(f"Merchant Dashboard: http://localhost:3001")
    print(f"API Gateway: http://localhost:8000")
    print(f"API Docs: http://localhost:8000/docs")

if __name__ == "__main__":
    main()
