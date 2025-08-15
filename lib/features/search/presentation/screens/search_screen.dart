import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _results = [];
  String _query = '';

  // Mock product data
  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Rainbow Cupcake',
      'price': 4.50,
      'type': 'cupcake',
      'category': 'Cupcakes',
    },
    {
      'name': 'Chocolate Brownie',
      'price': 4.00,
      'type': 'brownie',
      'category': 'Brownies',
    },
    {
      'name': 'Chocolate Chip Cookie',
      'price': 2.50,
      'type': 'cookie',
      'category': 'Cookies',
    },
    {
      'name': 'Vanilla Cake Slice',
      'price': 5.00,
      'type': 'cake',
      'category': 'Cake Slices',
    },
    {
      'name': 'Strawberry Cupcake',
      'price': 4.00,
      'type': 'cupcake',
      'category': 'Cupcakes',
    },
    {
      'name': 'Red Velvet Cake Pop',
      'price': 3.50,
      'type': 'cake',
      'category': 'Cake Pops',
    },
    {
      'name': 'Glazed Donut',
      'price': 3.20,
      'type': 'donut',
      'category': 'Donuts',
    },
    {
      'name': 'Blueberry Muffin',
      'price': 3.50,
      'type': 'muffin',
      'category': 'Muffins',
    },
    {
      'name': 'Carrot Cake Slice',
      'price': 5.50,
      'type': 'cake',
      'category': 'Cake Slices',
    },
    {
      'name': 'Sausage Roll',
      'price': 3.20,
      'type': 'savory',
      'category': 'Savory',
    },
  ];

  void _onSearchChanged(String value) async {
    setState(() {
      _isLoading = true;
      _query = value;
    });

    await Future.delayed(const Duration(milliseconds: 400)); // Simulate loading

    if (value.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    final results = _products
        .where(
          (p) =>
              p['name'].toLowerCase().contains(value.toLowerCase()) ||
              p['category'].toLowerCase().contains(value.toLowerCase()),
        )
        .toList();

    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  void _onCategoryTap(String category) {
    setState(() {
      _query = category;
      _controller.text = category;
    });
    _onSearchChanged(category);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Search',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for treats, sweets, or categories...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.secondary.withOpacity(0.6),
                        ),
                        onPressed: () {
                          _controller.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Categories
            if (_query.isEmpty) ...[
              Text(
                'Popular Categories',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 18,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    [
                          'Cupcakes',
                          'Cake Slices',
                          'Cookies',
                          'Brownies',
                          'Donuts',
                          'Muffins',
                        ]
                        .map(
                          (category) => GestureDetector(
                            onTap: () => _onCategoryTap(category),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                category,
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Search Results
            if (_isLoading)
              Expanded(
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading.json',
                    width: 80,
                    height: 80,
                  ),
                ),
              )
            else if (_query.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/flavors.json',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start typing to search for your favorite treats!',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          color: AppColors.secondary.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else if (_results.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/empty.json',
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found for "$_query"',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          color: AppColors.secondary.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching for something else',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.secondary.withOpacity(0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_results.length} results found',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          return Container(
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Icon(
                                    _getIconForType(item['type']),
                                    color: AppColors.primary,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    item['name'],
                                    style: AppTheme.elegantBodyStyle.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['category'],
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 12,
                                    color: AppColors.secondary.withOpacity(0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item['price'].toStringAsFixed(2)}',
                                  style: AppTheme.elegantBodyStyle.copyWith(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // TODO: Implement add to cart functionality
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${item['name']} added to cart!',
                                          ),
                                          backgroundColor: AppColors.primary,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      minimumSize: const Size.fromHeight(36),
                                    ),
                                    child: Text(
                                      'Add to Cart',
                                      style: AppTheme.buttonTextStyle.copyWith(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'cupcake':
        return Icons.cake;
      case 'brownie':
        return Icons.square;
      case 'cookie':
        return Icons.cookie;
      case 'cake':
        return Icons.cake_outlined;
      case 'donut':
        return Icons.circle;
      case 'muffin':
        return Icons.cake_rounded;
      case 'savory':
        return Icons.lunch_dining;
      default:
        return Icons.cake;
    }
  }
}
