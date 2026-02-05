from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import QueuePool
import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://yuvgo:yuvgo_password@localhost:5432/yuvgo_db")

# Optimized engine with connection pooling
engine = create_engine(
    DATABASE_URL,
    poolclass=QueuePool,
    pool_size=10,           # Number of connections to keep open
    max_overflow=20,        # Max additional connections when pool is full
    pool_timeout=30,        # Seconds to wait for connection
    pool_recycle=1800,      # Recycle connections after 30 minutes
    pool_pre_ping=True,     # Verify connection before using
    echo=False,             # Disable SQL logging in production
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    """Dependency for getting database session"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
