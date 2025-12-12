#!/usr/bin/env python3
"""Fix admin password in database"""
import psycopg2
from passlib.context import CryptContext

# Database connection
conn = psycopg2.connect(
    host="localhost",
    port=5433,
    database="yuvgo_db",
    user="yuvgo",
    password="yuvgo_password"
)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Generate new hash for simple password
password = "admin123"
hashed = pwd_context.hash(password)

print(f"Password: {password}")
print(f"Hash: {hashed}")

# Update in database
cur = conn.cursor()
cur.execute(
    "UPDATE admins SET password_hash = %s WHERE email = %s",
    (hashed, "admin@yuvgo.uz")
)
conn.commit()

# Verify
cur.execute("SELECT email, role FROM admins WHERE email = 'admin@yuvgo.uz'")
result = cur.fetchone()
print(f"\nUpdated admin: {result}")

# Test verification
print(f"Verification test: {pwd_context.verify(password, hashed)}")

cur.close()
conn.close()

print("\n✅ Admin password updated successfully!")
print(f"Login with: admin@yuvgo.uz / {password}")
