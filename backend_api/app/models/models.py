from sqlalchemy import Column, Integer, String, Boolean, Float, Text, DateTime, ForeignKey
from sqlalchemy.orm import relationship
from datetime import datetime
from ..core.database import Base


class Category(Base):
    __tablename__ = "categories"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    slug = Column(String, unique=True, nullable=False, index=True)
    icon = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relations
    artisans = relationship("Artisan", back_populates="category")
    
    def __repr__(self):
        return f"<Category(id={self.id}, name='{self.name}')>"


class Artisan(Base):
    __tablename__ = "artisans"
    
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, nullable=False)
    phone = Column(String, nullable=False)
    whatsapp_phone = Column(String, nullable=True)
    category_id = Column(Integer, ForeignKey("categories.id"), nullable=False)
    city = Column(String, nullable=False, default="N'Djamena")
    district = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    is_available = Column(Boolean, default=True)
    rating = Column(Float, default=0.0)
    photo_url = Column(String, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relations
    category = relationship("Category", back_populates="artisans")
    favorites = relationship("Favorite", back_populates="artisan")
    
    def __repr__(self):
        return f"<Artisan(id={self.id}, name='{self.full_name}', métier='{self.category.name if self.category else 'N/A'}')>"


class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=True)
    email = Column(String, unique=True, nullable=False, index=True)
    password_hash = Column(String, nullable=False)
    role = Column(String, default="user")  # 'admin' ou 'user'
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relations
    favorites = relationship("Favorite", back_populates="user")
    
    def __repr__(self):
        return f"<User(id={self.id}, email='{self.email}')>"


class Favorite(Base):
    __tablename__ = "favorites"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    artisan_id = Column(Integer, ForeignKey("artisans.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    # Relations
    user = relationship("User", back_populates="favorites")
    artisan = relationship("Artisan", back_populates="favorites")
    
    __table_args__ = (
        # Empêcher les doublons
        {'sqlite_autoincrement': True}
    )


class ArtisanRequest(Base):
    __tablename__ = "artisan_requests"
    
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String, nullable=False)
    phone = Column(String, nullable=False)
    whatsapp_phone = Column(String, nullable=True)
    category_name = Column(String, nullable=False)
    city = Column(String, nullable=False, default="N'Djamena")
    district = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    status = Column(String, default="pending")  # 'pending', 'approved', 'rejected'
    created_at = Column(DateTime, default=datetime.utcnow)
    reviewed_at = Column(DateTime, nullable=True)
    reviewed_by = Column(Integer, ForeignKey("users.id"), nullable=True)
    
    def __repr__(self):
        return f"<ArtisanRequest(id={self.id}, name='{self.full_name}', status='{self.status}')>"
