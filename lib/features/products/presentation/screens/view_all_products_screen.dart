import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ashleys_treats/core/theme/app_colors.dart';
import 'package:ashleys_treats/core/theme/app_theme.dart';
import 'package:ashleys_treats/core/widgets/product_card.dart';
import 'package:ashleys_treats/core/widgets/custom_toast.dart';
import '../providers/product_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class ViewAllProductsScreen extends ConsumerStatefulWidget {
  final String title;
  final String? category;
  final List<ProductModel> products;
  final bool isFeatured;

  const ViewAllProductsScreen({
    super.key,
    required this.title,
    this.category,
    required this.products,
    this.isFeatured = false,
  });

  @override
  ConsumerState<ViewAllProductsScreen> createState() => _ViewAllProductsScreenState();
}

class _ViewAllProductsScreenState extends ConsumerState<ViewAllProductsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _searchQuery = '';
  String _sortBy = 'name';
  bool _sortAscending = true;

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

  List<ProductModel> get _filteredAndSortedProducts {
    List<ProductModel> filtered = widget.products.where((product) {
      if (_searchQuery.isEmpty) return true;
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             product.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             product.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Sort products
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'category':
          comparison = a.category.compareTo(b.category);
          break;
        case 'popularity':
          // You can add popularity logic here
          comparison = 0;
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredAndSortedProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header
            Container(
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
                              widget.title,
                              style: AppTheme.girlishHeadingStyle.copyWith(
                                fontSize: 26,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (widget.category != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${filteredProducts.length} products available',
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.secondary.withOpacity(0.7),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
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
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search ${widget.title.toLowerCase()}...',
                        hintStyle: AppTheme.elegantBodyStyle.copyWith(
                          color: AppColors.secondary.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                child: Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.secondary.withOpacity(0.5),
                                  size: 20,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sort options
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _sortBy,
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.primary,
                              ),
                              style: AppTheme.elegantBodyStyle.copyWith(
                                color: AppColors.secondary,
                                fontSize: 14,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'name',
                                  child: Text('Sort by Name'),
                                ),
                                DropdownMenuItem(
                                  value: 'price',
                                  child: Text('Sort by Price'),
                                ),
                                DropdownMenuItem(
                                  value: 'category',
                                  child: Text('Sort by Category'),
                                ),
                                DropdownMenuItem(
                                  value: 'popularity',
                                  child: Text('Sort by Popularity'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _sortBy = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _sortAscending = !_sortAscending;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.2),
                                AppColors.accent.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _sortAscending
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Products Grid
            Expanded(
              child: filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : _buildProductsGrid(filteredProducts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: AppColors.secondary.withOpacity(0.5),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No products found',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 24,
                color: AppColors.secondary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filter criteria',
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 16,
                color: AppColors.secondary.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(List<ProductModel> products) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => _showProductDetails(product),
              onAddToCart: () => _addToCart(product),
              showInfoIcon: true,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
      ),
    );
  }
}
