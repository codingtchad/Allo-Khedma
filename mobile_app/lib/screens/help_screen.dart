import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aide & Utilisation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection(
            icon: Icons.search,
            title: 'Trouver un artisan',
            content: [
              '1. Utilisez la barre de recherche pour trouver un métier spécifique',
              '2. Ou parcourez les catégories disponibles',
              '3. Filtrez par quartier ou disponibilité',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            icon: Icons.phone,
            title: 'Contacter un artisan',
            content: [
              '• Cliquez sur "Appeler" pour téléphoner directement',
              '• Cliquez sur "WhatsApp" pour envoyer un message',
              '• Un message pré-rempli sera généré automatiquement',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            icon: Icons.favorite,
            title: 'Gérer vos favoris',
            content: [
              '• Cliquez sur l\'icône cœur pour sauvegarder un artisan',
              '• Retrouvez vos favoris dans l\'onglet "Favoris"',
              '• Supprimez un favori en cliquant à nouveau sur le cœur',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            icon: Icons.person_add,
            title: 'Devenir artisan',
            content: [
              '• Cliquez sur "Devenir artisan" depuis l\'accueil',
              '• Remplissez le formulaire avec vos informations',
              '• Notre équipe validera votre demande sous 48h',
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            icon: Icons.info,
            title: 'Conseils d\'utilisation',
            content: [
              '• Vérifiez la disponibilité avant de contacter',
              '• Consultez les notes et avis des autres utilisateurs',
              '• Précisez bien votre besoin lors du premier contact',
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: AppColors.primary, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Besoin d\'aide supplémentaire ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Contactez notre équipe depuis les paramètres',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<String> content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...content.map((line) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (line.startsWith('•') || line.startsWith('1.') || line.startsWith('2.') || line.startsWith('3.'))
                Text(
                  '${line.substring(0, 2)} ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  line.length > 2 ? line.substring(2) : line,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
