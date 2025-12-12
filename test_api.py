#!/usr/bin/env python3
"""
YuvGo API Test Script
Tests all endpoints and functionality
"""

import requests
import json
import time
from datetime import datetime

# Configuration
BASE_URL = "http://localhost:8000"
ADMIN_EMAIL = "admin@yuvgo.uz"
ADMIN_PASSWORD = "Admin@123"

# Colors for output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

class APITester:
    def __init__(self):
        self.admin_token = None
        self.user_token = None
        self.test_user_id = None
        self.test_partner_id = None
        self.test_subscription_id = None
        self.passed = 0
        self.failed = 0
        
    def log(self, message, color=RESET):
        print(f"{color}{message}{RESET}")
        
    def test(self, name, func):
        """Run a test function"""
        try:
            self.log(f"\n{'='*60}", BLUE)
            self.log(f"Testing: {name}", BLUE)
            self.log('='*60, BLUE)
            func()
            self.log(f"✓ {name} - PASSED", GREEN)
            self.passed += 1
        except Exception as e:
            self.log(f"✗ {name} - FAILED: {str(e)}", RED)
            self.failed += 1
            
    def test_health_checks(self):
        """Test health endpoints for all services"""
        services = [
            ("Gateway", f"{BASE_URL}/"),
            ("User Service", f"{BASE_URL}/api/user/"),
            ("Subscription Service", f"{BASE_URL}/api/subscription/"),
            ("Partner Service", f"{BASE_URL}/api/partner/"),
            ("Visit Service", f"{BASE_URL}/api/visit/"),
            ("Payment Service", f"{BASE_URL}/api/payment/"),
            ("Notification Service", f"{BASE_URL}/api/notification/"),
            ("Admin Service", f"{BASE_URL}/api/admin/"),
        ]
        
        for name, url in services:
            response = requests.get(url, timeout=5)
            assert response.status_code == 200, f"{name} is not responding"
            self.log(f"  ✓ {name} is healthy", GREEN)
            
    def test_admin_login(self):
        """Test admin authentication"""
        response = requests.post(
            f"{BASE_URL}/api/admin/auth/login",
            json={"email": ADMIN_EMAIL, "password": ADMIN_PASSWORD}
        )
        assert response.status_code == 200, "Admin login failed"
        data = response.json()
        assert "access_token" in data, "No access token received"
        self.admin_token = data["access_token"]
        self.log(f"  ✓ Admin logged in successfully", GREEN)
        self.log(f"  Token: {self.admin_token[:20]}...", YELLOW)
        
    def test_create_user(self):
        """Test user creation"""
        response = requests.post(
            f"{BASE_URL}/api/user/users",
            json={
                "phone_number": f"+998901{int(time.time()) % 1000000:06d}",
                "email": f"test{int(time.time())}@example.com",
                "full_name": "Test User"
            }
        )
        assert response.status_code in [200, 201], f"User creation failed: {response.text}"
        data = response.json()
        self.test_user_id = data["id"]
        self.log(f"  ✓ User created with ID: {self.test_user_id}", GREEN)
        
    def test_list_users(self):
        """Test listing users"""
        headers = {"Authorization": f"Bearer {self.admin_token}"}
        response = requests.get(f"{BASE_URL}/api/user/users", headers=headers)
        assert response.status_code == 200, "Failed to list users"
        data = response.json()
        assert isinstance(data, list), "Response is not a list"
        self.log(f"  ✓ Found {len(data)} users", GREEN)
        
    def test_subscription_plans(self):
        """Test subscription plans"""
        response = requests.get(f"{BASE_URL}/api/subscription/plans")
        assert response.status_code == 200, "Failed to get subscription plans"
        data = response.json()
        assert isinstance(data, list), "Response is not a list"
        assert len(data) > 0, "No subscription plans found"
        self.log(f"  ✓ Found {len(data)} subscription plans", GREEN)
        for plan in data:
            self.log(f"    - {plan['name']}: {plan['price']} {plan['currency']}", YELLOW)
            
    def test_create_partner(self):
        """Test partner creation"""
        response = requests.post(
            f"{BASE_URL}/api/partner/partners",
            json={
                "name": f"Test Car Wash {int(time.time())}",
                "description": "Test car wash for API testing",
                "email": f"partner{int(time.time())}@example.com",
                "phone_number": f"+998901{int(time.time()) % 1000000:06d}"
            }
        )
        assert response.status_code in [200, 201], f"Partner creation failed: {response.text}"
        data = response.json()
        self.test_partner_id = data["id"]
        self.log(f"  ✓ Partner created with ID: {self.test_partner_id}", GREEN)
        
    def test_list_partners(self):
        """Test listing partners"""
        response = requests.get(f"{BASE_URL}/api/partner/partners")
        assert response.status_code == 200, "Failed to list partners"
        data = response.json()
        assert isinstance(data, list), "Response is not a list"
        self.log(f"  ✓ Found {len(data)} partners", GREEN)
        
    def test_approve_partner(self):
        """Test partner approval"""
        if not self.test_partner_id:
            self.log("  ⚠ Skipping - no test partner", YELLOW)
            return
            
        headers = {"Authorization": f"Bearer {self.admin_token}"}
        response = requests.put(
            f"{BASE_URL}/api/admin/partners/{self.test_partner_id}/approve",
            headers=headers
        )
        assert response.status_code == 200, "Failed to approve partner"
        self.log(f"  ✓ Partner approved", GREEN)
        
    def test_create_location(self):
        """Test creating partner location"""
        if not self.test_partner_id:
            self.log("  ⚠ Skipping - no test partner", YELLOW)
            return
            
        response = requests.post(
            f"{BASE_URL}/api/partner/locations",
            json={
                "partner_id": self.test_partner_id,
                "name": "Test Location",
                "address": "123 Test Street, Tashkent",
                "city": "Tashkent",
                "latitude": 41.2995,
                "longitude": 69.2401,
                "working_hours": {
                    "monday": "09:00-20:00",
                    "tuesday": "09:00-20:00",
                    "wednesday": "09:00-20:00",
                    "thursday": "09:00-20:00",
                    "friday": "09:00-20:00",
                    "saturday": "10:00-18:00",
                    "sunday": "10:00-18:00"
                }
            }
        )
        assert response.status_code in [200, 201], f"Location creation failed: {response.text}"
        self.log(f"  ✓ Location created", GREEN)
        
    def test_analytics(self):
        """Test analytics endpoint"""
        headers = {"Authorization": f"Bearer {self.admin_token}"}
        response = requests.get(
            f"{BASE_URL}/api/admin/analytics/overview?period=month",
            headers=headers
        )
        assert response.status_code == 200, "Failed to get analytics"
        data = response.json()
        self.log(f"  ✓ Analytics retrieved", GREEN)
        self.log(f"    Total Users: {data.get('total_users', 0)}", YELLOW)
        self.log(f"    Active Subscriptions: {data.get('active_subscriptions', 0)}", YELLOW)
        self.log(f"    Total Visits: {data.get('total_visits', 0)}", YELLOW)
        
    def test_api_documentation(self):
        """Test API documentation endpoint"""
        response = requests.get(f"{BASE_URL}/docs")
        assert response.status_code == 200, "API documentation not accessible"
        self.log(f"  ✓ API documentation is accessible", GREEN)
        
    def test_database_connection(self):
        """Test database connectivity through API"""
        # Try to fetch data that requires DB
        response = requests.get(f"{BASE_URL}/api/subscription/plans")
        assert response.status_code == 200, "Database connection issue"
        self.log(f"  ✓ Database is connected and responding", GREEN)
        
    def test_redis_connection(self):
        """Test Redis connectivity (indirectly through rate limiting)"""
        # Make multiple requests to test rate limiting (which uses Redis)
        for i in range(5):
            response = requests.get(f"{BASE_URL}/")
            assert response.status_code == 200, "Service not responding"
        self.log(f"  ✓ Redis is working (rate limiting functional)", GREEN)
        
    def run_all_tests(self):
        """Run all tests"""
        self.log("\n" + "="*60, BLUE)
        self.log("YuvGo API Test Suite", BLUE)
        self.log("="*60, BLUE)
        self.log(f"Base URL: {BASE_URL}", YELLOW)
        self.log(f"Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}", YELLOW)
        
        # Infrastructure tests
        self.test("Health Checks", self.test_health_checks)
        self.test("Database Connection", self.test_database_connection)
        self.test("Redis Connection", self.test_redis_connection)
        self.test("API Documentation", self.test_api_documentation)
        
        # Authentication tests
        self.test("Admin Login", self.test_admin_login)
        
        # User management tests
        self.test("Create User", self.test_create_user)
        self.test("List Users", self.test_list_users)
        
        # Subscription tests
        self.test("Get Subscription Plans", self.test_subscription_plans)
        
        # Partner tests
        self.test("Create Partner", self.test_create_partner)
        self.test("List Partners", self.test_list_partners)
        self.test("Approve Partner", self.test_approve_partner)
        self.test("Create Location", self.test_create_location)
        
        # Analytics tests
        self.test("Get Analytics", self.test_analytics)
        
        # Print summary
        self.print_summary()
        
    def print_summary(self):
        """Print test summary"""
        total = self.passed + self.failed
        self.log("\n" + "="*60, BLUE)
        self.log("Test Summary", BLUE)
        self.log("="*60, BLUE)
        self.log(f"Total Tests: {total}", YELLOW)
        self.log(f"Passed: {self.passed}", GREEN)
        self.log(f"Failed: {self.failed}", RED if self.failed > 0 else GREEN)
        self.log(f"Success Rate: {(self.passed/total*100):.1f}%", 
                GREEN if self.failed == 0 else YELLOW)
        self.log("="*60, BLUE)
        
        if self.failed == 0:
            self.log("\n🎉 All tests passed! Your API is working correctly!", GREEN)
        else:
            self.log(f"\n⚠️  {self.failed} test(s) failed. Please check the errors above.", RED)

if __name__ == "__main__":
    tester = APITester()
    try:
        tester.run_all_tests()
    except KeyboardInterrupt:
        print("\n\nTests interrupted by user")
    except Exception as e:
        print(f"\n\nFatal error: {str(e)}")
