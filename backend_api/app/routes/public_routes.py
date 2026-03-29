from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from ..core.database import get_db
from ..repositories.repositories import ArtisanRepository, CategoryRepository
from ..schemas.schemas import Artisan, Category

router = APIRouter(prefix="/api", tags=["Public"])


@router.get("/categories", response_model=List[Category])
def get_categories(db: Session = Depends(get_db)):
    """Récupérer toutes les catégories"""
    return CategoryRepository.get_all(db)


@router.get("/artisans", response_model=List[Artisan])
def get_artisans(
    category_id: Optional[int] = None,
    city: Optional[str] = None,
    district: Optional[str] = None,
    available: Optional[bool] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Récupérer la liste des artisans avec filtres optionnels
    
    - **category_id**: Filtrer par catégorie
    - **city**: Filtrer par ville
    - **district**: Filtrer par quartier
    - **available**: Filtrer par disponibilité
    """
    artisans = []
    
    if category_id:
        artisans = ArtisanRepository.get_by_category(db, category_id, skip, limit)
    elif city:
        artisans = ArtisanRepository.get_by_city(db, city, skip, limit)
    elif district:
        artisans = ArtisanRepository.get_by_district(db, district, skip, limit)
    elif available:
        artisans = ArtisanRepository.get_available(db, skip, limit)
    else:
        artisans = ArtisanRepository.get_all(db, skip, limit)
    
    return artisans


@router.get("/artisans/{artisan_id}", response_model=Artisan)
def get_artisan(artisan_id: int, db: Session = Depends(get_db)):
    """Récupérer un artisan par son ID"""
    artisan = ArtisanRepository.get_by_id(db, artisan_id)
    if not artisan:
        raise HTTPException(status_code=404, detail="Artisan non trouvé")
    return artisan


@router.get("/search", response_model=List[Artisan])
def search_artisans(
    q: str = Query(..., min_length=1, description="Terme de recherche"),
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """
    Rechercher des artisans par nom, métier ou quartier
    
    - **q**: Terme de recherche
    """
    return ArtisanRepository.search(db, q, skip, limit)
