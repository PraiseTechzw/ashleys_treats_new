import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/cart_item.dart';
import '../../../products/data/models/product_model.dart';

// Cart State
class CartState {
  final List<CartItem> items;
  final bool isLoading;
  final String? error;

  const CartState({this.items = const [], this.isLoading = false, this.error});

  CartState copyWith({
    List<CartItem>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  // Computed properties
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  // Add item to cart
  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.productId == product.productId,
    );

    if (existingIndex >= 0) {
      // Update existing item
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + quantity,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      final newItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch,
        productId: product.productId,
        productName: product.name,
        price: product.price,
        quantity: quantity,
        imageUrl: product.images.isNotEmpty ? product.images.first : null,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  // Remove item from cart
  void removeItem(String productId) {
    state = state.copyWith(
      items: state.items.where((item) => item.productId != productId).toList(),
    );
  }

  // Update item quantity
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  // Clear cart
  void clearCart() {
    state = state.copyWith(items: []);
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return state.items.any((item) => item.productId == productId);
  }

  // Get quantity of specific product
  int getQuantity(String productId) {
    final item = state.items.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItem(
        id: 0,
        productId: '',
        productName: '',
        price: 0.0,
        quantity: 0,
        imageUrl: null,
      ),
    );
    return item.quantity;
  }
}

// Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Cart Item Count Provider
final cartItemCountProvider = Provider<int>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.itemCount;
});

// Cart Total Amount Provider
final cartTotalAmountProvider = Provider<double>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.totalAmount;
});

// Cart Items Provider
final cartItemsProvider = Provider<List<CartItem>>((ref) {
  final cartState = ref.watch(cartProvider);
  return cartState.items;
});
