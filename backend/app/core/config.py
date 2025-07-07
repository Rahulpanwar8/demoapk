from pydantic_settings import BaseSettings
from typing import List
from functools import lru_cache
from pydantic import field_validator

class Settings(BaseSettings):
    # Base Settings
    PROJECT_NAME: str = "Car Booking API"
    VERSION: str = "1.0.0"
    API_V1_STR: str = "/api/v1"
    
    # Database Settings
    DATABASE_URL: str = "postgresql+asyncpg://Harshit:699600@localhost:5432/CarApi"
    
    # JWT Settings
    SECRET_KEY: str = "72adc39b22b8edef33078d21159ceef62873db71c0cccb600e020f3d5083ce09"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # Superuser Settings ✅ (add these)
    FIRST_SUPERUSER: str
    FIRST_SUPERUSER_PASSWORD: str
    
    # CORS Settings
    BACKEND_CORS_ORIGINS: List[str] = ["*"]
    
    # File Upload Settings
    UPLOAD_FOLDER: str = "uploads"
    MAX_FILE_SIZE: int = 5 * 1024 * 1024  # 5MB
    
    @field_validator('MAX_FILE_SIZE', mode='before')
    def validate_max_file_size(cls, v):
        if isinstance(v, str):
            try:
                return int(v.split('#')[0].strip())
            except (ValueError, IndexError):
                return 5 * 1024 * 1024  # Default to 5MB
        return v
    
    class Config:
        case_sensitive = True
        env_file = ".env"

@lru_cache()
def get_settings() -> Settings:
    return Settings()

settings = get_settings()
