import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _orders = [];

  // Mock order data
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'orderNo': '1001',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Delivered',
      'total': 18.50,
      'items': ['Rainbow Cupcake', 'Chocolate Brownie'],
      'deliveryAddress': '123 Sweet Street, New York',
      'deliveryTime': '2:30 PM',
    },
    {
      'orderNo': '1000',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'status': 'In Transit',
      'total': 9.00,
      'items': ['Chocolate Chip Cookie', 'Vanilla Cake Slice'],
      'deliveryAddress': '123 Sweet Street, New York',
      'deliveryTime': '1:15 PM',
    },
    {
      'orderNo': '0999',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'status': 'Cancelled',
      'total': 4.50,
      'items': ['Strawberry Cupcake'],
      'deliveryAddress': '123 Sweet Street, New York',
      'deliveryTime': '3:00 PM',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _orders = _mockOrders;
      _isLoading = false;
    });
  }

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'My Orders',
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
          : _orders.isEmpty
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
                    'No orders yet',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      color: AppColors.secondary.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
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
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = _orders[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailScreen(order: order),
                      ),
                    );
                  },
                  child: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with order number and status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${order['orderNo']}',
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(
                                    order['status'],
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _statusColor(
                                      order['status'],
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _statusIcon(order['status']),
                                      color: _statusColor(order['status']),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _getStatusText(order['status']),
                                      style: AppTheme.elegantBodyStyle.copyWith(
                                        fontSize: 12,
                                        color: _statusColor(order['status']),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Order details
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: AppColors.secondary.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order['date'].toString().substring(0, 10),
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.secondary.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: AppColors.secondary.withOpacity(0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order['deliveryTime'],
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 14,
                                  color: AppColors.secondary.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Items
                          Text(
                            'Items: ${order['items'].join(', ')}',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 14,
                              color: AppColors.secondary.withOpacity(0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 12),

                          // Footer with total and action
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total: \$${order['total'].toStringAsFixed(2)}',
                                style: AppTheme.elegantBodyStyle.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailScreen(order: order),
                                    ),
                                  );
                                },
                                child: Text(
                                  'View Details',
                                  style: AppTheme.linkTextStyle.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
