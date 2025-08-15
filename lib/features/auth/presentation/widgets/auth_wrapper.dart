import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../../../common/presentation/screens/admin_nav_screen.dart';
import '../../../common/presentation/screens/customer_nav_screen.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const AuthLoadingScreen();
    }

    if (authState.isAuthenticated && authState.user != null) {
      // Route based on user role
      if (ref.read(authProvider.notifier).isAdmin) {
        return const AdminNavScreen();
      } else {
        return const CustomerNavScreen();
      }
    }

    // Show login screen if not authenticated
    return const LoginScreen();
  }
}

class AuthLoadingScreen extends StatelessWidget {
  const AuthLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.cardColor.withOpacity(0.3),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo with Lottie
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Lottie.asset(
                      'assets/animations/cupcakeani.json',
                      fit: BoxFit.contain,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Loading Text
                Text(
                  'Ashley\'s Treats',
                  style: AppTheme.girlishHeadingStyle.copyWith(
                    fontSize: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Loading Animation
                Lottie.asset(
                  'assets/animations/loading.json',
                  width: 60,
                  height: 60,
                  repeat: true,
                  animate: true,
                ),
                const SizedBox(height: 16),

                Text(
                  'Checking authentication...',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final bool requireAdmin;

  const AuthGuard({
    super.key,
    required this.child,
    this.requireAdmin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const AuthLoadingScreen();
    }

    if (!authState.isAuthenticated) {
      return _buildAccessDeniedScreen(context, 'Please log in to continue');
    }

    if (requireAdmin && !ref.read(authProvider.notifier).isAdmin) {
      return _buildAccessDeniedScreen(context, 'Admin access required');
    }

    return child;
  }

  Widget _buildAccessDeniedScreen(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.cardColor.withOpacity(0.3),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Access Denied Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 60,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Access Denied Title
                  Text(
                    'Access Denied',
                    style: AppTheme.girlishHeadingStyle.copyWith(
                      fontSize: 28,
                      color: AppColors.accent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Access Denied Message
                  Text(
                    message,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text(
                        'Go to Login',
                        style: AppTheme.buttonTextStyle.copyWith(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
