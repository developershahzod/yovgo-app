import redis
import os
import json
from typing import Optional, Any
from functools import wraps
import hashlib

REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")

# Connection pool for better performance
pool = redis.ConnectionPool.from_url(REDIS_URL, max_connections=20, decode_responses=True)
redis_client = redis.Redis(connection_pool=pool)

class RedisCache:
    """Redis cache utility class"""
    
    @staticmethod
    def set(key: str, value: Any, ttl: int = 3600) -> bool:
        """Set a value in Redis with TTL"""
        try:
            if isinstance(value, (dict, list)):
                value = json.dumps(value)
            redis_client.setex(key, ttl, value)
            return True
        except Exception as e:
            print(f"Redis set error: {e}")
            return False
    
    @staticmethod
    def get(key: str) -> Optional[Any]:
        """Get a value from Redis"""
        try:
            value = redis_client.get(key)
            if value:
                try:
                    return json.loads(value)
                except json.JSONDecodeError:
                    return value
            return None
        except Exception as e:
            print(f"Redis get error: {e}")
            return None
    
    @staticmethod
    def delete(key: str) -> bool:
        """Delete a key from Redis"""
        try:
            redis_client.delete(key)
            return True
        except Exception as e:
            print(f"Redis delete error: {e}")
            return False
    
    @staticmethod
    def exists(key: str) -> bool:
        """Check if key exists in Redis"""
        try:
            return redis_client.exists(key) > 0
        except Exception as e:
            print(f"Redis exists error: {e}")
            return False
    
    @staticmethod
    def increment(key: str, amount: int = 1) -> Optional[int]:
        """Increment a counter in Redis"""
        try:
            return redis_client.incrby(key, amount)
        except Exception as e:
            print(f"Redis increment error: {e}")
            return None
    
    @staticmethod
    def get_or_set(key: str, func, ttl: int = 3600) -> Any:
        """Get from cache or compute and set"""
        cached = RedisCache.get(key)
        if cached is not None:
            return cached
        result = func()
        RedisCache.set(key, result, ttl)
        return result
    
    @staticmethod
    def invalidate_pattern(pattern: str) -> int:
        """Delete all keys matching pattern"""
        try:
            keys = redis_client.keys(pattern)
            if keys:
                return redis_client.delete(*keys)
            return 0
        except Exception as e:
            print(f"Redis invalidate error: {e}")
            return 0


def cache_response(ttl: int = 300, key_prefix: str = "api"):
    """Decorator to cache API responses"""
    def decorator(func):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            # Create cache key from function name and arguments
            key_parts = [key_prefix, func.__name__]
            key_parts.extend([str(v) for v in kwargs.values() if v is not None])
            cache_key = ":".join(key_parts)
            
            # Try to get from cache
            cached = RedisCache.get(cache_key)
            if cached is not None:
                return cached
            
            # Execute function and cache result
            result = await func(*args, **kwargs)
            RedisCache.set(cache_key, result, ttl)
            return result
        return wrapper
    return decorator
