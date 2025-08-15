import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/navigation_service.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/splash/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/widgets/auth_wrapper.dart';
import '../../features/splash/presentation/providers/onboarding_provider.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({super.key});

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  String? _initialRoute;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determineInitialRoute();
  }

  Future<void> _determineInitialRoute() async {
    print('AppWrapper: Starting to determine initial route...'); // Debug

    // Wait for the onboarding provider to be ready
    await Future.delayed(const Duration(milliseconds: 500));

    // Wait for the onboarding provider to actually load its data
    bool providerReady = false;
    int attempts = 0;
    const maxAttempts = 10;

    while (!providerReady && attempts < maxAttempts && mounted) {
      final onboardingStatus = ref.read(onboardingProvider);
      print(
        'AppWrapper: Attempt $attempts - Onboarding provider status: $onboardingStatus',
      ); // Debug

      // Check if the provider has actually loaded (not just the default false value)
      if (onboardingStatus == true || attempts > 5) {
        // Give it a few attempts
        providerReady = true;
        print(
          'AppWrapper: Provider is ready, status: $onboardingStatus',
        ); // Debug
      } else {
        attempts++;
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    if (mounted) {
      // Wait for auth provider to check session status
      final authState = ref.read(authProvider);
      print(
        'AppWrapper: Auth state before route determination - isAuthenticated: ${authState.isAuthenticated}, hasCheckedSession: ${authState.hasCheckedSession}',
      ); // Debug

      // If auth provider hasn't checked session yet, wait for it
      if (!authState.hasCheckedSession) {
        print(
          'AppWrapper: Waiting for auth provider to check session...',
        ); // Debug
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Give auth provider time to initialize

        // Force a refresh if still not checked
        if (!authState.hasCheckedSession) {
          print('AppWrapper: Forcing auth status refresh...'); // Debug
          await ref.read(authProvider.notifier).refreshAuthStatus();
        }
      }

      final route = await NavigationService.getInitialRoute(ref);
      print('AppWrapper: Determined route: $route'); // Debug
      setState(() {
        _initialRoute = route;
        _isLoading = false;
      });
      print(
        'AppWrapper: State updated, _initialRoute: $_initialRoute, _isLoading: $_isLoading',
      ); // Debug
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      'AppWrapper: Building with _isLoading: $_isLoading, _initialRoute: $_initialRoute',
    ); // Debug

    if (_isLoading) {
      print('AppWrapper: Showing SplashScreen (loading)'); // Debug
      return const SplashScreen();
    }

    // Return the appropriate screen based on the determined route
    switch (_initialRoute) {
      case '/onboarding':
        print('AppWrapper: Showing OnboardingScreen'); // Debug
        return const OnboardingScreen();
      case '/login':
        print('AppWrapper: Showing LoginScreen'); // Debug
        return const LoginScreen();
      case '/auth':
        print('AppWrapper: Showing AuthWrapper'); // Debug
        return const AuthWrapper();
      default:
        print('AppWrapper: Showing SplashScreen (fallback)'); // Debug
        return const SplashScreen(); // Fallback
    }
  }
}
