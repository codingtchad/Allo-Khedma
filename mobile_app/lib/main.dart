import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        appId: '1:YOUR_PROJECT_ID:android:YOUR_APP_ID',
        apiKey: 'YOUR_API_KEY',
        projectId: 'dalipro-tchad',
        messagingSenderId: 'YOUR_SENDER_ID',
        storageBucket: 'dalipro-tchad.appspot.com',
      ),
    );
    runApp(const DaliProApp());
  } catch (e) {
    debugPrint('Erreur initialisation Firebase: $e');
    runApp(const DaliProApp(firebaseError: true));
  }
}

class DaliProApp extends StatelessWidget {
  final bool firebaseError;
  
  const DaliProApp({super.key, this.firebaseError = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaliPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC96E12),
          primary: const Color(0xFFC96E12),
          primaryContainer: const Color(0xFFF3C892),
          secondary: const Color(0xFFA5570D),
          surface: const Color(0xFFFFFFFF),
          background: const Color(0xFFFFF8F1),
          error: const Color(0xFFD64545),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF1F1F1F),
          onBackground: const Color(0xFF1F1F1F),
          onError: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xFFFFF8F1),
          foregroundColor: Color(0xFFC96E12),
          titleTextStyle: TextStyle(
            color: Color(0xFF1F1F1F),
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFC96E12), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: firebaseError 
          ? const ErrorScreen(message: 'Erreur de connexion Firebase')
          : const SplashScreen(),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;
  
  const ErrorScreen({super.key, required this.message});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Oups !',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF6B6B6B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
