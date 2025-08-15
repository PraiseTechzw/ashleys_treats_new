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
import 'features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and FCM
  await FirebaseService().init();

  // Seed demo data
  await DemoDataSeeder.seedDemoData();

  // Initialize Isar (singleton, lazy)
  runApp(const ProviderScope(child: AshleyTreatsApp()));
}

class AshleyTreatsApp extends ConsumerStatefulWidget {
  const AshleyTreatsApp({super.key});

  @override
  ConsumerState<AshleyTreatsApp> createState() => _AshleyTreatsAppState();
}

class _AshleyTreatsAppState extends ConsumerState<AshleyTreatsApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app comes back to foreground, refresh auth status
    if (state == AppLifecycleState.resumed) {
      print('App: App resumed, refreshing auth status...');
      ref.read(authProvider.notifier).refreshAuthStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
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
