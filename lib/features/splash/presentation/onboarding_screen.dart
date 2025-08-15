import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'providers/onboarding_provider.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/debug_onboarding_status.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _page = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Welcome to Ashley\'s Treats!',
      'subtitle': 'Where Sweet Dreams Come True',
      'desc':
          'Discover our magical world of delicious cupcakes, cookies, and sweet treats made with love and the finest ingredients.',
      'animation': 'assets/animations/cupcakeani.json',
      'color': AppColors.primary,
    },
    {
      'title': 'Browse & Choose',
      'subtitle': 'Endless Sweet Possibilities',
      'desc':
          'Explore our delightful collection of flavors, from classic vanilla to exotic combinations that will make your taste buds dance.',
      'animation': 'assets/animations/flavors.json',
      'color': AppColors.secondary,
    },
    {
      'title': 'Order & Enjoy',
      'subtitle': 'Sweet Delivery to Your Door',
      'desc':
          'Place your order with just a few taps and watch as we prepare your treats with care. Fast, fresh, and fabulous delivery!',
      'animation': 'assets/animations/Delivery.json',
      'color': AppColors.accent,
    },
    {
      'title': 'Track & Celebrate',
      'subtitle': 'Every Bite is Special',
      'desc':
          'Follow your order in real-time and celebrate every sweet moment. Because life is better with a little sweetness!',
      'animation': 'assets/animations/celebrate Confetti.json',
      'color': AppColors.primary,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _getStarted();
    }
  }

  void _getStarted() async {
    // Mark onboarding as complete
    await ref.read(onboardingProvider.notifier).markOnboardingComplete();
    if (mounted) {
      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Ashley\'s Treats! 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Wait a bit for the message to show
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Navigate to the appropriate screen based on auth status
        await NavigationService.navigateToInitialRoute(context, ref);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _getStarted,
                    child: Text(
                      'Skip',
                      style: AppTheme.linkTextStyle.copyWith(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) {
                    setState(() => _page = i);
                    _animationController.reset();
                    _animationController.forward();
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, i) {
                    final slide = _slides[i];
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Lottie Animation Container
                                Container(
                                  width: 250,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    color: slide['color'].withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(125),
                                    boxShadow: [
                                      BoxShadow(
                                        color: slide['color'].withOpacity(0.1),
                                        blurRadius: 40,
                                        offset: const Offset(0, 20),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(125),
                                    child: Lottie.asset(
                                      slide['animation'],
                                      fit: BoxFit.contain,
                                      repeat: true,
                                      animate: true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 48),
                                // Title
                                Text(
                                  slide['title'],
                                  style: AppTheme.girlishHeadingStyle.copyWith(
                                    fontSize: 32,
                                    color: slide['color'],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                // Subtitle
                                Text(
                                  slide['subtitle'],
                                  style: AppTheme.girlishSubheadingStyle
                                      .copyWith(
                                        fontSize: 20,
                                        color: slide['color'].withOpacity(0.8),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                // Description
                                Text(
                                  slide['desc'],
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Page indicators
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: i == _page ? 24 : 12,
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: i == _page
                            ? _slides[i]['color']
                            : AppColors.cardColor,
                        boxShadow: i == _page
                            ? [
                                BoxShadow(
                                  color: _slides[i]['color'].withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: [
                    // Previous button
                    if (_page > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            'Previous',
                            style: AppTheme.buttonTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    if (_page > 0) const SizedBox(width: 16),

                    // Next/Get Started button
                    Expanded(
                      flex: _page > 0 ? 1 : 1,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        child: Text(
                          _page == _slides.length - 1 ? 'Get Started' : 'Next',
                          style: AppTheme.buttonTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
