# 🚀 Guide de Démarrage Rapide - Allo-Khedma

## Prérequis

- **Docker** et **Docker Compose** installés
- **Git** pour cloner le projet
- **Flutter** (optionnel, pour développer l'app mobile)
- **Python 3.11+** (optionnel, pour développer le backend localement)

---

## Option 1 : Démarrage avec Docker (Recommandé)

### Étape 1 : Cloner le projet

```bash
git clone https://github.com/codingtchad/Allo-Khedma.git
cd Allo-Khedma
```

### Étape 2 : Lancer avec Docker Compose

```bash
docker-compose up --build
```

C'est tout ! Le système démarre automatiquement :

- ✅ **Base de données PostgreSQL** sur le port 5432
- ✅ **Backend API FastAPI** sur http://localhost:8000
- ✅ **Documentation Swagger** sur http://localhost:8000/docs
- ✅ **Création automatique d'un admin par défaut**

### Étape 3 : Tester l'API

Ouvrez votre navigateur et allez sur :
- **API Root** : http://localhost:8000
- **Documentation interactive** : http://localhost:8000/docs
- **Health check** : http://localhost:8000/health

### Étape 4 : Se connecter en tant qu'admin

**Identifiants par défaut :**
- Email : `admin@allokhedma.com`
- Mot de passe : `Admin123!ChangeMe`

Testez avec curl :

```bash
# Obtenir un token JWT
curl -X POST "http://localhost:8000/api/admin/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin@allokhedma.com&password=Admin123!ChangeMe"
```

### Étape 5 : Créer des catégories et artisans

Via la documentation Swagger (http://localhost:8000/docs) :

1. **POST** `/api/admin/categories` - Créer une catégorie (ex: Plombier)
2. **POST** `/api/admin/artisans` - Créer un artisan
3. **GET** `/api/artisans` - Voir la liste publique des artisans

---

## Option 2 : Développement Local (Sans Docker)

### Backend API

```bash
cd backend_api

# Créer un environnement virtuel
python -m venv venv

# Activer l'environnement
# Sur Linux/Mac :
source venv/bin/activate
# Sur Windows :
venv\Scripts\activate

# Installer les dépendances
pip install -r requirements.txt

# Copier et configurer .env
cp .env.example .env
# Éditer .env avec vos paramètres (DATABASE_URL, etc.)

# Lancer PostgreSQL localement ou utiliser un service cloud

# Lancer le serveur
uvicorn app.main:app --reload
```

### Mobile App Flutter

```bash
cd mobile_app

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Ou spécifier un appareil
flutter run -d android  # Pour Android
flutter run -d chrome   # Pour Web (si configuré)
```

---

## Vérification que tout fonctionne

### 1. Tester les endpoints publics

```bash
# Récupérer les catégories (vide au début)
curl http://localhost:8000/api/categories

# Récupérer les artisans (vide au début)
curl http://localhost:8000/api/artisans
```

### 2. Créer une catégorie (admin requis)

```bash
# D'abord, obtenir le token
TOKEN=$(curl -s -X POST "http://localhost:8000/api/admin/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin@allokhedma.com&password=Admin123!ChangeMe" \
  | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)

# Créer une catégorie
curl -X POST "http://localhost:8000/api/admin/categories" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "name": "Plombier",
    "slug": "plombier",
    "icon": "plumbing"
  }'
```

### 3. Créer un artisan (admin requis)

```bash
# Récupérer l'ID de la catégorie créée
CATEGORY_ID=$(curl -s http://localhost:8000/api/categories | grep -o '"id":[0-9]*' | head -1 | cut -d':' -f2)

# Créer un artisan
curl -X POST "http://localhost:8000/api/admin/artisans" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d "{
    \"full_name\": \"Mahamat Ali\",
    \"phone\": \"+23590000001\",
    \"whatsapp_phone\": \"+23590000001\",
    \"category_id\": $CATEGORY_ID,
    \"city\": \"N'Djamena\",
    \"district\": \"Moursal\",
    \"description\": \"Plombier expérimenté disponible pour dépannage rapide.\",
    \"is_available\": true,
    \"rating\": 4.5
  }"
```

### 4. Vérifier que l'artisan est visible publiquement

```bash
curl http://localhost:8000/api/artisans
```

---

## Arrêter le système

```bash
# Arrêter tous les services
docker-compose down

# Arrêter et supprimer les volumes (attention, efface la base de données !)
docker-compose down -v
```

---

## Prochaines étapes

1. **Personnaliser les identifiants admin** dans `.env`
2. **Ajouter des catégories** : Plombier, Électricien, Réparateur, etc.
3. **Importer ou créer des artisans** via le dashboard admin
4. **Configurer l'app mobile** pour pointer vers l'API
5. **Déployer en production** (voir docs/README.md)

---

## En cas de problème

### Le backend ne démarre pas

```bash
# Voir les logs
docker-compose logs backend

# Redémarrer
docker-compose restart backend
```

### La base de données n'est pas accessible

```bash
# Vérifier que PostgreSQL est prêt
docker-compose logs db

# Redémarrer la base de données
docker-compose restart db
```

### Erreur de migration

Supprimer les volumes et redémarrer :

```bash
docker-compose down -v
docker-compose up --build
```

---

## Besoin d'aide ?

- 📖 **Documentation complète** : [docs/README.md](docs/README.md)
- 🐛 **Signaler un bug** : https://github.com/codingtchad/Allo-Khedma/issues
- 📧 **Contact** : contact@allokhedma.com

---

**Développé avec ❤️ à N'Djamena, Tchad**
