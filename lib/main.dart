import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'services/firebase/firebase_service.dart';
import 'core/utils/demo_data_seeder.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/welcome_screen.dart';
import 'features/auth/presentation/widgets/auth_wrapper.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/splash/presentation/onboarding_screen.dart';
import 'core/widgets/app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and FCM
  await FirebaseService().init();

  // Seed demo data
  await DemoDataSeeder.seedDemoData();

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
      home: const AppWrapper(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
          case '/onboarding':
            return MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            );
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/register':
            return MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            );
          case '/forgot_password':
            return MaterialPageRoute(
              builder: (context) => const ForgotPasswordScreen(),
            );
          case '/welcome':
            final isNewUser = settings.arguments as bool? ?? false;
            return MaterialPageRoute(
              builder: (context) => WelcomeScreen(isNewUser: isNewUser),
            );
          case '/auth':
            return MaterialPageRoute(builder: (context) => const AuthWrapper());
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
        }
      },
    );
  }
}
