import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../../products/data/models/product_model.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../products/presentation/screens/product_detail_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  List<ProductModel> _searchResults = [];
  bool _isSearching = false;
  String _selectedCategory = 'All';
  String _sortBy = 'relevance';
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
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay for better UX
    Future.delayed(const Duration(milliseconds: 300), () {
      final allProducts = ref.read(productProvider).products;
      final results = allProducts.where((product) {
        final searchQuery = query.toLowerCase();
        return product.name.toLowerCase().contains(searchQuery) ||
               product.description.toLowerCase().contains(searchQuery) ||
               product.category.toLowerCase().contains(searchQuery);
      }).toList();

      // Apply category filter
      if (_selectedCategory != 'All') {
        results.removeWhere((product) => product.category != _selectedCategory);
      }

      // Apply sorting
      _sortResults(results);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _sortResults(List<ProductModel> results) {
    switch (_sortBy) {
      case 'name':
        results.sort((a, b) => _sortAscending 
          ? a.name.compareTo(b.name) 
          : b.name.compareTo(a.name));
        break;
      case 'price':
        results.sort((a, b) => _sortAscending 
          ? a.price.compareTo(b.price) 
          : b.price.compareTo(a.price));
        break;
      case 'category':
        results.sort((a, b) => _sortAscending 
          ? a.category.compareTo(b.category) 
          : b.category.compareTo(a.category));
        break;
      case 'relevance':
      default:
        // Keep original order for relevance
        break;
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    if (_searchController.text.isNotEmpty) {
      _performSearch(_searchController.text);
    }
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
    if (_searchResults.isNotEmpty) {
      _sortResults(_searchResults);
      setState(() {});
    }
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

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Search Header
            _buildSearchHeader(),
            
            // Category Filter Chips
            if (_searchController.text.isNotEmpty) _buildCategoryFilter(categories),
            
            // Sort Options
            if (_searchResults.isNotEmpty) _buildSortOptions(),
            
            // Search Content
            Expanded(
              child: _buildSearchContent(productState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return SlideTransition(
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
              // Title and Search Icon
              Row(
                children: [
                  Container(
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
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search Treats',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 26,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Find your perfect sweet treat',
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

              // Enhanced Search Bar
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
                  controller: _searchController,
                  onChanged: _performSearch,
                  decoration: InputDecoration(
                    hintText: 'Search for cupcakes, cookies, cakes...',
                    hintStyle: AppTheme.elegantBodyStyle.copyWith(
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.clear_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(List<String> categories) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          
          return GestureDetector(
            onTap: () => _onCategoryChanged(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.8),
                          AppColors.accent.withOpacity(0.6),
                        ],
                      )
                    : null,
                color: isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                category,
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
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
                      value: 'relevance',
                      child: Text('Sort by Relevance'),
                    ),
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
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _onSortChanged(value);
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
              if (_searchResults.isNotEmpty) {
                _sortResults(_searchResults);
                setState(() {});
              }
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
    );
  }

  Widget _buildSearchContent(ProductState productState) {
    if (_searchController.text.isEmpty) {
      return _buildSearchSuggestions(productState);
    }

    if (_isSearching) {
      return _buildLoadingState();
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSearchResults();
  }

  Widget _buildSearchSuggestions(ProductState productState) {
    final categories = ref.watch(categoriesProvider);
    
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Popular Categories', Icons.category_rounded),
              const SizedBox(height: 16),
              _buildCategoryGrid(categories),
              
              const SizedBox(height: 32),
              
              _buildSectionHeader('Quick Searches', Icons.trending_up_rounded),
              const SizedBox(height: 16),
              _buildQuickSearchChips(),
              
              const SizedBox(height: 32),
              
              _buildSectionHeader('Recent Searches', Icons.history_rounded),
              const SizedBox(height: 16),
              _buildRecentSearches(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 20,
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(List<String> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        if (category == 'All') return const SizedBox.shrink();
        
        return GestureDetector(
          onTap: () {
            _searchController.text = category;
            _performSearch(category);
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.accent.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                category,
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickSearchChips() {
    final quickSearches = [
      'Chocolate',
      'Vanilla',
      'Strawberry',
      'Birthday',
      'Wedding',
      'Gluten Free',
      'Vegan',
      'Nut Free'
    ];
    
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: quickSearches.map((search) {
        return GestureDetector(
          onTap: () {
            _searchController.text = search;
            _performSearch(search);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              search,
              style: AppTheme.elegantBodyStyle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentSearches() {
    // Mock recent searches - in real app, this would come from storage
    final recentSearches = [
      'Chocolate Cupcake',
      'Birthday Cake',
      'Vanilla Cookie'
    ];
    
    if (recentSearches.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              color: AppColors.secondary.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No recent searches yet',
              style: AppTheme.elegantBodyStyle.copyWith(
                color: AppColors.secondary.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    
    return Column(
      children: recentSearches.map((search) {
        return GestureDetector(
          onTap: () {
            _searchController.text = search;
            _performSearch(search);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_rounded,
                  color: AppColors.secondary.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    search,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      color: AppColors.secondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.secondary.withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/loading.json',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Searching...',
            style: AppTheme.elegantBodyStyle.copyWith(
              color: AppColors.secondary.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
        ],
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
              'No results found',
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Clear Search',
                style: AppTheme.buttonTextStyle.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Results count
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                '${_searchResults.length} result${_searchResults.length == 1 ? '' : 's'} found',
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Results grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final product = _searchResults[index];
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
          ],
        ),
      ),
    );
  }
}
