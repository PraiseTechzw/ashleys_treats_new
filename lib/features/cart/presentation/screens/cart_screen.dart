import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../providers/cart_provider.dart';
import '../../data/models/cart_item.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Shopping Cart',
                    style: AppTheme.authTitleStyle.copyWith(
                      fontSize: 24,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Cart content
            Expanded(
              child: cartState.isEmpty
                  ? _buildEmptyCart()
                  : _buildCartItems(cartState.items, ref),
            ),

            // Checkout section
            if (cartState.isNotEmpty)
              _buildCheckoutSection(cartState, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: AppTheme.authTitleStyle.copyWith(
              fontSize: 24,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add some delicious treats to get started!',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<CartItem> items, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildCartItemCard(item, ref);
      },
    );
  }

  Widget _buildCartItemCard(CartItem item, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Product image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.cake,
                      color: AppColors.primary,
                      size: 40,
                    ),
            ),
            const SizedBox(width: 16),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity controls
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (item.quantity > 1) {
                          ref.read(cartProvider.notifier).updateQuantity(
                                item.productId,
                                item.quantity - 1,
                              );
                        } else {
                          ref.read(cartProvider.notifier).removeItem(item.productId);
                        }
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '${item.quantity}',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).updateQuantity(
                              item.productId,
                              item.quantity + 1,
                            );
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(CartState cartState, WidgetRef ref) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Order summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total (${cartState.itemCount} items):',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                  Text(
                    '\$${cartState.totalAmount.toStringAsFixed(2)}',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Checkout button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to checkout
                    ToastManager.showInfo(
                      context,
                      'Checkout functionality coming soon!',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    'Proceed to Checkout',
                    style: AppTheme.buttonTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Clear cart button
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text('Clear Cart'),
                      content: Text('Are you sure you want to clear your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(cartProvider.notifier).clearCart();
                            Navigator.pop(dialogContext);
                            ToastManager.showSuccess(
                              context,
                              'Cart cleared successfully!',
                            );
                          },
                          child: Text('Clear'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Clear Cart',
                  style: AppTheme.linkTextStyle.copyWith(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
