from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.models import Artisan, Category, ArtisanRequest
from ..schemas.schemas import ArtisanCreate, ArtisanUpdate, ArtisanRequestCreate


class ArtisanRepository:
    
    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100) -> List[Artisan]:
        """Récupérer tous les artisans"""
        return db.query(Artisan).offset(skip).limit(limit).all()
    
    @staticmethod
    def get_by_id(db: Session, artisan_id: int) -> Optional[Artisan]:
        """Récupérer un artisan par ID"""
        return db.query(Artisan).filter(Artisan.id == artisan_id).first()
    
    @staticmethod
    def get_by_category(db: Session, category_id: int, skip: int = 0, limit: int = 100) -> List[Artisan]:
        """Récupérer les artisans par catégorie"""
        return db.query(Artisan).filter(Artisan.category_id == category_id).offset(skip).limit(limit).all()
    
    @staticmethod
    def get_by_city(db: Session, city: str, skip: int = 0, limit: int = 100) -> List[Artisan]:
        """Récupérer les artisans par ville"""
        return db.query(Artisan).filter(Artisan.city.ilike(f"%{city}%")).offset(skip).limit(limit).all()
    
    @staticmethod
    def get_by_district(db: Session, district: str, skip: int = 0, limit: int = 100) -> List[Artisan]:
        """Récupérer les artisans par quartier"""
        return db.query(Artisan).filter(Artisan.district.ilike(f"%{district}%")).offset(skip).limit(limit).all()
    
    @staticmethod
    def get_available(db: Session, skip: int = 0, limit: int = 100) -> List[Artisan]:
        """Récupérer les artisans disponibles"""
        return db.query(Artisan).filter(Artisan.is_available == True).offset(skip).limit(limit).all()
    
    @staticmethod
    def search(db: Session, query: str, skip: int = 0, limit: int = 100) -> List[Artisan]:
        """Rechercher des artisans par nom, métier ou quartier"""
        search_term = f"%{query}%"
        return db.query(Artisan).join(Category).filter(
            (Artisan.full_name.ilike(search_term)) |
            (Category.name.ilike(search_term)) |
            (Artisan.district.ilike(search_term)) |
            (Artisan.city.ilike(search_term))
        ).offset(skip).limit(limit).all()
    
    @staticmethod
    def create(db: Session, artisan: ArtisanCreate) -> Artisan:
        """Créer un nouvel artisan"""
        db_artisan = Artisan(**artisan.model_dump())
        db.add(db_artisan)
        db.commit()
        db.refresh(db_artisan)
        return db_artisan
    
    @staticmethod
    def update(db: Session, artisan_id: int, artisan_update: ArtisanUpdate) -> Optional[Artisan]:
        """Mettre à jour un artisan"""
        db_artisan = db.query(Artisan).filter(Artisan.id == artisan_id).first()
        if not db_artisan:
            return None
        
        update_data = artisan_update.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(db_artisan, field, value)
        
        db.commit()
        db.refresh(db_artisan)
        return db_artisan
    
    @staticmethod
    def delete(db: Session, artisan_id: int) -> bool:
        """Supprimer un artisan"""
        db_artisan = db.query(Artisan).filter(Artisan.id == artisan_id).first()
        if not db_artisan:
            return False
        
        db.delete(db_artisan)
        db.commit()
        return True
    
    @staticmethod
    def count(db: Session) -> int:
        """Compter le nombre total d'artisans"""
        return db.query(Artisan).count()


class CategoryRepository:
    
    @staticmethod
    def get_all(db: Session) -> List[Category]:
        """Récupérer toutes les catégories"""
        return db.query(Category).all()
    
    @staticmethod
    def get_by_id(db: Session, category_id: int) -> Optional[Category]:
        """Récupérer une catégorie par ID"""
        return db.query(Category).filter(Category.id == category_id).first()
    
    @staticmethod
    def get_by_slug(db: Session, slug: str) -> Optional[Category]:
        """Récupérer une catégorie par slug"""
        return db.query(Category).filter(Category.slug == slug).first()
    
    @staticmethod
    def create(db: Session, name: str, slug: str, icon: Optional[str] = None) -> Category:
        """Créer une nouvelle catégorie"""
        db_category = Category(name=name, slug=slug, icon=icon)
        db.add(db_category)
        db.commit()
        db.refresh(db_category)
        return db_category


class ArtisanRequestRepository:
    
    @staticmethod
    def get_all(db: Session, status: Optional[str] = None) -> List[ArtisanRequest]:
        """Récupérer toutes les demandes (avec filtre optionnel par statut)"""
        query = db.query(ArtisanRequest)
        if status:
            query = query.filter(ArtisanRequest.status == status)
        return query.order_by(ArtisanRequest.created_at.desc()).all()
    
    @staticmethod
    def get_by_id(db: Session, request_id: int) -> Optional[ArtisanRequest]:
        """Récupérer une demande par ID"""
        return db.query(ArtisanRequest).filter(ArtisanRequest.id == request_id).first()
    
    @staticmethod
    def create(db: Session, request: ArtisanRequestCreate) -> ArtisanRequest:
        """Créer une nouvelle demande d'inscription"""
        db_request = ArtisanRequest(**request.model_dump())
        db.add(db_request)
        db.commit()
        db.refresh(db_request)
        return db_request
    
    @staticmethod
    def update_status(db: Session, request_id: int, status: str, reviewed_by: Optional[int] = None) -> Optional[ArtisanRequest]:
        """Mettre à jour le statut d'une demande"""
        db_request = db.query(ArtisanRequest).filter(ArtisanRequest.id == request_id).first()
        if not db_request:
            return None
        
        from datetime import datetime
        db_request.status = status
        db_request.reviewed_at = datetime.utcnow()
        db_request.reviewed_by = reviewed_by
        
        db.commit()
        db.refresh(db_request)
        return db_request
    
    @staticmethod
    def count_pending(db: Session) -> int:
        """Compter le nombre de demandes en attente"""
        return db.query(ArtisanRequest).filter(ArtisanRequest.status == "pending").count()
