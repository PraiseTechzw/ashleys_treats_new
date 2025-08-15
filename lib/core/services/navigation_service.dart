import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    // Wait for auth provider to check session status
    final authState = ref.read(authProvider);
    print(
      'Navigation: Initial auth state - isAuthenticated: ${authState.isAuthenticated}, hasCheckedSession: ${authState.hasCheckedSession}',
    ); // Debug info

    // If auth provider hasn't checked session yet, wait for it
    if (!authState.hasCheckedSession) {
      print(
        'Navigation: Waiting for auth provider to check session...',
      ); // Debug info

      // Wait for the auth provider to finish checking session
      int attempts = 0;
      const maxAttempts = 20; // Wait up to 2 seconds

      while (!authState.hasCheckedSession && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;

        // Re-read the auth state
        final currentAuthState = ref.read(authProvider);
        if (currentAuthState.hasCheckedSession) {
          print(
            'Navigation: Auth provider finished checking session after $attempts attempts',
          ); // Debug info
          break;
        }
      }

      // If still not checked, force a refresh
      if (!authState.hasCheckedSession) {
        print('Navigation: Forcing auth status refresh...'); // Debug info
        await ref.read(authProvider.notifier).refreshAuthStatus();
      }
    }

    // Now check the final auth state
    final finalAuthState = ref.read(authProvider);
    print(
      'Navigation: Final auth state - isAuthenticated: ${finalAuthState.isAuthenticated}, user: ${finalAuthState.user?.email}',
    ); // Debug info

    if (finalAuthState.isAuthenticated && finalAuthState.user != null) {
      print(
        'Navigation: User is authenticated, routing to /auth',
      ); // Debug info
      return '/auth';
    } else {
      print(
        'Navigation: User is not authenticated, routing to /login',
      ); // Debug info
      return '/login';
    }
  }

  static Future<void> navigateToInitialRoute(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final route = await getInitialRoute(ref);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  static Future<void> resetToInitialRoute(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final route = await getInitialRoute(ref);
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
    }
  }

  // Helper method to check if user should be redirected to home
  static Future<bool> shouldRedirectToHome(WidgetRef ref) async {
    final authState = ref.read(authProvider);

    // If auth provider hasn't checked session yet, wait for it
    if (!authState.hasCheckedSession) {
      await ref.read(authProvider.notifier).refreshAuthStatus();
    }

    final finalAuthState = ref.read(authProvider);
    return finalAuthState.isAuthenticated && finalAuthState.user != null;
  }
}
