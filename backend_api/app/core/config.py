from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql://allo_khedma_user:password_secure@localhost:5432/allo_khedma"
    
    # Security
    SECRET_KEY: str = "votre_secret_key_tres_long_et_aleatoire_changez_cette_valeur"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    
    # Admin
    ADMIN_EMAIL: str = "admin@allokhedma.com"
    ADMIN_PASSWORD: str = "Admin123!ChangeMe"
    
    # CORS
    ALLOWED_ORIGINS: str = "http://localhost:3000,http://localhost:8080"
    
    # Cloudinary
    CLOUDINARY_CLOUD_NAME: str = ""
    CLOUDINARY_API_KEY: str = ""
    CLOUDINARY_API_SECRET: str = ""
    
    # Environment
    ENVIRONMENT: str = "development"
    
    @property
    def allowed_origins_list(self) -> List[str]:
        return [origin.strip() for origin in self.ALLOWED_ORIGINS.split(",")]
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
