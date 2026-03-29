from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from .core.database import engine, Base, get_db
from .core.config import settings
from .routes import public_routes, admin_routes
from .models.models import User
from .core.security import hash_password

# Créer les tables de la base de données
Base.metadata.create_all(bind=engine)

# Initialiser l'application
app = FastAPI(
    title="Allo-Khedma API",
    description="API pour la mise en relation entre artisans et clients à N'Djamena",
    version="1.0.0"
)

# Configuration CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inclure les routes
app.include_router(public_routes.router)
app.include_router(admin_routes.router)


# Événement au démarrage
@app.on_event("startup")
async def startup_event():
    """Créer un utilisateur admin par défaut s'il n'existe pas"""
    from sqlalchemy.orm import Session
    
    db = SessionLocal()
    try:
        # Vérifier si un admin existe déjà
        admin_exists = db.query(User).filter(User.role == "admin").first()
        
        if not admin_exists:
            # Créer l'admin par défaut
            admin_user = User(
                name="Admin Allo-Khedma",
                email=settings.ADMIN_EMAIL,
                password_hash=hash_password(settings.ADMIN_PASSWORD),
                role="admin"
            )
            db.add(admin_user)
            db.commit()
            print(f"✅ Admin créé par défaut : {settings.ADMIN_EMAIL}")
        else:
            print("✅ Un utilisateur admin existe déjà")
    except Exception as e:
        print(f"⚠️ Erreur lors de la création de l'admin : {e}")
        db.rollback()
    finally:
        db.close()


# Route de santé
@app.get("/")
def read_root():
    return {
        "message": "Bienvenue sur l'API Allo-Khedma",
        "version": "1.0.0",
        "docs": "/docs"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}


# Import nécessaire pour le SessionLocal
from .core.database import SessionLocal
