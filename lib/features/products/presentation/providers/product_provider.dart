import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/product_repository.dart';
import '../../data/models/product_model.dart';

// Product Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// Product State
class ProductState {
  final List<ProductModel> products;
  final List<ProductModel> featuredProducts;
  final List<ProductModel> productsByCategory;
  final bool isLoading;
  final String? error;
  final String selectedCategory;

  const ProductState({
    this.products = const [],
    this.featuredProducts = const [],
    this.productsByCategory = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory = 'All',
  });

  ProductState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? featuredProducts,
    List<ProductModel>? productsByCategory,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? selectedCategory,
  }) {
    return ProductState(
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      productsByCategory: productsByCategory ?? this.productsByCategory,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Product Notifier
class ProductNotifier extends StateNotifier<ProductState> {
  final ProductRepository _productRepository;

  ProductNotifier(this._productRepository) : super(const ProductState()) {
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final products = await _productRepository.getAllProducts();
      
      // Filter featured products (you can customize this logic)
      final featuredProducts = products.where((product) => 
        product.category == 'Cupcakes' || 
        product.category == 'Cakes' ||
        product.price > 4.0
      ).take(6).toList();

      state = state.copyWith(
        products: products,
        featuredProducts: featuredProducts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load products: ${e.toString()}',
      );
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    try {
      state = state.copyWith(isLoading: true, error: null, selectedCategory: category);
      
      List<ProductModel> productsByCategory;
      if (category == 'All') {
        productsByCategory = state.products;
      } else {
        productsByCategory = await _productRepository.getProductsByCategory(category);
      }
      
      state = state.copyWith(
        productsByCategory: productsByCategory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load products by category: ${e.toString()}',
      );
    }
  }

  Future<void> refreshProducts() async {
    await _loadProducts();
  }

  List<String> get categories {
    final categories = state.products.map((product) => product.category).toSet().toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<ProductModel> get productsByCategory {
    if (state.selectedCategory == 'All') {
      return state.products;
    }
    return state.productsByCategory;
  }
}

// Product Provider
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return ProductNotifier(repository);
});

// Featured Products Provider
final featuredProductsProvider = Provider<List<ProductModel>>((ref) {
  final productState = ref.watch(productProvider);
  return productState.featuredProducts;
});

// Categories Provider
final categoriesProvider = Provider<List<String>>((ref) {
  final productNotifier = ref.watch(productProvider.notifier);
  return productNotifier.categories;
});
