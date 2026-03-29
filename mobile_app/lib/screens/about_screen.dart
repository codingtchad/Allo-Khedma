import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Logo et titre
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.construction,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Allo-Khedma',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Mission
            _buildCard(
              icon: Icons.target,
              title: 'Notre Mission',
              content: 'Faciliter la connexion entre les habitants de N\'Djamena et des artisans locaux qualifiés, pour des services rapides et de confiance.',
            ),
            const SizedBox(height: 16),

            // Public cible
            _buildCard(
              icon: Icons.people,
              title: 'Pour Qui ?',
              content: '• Particuliers cherchant un artisan\n• Artisans voulant développer leur clientèle\n• Tous les quartiers de N\'Djamena',
            ),
            const SizedBox(height: 16),

            // Fonctionnalités
            _buildCard(
              icon: Icons.star,
              title: 'Fonctionnalités',
              content: '• Recherche par métier et quartier\n• Contact direct (appel & WhatsApp)\n• Système de notation\n• Gestion des favoris\n• Inscription artisan simplifiée',
            ),
            const SizedBox(height: 16),

            // Contact
            _buildCard(
              icon: Icons.contact_mail,
              title: 'Contact',
              content: 'Email: contact@allo-khedma.td\nTéléphone: +235 XX XX XX XX\nN\'Djamena, Tchad',
            ),
            const SizedBox(height: 32),

            // Copyright
            Text(
              '© 2024 Allo-Khedma. Tous droits réservés.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Développé avec ❤️ au Tchad',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
