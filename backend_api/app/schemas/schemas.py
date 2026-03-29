from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import datetime


# === Category Schemas ===

class CategoryBase(BaseModel):
    name: str
    slug: str
    icon: Optional[str] = None


class CategoryCreate(CategoryBase):
    pass


class CategoryUpdate(BaseModel):
    name: Optional[str] = None
    slug: Optional[str] = None
    icon: Optional[str] = None


class Category(CategoryBase):
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True


# === Artisan Schemas ===

class ArtisanBase(BaseModel):
    full_name: str
    phone: str
    whatsapp_phone: Optional[str] = None
    category_id: int
    city: str = "N'Djamena"
    district: str
    description: Optional[str] = None
    is_available: bool = True
    rating: float = 0.0
    photo_url: Optional[str] = None


class ArtisanCreate(ArtisanBase):
    pass


class ArtisanUpdate(BaseModel):
    full_name: Optional[str] = None
    phone: Optional[str] = None
    whatsapp_phone: Optional[str] = None
    category_id: Optional[int] = None
    city: Optional[str] = None
    district: Optional[str] = None
    description: Optional[str] = None
    is_available: Optional[bool] = None
    rating: Optional[float] = None
    photo_url: Optional[str] = None


class Artisan(ArtisanBase):
    id: int
    created_at: datetime
    updated_at: datetime
    category: Optional[Category] = None
    
    class Config:
        from_attributes = True


# === User Schemas ===

class UserBase(BaseModel):
    name: Optional[str] = None
    email: EmailStr
    role: str = "user"


class UserCreate(UserBase):
    password: str


class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[EmailStr] = None
    role: Optional[str] = None


class User(UserBase):
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


# === Favorite Schemas ===

class FavoriteBase(BaseModel):
    user_id: int
    artisan_id: int


class FavoriteCreate(FavoriteBase):
    pass


class Favorite(FavoriteBase):
    id: int
    created_at: datetime
    artisan: Optional[Artisan] = None
    
    class Config:
        from_attributes = True


# === ArtisanRequest Schemas ===

class ArtisanRequestBase(BaseModel):
    full_name: str
    phone: str
    whatsapp_phone: Optional[str] = None
    category_name: str
    city: str = "N'Djamena"
    district: str
    description: Optional[str] = None


class ArtisanRequestCreate(ArtisanRequestBase):
    pass


class ArtisanRequestUpdate(BaseModel):
    status: Optional[str] = None  # 'pending', 'approved', 'rejected'


class ArtisanRequest(ArtisanRequestBase):
    id: int
    status: str
    created_at: datetime
    reviewed_at: Optional[datetime] = None
    reviewed_by: Optional[int] = None
    
    class Config:
        from_attributes = True


# === Search Schema ===

class SearchResults(BaseModel):
    artisans: List[Artisan]
    total: int
