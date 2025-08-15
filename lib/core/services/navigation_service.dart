import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/splash/presentation/providers/onboarding_provider.dart';

class NavigationService {
  static Future<String> getInitialRoute(WidgetRef ref) async {
    // Check if user has seen onboarding
    final hasSeenOnboarding = ref.read(onboardingProvider);
    print('Navigation: hasSeenOnboarding = $hasSeenOnboarding'); // Debug info
    
    if (!hasSeenOnboarding) {
      print('Navigation: routing to /onboarding'); // Debug info
      return '/onboarding';
    }
    
    // Check if user is authenticated
    final authState = ref.read(authProvider);
    print('Navigation: isAuthenticated = ${authState.isAuthenticated}'); // Debug info
    
    if (authState.isAuthenticated) {
      print('Navigation: routing to /auth'); // Debug info
      return '/auth';
    } else {
      print('Navigation: routing to /login'); // Debug info
      return '/login';
    }
  }
  
  static Future<void> navigateToInitialRoute(BuildContext context, WidgetRef ref) async {
    final route = await getInitialRoute(ref);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }
  
  static Future<void> resetToInitialRoute(BuildContext context, WidgetRef ref) async {
    final route = await getInitialRoute(ref);
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
    }
  }
}
