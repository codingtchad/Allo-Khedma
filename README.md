# Allo-Khedma - Architecture complète

Application de mise en relation entre artisans et clients à N'Djamena, Tchad.

## 📁 Structure du projet

```
allo-khedma/
├── mobile_app/          # Application Flutter
├── backend_api/         # API REST (FastAPI)
├── admin_web/           # Dashboard admin (React)
├── docs/                # Documentation
├── scripts/             # Scripts de déploiement
├── .gitignore
├── README.md
└── docker-compose.yml
```

## 🚀 Démarrage rapide

### Mobile (Flutter)
```bash
cd mobile_app
flutter pub get
flutter run
```

### Backend (FastAPI)
```bash
cd backend_api
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Admin (React)
```bash
cd admin_web
npm install
npm start
```

## 📖 Documentation complète

Voir le dossier `docs/` pour :
- Configuration Firebase
- Schéma de base de données
- API REST endpoints
- Guide de déploiement

## 🔧 Technologies

- **Mobile** : Flutter + Firebase
- **Backend** : FastAPI + PostgreSQL
- **Admin** : React + TailwindCSS
- **Base de données** : PostgreSQL
- **Storage** : Cloudinary / Firebase Storage

## 👥 Équipe

Développé par CodingTchad pour connecter les artisans locaux avec leurs clients.
