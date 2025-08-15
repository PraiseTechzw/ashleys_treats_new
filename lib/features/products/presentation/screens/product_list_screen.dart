import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/enhanced_app_bar.dart';
import '../../../../core/widgets/promotional_carousel.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../providers/product_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/product_model.dart';
import 'product_detail_screen.dart';
import 'view_all_products_screen.dart';
import 'categories_overview_screen.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _addToCart(ProductModel product) {
    ref.read(cartProvider.notifier).addItem(product);
    ToastManager.showSuccess(context, '${product.name} added to cart!');
  }

  void _showProductDetails(ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailsBottomSheet(
        product: product,
        onAddToCart: () => _addToCart(product),
      ),
    );
  }

  void _onCartTap() {
    // TODO: Navigate to cart screen
  }

  void _onLocationTap() {
    // TODO: Show location picker
  }

  void _onProfileTap() {
    // TODO: Navigate to profile screen
  }

  void _onViewAllFeatured() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAllProductsScreen(
          title: 'Featured Treats',
          products: ref.read(featuredProductsProvider),
          isFeatured: true,
        ),
      ),
    );
  }

  void _onViewAllCategory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewAllProductsScreen(
          title: 'All ${ref.read(productProvider).selectedCategory}',
          category: ref.read(productProvider).selectedCategory,
          products: ref.read(productProvider).productsByCategory,
        ),
      ),
    );
  }

  void _onViewAllCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoriesOverviewScreen()),
    );
  }

  List<PromotionalBanner> get _promotionalBanners => [
    PromotionalBanner(
      title: 'Sweet & Savory Treats',
      subtitle: 'Delivered to Your Doorstep',
      badge: 'NEW',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary.withOpacity(0.9),
          AppColors.accent.withOpacity(0.8),
        ],
      ),
    ),
    PromotionalBanner(
      title: '50% Off First Order',
      subtitle: 'Use code: SWEET50',
      badge: 'OFFER',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accent.withOpacity(0.9),
          AppColors.primary.withOpacity(0.8),
        ],
      ),
    ),
    PromotionalBanner(
      title: 'Free Delivery',
      subtitle: 'On orders over \$25',
      badge: 'FREE',
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.green.withOpacity(0.9), Colors.green.withOpacity(0.7)],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user?.displayName ?? 'Sweet Friend';
    final productState = ref.watch(productProvider);
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Enhanced App Bar
            SliverToBoxAdapter(
              child: EnhancedAppBar(
                userName: userName,
                location: 'Zimbabwe',
                cartItemCount: cartState.itemCount,
                onCartTap: _onCartTap,
                onLocationTap: _onLocationTap,
                onProfileTap: _onProfileTap,
              ),
            ),

            // Promotional Carousel
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: PromotionalCarousel(
                      banners: _promotionalBanners,
                      height: 220,
                      onBannerTap: () {
                        // TODO: Handle banner tap
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Loading indicator
            if (productState.isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/animations/loading.json',
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading delicious treats...',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Error message
            if (productState.error != null && !productState.isLoading)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            productState.error!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(productProvider.notifier)
                                .refreshProducts();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Featured Products Section
            if (productState.featuredProducts.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Featured Treats',
                  onViewAllPressed: _onViewAllFeatured,
                ),
              ),
              SliverToBoxAdapter(child: _buildFeaturedProductsSection()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '💡 Tap on any product for detailed information',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 12,
                      color: AppColors.secondary.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],

            // Categories Section
            if (productState.products.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Categories',
                  onViewAllPressed: _onViewAllCategories,
                ),
              ),
              SliverToBoxAdapter(child: _buildCategoriesSection()),
            ],

            // Products by Category Section
            if (productState.products.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'All ${productState.selectedCategory}',
                  onViewAllPressed: _onViewAllCategory,
                ),
              ),
              SliverToBoxAdapter(child: _buildProductsSection()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '💡 Tap on any product for detailed information',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 12,
                      color: AppColors.secondary.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],

            // Enhanced Delivery Highlight
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.accent.withOpacity(0.15),
                          AppColors.primary.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Lottie.asset(
                              'assets/animations/Delivery.json',
                              height: 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_shipping_rounded,
                                      color: AppColors.accent,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Fast & Fresh Delivery!',
                                      style: AppTheme.girlishHeadingStyle
                                          .copyWith(
                                            fontSize: 16,
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Track your order in real-time and enjoy every bite. We ensure your treats arrive fresh and delicious!',
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 14,
                                    color: AppColors.secondary.withOpacity(0.8),
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.track_changes_rounded,
                              color: AppColors.accent,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProductsSection() {
    final featuredProducts = ref.watch(featuredProductsProvider);

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredProducts.length,
        itemBuilder: (context, index) {
          final product = featuredProducts[index];
          return ProductCard(
            product: product,
            onTap: () => _showProductDetails(product),
            onAddToCart: () => _addToCart(product),
            showInfoIcon: true,
          );
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = ref.watch(categoriesProvider);

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected =
              ref.watch(productProvider).selectedCategory == category;

          return GestureDetector(
            onTap: () {
              ref
                  .read(productProvider.notifier)
                  .loadProductsByCategory(category);
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(left: 16, right: 8),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.2)
                          : AppColors.cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.cardColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.secondary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 12,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.secondary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsSection() {
    final products = ref.watch(productProvider).productsByCategory;

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () => _showProductDetails(product),
            onAddToCart: () => _addToCart(product),
            showInfoIcon: true,
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cupcakes':
        return Icons.cake;
      case 'cakes':
        return Icons.cake_outlined;
      case 'cookies':
        return Icons.cookie;
      case 'donuts':
        return Icons.circle;
      case 'muffins':
        return Icons.cake_outlined;
      case 'brownies':
        return Icons.square;
      case 'cake pops':
        return Icons.cake_outlined;
      default:
        return Icons.cake;
    }
  }
}
