#!/usr/bin/env python3
"""
Add test subscription for user
"""
import sys
import psycopg2
from datetime import datetime, timedelta
import uuid

# Database connection
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'yuvgo_db',
    'user': 'yuvgo_user',
    'password': 'yuvgo_password'
}

def add_test_subscription(phone_number="+998901234567"):
    """Add test subscription for user"""
    
    try:
        # Connect to database
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # Find user by phone
        cur.execute("SELECT id, full_name FROM users WHERE phone_number = %s", (phone_number,))
        user = cur.fetchone()
        
        if not user:
            print(f"❌ User with phone {phone_number} not found")
            print("\nAvailable users:")
            cur.execute("SELECT phone_number, full_name FROM users LIMIT 10")
            for row in cur.fetchall():
                print(f"  - {row[0]} ({row[1]})")
            return
        
        user_id, user_name = user
        print(f"✓ Found user: {user_name} ({phone_number})")
        
        # Check existing subscription
        cur.execute("""
            SELECT id, status, visits_remaining, end_date 
            FROM subscriptions 
            WHERE user_id = %s AND status = 'active'
        """, (user_id,))
        
        existing = cur.fetchone()
        if existing:
            print(f"\n⚠️  User already has active subscription:")
            print(f"   ID: {existing[0]}")
            print(f"   Status: {existing[1]}")
            print(f"   Visits remaining: {existing[2]}")
            print(f"   End date: {existing[3]}")
            
            response = input("\nUpdate this subscription? (y/n): ")
            if response.lower() != 'y':
                return
            
            # Update existing subscription
            end_date = datetime.utcnow() + timedelta(days=30)
            cur.execute("""
                UPDATE subscriptions 
                SET visits_remaining = 10,
                    end_date = %s,
                    is_unlimited = false
                WHERE id = %s
            """, (end_date, existing[0]))
            
            print(f"\n✅ Subscription updated!")
            print(f"   Visits: 10")
            print(f"   End date: {end_date.strftime('%Y-%m-%d')}")
        
        else:
            # Create new subscription
            subscription_id = str(uuid.uuid4())
            start_date = datetime.utcnow()
            end_date = start_date + timedelta(days=30)
            
            cur.execute("""
                INSERT INTO subscriptions (
                    id, user_id, plan_id, status, 
                    start_date, end_date, visits_remaining, is_unlimited
                ) VALUES (
                    %s, %s, 'test-plan', 'active',
                    %s, %s, 10, false
                )
            """, (subscription_id, user_id, start_date, end_date))
            
            print(f"\n✅ New subscription created!")
            print(f"   ID: {subscription_id}")
            print(f"   Visits: 10")
            print(f"   End date: {end_date.strftime('%Y-%m-%d')}")
        
        conn.commit()
        
        # Show final status
        cur.execute("""
            SELECT id, status, visits_remaining, end_date 
            FROM subscriptions 
            WHERE user_id = %s AND status = 'active'
        """, (user_id,))
        
        sub = cur.fetchone()
        print(f"\n📋 Current subscription:")
        print(f"   User: {user_name}")
        print(f"   Phone: {phone_number}")
        print(f"   Subscription ID: {sub[0]}")
        print(f"   Status: {sub[1]}")
        print(f"   Visits remaining: {sub[2]}")
        print(f"   Valid until: {sub[3].strftime('%Y-%m-%d')}")
        
        print(f"\n✅ User can now scan QR codes!")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()

if __name__ == "__main__":
    phone = sys.argv[1] if len(sys.argv) > 1 else "+998901234567"
    add_test_subscription(phone)
