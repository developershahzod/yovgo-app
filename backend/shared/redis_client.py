import redis
import os
import json
from typing import Optional, Any

REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")

redis_client = redis.from_url(REDIS_URL, decode_responses=True)

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
