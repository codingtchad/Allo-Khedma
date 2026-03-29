import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../core/services/api_service.dart';

class ArtisanRegistrationScreen extends StatefulWidget {
  const ArtisanRegistrationScreen({super.key});

  @override
  State<ArtisanRegistrationScreen> createState() => _ArtisanRegistrationScreenState();
}

class _ArtisanRegistrationScreenState extends State<ArtisanRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _categoryController = TextEditingController();
  final _cityController = TextEditingController(text: 'N\'Djamena');
  final _districtController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Plombier', 'Électricien', 'Réparateur', 'Peintre', 'Maçon', 'Menuisier', 'Couturier', 'Coiffeur'
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _categoryController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.submitArtisanRequest({
        'full_name': _fullNameController.text,
        'phone': _phoneController.text,
        'whatsapp_phone': _whatsappController.text,
        'category': _categoryController.text,
        'city': _cityController.text,
        'district': _districtController.text,
        'description': _descriptionController.text,
      });

      if (mounted) {
        context.push('/registration-success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devenir artisan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rejoignez notre réseau d\'artisans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remplissez ce formulaire pour être ajouté à Allo-Khedma',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Nom complet
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom complet',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Téléphone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Numéro de téléphone',
                  prefixIcon: Icon(Icons.phone),
                  hintText: '+235 XX XX XX XX',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // WhatsApp
              TextFormField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  labelText: 'Numéro WhatsApp',
                  prefixIcon: Icon(Icons.message),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre numéro WhatsApp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Catégorie
              DropdownButtonFormField<String>(
                value: _categoryController.text.isEmpty ? null : _categoryController.text,
                decoration: const InputDecoration(
                  labelText: 'Métier / Catégorie',
                  prefixIcon: Icon(Icons.work),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner votre métier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Ville
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Ville',
                  prefixIcon: Icon(Icons.location_city),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Quartier
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(
                  labelText: 'Quartier',
                  prefixIcon: Icon(Icons.map),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre quartier';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description de vos services',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez décrire vos services';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Bouton submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Envoyer ma demande'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
