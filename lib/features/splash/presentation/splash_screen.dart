import 'package:ashleys_treats/features/splash/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../core/services/navigation_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _startSplash();
  }

  void _startSplash() async {
    _animationController.forward();

    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() async {
    await NavigationService.navigateToInitialRoute(context, ref);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background,
                  AppColors.cardColor.withOpacity(0.3),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and Brand
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Lottie.asset(
                    'assets/animations/cupcakeani.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),

                const SizedBox(height: 32),

                // App Title
                Text(
                  'Ashley\'s Treats',
                  style: AppTheme.girlishHeadingStyle.copyWith(
                    fontSize: 36,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Sweet Delights, Delivered with Love',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.secondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 64),

                // Loading Animation
                Lottie.asset(
                  'assets/animations/loading.json',
                  width: 80,
                  height: 80,
                  repeat: true,
                  animate: true,
                ),

                const SizedBox(height: 24),

                // Loading Text
                Text(
                  'Loading...',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withOpacity(0.6),
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
