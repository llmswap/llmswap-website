# Code Generation & Development Workflow Demo

## Realistic Developer Session: Building a REST API

```bash
$ llmswap generate "FastAPI REST API with user authentication and PostgreSQL"

🤖 Generating with claude-3-5-sonnet...

Generated: **FastAPI User Authentication API**

```python
# main.py
from fastapi import FastAPI, HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy import create_engine, Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from passlib.context import CryptContext
from datetime import datetime, timedelta
import jwt
import os

app = FastAPI(title="User Auth API", version="1.0.0")

# Database setup
SQLALCHEMY_DATABASE_URL = "postgresql://user:password@localhost/dbname"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)

Base.metadata.create_all(bind=engine)

# Auth setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/register", status_code=status.HTTP_201_CREATED)
async def register_user(email: str, password: str, db: Session = Depends(get_db)):
    # User registration logic
    hashed_password = pwd_context.hash(password)
    db_user = User(email=email, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    return {"message": "User created successfully"}

@app.post("/login")
async def login(email: str, password: str, db: Session = Depends(get_db)):
    # Login logic with JWT token
    user = db.query(User).filter(User.email == email).first()
    if user and pwd_context.verify(password, user.hashed_password):
        token = jwt.encode({"user_id": user.id}, SECRET_KEY, algorithm="HS256")
        return {"access_token": token, "token_type": "bearer"}
    raise HTTPException(status_code=401, detail="Invalid credentials")
```

**Requirements file:**
```txt
fastapi==0.104.1
uvicorn==0.24.0
sqlalchemy==2.0.23
psycopg2-binary==2.9.9
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
```

**Docker setup:**
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

You: This looks good, but I need to add user profile endpoints and better error handling

$ llmswap generate "Add user profile CRUD endpoints to the existing FastAPI code" --language python

🤖 Generating with claude-3-5-sonnet...

**Enhanced API with Profile Management:**

```python
# Add to main.py after existing code

from pydantic import BaseModel, EmailStr
from typing import Optional

class UserProfile(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    bio: Optional[str] = None
    avatar_url: Optional[str] = None

class UserResponse(BaseModel):
    id: int
    email: str
    first_name: Optional[str]
    last_name: Optional[str]
    bio: Optional[str]
    created_at: datetime

# Update User model
class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    first_name = Column(String, nullable=True)
    last_name = Column(String, nullable=True)
    bio = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=["HS256"])
        user_id: int = payload.get("user_id")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        return user_id
    except jwt.PyJWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

@app.get("/profile", response_model=UserResponse)
async def get_profile(current_user_id: int = Depends(get_current_user), 
                     db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == current_user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@app.put("/profile", response_model=UserResponse) 
async def update_profile(profile_data: UserProfile,
                        current_user_id: int = Depends(get_current_user),
                        db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == current_user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    for field, value in profile_data.dict(exclude_unset=True).items():
        setattr(user, field, value)
    
    db.commit()
    db.refresh(user)
    return user

@app.delete("/profile")
async def delete_profile(current_user_id: int = Depends(get_current_user),
                        db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == current_user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    db.delete(user)
    db.commit()
    return {"message": "Profile deleted successfully"}
```

You: Perfect! Now I need to generate some test cases for this API

$ llmswap switch groq
🔄 Switched to groq (llama-3.3-70b-versatile)

$ llmswap generate "pytest test cases for the FastAPI authentication API" --language python

🤖 Generating with llama-3.3-70b-versatile (Lightning fast)...

**Comprehensive Test Suite:**

```python
# test_api.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import jwt
from main import app, get_db, User, Base, SECRET_KEY

# Test database setup
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()

app.dependency_overrides[get_db] = override_get_db

@pytest.fixture(scope="module")
def client():
    Base.metadata.create_all(bind=engine)
    with TestClient(app) as c:
        yield c
    Base.metadata.drop_all(bind=engine)

@pytest.fixture
def test_user_data():
    return {
        "email": "test@example.com",
        "password": "testpassword123"
    }

def test_register_user(client, test_user_data):
    response = client.post("/register", json=test_user_data)
    assert response.status_code == 201
    assert response.json()["message"] == "User created successfully"

def test_register_duplicate_user(client, test_user_data):
    # Register first time
    client.post("/register", json=test_user_data)
    # Try to register again
    response = client.post("/register", json=test_user_data)
    assert response.status_code == 400

def test_login_success(client, test_user_data):
    # Register user first
    client.post("/register", json=test_user_data)
    # Login
    response = client.post("/login", json=test_user_data)
    assert response.status_code == 200
    assert "access_token" in response.json()
    assert response.json()["token_type"] == "bearer"

def test_login_invalid_credentials(client):
    response = client.post("/login", json={
        "email": "wrong@example.com",
        "password": "wrongpassword"
    })
    assert response.status_code == 401
    assert response.json()["detail"] == "Invalid credentials"

def test_get_profile_unauthorized(client):
    response = client.get("/profile")
    assert response.status_code == 403

def test_get_profile_success(client, test_user_data):
    # Register and login
    client.post("/register", json=test_user_data)
    login_response = client.post("/login", json=test_user_data)
    token = login_response.json()["access_token"]
    
    # Get profile
    headers = {"Authorization": f"Bearer {token}"}
    response = client.get("/profile", headers=headers)
    assert response.status_code == 200
    assert response.json()["email"] == test_user_data["email"]

def test_update_profile(client, test_user_data):
    # Setup user and token
    client.post("/register", json=test_user_data)
    login_response = client.post("/login", json=test_user_data)
    token = login_response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    
    # Update profile
    profile_update = {
        "first_name": "John",
        "last_name": "Doe",
        "bio": "Software Developer"
    }
    response = client.put("/profile", json=profile_update, headers=headers)
    assert response.status_code == 200
    assert response.json()["first_name"] == "John"
    assert response.json()["last_name"] == "Doe"

def test_delete_profile(client, test_user_data):
    # Setup user and token
    client.post("/register", json=test_user_data)
    login_response = client.post("/login", json=test_user_data)
    token = login_response.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    
    # Delete profile
    response = client.delete("/profile", headers=headers)
    assert response.status_code == 200
    assert response.json()["message"] == "Profile deleted successfully"
    
    # Verify profile is deleted
    response = client.get("/profile", headers=headers)
    assert response.status_code == 404

# Performance test
def test_concurrent_requests(client, test_user_data):
    import concurrent.futures
    import time
    
    def make_request():
        start = time.time()
        response = client.post("/register", json={
            "email": f"user{time.time()}@example.com",
            "password": "password123"
        })
        return time.time() - start, response.status_code
    
    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        futures = [executor.submit(make_request) for _ in range(10)]
        results = [future.result() for future in futures]
    
    # All requests should complete within reasonable time
    avg_time = sum(r[0] for r in results) / len(results)
    assert avg_time < 1.0  # Less than 1 second average
    assert all(r[1] == 201 for r in results)  # All successful
```

You: Great! Now let's run the tests and see what happens

```bash
$ pytest test_api.py -v

================================ test session starts =================================
platform darwin -- Python 3.11.6, pytest-7.4.3, pluggy-1.3.0
collected 8 tests

test_api.py::test_register_user PASSED                                    [ 12%]
test_api.py::test_register_duplicate_user FAILED                          [ 25%]
test_api.py::test_login_success PASSED                                    [ 37%]
test_api.py::test_login_invalid_credentials PASSED                        [ 50%]
test_api.py::test_get_profile_unauthorized PASSED                         [ 62%]
test_api.py::test_get_profile_success PASSED                              [ 75%]
test_api.py::test_update_profile PASSED                                   [ 87%]
test_api.py::test_delete_profile PASSED                                   [100%]

============================== 1 failed, 7 passed in 2.34s ==============================

FAILED test_api.py::test_register_duplicate_user - AssertionError: assert 500 == 400
```

Looks like we have a bug! The duplicate user registration isn't being handled properly.

$ llmswap debug --error "AssertionError: assert 500 == 400 - duplicate user registration"

🤖 Analyzing error with groq...

**Bug Analysis:**

The error indicates that duplicate user registration is returning a 500 (Internal Server Error) instead of 400 (Bad Request). This suggests an unhandled database constraint violation.

**Root Cause:**
When trying to insert a user with a duplicate email, the database throws an `IntegrityError`, but our code doesn't catch it.

**Fix:**

```python
# Update the register_user endpoint in main.py
from sqlalchemy.exc import IntegrityError

@app.post("/register", status_code=status.HTTP_201_CREATED)
async def register_user(email: str, password: str, db: Session = Depends(get_db)):
    try:
        # Check if user already exists
        existing_user = db.query(User).filter(User.email == email).first()
        if existing_user:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, 
                detail="User with this email already exists"
            )
        
        hashed_password = pwd_context.hash(password)
        db_user = User(email=email, hashed_password=hashed_password)
        db.add(db_user)
        db.commit()
        return {"message": "User created successfully"}
    
    except IntegrityError:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with this email already exists"
        )
```

**Additional Improvements:**
1. Add proper request/response models with validation
2. Add rate limiting for registration attempts  
3. Add email verification workflow
4. Add password strength requirements

This fix ensures proper error handling and returns the expected 400 status code.

You: /switch openai

🔄 Switched to openai (gpt-4o)

You: Now let's generate a Docker Compose setup for the full development environment

$ llmswap generate "Docker Compose with FastAPI, PostgreSQL, Redis for caching, and nginx reverse proxy" --save docker-compose.yml

🤖 Generating with gpt-4o...

**Production-Ready Docker Compose Setup:**

```yaml
# docker-compose.yml
version: '3.8'

services:
  # PostgreSQL Database
  postgres:
    image: postgres:15-alpine
    container_name: auth_db
    environment:
      POSTGRES_DB: authdb
      POSTGRES_USER: authuser
      POSTGRES_PASSWORD: authpassword
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "5432:5432"
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U authuser -d authdb"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Redis for caching and sessions
  redis:
    image: redis:7-alpine
    container_name: auth_redis
    command: redis-server --appendonly yes --requirepass redispassword
    volumes:
      - redis_data:/data
    ports:
      - "6379:6379"
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 30s
      timeout: 3s
      retries: 5

  # FastAPI Application
  api:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: auth_api
    environment:
      - DATABASE_URL=postgresql://authuser:authpassword@postgres:5432/authdb
      - REDIS_URL=redis://:redispassword@redis:6379/0
      - SECRET_KEY=your-super-secret-jwt-key-change-in-production
      - ENVIRONMENT=development
    volumes:
      - ./app:/app
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped

  # Nginx Reverse Proxy
  nginx:
    image: nginx:alpine
    container_name: auth_nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - api
    networks:
      - app-network
    restart: unless-stopped

  # Redis Commander (Development only)
  redis-commander:
    image: rediscommander/redis-commander:latest
    container_name: redis_commander
    environment:
      - REDIS_HOSTS=local:redis:6379:0:redispassword
    ports:
      - "8081:8081"
    depends_on:
      - redis
    networks:
      - app-network
    profiles:
      - dev

volumes:
  postgres_data:
  redis_data:

networks:
  app-network:
    driver: bridge
```

**Nginx Configuration (`nginx/nginx.conf`):**

```nginx
events {
    worker_connections 1024;
}

http {
    upstream api_backend {
        server api:8000;
    }

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=auth:10m rate=5r/s;

    server {
        listen 80;
        server_name localhost;

        # Security headers
        add_header X-Frame-Options DENY;
        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";

        # API endpoints
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://api_backend/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Auth endpoints with stricter rate limiting
        location ~ ^/(login|register) {
            limit_req zone=auth burst=10 nodelay;
            proxy_pass http://api_backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        # Health check
        location /health {
            proxy_pass http://api_backend/health;
        }

        # Static files (if any)
        location /static/ {
            alias /var/www/static/;
            expires 30d;
            add_header Cache-Control "public, immutable";
        }
    }
}
```

**Enhanced Dockerfile:**

```dockerfile
FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Copy application code
COPY . .
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Add health check endpoint to main.py
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Expose port
EXPOSE 8000

# Start application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

**Environment Setup Script (`setup.sh`):**

```bash
#!/bin/bash
# setup.sh - Development environment setup

set -e

echo "🚀 Setting up FastAPI development environment..."

# Create necessary directories
mkdir -p nginx/ssl
mkdir -p logs

# Generate self-signed SSL certificates for development
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx/ssl/nginx.key \
    -out nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Create init.sql for database setup
cat > init.sql << EOF
-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);
EOF

echo "✅ Environment setup complete!"
echo "Run: docker-compose up -d to start all services"
echo "Run: docker-compose --profile dev up -d to include Redis Commander"
```

**Usage:**
```bash
# Setup development environment
chmod +x setup.sh && ./setup.sh

# Start production stack
docker-compose up -d

# Start with development tools
docker-compose --profile dev up -d

# View logs
docker-compose logs -f api

# Scale API instances
docker-compose up -d --scale api=3
```

This setup provides a complete production-ready environment with load balancing, caching, security headers, rate limiting, and health checks!

You: Perfect! Let me check the final session stats

$ /stats

📊 Session Statistics:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Messages: 14
Providers used: claude-3-5-sonnet, llama-3.3-70b-versatile, gpt-4o
Total tokens: 4,567 (2,234 input, 2,333 output)
Total cost: $0.15
Session duration: 22m 43s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Provider breakdown by task:
• claude-3-5-sonnet: API generation, authentication logic (1,456 tokens)
• llama-3.3-70b-versatile: Test generation, debugging (1,890 tokens)  
• gpt-4o: Infrastructure setup, Docker/nginx config (1,221 tokens)

Task completion:
✅ Complete REST API with authentication
✅ User profile CRUD operations  
✅ Comprehensive test suite
✅ Bug identification and fixes
✅ Production Docker environment
✅ Security and performance optimizations

Cost efficiency: $0.15 for complete full-stack development vs ~$2.50 single-provider equivalent
```