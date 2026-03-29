from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import timedelta
from ..core.database import get_db
from ..core.security import hash_password, verify_password
from ..core.jwt import create_access_token
from ..core.config import settings
from ..repositories.repositories import ArtisanRepository, ArtisanRequestRepository, CategoryRepository
from ..schemas.schemas import (
    Artisan, ArtisanCreate, ArtisanUpdate,
    ArtisanRequest, ArtisanRequestCreate, ArtisanRequestUpdate,
    UserLogin, Token, Category, CategoryCreate
)
from ..models.models import User
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError

router = APIRouter(prefix="/api/admin", tags=["Admin"])

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/admin/login")


# === Authentification ===

@router.post("/login", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    """
    Connexion admin
    
    Utilise le format OAuth2 avec email et mot de passe
    """
    # Trouver l'utilisateur par email
    user = db.query(User).filter(User.email == form_data.username).first()
    
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Vérifier que c'est un admin
    if user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès non autorisé. Compte admin requis."
        )
    
    # Créer le token
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email, "role": user.role},
        expires_delta=access_token_expires
    )
    
    return {"access_token": access_token, "token_type": "bearer"}


# === Dépendance pour vérifier l'authentification ===

async def get_current_admin_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
) -> User:
    """Vérifier que l'utilisateur est authentifié et admin"""
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Impossible de valider les identifiants",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        from ..core.jwt import verify_token
        payload = verify_token(token)
        if payload is None:
            raise credentials_exception
        
        email: str = payload.get("sub")
        role: str = payload.get("role")
        
        if email is None or role != "admin":
            raise credentials_exception
            
    except JWTError:
        raise credentials_exception
    
    user = db.query(User).filter(User.email == email).first()
    if user is None:
        raise credentials_exception
    
    return user


# === Gestion des artisans ===

@router.get("/artisans", response_model=List[Artisan])
def get_all_artisans(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Récupérer tous les artisans (admin uniquement)"""
    return ArtisanRepository.get_all(db, skip, limit)


@router.post("/artisans", response_model=Artisan, status_code=status.HTTP_201_CREATED)
def create_artisan(
    artisan: ArtisanCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Créer un nouvel artisan (admin uniquement)"""
    return ArtisanRepository.create(db, artisan)


@router.put("/artisans/{artisan_id}", response_model=Artisan)
def update_artisan(
    artisan_id: int,
    artisan_update: ArtisanUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Mettre à jour un artisan (admin uniquement)"""
    updated_artisan = ArtisanRepository.update(db, artisan_id, artisan_update)
    if not updated_artisan:
        raise HTTPException(status_code=404, detail="Artisan non trouvé")
    return updated_artisan


@router.delete("/artisans/{artisan_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_artisan(
    artisan_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Supprimer un artisan (admin uniquement)"""
    success = ArtisanRepository.delete(db, artisan_id)
    if not success:
        raise HTTPException(status_code=404, detail="Artisan non trouvé")


# === Gestion des demandes d'inscription ===

@router.get("/artisan-requests", response_model=List[ArtisanRequest])
def get_artisan_requests(
    status_filter: str = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Récupérer toutes les demandes d'inscription (admin uniquement)"""
    return ArtisanRequestRepository.get_all(db, status_filter)


@router.put("/artisan-requests/{request_id}/approve", response_model=ArtisanRequest)
def approve_artisan_request(
    request_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Approuver une demande d'inscription (admin uniquement)"""
    request = ArtisanRequestRepository.update_status(
        db, request_id, "approved", reviewed_by=current_user.id
    )
    if not request:
        raise HTTPException(status_code=404, detail="Demande non trouvée")
    
    # Optionnel : Créer automatiquement l'artisan à partir de la demande approuvée
    # Cela peut être fait dans un service séparé
    
    return request


@router.put("/artisan-requests/{request_id}/reject", response_model=ArtisanRequest)
def reject_artisan_request(
    request_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Rejeter une demande d'inscription (admin uniquement)"""
    request = ArtisanRequestRepository.update_status(
        db, request_id, "rejected", reviewed_by=current_user.id
    )
    if not request:
        raise HTTPException(status_code=404, detail="Demande non trouvée")
    return request


# === Gestion des catégories ===

@router.post("/categories", response_model=Category, status_code=status.HTTP_201_CREATED)
def create_category(
    category: CategoryCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Créer une nouvelle catégorie (admin uniquement)"""
    return CategoryRepository.create(db, category.name, category.slug, category.icon)


# === Stats dashboard ===

@router.get("/stats")
def get_dashboard_stats(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_admin_user)
):
    """Récupérer les statistiques du dashboard (admin uniquement)"""
    return {
        "total_artisans": ArtisanRepository.count(db),
        "pending_requests": ArtisanRequestRepository.count_pending(db),
        "total_categories": len(CategoryRepository.get_all(db))
    }
