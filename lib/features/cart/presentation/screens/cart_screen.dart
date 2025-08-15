import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../screens/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _cart = [];

  // Mock cart data
  final List<Map<String, dynamic>> _mockCart = [
    {
      'name': 'Rainbow Cupcake',
      'price': 4.50,
      'quantity': 2,
      'type': 'cupcake',
    },
    {
      'name': 'Chocolate Brownie',
      'price': 4.00,
      'quantity': 1,
      'type': 'brownie',
    },
    {
      'name': 'Chocolate Chip Cookie',
      'price': 2.50,
      'quantity': 3,
      'type': 'cookie',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _cart = List<Map<String, dynamic>>.from(_mockCart);
      _isLoading = false;
    });
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      _cart[index]['quantity'] += delta;
      if (_cart[index]['quantity'] < 1) _cart[index]['quantity'] = 1;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  double get _subtotal =>
      _cart.fold(0.0, (sum, item) => sum + item['price'] * item['quantity']);
  double get _deliveryFee => _cart.isEmpty ? 0.0 : 2.50;
  double get _total => _subtotal + _deliveryFee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Cart',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animations/loading.json',
                width: 80,
                height: 80,
              ),
            )
          : _cart.isEmpty
          ? Center(
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
                    'Your cart is empty',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      color: AppColors.secondary.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to products
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Start Shopping',
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _cart[index];
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
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              _getIconForType(item['type']),
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            item['name'],
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                          subtitle: Text(
                            '\$${item['price'].toStringAsFixed(2)} x ${item['quantity']}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 13,
                              color: AppColors.secondary.withOpacity(0.7),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
                                    color: AppColors.primary,
                                    onPressed: () => _updateQuantity(index, -1),
                                  ),
                                  Text(
                                    '${item['quantity']}',
                                    style: AppTheme.elegantBodyStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: AppColors.primary,
                                    onPressed: () => _updateQuantity(index, 1),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: AppColors.accent,
                                onPressed: () => _removeItem(index),
                                tooltip: 'Remove',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSummaryRow('Subtotal', _subtotal),
                      _buildSummaryRow('Delivery Fee', _deliveryFee),
                      const Divider(height: 32),
                      _buildSummaryRow('Total', _total, isTotal: true),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _cart.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CheckoutScreen(),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Checkout',
                            style: AppTheme.buttonTextStyle.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: isTotal ? 18 : 14,
              color: isTotal
                  ? AppColors.primary
                  : AppColors.secondary.withOpacity(0.7),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: isTotal ? 18 : 14,
              color: isTotal ? AppColors.primary : AppColors.secondary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
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
      default:
        return Icons.cake;
    }
  }
}
