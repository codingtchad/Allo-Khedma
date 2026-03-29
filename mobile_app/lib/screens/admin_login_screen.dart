import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/artisan_service.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _service = ArtisanService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC96E12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.handshake,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  'Administration',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Connectez-vous pour gérer les artisans',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Formulaire
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!value.contains('@')) {
                            return 'Email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD64545).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xFFD64545)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Color(0xFFD64545)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('Se connecter'),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await _service.signInAdmin(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (_service.isAdmin()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Compte non autorisé. Contactez l\'administrateur.';
        });
        await _service.signOut();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Échec de connexion. Vérifiez vos identifiants.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
