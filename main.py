import os
import logging
from datetime import datetime, timedelta
from dotenv import load_dotenv
from fastapi import FastAPI, Depends, HTTPException, Query, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from jose import jwt, JWTError
import psycopg2
from psycopg2.extras import RealDictCursor
from pydantic import BaseModel

# ✅ Configure Logging
logging.basicConfig(level=logging.DEBUG, format="%(asctime)s - %(levelname)s - %(message)s")

# ✅ Load Environment Variables
load_dotenv()
SECRET_KEY = os.getenv("SECRET_KEY", "mysecretkey")  # Use a strong secret key in production
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# ✅ Initialize FastAPI App
app = FastAPI()

# ✅ Add CORS Middleware (Fixing CORS Errors)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow requests from frontend
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Database Connection with Error Handling
DATABASE_URL = "dbname=fluentedge_db user=fluentedge_user password=yourpassword host=localhost"

def get_db_connection():
    """Creates and returns a new database connection."""
    try:
        conn = psycopg2.connect(DATABASE_URL)
        conn.autocommit = True
        logging.info("✅ Connected to PostgreSQL database successfully!")
        return conn
    except Exception as e:
        logging.critical(f"❌ Database Connection Failed: {e}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Database connection error")

# ✅ Password Hashing Setup
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")  # Standardized to `/token`

def hash_password(password: str):
    """Hashes a password using bcrypt."""
    return pwd_context.hash(password)

def verify_password(plain_password: str, hashed_password: str):
    """Verifies a password against a hashed password."""
    return pwd_context.verify(plain_password, hashed_password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    """Generates an access token with an expiration time."""
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# ✅ Health Check API
@app.get("/health")
async def health_check():
    return {"status": "API is running"}

# ✅ Register API
class RegisterUserRequest(BaseModel):
    name: str
    email: str
    password: str

@app.post("/register")
async def register(user: RegisterUserRequest):
    """Registers a new user."""
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # Check if email already exists
                cursor.execute("SELECT id FROM users WHERE email = %s", (user.email,))
                if cursor.fetchone():
                    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Email already exists")

                # Insert new user
                query = "INSERT INTO users (username, email, password_hash) VALUES (%s, %s, %s) RETURNING id;"
                cursor.execute(query, (user.name, user.email, hash_password(user.password)))
                user_id = cursor.fetchone()

                if user_id:
                    return {"message": f"User {user.email} registered successfully!", "user_id": user_id[0]}
                else:
                    raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Registration failed.")

    except Exception as e:
        logging.error(f"❌ Registration error: {e}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# ✅ Login API
@app.post("/token")
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """Authenticates a user and returns an access token."""
    try:
        with get_db_connection() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                # Fetch user from database
                cursor.execute("SELECT id, password_hash FROM users WHERE email = %s", (form_data.username,))
                user = cursor.fetchone()

                # Verify password
                if not user or not verify_password(form_data.password, user["password_hash"]):
                    raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid email or password")

                # Generate access token
                access_token = create_access_token(data={"sub": form_data.username})
                return {"access_token": access_token, "token_type": "bearer"}

    except Exception as e:
        logging.error(f"❌ Login error: {e}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# ✅ Fetch User ID API
@app.get("/getUserId")
async def get_user_id(username: str = Query(..., description="Username to fetch user ID")):
    """Fetches the user ID for a given username."""
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # Fetch user ID
                cursor.execute("SELECT id FROM users WHERE LOWER(username) = LOWER(%s)", (username,))
                user = cursor.fetchone()

                if user:
                    return {"user_id": user[0]}
                else:
                    raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")

    except Exception as e:
        logging.error(f"❌ Error fetching user_id: {e}")
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail=str(e))

# ✅ Backend Fully Loaded Successfully!
logging.info("✅ Backend Fully Loaded Successfully!")