import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/artisan.dart';
import '../services/artisan_service.dart';
import 'admin_edit_artisan_screen.dart';

class AdminArtisansListScreen extends StatelessWidget {
  const AdminArtisansListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ArtisanService();
    
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F1),
      appBar: AppBar(
        title: const Text('Gérer les artisans'),
      ),
      body: StreamBuilder<List<Artisan>>(
        stream: service.getArtisansStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text('Erreur de chargement', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString(), textAlign: TextAlign.center),
                ],
              ),
            );
          }
          
          final artisans = snapshot.data ?? [];
          
          if (artisans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Aucun artisan trouvé', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Commencez par ajouter un artisan'),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: artisans.length,
            itemBuilder: (context, index) {
              final artisan = artisans[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => _showOptions(context, artisan, service),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFFF3C892),
                          backgroundImage: artisan.photoUrl != null
                              ? NetworkImage(artisan.photoUrl!)
                              : null,
                          child: artisan.photoUrl == null
                              ? Icon(Icons.person, color: Colors.grey[600])
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artisan.nom,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${artisan.metier} • ${artisan.quartier}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: artisan.disponible
                                          ? const Color(0xFF2E9B57).withOpacity(0.1)
                                          : const Color(0xFFD64545).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      artisan.disponible ? 'Disponible' : 'Indisponible',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: artisan.disponible
                                            ? const Color(0xFF2E9B57)
                                            : const Color(0xFFD64545),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 14, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        artisan.note.toStringAsFixed(1),
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.more_vert, color: Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  void _showOptions(BuildContext context, Artisan artisan, ArtisanService service) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Color(0xFFC96E12)),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminEditArtisanScreen(artisan: artisan),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.visibility, color: Color(0xFFC96E12)),
              title: const Text('Voir le détail'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to detail screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Color(0xFFD64545)),
              title: const Text('Supprimer', style: TextStyle(color: Color(0xFFD64545))),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, artisan, service);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  void _confirmDelete(BuildContext context, Artisan artisan, ArtisanService service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cet artisan ?'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${artisan.nom} ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await service.deleteArtisan(artisan.id);
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Artisan supprimé avec succès')),
                );
              } catch (e) {
                if (context.mounted) Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFD64545)),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
