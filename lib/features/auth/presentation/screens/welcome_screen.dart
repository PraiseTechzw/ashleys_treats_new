import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  final bool isNewUser;

  const WelcomeScreen({super.key, required this.isNewUser});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 80.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user?.displayName ?? 'Sweet Friend';
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.05),
              AppColors.background,
              AppColors.primary.withOpacity(0.03),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight - MediaQuery.of(context).padding.top,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Top Section with Animation
                    SizedBox(
                      height: isSmallScreen
                          ? screenHeight * 0.45
                          : screenHeight * 0.5,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo with Celebration
                          AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Container(
                                  width: isSmallScreen ? 100 : 140,
                                  height: isSmallScreen ? 100 : 140,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 50 : 70,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: isSmallScreen ? 25 : 40,
                                        offset: const Offset(0, 20),
                                      ),
                                    ],
                                  ),
                                  child: Lottie.asset(
                                    widget.isNewUser
                                        ? 'assets/animations/celebrate Confetti.json'
                                        : 'assets/animations/cupcakeani.json',
                                    fit: BoxFit.contain,
                                    controller: _animationController,
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: isSmallScreen ? 24 : 40),

                          // Personalized Welcome Text
                          AnimatedBuilder(
                            animation: _fadeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, _slideAnimation.value),
                                child: Opacity(
                                  opacity: _fadeAnimation.value,
                                  child: Column(
                                    children: [
                                      // Welcome message
                                      Text(
                                        widget.isNewUser
                                            ? 'Welcome to the family,'
                                            : 'Welcome back,',
                                        style: AppTheme.authSubtitleStyle
                                            .copyWith(
                                              fontSize: isSmallScreen ? 18 : 22,
                                              color: AppColors.onBackground
                                                  .withOpacity(0.7),
                                              fontWeight: FontWeight.w400,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: isSmallScreen ? 6 : 8),

                                      // User's name with special styling
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 16 : 24,
                                          vertical: isSmallScreen ? 6 : 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primary.withOpacity(
                                                0.8,
                                              ),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary
                                                  .withOpacity(0.3),
                                              blurRadius: 15,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          userName,
                                          style: AppTheme.authTitleStyle
                                              .copyWith(
                                                fontSize: isSmallScreen
                                                    ? 22
                                                    : 28,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.onPrimary,
                                                letterSpacing: 0.5,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),

                                      SizedBox(height: isSmallScreen ? 8 : 12),

                                      // Brand name
                                      Text(
                                        'Ashley\'s Treats! 🧁',
                                        style: AppTheme.authTitleStyle.copyWith(
                                          fontSize: isSmallScreen ? 18 : 24,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // Bottom Section with Content
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(isSmallScreen ? 20.0 : 32.0),
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value * 0.5),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Column(
                                children: [
                                  // Personalized Message Card
                                  Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 20 : 28,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.15,
                                          ),
                                          blurRadius: 25,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.1,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        // Icon with background
                                        Container(
                                          padding: EdgeInsets.all(
                                            isSmallScreen ? 12 : 16,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Icon(
                                            widget.isNewUser
                                                ? Icons.celebration
                                                : Icons.favorite,
                                            color: AppColors.primary,
                                            size: isSmallScreen ? 28 : 36,
                                          ),
                                        ),
                                        SizedBox(
                                          height: isSmallScreen ? 16 : 20,
                                        ),

                                        // Personalized message
                                        Text(
                                          widget.isNewUser
                                              ? 'Your sweet journey begins now, $userName! 🎉'
                                              : 'We\'re so happy to see you again, $userName! 💕',
                                          style: AppTheme.authTitleStyle
                                              .copyWith(
                                                fontSize: isSmallScreen
                                                    ? 16
                                                    : 20,
                                                color: AppColors.onBackground,
                                                fontWeight: FontWeight.w600,
                                                height: 1.3,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height: isSmallScreen ? 12 : 16,
                                        ),

                                        // Description
                                        Text(
                                          widget.isNewUser
                                              ? 'Explore our delicious treats, customize your orders, and enjoy the sweetest experience with Ashley\'s Treats! Every bite is made with love just for you.'
                                              : 'Ready to discover more delicious treats? Let\'s make your day sweeter with our fresh-baked goodies!',
                                          style: AppTheme.authSubtitleStyle
                                              .copyWith(
                                                fontSize: isSmallScreen
                                                    ? 14
                                                    : 16,
                                                height: 1.5,
                                                color: AppColors.onBackground
                                                    .withOpacity(0.8),
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: isSmallScreen ? 24 : 32),

                                  // Action Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: isSmallScreen ? 52 : 60,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/auth',
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: AppColors.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        elevation: 12,
                                        shadowColor: AppColors.primary
                                            .withOpacity(0.4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            widget.isNewUser
                                                ? Icons.explore
                                                : Icons.shopping_bag,
                                            size: isSmallScreen ? 20 : 24,
                                          ),
                                          SizedBox(
                                            width: isSmallScreen ? 8 : 12,
                                          ),
                                          Text(
                                            widget.isNewUser
                                                ? 'Start Exploring'
                                                : 'Continue Shopping',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 16 : 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: isSmallScreen ? 16 : 20),

                                  // Skip Option
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/auth',
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 16 : 24,
                                        vertical: isSmallScreen ? 8 : 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Skip for now',
                                      style: AppTheme.linkTextStyle.copyWith(
                                        fontSize: isSmallScreen ? 14 : 16,
                                        color: AppColors.secondary.withOpacity(
                                          0.7,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Bottom padding for small screens
                                  if (isSmallScreen) const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
