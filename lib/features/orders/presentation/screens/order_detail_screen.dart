import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/order.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'in transit':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle;
      case 'in transit':
        return Icons.local_shipping;
      case 'cancelled':
        return Icons.cancel;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.receipt_long;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return 'Delivered';
      case 'in transit':
        return 'On the way';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Preparing';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Order #${order.orderNumber ?? order.id}',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.secondary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Status Card
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
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _statusIcon(order.status),
                      color: _statusColor(order.status),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getStatusText(order.status),
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 20,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Order placed on ${_formatDate(order.createdAt)}',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Items
            Text(
              'Order Items',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: item.imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.cake_rounded,
                                        color: AppColors.primary,
                                        size: 24,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.cake_rounded,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                        ),
                        const SizedBox(width: 16),
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
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Qty: ${item.quantity}',
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.secondary.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Order Summary
            Text(
              'Order Summary',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
                children: [
                  _buildSummaryRow(
                    'Subtotal',
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Delivery Fee',
                    '\$${order.deliveryFee.toStringAsFixed(2)}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total',
                    '\$${order.finalTotal.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Delivery Information
            if (order.deliveryAddress != null) ...[
              Text(
                'Delivery Information',
                style: AppTheme.girlishHeadingStyle.copyWith(
                  fontSize: 20,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Container(
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
                    if (order.customerName != null) ...[
                      _buildInfoRow('Name', order.customerName!),
                      const SizedBox(height: 12),
                    ],
                    if (order.customerPhone != null) ...[
                      _buildInfoRow('Phone', order.customerPhone!),
                      const SizedBox(height: 12),
                    ],
                    _buildInfoRow('Address', order.deliveryAddress!),
                    if (order.deliveryTime != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Delivery Time',
                        _formatDateTime(order.deliveryTime!),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Payment Information
            Text(
              'Payment Information',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
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
              child: _buildInfoRow('Payment Method', order.paymentMethod),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: AppColors.secondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.7),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
