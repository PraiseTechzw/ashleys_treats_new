import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_toast.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  TimeOfDay? _deliveryTime;
  bool _isPlacingOrder = false;

  // Mock cart data for checkout
  final List<Map<String, dynamic>> _cartItems = [
    {'name': 'Rainbow Cupcake', 'price': 4.50, 'quantity': 2},
    {'name': 'Chocolate Brownie', 'price': 4.00, 'quantity': 1},
    {'name': 'Chocolate Chip Cookie', 'price': 2.50, 'quantity': 3},
  ];

  double get _subtotal => _cartItems.fold(
    0.0,
    (sum, item) => sum + item['price'] * item['quantity'],
  );
  double get _deliveryFee => 2.50;
  double get _total => _subtotal + _deliveryFee;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _deliveryTime = picked);
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate() || _deliveryTime == null) {
      if (_deliveryTime == null) {
        ToastManager.showWarning(context, 'Please select a delivery time');
      }
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ToastManager.showSuccess(context, 'Order placed successfully! 🎉');

        // Show success animation
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.of(context).pop(); // Return to cart
          Navigator.of(context).pop(); // Return to previous screen
        }
      }
    } catch (e) {
      if (mounted) {
        ToastManager.showError(
          context,
          'Failed to place order. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Checkout',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.secondary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                    Text(
                      'Order Summary',
                      style: AppTheme.girlishHeadingStyle.copyWith(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._cartItems.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item['name']} x${item['quantity']}',
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            Text(
                              '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    _buildSummaryRow('Subtotal', _subtotal),
                    _buildSummaryRow('Delivery Fee', _deliveryFee),
                    const Divider(height: 16),
                    _buildSummaryRow('Total', _total, isTotal: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Delivery Information
              Text(
                'Delivery Information',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 16),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  hintText: 'Enter your complete delivery address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Delivery Time
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _deliveryTime != null
                        ? AppColors.primary
                        : AppColors.secondary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: _deliveryTime != null
                          ? AppColors.primary
                          : AppColors.secondary.withOpacity(0.6),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _deliveryTime != null
                            ? 'Delivery Time: ${_deliveryTime!.format(context)}'
                            : 'Select Delivery Time',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          color: _deliveryTime != null
                              ? AppColors.primary
                              : AppColors.secondary.withOpacity(0.6),
                          fontWeight: _deliveryTime != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Pick Time',
                        style: AppTheme.buttonTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Place Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isPlacingOrder ? null : _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isPlacingOrder
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Placing Order...',
                              style: AppTheme.buttonTextStyle.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Place Order - \$${_total.toStringAsFixed(2)}',
                          style: AppTheme.buttonTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Delivery Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Lottie.asset(
                      'assets/animations/Delivery.json',
                      width: 40,
                      height: 40,
                      repeat: true,
                      animate: true,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Free delivery on orders over \$20. Estimated delivery time: 30-45 minutes.',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 12,
                          color: AppColors.secondary.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              fontSize: isTotal ? 16 : 14,
              color: isTotal
                  ? AppColors.primary
                  : AppColors.secondary.withOpacity(0.7),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppColors.primary : AppColors.secondary,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
