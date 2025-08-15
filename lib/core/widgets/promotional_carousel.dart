import 'package:flutter/material.dart';
import 'package:ashleys_treats/core/theme/app_colors.dart';
import 'package:ashleys_treats/core/theme/app_theme.dart';

class PromotionalCarousel extends StatefulWidget {
  final List<PromotionalBanner> banners;
  final double height;
  final VoidCallback? onBannerTap;

  const PromotionalCarousel({
    super.key,
    required this.banners,
    this.height = 200,
    this.onBannerTap,
  });

  @override
  State<PromotionalCarousel> createState() => _PromotionalCarouselState();
}

class _PromotionalCarouselState extends State<PromotionalCarousel>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    // Auto-scroll every 4 seconds
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && widget.banners.length > 1) {
        if (_currentPage < widget.banners.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Carousel
        FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SizedBox(
              height: widget.height,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: widget.banners.length,
                itemBuilder: (context, index) {
                  final banner = widget.banners[index];
                  return GestureDetector(
                    onTap: widget.onBannerTap,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            // Background image or gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient:
                                    banner.gradient ??
                                    LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.primary.withOpacity(0.8),
                                        AppColors.accent.withOpacity(0.6),
                                      ],
                                    ),
                              ),
                              child: banner.imagePath != null
                                  ? Image.asset(
                                      banner.imagePath!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : null,
                            ),

                            // Gradient overlay for better text readability
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Content
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Badge
                                    if (banner.badge != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          banner.badge!,
                                          style: AppTheme.elegantBodyStyle
                                              .copyWith(
                                                fontSize: 12,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),

                                    const SizedBox(height: 12),

                                    // Title
                                    Text(
                                      banner.title,
                                      style: AppTheme.girlishHeadingStyle
                                          .copyWith(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                offset: const Offset(0, 2),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Subtitle
                                    if (banner.subtitle != null)
                                      Text(
                                        banner.subtitle!,
                                        style: AppTheme.elegantBodyStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: const Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Page indicators
        if (widget.banners.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.banners.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  gradient: _currentPage == index
                      ? LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        )
                      : null,
                  color: _currentPage == index
                      ? null
                      : AppColors.secondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class PromotionalBanner {
  final String title;
  final String? subtitle;
  final String? badge;
  final String? imagePath;
  final LinearGradient? gradient;
  final VoidCallback? onTap;

  const PromotionalBanner({
    required this.title,
    this.subtitle,
    this.badge,
    this.imagePath,
    this.gradient,
    this.onTap,
  });
}
