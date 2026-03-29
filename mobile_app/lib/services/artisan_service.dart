import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/artisan.dart';

class ArtisanService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference get _artisansCollection => _firestore.collection('artisans');
  CollectionReference get _inscriptionsCollection => _firestore.collection('inscriptions');

  // Stream pour récupérer tous les artisans valides
  Stream<List<Artisan>> getArtisansStream() {
    return _artisansCollection
        .where('estValide', isEqualTo: true)
        .orderBy('note', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Artisan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Stream pour filtrer par métier
  Stream<List<Artisan>> getArtisansByMetier(String metier) {
    return _artisansCollection
        .where('metier', isEqualTo: metier)
        .where('estValide', isEqualTo: true)
        .orderBy('note', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Artisan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // Recherche textuelle
  Future<List<Artisan>> searchArtisans(String query) async {
    final queryLower = query.toLowerCase();
    
    // Note: Pour une recherche avancée, utilisez Algolia ou Elasticsearch
    // Ici on fait une recherche basique côté client
    final snapshot = await _artisansCollection
        .where('estValide', isEqualTo: true)
        .get();
    
    return snapshot.docs
        .map((doc) => Artisan.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .where((artisan) =>
            artisan.nom.toLowerCase().contains(queryLower) ||
            artisan.metier.toLowerCase().contains(queryLower) ||
            artisan.quartier.toLowerCase().contains(queryLower) ||
            artisan.description.toLowerCase().contains(queryLower))
        .toList();
  }

  // Récupérer un artisan par ID
  Future<Artisan?> getArtisanById(String id) async {
    try {
      final doc = await _artisansCollection.doc(id).get();
      if (doc.exists) {
        return Artisan.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'artisan: $e');
    }
  }

  // Ajouter un artisan (admin seulement)
  Future<void> addArtisan(Artisan artisan) async {
    try {
      await _artisansCollection.add(artisan.toMap());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'artisan: $e');
    }
  }

  // Modifier un artisan (admin seulement)
  Future<void> updateArtisan(Artisan artisan) async {
    try {
      await _artisansCollection.doc(artisan.id).update(artisan.toMap());
    } catch (e) {
      throw Exception('Erreur lors de la modification de l\'artisan: $e');
    }
  }

  // Supprimer un artisan (admin seulement)
  Future<void> deleteArtisan(String id) async {
    try {
      await _artisansCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'artisan: $e');
    }
  }

  // Soumettre une inscription (formulaire public)
  Future<void> submitInscription(Map<String, dynamic> data) async {
    try {
      await _inscriptionsCollection.add({
        ...data,
        'dateSoumission': FieldValue.serverTimestamp(),
        'statut': 'en_attente',
      });
    } catch (e) {
      throw Exception('Erreur lors de la soumission: $e');
    }
  }

  // Upload de photo
  Future<String> uploadPhoto(File imageFile, String artisanId) async {
    try {
      final ref = _storage.ref().child('artisans').child('$artisanId.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erreur lors de l\'upload de la photo: $e');
    }
  }

  // Authentification Admin
  Future<UserCredential> signInAdmin(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isAdmin() {
    final user = _auth.currentUser;
    // Vérifiez si l'email est dans la liste des admins
    return user != null && user.email?.endsWith('@dalipro.td') == true;
  }
}
