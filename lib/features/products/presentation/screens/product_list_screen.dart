import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/product_repository.dart';
import '../../data/models/product_model.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen>
    with TickerProviderStateMixin {
  final ProductRepository _repo = ProductRepository();
  late Future<List<ProductModel>> _productsFuture;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock user data
  final String userName = 'Ashley';
  final String location = 'New York';

  // Categories
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Cupcakes', 'icon': Icons.cake, 'color': AppColors.primary},
    {
      'name': 'Cake Slices',
      'icon': Icons.cake_outlined,
      'color': AppColors.secondary,
    },
    {
      'name': 'Cake Tasters',
      'icon': Icons.cake_rounded,
      'color': AppColors.accent,
    },
    {
      'name': 'Cake Pops',
      'icon': Icons.cake_outlined,
      'color': AppColors.cardColor,
    },
    {'name': 'Cookies', 'icon': Icons.cookie, 'color': AppColors.primary},
    {'name': 'Donuts', 'icon': Icons.circle, 'color': AppColors.secondary},
    {'name': 'Muffins', 'icon': Icons.cake_outlined, 'color': AppColors.accent},
    {'name': 'Brownies', 'icon': Icons.square, 'color': AppColors.cardColor},
  ];

  // Today's Specials
  final List<Map<String, dynamic>> _specials = [
    {
      'name': 'Rainbow Cupcake',
      'price': 4.50,
      'type': 'cupcake',
      'isSpecial': true,
    },
    {
      'name': 'Chocolate Brownie',
      'price': 4.00,
      'type': 'brownie',
      'isSpecial': true,
    },
    {
      'name': 'Vanilla Cake Slice',
      'price': 5.00,
      'type': 'cake',
      'isSpecial': true,
    },
  ];

  final List<Map<String, dynamic>> _popularSweets = [
    {'name': 'Chocolate Cupcake', 'price': 4.50, 'type': 'sweet'},
    {'name': 'Vanilla Cake Slice', 'price': 5.00, 'type': 'cake'},
    {'name': 'Red Velvet Cake Pop', 'price': 3.50, 'type': 'cake'},
    {'name': 'Chocolate Chip Cookie', 'price': 2.80, 'type': 'cookie'},
    {'name': 'Glazed Donut', 'price': 3.20, 'type': 'donut'},
  ];

  final List<Map<String, dynamic>> _popularSavory = [
    {'name': 'Blueberry Muffin', 'price': 3.50, 'type': 'muffin'},
    {'name': 'Chocolate Brownie', 'price': 4.00, 'type': 'brownie'},
    {'name': 'Carrot Cake Slice', 'price': 5.50, 'type': 'cake'},
    {'name': 'Strawberry Cake Taster', 'price': 2.50, 'type': 'cake'},
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = _repo.getAllProducts();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header with greeting
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_getGreeting()}, $userName!',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 24,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              location,
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.secondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hero Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sweet & Savory Treats\nDelivered to Your Doorstep',
                                style: AppTheme.girlishHeadingStyle.copyWith(
                                  fontSize: 22,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Order cupcakes, cookies, pies, and more. Fast, fresh, and fabulous delivery!',
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.secondary.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Navigate to full menu
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Order Now',
                                  style: AppTheme.buttonTextStyle.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Lottie.asset(
                            'assets/animations/Delivery.json',
                            height: 120,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Today's Specials
            SliverToBoxAdapter(
              child: _buildSectionHeader('Today\'s Specials', () {}),
            ),
            SliverToBoxAdapter(child: _buildSpecialsSection()),

            // Categories
            SliverToBoxAdapter(child: _buildSectionHeader('Categories', () {})),
            SliverToBoxAdapter(child: _buildCategoriesSection()),

            // Popular Cupcakes & Cakes
            SliverToBoxAdapter(
              child: _buildSectionHeader('Popular Cupcakes & Cakes', () {}),
            ),
            SliverToBoxAdapter(child: _buildPopularSection(_popularSweets)),

            // Popular Cookies & More
            SliverToBoxAdapter(
              child: _buildSectionHeader('Popular Cookies & More', () {}),
            ),
            SliverToBoxAdapter(child: _buildPopularSection(_popularSavory)),

            // Delivery Highlight
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Lottie.asset(
                          'assets/animations/Delivery.json',
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Fast & Fresh Delivery!\nTrack your order in real-time and enjoy every bite.',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildSectionHeader(String title, VoidCallback onAllPressed) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: AppColors.secondary,
            ),
          ),
          TextButton(
            onPressed: onAllPressed,
            child: Text(
              'All',
              style: AppTheme.elegantBodyStyle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialsSection() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _specials.length,
        itemBuilder: (context, index) {
          final item = _specials[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Icon(
                      item['type'] == 'cupcake'
                          ? Icons.cake
                          : Icons.cake_outlined,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${item['price']}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (item['isSpecial'])
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Special',
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
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
          );
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Container(
            width: 80,
            margin: const EdgeInsets.only(left: 16, right: 8),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: category['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: category['color'].withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    category['icon'],
                    color: category['color'],
                    size: 30,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'],
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularSection(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 130,
            margin: const EdgeInsets.only(left: 16, right: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  items == _popularSweets ? Icons.cake : Icons.cake_outlined,
                  color: items == _popularSweets
                      ? AppColors.primary
                      : AppColors.cardColor,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  item['name'],
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 13,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item['price']}',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
