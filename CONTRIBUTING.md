# Comment contribuer à Allo-Khedma

Merci de votre intérêt pour contribuer à **Allo-Khedma** ! Ce guide vous aidera à démarrer.

## 🎯 Comment contribuer

### 1. Signaler un bug
- Ouvrez une issue sur GitHub avec le label `bug`
- Décrivez clairement le problème
- Incluez les étapes pour reproduire le bug
- Ajoutez des captures d'écran si pertinent

### 2. Proposer une fonctionnalité
- Ouvrez une issue avec le label `enhancement`
- Expliquez l'utilité de la fonctionnalité
- Décrivez comment elle devrait fonctionner

### 3. Corriger un bug ou ajouter une fonctionnalité
- Forkez le projet
- Créez une branche (`git checkout -b feature/AmazingFeature`)
- Faites vos modifications
- Testez soigneusement
- Commitez vos changements (`git commit -m 'Add AmazingFeature'`)
- Poussez vers la branche (`git push origin feature/AmazingFeature`)
- Ouvrez une Pull Request

## 📋 Standards de code

### Flutter/Dart
- Suivez le [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Utilisez `flutter analyze` avant de commiter
- Assurez-vous que tous les tests passent

### Python/FastAPI
- Suivez [PEP 8](https://pep8.org/)
- Utilisez `black` pour le formatage
- Ajoutez des docstrings aux fonctions publiques

## 🧪 Tests

Avant de soumettre une PR, assurez-vous que :
- Les tests Flutter passent : `flutter test`
- Les tests Python passent : `pytest`
- L'application se lance sans erreur

## 📝 Convention de commit

Utilisez [Conventional Commits](https://www.conventionalcommits.org/) :
- `feat:` nouvelle fonctionnalité
- `fix:` correction de bug
- `docs:` documentation
- `style:` formatage
- `refactor:` refactoring
- `test:` ajout de tests
- `chore:` maintenance

Exemple : `feat: ajout de la recherche par quartier`

## 🔍 Processus de review

1. Une PR sera reviewée par au moins un mainteneur
2. Des commentaires pourront être demandés
3. Une fois approuvée, la PR sera mergée

## 💬 Communication

- Soyez respectueux et constructif
- Posez des questions dans les issues
- Partagez vos idées ouvertement

Merci de faire grandir Allo-Khedma avec nous ! 🚀
