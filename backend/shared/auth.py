from datetime import datetime, timedelta
from typing import Optional, Dict, Any
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import HTTPException, Security, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os

# Configuration
JWT_SECRET = os.getenv("JWT_SECRET", "your-secret-key-change-in-production")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "525600"))  # 365 days
REFRESH_TOKEN_EXPIRE_DAYS = int(os.getenv("REFRESH_TOKEN_EXPIRE_DAYS", "365"))

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

class AuthHandler:
    """Authentication handler for JWT tokens"""
    
    @staticmethod
    def hash_password(password: str) -> str:
        """Hash a password"""
        return pwd_context.hash(password)
    
    @staticmethod
    def verify_password(plain_password: str, hashed_password: str) -> bool:
        """Verify a password against hash"""
        try:
            # Truncate password to 72 bytes for bcrypt
            if len(plain_password.encode('utf-8')) > 72:
                plain_password = plain_password[:72]
            return pwd_context.verify(plain_password, hashed_password)
        except Exception as e:
            print(f"Password verification error: {e}")
            return False
    
    @staticmethod
    def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
        """Create JWT access token"""
        to_encode = data.copy()
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        
        to_encode.update({"exp": expire, "type": "access"})
        encoded_jwt = jwt.encode(to_encode, JWT_SECRET, algorithm=JWT_ALGORITHM)
        return encoded_jwt
    
    @staticmethod
    def create_refresh_token(data: Dict[str, Any]) -> str:
        """Create JWT refresh token"""
        to_encode = data.copy()
        expire = datetime.utcnow() + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
        to_encode.update({"exp": expire, "type": "refresh"})
        encoded_jwt = jwt.encode(to_encode, JWT_SECRET, algorithm=JWT_ALGORITHM)
        return encoded_jwt
    
    @staticmethod
    def decode_token(token: str) -> Dict[str, Any]:
        """Decode and verify JWT token"""
        try:
            payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
            return payload
        except JWTError as e:
            raise HTTPException(status_code=401, detail=f"Invalid token: {str(e)}")
    
    @staticmethod
    def get_current_user(credentials: HTTPAuthorizationCredentials = Security(security)) -> Dict[str, Any]:
        """Get current user from JWT token"""
        token = credentials.credentials
        payload = AuthHandler.decode_token(token)
        
        if payload.get("type") != "access":
            raise HTTPException(status_code=401, detail="Invalid token type")
        
        return payload
    
    @staticmethod
    def get_current_admin(credentials: HTTPAuthorizationCredentials = Security(security)) -> Dict[str, Any]:
        """Get current admin from JWT token"""
        token = credentials.credentials
        payload = AuthHandler.decode_token(token)
        
        if payload.get("type") != "access":
            raise HTTPException(status_code=401, detail="Invalid token type")
        
        if payload.get("role") not in ["admin", "super_admin"]:
            raise HTTPException(status_code=403, detail="Admin access required")
        
        return payload
    
    @staticmethod
    def check_permission(user: Dict[str, Any], required_permission: str) -> bool:
        """Check if user has required permission"""
        permissions = user.get("permissions", [])
        
        # Super admin has all permissions
        if "all" in permissions:
            return True
        
        # Check specific permission
        return required_permission in permissions

def require_permission(permission: str):
    """Decorator to require specific permission"""
    def decorator(current_user: Dict[str, Any] = Depends(AuthHandler.get_current_admin)):
        if not AuthHandler.check_permission(current_user, permission):
            raise HTTPException(status_code=403, detail=f"Permission '{permission}' required")
        return current_user
    return decorator
