#!/usr/bin/env python3
"""
Create default admin user for YuvGo
"""
import sys
import os
from pathlib import Path

# Add backend to path
backend_path = Path(__file__).parent / "backend"
sys.path.insert(0, str(backend_path))

from shared.database import SessionLocal
from shared.models import Admin
from shared.auth import AuthHandler
from datetime import datetime

def create_admin():
    """Create default admin user"""
    db = SessionLocal()
    auth_handler = AuthHandler()
    
    try:
        # Check if admin exists
        existing_admin = db.query(Admin).filter(Admin.email == "admin@yuvgo.uz").first()
        
        if existing_admin:
            print("✓ Admin already exists")
            print(f"  Email: {existing_admin.email}")
            print(f"  Name: {existing_admin.full_name}")
            print(f"  Role: {existing_admin.role}")
            print(f"  Active: {existing_admin.is_active}")
            
            # Update password to ensure it's correct
            print("\n→ Updating password to 'Admin@123'...")
            existing_admin.password_hash = auth_handler.hash_password("Admin@123")
            db.commit()
            print("✓ Password updated successfully")
            
        else:
            print("→ Creating new admin user...")
            
            # Create new admin
            admin = Admin(
                email="admin@yuvgo.uz",
                password_hash=auth_handler.hash_password("Admin@123"),
                full_name="System Administrator",
                role="super_admin",
                permissions=[
                    "users.read", "users.write", "users.delete",
                    "partners.read", "partners.write", "partners.delete",
                    "subscriptions.read", "subscriptions.write", "subscriptions.delete",
                    "payments.read", "payments.write",
                    "analytics.read",
                    "admins.read", "admins.write", "admins.delete",
                    "promotions.read", "promotions.write", "promotions.delete",
                    "audit.read"
                ],
                is_active=True,
                created_at=datetime.utcnow()
            )
            
            db.add(admin)
            db.commit()
            db.refresh(admin)
            
            print("✓ Admin created successfully")
            print(f"  Email: {admin.email}")
            print(f"  Name: {admin.full_name}")
            print(f"  Role: {admin.role}")
        
        print("\n" + "="*50)
        print("LOGIN CREDENTIALS:")
        print("="*50)
        print("Email:    admin@yuvgo.uz")
        print("Password: Admin@123")
        print("="*50)
        
    except Exception as e:
        print(f"✗ Error: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    print("YuvGo - Create Admin User")
    print("="*50)
    create_admin()
