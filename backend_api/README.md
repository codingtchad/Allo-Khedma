# Backend API - Allo-Khedma

API REST développée avec FastAPI pour gérer les artisans, catégories, et demandes d'inscription.

## 📁 Structure

```
backend_api/
├── app/
│   ├── main.py              # Point d'entrée
│   ├── core/                # Configuration, sécurité, database
│   ├── models/              # Modèles SQLAlchemy
│   ├── schemas/             # Schémas Pydantic
│   ├── routes/              # Endpoints API
│   ├── services/            # Logique métier
│   ├── repositories/        # Accès aux données
│   └── utils/               # Utilitaires
├── requirements.txt
├── .env
└── README.md
```

## 🚀 Installation

```bash
# Créer un environnement virtuel
python -m venv venv
source venv/bin/activate  # Sur Windows: venv\Scripts\activate

# Installer les dépendances
pip install -r requirements.txt

# Configurer les variables d'environnement
cp .env.example .env
# Éditer .env avec vos paramètres

# Lancer le serveur
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## 📡 Endpoints API

### Public

#### Catégories
- `GET /api/categories` - Liste toutes les catégories

#### Artisans
- `GET /api/artisans` - Liste tous les artisans
- `GET /api/artisans/{id}` - Détail d'un artisan
- `GET /api/artisans?category={category}` - Filtrer par catégorie
- `GET /api/artisans?city={city}` - Filtrer par ville
- `GET /api/artisans?district={district}` - Filtrer par quartier
- `GET /api/artisans?available=true` - Artisans disponibles

#### Recherche
- `GET /api/search?q={query}` - Recherche globale

#### Inscription artisan
- `POST /api/artisan-requests` - Soumettre une demande d'inscription

### Authentifié (Admin)

#### Gestion artisans
- `POST /api/admin/artisans` - Créer un artisan
- `PUT /api/admin/artisans/{id}` - Modifier un artisan
- `DELETE /api/admin/artisans/{id}` - Supprimer un artisan

#### Gestion demandes
- `GET /api/admin/artisan-requests` - Liste des demandes
- `PUT /api/admin/artisan-requests/{id}/approve` - Approuver une demande
- `PUT /api/admin/artisan-requests/{id}/reject` - Rejeter une demande

#### Auth
- `POST /api/admin/login` - Connexion admin
- `POST /api/admin/logout` - Déconnexion

## 🗄️ Base de données

### Tables principales

#### categories
- id (Integer, Primary Key)
- name (String)
- slug (String, Unique)
- icon (String)
- created_at (DateTime)

#### artisans
- id (Integer, Primary Key)
- full_name (String)
- phone (String)
- whatsapp_phone (String)
- category_id (Integer, Foreign Key)
- city (String)
- district (String)
- description (Text)
- is_available (Boolean)
- rating (Float)
- photo_url (String)
- created_at (DateTime)
- updated_at (DateTime)

#### users
- id (Integer, Primary Key)
- name (String)
- email (String, Unique)
- password_hash (String)
- role (String: 'admin', 'user')
- created_at (DateTime)

#### favorites
- id (Integer, Primary Key)
- user_id (Integer, Foreign Key)
- artisan_id (Integer, Foreign Key)
- created_at (DateTime)

#### artisan_requests
- id (Integer, Primary Key)
- full_name (String)
- phone (String)
- whatsapp_phone (String)
- category_name (String)
- city (String)
- district (String)
- description (Text)
- status (String: 'pending', 'approved', 'rejected')
- created_at (DateTime)
- reviewed_at (DateTime)

## 🔐 Sécurité

- Authentification JWT pour les endpoints admin
- Hash des mots de passe avec bcrypt
- Validation des entrées avec Pydantic
- Rate limiting sur les endpoints sensibles
- CORS configuré

## 🧪 Tests

```bash
# Lancer les tests
pytest

# Avec couverture
pytest --cov=app
```

## 📦 Déploiement

### Docker
```bash
docker-compose up --build
```

### Production
```bash
# Utiliser gunicorn avec uvicorn workers
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000
```

## 🔧 Variables d'environnement

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/allo_khedma

# Security
SECRET_KEY=votre_secret_key_tres_long
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Admin
ADMIN_EMAIL=admin@allokhedma.com
ADMIN_PASSWORD=password_secure

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080

# Storage
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
```

## 📝 Exemple de réponse API

### GET /api/artisans

```json
[
  {
    "id": 1,
    "full_name": "Mahamat Ali",
    "phone": "+23590000001",
    "whatsapp_phone": "+23590000001",
    "category": {
      "id": 1,
      "name": "Plombier",
      "slug": "plombier",
      "icon": "plumbing"
    },
    "city": "N'Djamena",
    "district": "Moursal",
    "description": "Plombier disponible pour dépannage rapide à domicile.",
    "is_available": true,
    "rating": 4.6,
    "photo_url": "https://res.cloudinary.com/...",
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

## 🛠️ Stack technique

- **Framework** : FastAPI
- **ORM** : SQLAlchemy + Alembic
- **Validation** : Pydantic
- **Auth** : JWT (python-jose)
- **Password Hashing** : bcrypt
- **Database** : PostgreSQL
- **Migrations** : Alembic
- **Tests** : pytest + httpx
