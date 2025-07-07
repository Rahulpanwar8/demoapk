from app.schemas.user import UserInToken
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from datetime import datetime

from app.database import get_db
from app.schemas.user import UserCreate, UserOut, Token, UserLogin
from app.models.user import User, UserStatus
from app.utils.auth import (
    get_password_hash,
    verify_password,
    create_access_token,
    get_current_user
)

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/signup", response_model=UserOut, status_code=status.HTTP_201_CREATED)
async def signup(user_data: UserCreate, db: AsyncSession = Depends(get_db)):
    # Check if user exists
    result = await db.execute(
        select(User).where(
            (User.email == user_data.email) | (User.phone == user_data.phone)
        )
    )
    existing_user = result.scalars().first()
    
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email or phone already registered"
        )
    
    # Create new user
    hashed_password = get_password_hash(user_data.password)
    db_user = User(
        email=user_data.email,
        phone=user_data.phone,
        first_name=user_data.first_name,
        last_name=user_data.last_name,
        hashed_password=hashed_password,
        status=UserStatus.PENDING
    )
    
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    
    return UserOut.from_orm(db_user)  # Explicit conversion

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(User).where(User.email == form_data.username))
    user = result.scalars().first()
    
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token = create_access_token(data={"sub": user.email})
    
    # Handle role properly whether it's enum or string
    role_value = user.role.value if hasattr(user.role, 'value') else user.role
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "id": user.id,
            "email": user.email,
            "role": role_value  # Fixed: works with both enum and string
        }
    }

# In your FastAPI code, add debug print:
@router.get("/me")
async def read_users_me(current_user: User = Depends(get_current_user)):
    print(f"User accessing /me: {current_user.email}")  # Add this line
    return current_user

@router.post("/verify-token", response_model=UserOut)
async def verify_token(current_user: User = Depends(get_current_user)):
    return current_user