# DaliPro - Application Artisans N'Djamena

Application mobile Flutter pour trouver rapidement un artisan local à N'Djamena : plombier, électricien, réparateur.

## 🎨 Design

- **Primaire**: #C96E12 (Orange chaleureux)
- **Primaire foncé**: #A5570D
- **Accent**: #F3C892
- **Fond**: #FFF8F1
- **Surface**: #FFFFFF
- **Texte principal**: #1F1F1F
- **Texte secondaire**: #6B6B6B
- **Succès**: #2E9B57
- **Erreur**: #D64545

Style : Mobile-first, moderne, minimal, cartes arrondies, ombres légères.

## 🚀 Fonctionnalités

### Pour les utilisateurs
- Recherche d'artisans par métier (plombier, électricien, réparateur)
- Filtrage par quartier et disponibilité
- Affichage des détails (note, description, contact)
- Appel direct et contact WhatsApp
- Favoris et historique
- Inscription simplifiée

### Pour les artisans
- Formulaire d'inscription
- Gestion de profil
- Mise à jour disponibilité

### Pour les administrateurs
- Dashboard de gestion
- CRUD complet des artisans
- Validation des inscriptions
- Statistiques

## 🛠️ Stack Technique

- **Frontend**: Flutter 3.x, Dart
- **Backend**: Firebase (Serverless)
  - Firestore (Base de données)
  - Firebase Auth (Authentification)
  - Firebase Storage (Photos)
- **Architecture**: Clean Architecture légère

## 🔧 Configuration

### 1. Installer les dépendances
```bash
flutter pub get
```

### 2. Configurer Firebase
1. Créer un projet Firebase sur https://console.firebase.google.com
2. Ajouter une application Android avec le package ID: `com.dalipro.app`
3. Télécharger `google-services.json` dans `android/app/`
4. Activer les services :
   - Firestore Database
   - Authentication (Email/Mot de passe)
   - Storage

### 3. Mettre à jour les identifiants Firebase
Dans `lib/main.dart`, remplacer les valeurs :
```dart
FirebaseOptions(
  appId: '1:YOUR_PROJECT_ID:android:YOUR_APP_ID',
  apiKey: 'YOUR_API_KEY',
  projectId: 'dalipro-tchad',
  messagingSenderId: 'YOUR_SENDER_ID',
  storageBucket: 'dalipro-tchad.appspot.com',
)
```

### 4. Règles de sécurité Firestore

Déployer ces règles dans la console Firebase :

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Artisans - Lecture publique, écriture admin seulement
    match /artisans/{artisanId} {
      allow read: if true;
      allow write: if request.auth != null && 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Inscriptions - Tout le monde peut soumettre
    match /inscriptions/{inscriptionId} {
      allow create: if true;
      allow read, update, delete: if request.auth != null && 
                                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Users - Lecture/écriture utilisateur connecté
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5. Création d'un compte admin

Dans Firebase Console > Authentication :
1. Créer un utilisateur avec email `admin@dalipro.td`
2. Dans Firestore, créer un document dans la collection `users` :
```json
{
  "email": "admin@dalipro.td",
  "role": "admin",
  "createdAt": timestamp
}
```

## 🏃‍♂️ Démarrage

```bash
# Lancer l'application
flutter run

# Build APK de production
flutter build apk --release

# Build APK split par architecture
flutter build apk --split-per-abi
```

## 🔐 Sécurité

- Authentification requise pour l'admin
- Règles de sécurité Firestore
- Validation des formulaires
- HTTPS forcé

## 📄 Licence

Propriétaire - Tous droits réservés DaliPro 2024

## 👥 Contact

- Email: contact@dalipro.td
- WhatsApp: +235 XX XX XX XX
- N'Djamena, Tchad
