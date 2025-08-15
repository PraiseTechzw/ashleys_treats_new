import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'services/firebase/firebase_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/splash/presentation/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase and FCM
  await FirebaseService().init();
  // Initialize Isar (singleton, lazy)
  runApp(const ProviderScope(child: AshleyTreatsApp()));
}

class AshleyTreatsApp extends ConsumerWidget {
  const AshleyTreatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Ashley\'s Treats',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/auth': (context) => const AuthWrapper(),
      },
    );
  }
}
