import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../orders/data/order_provider.dart';
import '../../../orders/data/models/order.dart';
import '../../../orders/data/firestore_order_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  TimeOfDay? _deliveryTime;
  String _selectedPaymentMethod = 'cash_on_delivery';
  bool _isPlacingOrder = false;
  bool _acceptTerms = false;
  bool _useSavedData = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();

    // Auto-populate user data after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateUserData();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _populateUserData() {
    final user = ref.read(authProvider).user;
    if (user != null && _useSavedData) {
      _nameController.text = user.displayName.isNotEmpty
          ? user.displayName
          : '';
      _emailController.text = user.email.isNotEmpty ? user.email : '';
      _phoneController.text = user.phoneNumber.isNotEmpty
          ? user.phoneNumber
          : '';

      // Use first saved address if available
      if (user.addresses.isNotEmpty) {
        _addressController.text = user.addresses.first.toString();
      }
    }
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

  void _toggleUseSavedData() {
    setState(() {
      _useSavedData = !_useSavedData;
    });

    if (_useSavedData) {
      _populateUserData();
    } else {
      // Clear fields when not using saved data
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
    }
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate() ||
        _deliveryTime == null ||
        !_acceptTerms) {
      if (_deliveryTime == null) {
        ToastManager.showWarning(context, 'Please select a delivery time');
      } else if (!_acceptTerms) {
        ToastManager.showWarning(
          context,
          'Please accept the terms and conditions',
        );
      }
      return;
    }

    setState(() => _isPlacingOrder = true);

    try {
      final cartState = ref.read(cartProvider);
      final user = ref.read(authProvider).user;

      if (user == null) {
        ToastManager.showError(context, 'Please log in to place an order');
        return;
      }

      // Convert cart items to order items
      final orderItems = cartState.items
          .map(
            (item) => OrderItem(
              productId: item.productId,
              productName: item.productName,
              price: item.price,
              quantity: item.quantity,
              imageUrl: null, // We can add image URL later if needed
            ),
          )
          .toList();

      // Calculate delivery fee
      final deliveryFee = _getDeliveryFee(cartState.totalAmount);
      final finalTotal = cartState.totalAmount + deliveryFee;

      // Create the order using Firestore service
      final orderService = FirestoreOrderService();
      final order = await orderService.createOrder(
        userId: user.userId,
        items: orderItems,
        totalAmount: cartState.totalAmount,
        deliveryFee: deliveryFee,
        paymentMethod: _selectedPaymentMethod,
        customerName: _nameController.text.trim(),
        customerEmail: _emailController.text.trim(),
        customerPhone: _phoneController.text.trim(),
        deliveryAddress: _addressController.text.trim(),
        deliveryTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _deliveryTime!.hour,
          _deliveryTime!.minute,
        ),
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      if (mounted) {
        ToastManager.showSuccess(context, 'Order placed successfully! 🎉');

        // Show order confirmation
        _showOrderConfirmation(order);

        // Clear cart after successful order
        ref.read(cartProvider.notifier).clearCart();
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

  void _showOrderConfirmation(Order order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            Text(
              'Order Confirmed!',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your order has been placed successfully!',
              style: AppTheme.elegantBodyStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildOrderInfoRow('Order Number:', order.orderNumber ?? 'N/A'),
            _buildOrderInfoRow(
              'Total Amount:',
              '\$${order.finalTotal.toStringAsFixed(2)}',
            ),
            _buildOrderInfoRow(
              'Payment Method:',
              _getPaymentMethodDisplay(order.paymentMethod),
            ),
            _buildOrderInfoRow(
              'Delivery Time:',
              _formatDeliveryTime(order.deliveryTime),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Payment will be collected when Ashley delivers your order.',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to cart
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: Text(
              'Continue Shopping',
              style: AppTheme.buttonTextStyle.copyWith(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 14,
                color: AppColors.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodDisplay(String method) {
    switch (method) {
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      case 'mobile_money':
        return 'Mobile Money';
      case 'bank_transfer':
        return 'Bank Transfer';
      default:
        return method;
    }
  }

  String _formatDeliveryTime(DateTime? deliveryTime) {
    if (deliveryTime == null) return 'Not specified';
    return TimeOfDay.fromDateTime(deliveryTime).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final user = ref.watch(authProvider).user;

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
              // Enhanced Order Summary
              _buildOrderSummary(cartState),

              const SizedBox(height: 24),

              // User Data Toggle
              if (user != null) _buildUserDataToggle(),

              const SizedBox(height: 24),

              // Delivery Information
              _buildSectionHeader(
                'Delivery Information',
                Icons.location_on_rounded,
              ),
              const SizedBox(height: 16),
              _buildDeliveryForm(),

              const SizedBox(height: 24),

              // Payment Method
              _buildSectionHeader('Payment Method', Icons.payment_rounded),
              const SizedBox(height: 16),
              _buildPaymentMethodSelection(),

              const SizedBox(height: 24),

              // Terms and Conditions
              _buildTermsAndConditions(),

              const SizedBox(height: 32),

              // Place Order Button
              _buildPlaceOrderButton(cartState),

              const SizedBox(height: 24),

              // Delivery Info
              _buildDeliveryInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDataToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_outline, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use Saved Information',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'Automatically fill in your details from your profile',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _useSavedData,
            onChanged: (value) => _toggleUseSavedData(),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(CartState cartState) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.cardColor.withValues(alpha: 0.25),
                AppColors.accent.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.2),
                          AppColors.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Order Summary',
                    style: AppTheme.girlishHeadingStyle.copyWith(
                      fontSize: 22,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Order items
              ...cartState.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.productName} x${item.quantity}',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
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
              _buildSummaryRow('Subtotal', cartState.totalAmount),
              _buildSummaryRow(
                'Delivery Fee',
                _getDeliveryFee(cartState.totalAmount),
              ),
              const Divider(height: 16),
              _buildSummaryRow(
                'Total',
                _getTotalAmount(cartState.totalAmount),
                isTotal: true,
              ),
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
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
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

  Widget _buildDeliveryForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFormField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            icon: Icons.person_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          _buildFormField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
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

          _buildFormField(
            controller: _phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          _buildFormField(
            controller: _addressController,
            label: 'Delivery Address',
            hint: 'Enter your complete delivery address',
            icon: Icons.location_on_outlined,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          _buildFormField(
            controller: _notesController,
            label: 'Special Instructions (Optional)',
            hint: 'Any special delivery instructions or notes',
            icon: Icons.note_outlined,
            maxLines: 2,
          ),

          const SizedBox(height: 20),

          // Delivery Time Selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.accent.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _deliveryTime != null
                    ? AppColors.primary
                    : AppColors.secondary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Time',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.secondary.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _deliveryTime != null
                            ? '${_deliveryTime!.format(context)}'
                            : 'Select preferred delivery time',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          color: _deliveryTime != null
                              ? AppColors.primary
                              : AppColors.secondary.withValues(alpha: 0.6),
                          fontWeight: _deliveryTime != null
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
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
        ],
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surface.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPaymentOption(
            value: 'cash_on_delivery',
            title: 'Cash on Delivery',
            subtitle: 'Pay when Ashley delivers your order',
            icon: Icons.money_rounded,
            color: Colors.green,
            isRecommended: true,
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            value: 'mobile_money',
            title: 'Mobile Money',
            subtitle: 'Pay via mobile money transfer',
            icon: Icons.phone_android_rounded,
            color: AppColors.accent,
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(
            value: 'bank_transfer',
            title: 'Bank Transfer',
            subtitle: 'Pay via bank transfer',
            icon: Icons.account_balance_rounded,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                  ],
                )
              : null,
          color: isSelected ? null : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : AppColors.primary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Recommended',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardColor.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _acceptTerms ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _acceptTerms
                      ? AppColors.primary
                      : AppColors.secondary.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: _acceptTerms
                  ? Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 14,
                  color: AppColors.secondary,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(CartState cartState) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isPlacingOrder ? null : _placeOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
        ),
        child: _isPlacingOrder
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Placing Order...',
                    style: AppTheme.buttonTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_checkout_rounded, size: 28),
                  const SizedBox(width: 16),
                  Text(
                    'Place Order - \$${_getTotalAmount(cartState.totalAmount).toStringAsFixed(2)}',
                    style: AppTheme.buttonTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Lottie.asset(
            'assets/animations/Delivery.json',
            width: 60,
            height: 60,
            repeat: true,
            animate: true,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fast & Fresh Delivery!',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Free delivery on orders over \$25. Estimated delivery time: 30-45 minutes. Payment collected when Ashley delivers.',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withValues(alpha: 0.7),
                    height: 1.4,
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
              fontSize: isTotal ? 16 : 14,
              color: isTotal
                  ? AppColors.primary
                  : AppColors.secondary.withValues(alpha: 0.7),
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

  double _getDeliveryFee(double subtotal) {
    return subtotal >= 25.0 ? 0.0 : 2.50;
  }

  double _getTotalAmount(double subtotal) {
    return subtotal + _getDeliveryFee(subtotal);
  }
}
