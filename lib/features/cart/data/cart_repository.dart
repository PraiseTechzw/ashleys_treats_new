import 'models/cart_item.dart';

class CartRepository {
  final List<CartItem> _cartItems = [];

  Future<List<CartItem>> getAllCartItems() async {
    return _cartItems;
  }

  Future<void> addOrUpdateCartItem(CartItem item) async {
    final existingIndex = _cartItems.indexWhere((element) => element.id == item.id);
    if (existingIndex != -1) {
      _cartItems[existingIndex] = item;
    } else {
      _cartItems.add(item);
    }
  }

  Future<void> deleteCartItem(int id) async {
    _cartItems.removeWhere((item) => item.id == id);
  }

  Future<void> clearCart() async {
    _cartItems.clear();
  }
}
