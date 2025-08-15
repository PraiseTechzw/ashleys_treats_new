import 'package:flutter/material.dart';
import 'package:ashleys_treats/core/theme/app_colors.dart';
import 'package:ashleys_treats/core/theme/app_theme.dart';
import 'package:ashleys_treats/features/products/data/models/product_model.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final bool showInfoIcon;
  final double width;
  final double height;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
    this.showInfoIcon = true,
    this.width = 160,
    this.height = 200,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  margin: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isHovered
                          ? AppColors.primary.withOpacity(0.3)
                          : AppColors.cardColor.withOpacity(0.2),
                      width: _isHovered ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.primary.withOpacity(0.08),
                        blurRadius: _isHovered ? 15 : 10,
                        offset: const Offset(0, 5),
                        spreadRadius: _isHovered ? 2 : 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image section
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.cardColor.withOpacity(0.1),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Product image
                              if (widget.product.images.isNotEmpty)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Image.asset(
                                    widget.product.images.first,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                )
                              else
                                Center(
                                  child: Icon(
                                    Icons.cake,
                                    color: AppColors.primary,
                                    size: 48,
                                  ),
                                ),

                              // Info icon overlay
                              if (widget.showInfoIcon)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.info_outline,
                                      color: AppColors.primary.withOpacity(0.7),
                                      size: 16,
                                    ),
                                  ),
                                ),

                              // Category badge
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.9),
                                        AppColors.accent.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    widget.product.category,
                                    style: AppTheme.elegantBodyStyle.copyWith(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Product details
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name
                            Text(
                              widget.product.name,
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 12),

                            // Price and add to cart button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Price
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.1),
                                        AppColors.accent.withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '\$${widget.product.price.toStringAsFixed(2)}',
                                    style: AppTheme.elegantBodyStyle.copyWith(
                                      fontSize: 16,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Add to cart button
                                GestureDetector(
                                  onTap: widget.onAddToCart,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          AppColors.accent,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.add_shopping_cart_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
    );
  }
}
