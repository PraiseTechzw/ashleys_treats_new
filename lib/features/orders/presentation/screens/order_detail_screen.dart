import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class OrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;
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
          'Order #${order['orderNo']}',
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
                      color: _statusColor(order['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      _statusIcon(order['status']),
                      color: _statusColor(order['status']),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Status',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getStatusText(order['status']),
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(order['status']),
                          ),
                        ),
                        if (order['status'].toLowerCase() == 'in transit')
                          Text(
                            'Estimated delivery: 15-20 minutes',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 12,
                              color: AppColors.secondary.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Order Details
            Text(
              'Order Details',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Order Number', '#${order['orderNo']}'),
                  _buildDetailRow(
                    'Date',
                    order['date'].toString().substring(0, 10),
                  ),
                  _buildDetailRow(
                    'Total',
                    '\$${order['total'].toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(
                    'Delivery Time',
                    order['deliveryTime'] ?? 'Not specified',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Items
            Text(
              'Items',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: order['items'].length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = order['items'][index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.cake,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      item,
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.secondary,
                      ),
                    ),
                    trailing: Text(
                      '\$${(order['total'] / order['items'].length).toStringAsFixed(2)}',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Address',
                    order['deliveryAddress'] ?? 'Not specified',
                  ),
                  _buildDetailRow('Phone', '+1 (555) 123-4567'),
                  _buildDetailRow(
                    'Delivery Time',
                    order['deliveryTime'] ?? 'Not specified',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            if (order['status'].toLowerCase() == 'pending')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement cancel order functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cancel order functionality coming soon!',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancel Order',
                    style: AppTheme.buttonTextStyle.copyWith(fontSize: 16),
                  ),
                ),
              ),

            if (order['status'].toLowerCase() == 'delivered')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement reorder functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reorder functionality coming soon!'),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Reorder',
                    style: AppTheme.buttonTextStyle.copyWith(fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Delivery Animation
            if (order['status'].toLowerCase() == 'in transit')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/Delivery.json',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your order is on the way!',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track your delivery in real-time',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
