class Artisan {
  final String id;
  final String nom;
  final String metier;
  final String telephone;
  final String whatsapp;
  final String quartier;
  final String ville;
  final String description;
  final bool disponible;
  final double note;
  final String? photoUrl;
  final DateTime dateInscription;
  final bool estValide;

  Artisan({
    required this.id,
    required this.nom,
    required this.metier,
    required this.telephone,
    required this.whatsapp,
    required this.quartier,
    required this.ville = 'N\'Djamena',
    required this.description,
    required this.disponible,
    required this.note,
    this.photoUrl,
    required this.dateInscription,
    this.estValide = true,
  });

  factory Artisan.fromMap(Map<String, dynamic> map, String documentId) {
    return Artisan(
      id: documentId,
      nom: map['nom'] ?? '',
      metier: map['metier'] ?? '',
      telephone: map['telephone'] ?? '',
      whatsapp: map['whatsapp'] ?? '',
      quartier: map['quartier'] ?? '',
      ville: map['ville'] ?? 'N\'Djamena',
      description: map['description'] ?? '',
      disponible: map['disponible'] ?? true,
      note: (map['note'] ?? 0.0).toDouble(),
      photoUrl: map['photoUrl'],
      dateInscription: (map['dateInscription'] as Timestamp?)?.toDate() ?? DateTime.now(),
      estValide: map['estValide'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'metier': metier,
      'telephone': telephone,
      'whatsapp': whatsapp,
      'quartier': quartier,
      'ville': ville,
      'description': description,
      'disponible': disponible,
      'note': note,
      'photoUrl': photoUrl,
      'dateInscription': Timestamp.fromDate(dateInscription),
      'estValide': estValide,
    };
  }

  Artisan copyWith({
    String? id,
    String? nom,
    String? metier,
    String? telephone,
    String? whatsapp,
    String? quartier,
    String? ville,
    String? description,
    bool? disponible,
    double? note,
    String? photoUrl,
    DateTime? dateInscription,
    bool? estValide,
  }) {
    return Artisan(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      metier: metier ?? this.metier,
      telephone: telephone ?? this.telephone,
      whatsapp: whatsapp ?? this.whatsapp,
      quartier: quartier ?? this.quartier,
      ville: ville ?? this.ville,
      description: description ?? this.description,
      disponible: disponible ?? this.disponible,
      note: note ?? this.note,
      photoUrl: photoUrl ?? this.photoUrl,
      dateInscription: dateInscription ?? this.dateInscription,
      estValide: estValide ?? this.estValide,
    );
  }
}
