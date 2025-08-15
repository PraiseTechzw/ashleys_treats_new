import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ashleys_treats/core/theme/app_colors.dart';
import 'package:ashleys_treats/core/theme/app_theme.dart';
import '../providers/product_provider.dart';
import 'view_all_products_screen.dart';

class CategoriesOverviewScreen extends ConsumerStatefulWidget {
  const CategoriesOverviewScreen({super.key});

  @override
  ConsumerState<CategoriesOverviewScreen> createState() => _CategoriesOverviewScreenState();
}

class _CategoriesOverviewScreenState extends ConsumerState<CategoriesOverviewScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onCategoryTap(String category) {
    ref.read(productProvider.notifier).loadProductsByCategory(category);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAllProductsScreen(
          title: 'All $category',
          category: category,
          products: ref.read(productProvider).productsByCategory,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cupcakes':
        return Icons.cake_rounded;
      case 'cakes':
        return Icons.cake_outlined;
      case 'cookies':
        return Icons.cookie_rounded;
      case 'donuts':
        return Icons.circle_rounded;
      case 'muffins':
        return Icons.cake_outlined;
      case 'brownies':
        return Icons.square_rounded;
      case 'cake pops':
        return Icons.cake_rounded;
      default:
        return Icons.cake_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cupcakes':
        return Colors.pink;
      case 'cakes':
        return Colors.purple;
      case 'cookies':
        return Colors.orange;
      case 'donuts':
        return Colors.brown;
      case 'muffins':
        return Colors.blue;
      case 'brownies':
        return Colors.deepOrange;
      case 'cake pops':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  String _getCategoryDescription(String category) {
    switch (category.toLowerCase()) {
      case 'cupcakes':
        return 'Delicious individual treats perfect for any occasion';
      case 'cakes':
        return 'Beautiful celebration cakes for special moments';
      case 'cookies':
        return 'Classic cookies with a modern twist';
      case 'donuts':
        return 'Sweet and fluffy donuts in various flavors';
      case 'muffins':
        return 'Moist and flavorful muffins for breakfast or snack';
      case 'brownies':
        return 'Rich and fudgy chocolate brownies';
      case 'cake pops':
        return 'Fun and colorful cake pops on sticks';
      default:
        return 'Delicious treats for every taste';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header
            SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.15),
                        AppColors.cardColor.withOpacity(0.25),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Title and back button
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.surface,
                                    AppColors.surface.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categories',
                                  style: AppTheme.girlishHeadingStyle.copyWith(
                                    fontSize: 26,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Explore our delicious treat categories',
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 14,
                                    color: AppColors.secondary.withOpacity(0.7),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Search bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search categories...',
                            hintStyle: AppTheme.elegantBodyStyle.copyWith(
                              color: AppColors.secondary.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.search_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories Grid
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final categoryColor = _getCategoryColor(category);
                      
                      return GestureDetector(
                        onTap: () => _onCategoryTap(category),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                categoryColor.withOpacity(0.1),
                                categoryColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: categoryColor.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Category Icon
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        categoryColor.withOpacity(0.2),
                                        categoryColor.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: categoryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    _getCategoryIcon(category),
                                    color: categoryColor,
                                    size: 40,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Category Name
                                Text(
                                  category,
                                  style: AppTheme.girlishHeadingStyle.copyWith(
                                    fontSize: 18,
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 8),

                                // Category Description
                                Text(
                                  _getCategoryDescription(category),
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 12,
                                    color: AppColors.secondary.withOpacity(0.7),
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 12),

                                // Explore Button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        categoryColor.withOpacity(0.8),
                                        categoryColor.withOpacity(0.6),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: categoryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Explore',
                                        style: AppTheme.elegantBodyStyle.copyWith(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                        size: 14,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
