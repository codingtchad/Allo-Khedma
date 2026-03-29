# Documentation Allo-Khedma

## 📋 Table des matières

1. [Vue d'ensemble](#vue-densemble)
2. [Architecture](#architecture)
3. [Configuration](#configuration)
4. [API Reference](#api-reference)
5. [Déploiement](#déploiement)

---

## Vue d'ensemble

Allo-Khedma est une plateforme de mise en relation entre artisans et clients à N'Djamena, Tchad.

### Fonctionnalités principales

- **Recherche d'artisans** : Par catégorie, ville, quartier
- **Fiches artisans** : Informations détaillées, photos, contacts
- **Contact direct** : Appel téléphonique, WhatsApp
- **Inscription artisans** : Formulaire de soumission
- **Administration** : Dashboard de gestion des artisans et demandes

---

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Mobile App     │────▶│  Backend API    │────▶│  PostgreSQL     │
│  (Flutter)      │     │  (FastAPI)      │     │  (Database)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌─────────────────┐
                        │  Cloud Storage  │
                        │  (Images)       │
                        └─────────────────┘
```

### Stack technique

- **Mobile** : Flutter + Firebase (pour auth optionnelle)
- **Backend** : FastAPI (Python)
- **Base de données** : PostgreSQL 15
- **ORM** : SQLAlchemy
- **Auth** : JWT (JSON Web Tokens)
- **Storage** : Cloudinary / S3 compatible

---

## Configuration

### 1. Backend API

#### Installation locale

```bash
cd backend_api

# Créer un environnement virtuel
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Installer les dépendances
pip install -r requirements.txt

# Copier le fichier d'environnement
cp .env.example .env

# Éditer .env avec vos paramètres
# DATABASE_URL, SECRET_KEY, etc.

# Lancer le serveur
uvicorn app.main:app --reload
```

#### Avec Docker

```bash
# Depuis la racine du projet
docker-compose up --build

# L'API sera disponible sur http://localhost:8000
# La documentation Swagger sur http://localhost:8000/docs
```

### 2. Mobile App

```bash
cd mobile_app

# Installer les dépendances Flutter
flutter pub get

# Lancer l'application
flutter run

# Pour Android
flutter run -d android

# Pour iOS (macOS uniquement)
flutter run -d ios
```

### 3. Base de données

La base de données est automatiquement créée au premier lancement avec :
- Tables : categories, artisans, users, favorites, artisan_requests
- Un utilisateur admin par défaut

**Identifiants admin par défaut :**
- Email : `admin@allokhedma.com`
- Mot de passe : `Admin123!ChangeMe`

⚠️ **Important** : Changez ces identifiants en production !

---

## API Reference

### Endpoints Publics

#### Catégories

```http
GET /api/categories
```

Retourne toutes les catégories d'artisans.

#### Artisans

```http
GET /api/artisans
GET /api/artisans?category_id=1
GET /api/artisans?city=N'Djamena
GET /api/artisans?district=Moursal
GET /api/artisans?available=true
```

Retourne la liste des artisans avec filtres optionnels.

```http
GET /api/artisans/{id}
```

Retourne les détails d'un artisan spécifique.

#### Recherche

```http
GET /api/search?q=plombier
```

Recherche des artisans par nom, métier ou quartier.

---

### Endpoints Admin (Authentification requise)

#### Login

```http
POST /api/admin/login
Content-Type: application/x-www-form-urlencoded

username=admin@allokhedma.com
password=Admin123!ChangeMe
```

Retourne un token JWT.

#### Gestion des artisans

```http
GET /api/admin/artisans              # Liste tous les artisans
POST /api/admin/artisans             # Crée un artisan
PUT /api/admin/artisans/{id}         # Met à jour un artisan
DELETE /api/admin/artisans/{id}      # Supprime un artisan
```

#### Gestion des demandes

```http
GET /api/admin/artisan-requests                 # Liste les demandes
PUT /api/admin/artisan-requests/{id}/approve    # Approuve une demande
PUT /api/admin/artisan-requests/{id}/reject     # Rejette une demande
```

#### Stats Dashboard

```http
GET /api/admin/stats
```

Retourne les statistiques : total artisans, demandes en attente, catégories.

---

## Déploiement

### Production Backend

#### Option 1 : Render / Railway

1. Pousser le code sur GitHub
2. Connecter le dépôt sur Render/Railway
3. Configurer les variables d'environnement
4. Ajouter un add-on PostgreSQL
5. Déployer

#### Option 2 : VPS (Ubuntu)

```bash
# Installer Docker et Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Cloner le projet
git clone https://github.com/codingtchad/Allo-Khedma.git
cd Allo-Khedma

# Configurer les variables d'environnement
cp backend_api/.env.example backend_api/.env
# Éditer avec vos valeurs

# Lancer avec Docker Compose
docker-compose up -d

# Configurer Nginx comme reverse proxy (optionnel)
```

### Production Mobile

```bash
# Build APK pour Android
flutter build apk --release

# Le fichier sera dans : build/app/outputs/flutter-apk/app-release.apk

# Build pour iOS (nécessite macOS)
flutter build ios --release
```

---

## Sécurité

### Bonnes pratiques implémentées

- ✅ Hash des mots de passe avec bcrypt
- ✅ Authentification JWT pour les endpoints admin
- ✅ Validation des entrées avec Pydantic
- ✅ CORS configuré
- ✅ Requêtes paramétrées (prévention SQL injection)

### À faire en production

- [ ] Changer le SECRET_KEY par défaut
- [ ] Utiliser HTTPS
- [ ] Configurer rate limiting
- [ ] Activer les logs d'audit
- [ ] Sauvegardes automatiques de la base de données
- [ ] Monitoring (Sentry, Prometheus, etc.)

---

## Contribution

1. Forker le projet
2. Créer une branche feature (`git checkout -b feature/amazing-feature`)
3. Committer les changements (`git commit -m 'Add amazing feature'`)
4. Pusher vers la branche (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

---

## Licence

Ce projet est développé par CodingTchad pour la communauté tchadienne.

---

## Contact

- **Email** : contact@allokhedma.com
- **GitHub** : https://github.com/codingtchad
- **Localisation** : N'Djamena, Tchad
