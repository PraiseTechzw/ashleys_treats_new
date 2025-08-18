import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../orders/data/order_provider.dart';
import '../../../orders/data/models/order.dart';

class AdminOrderManagementScreen extends ConsumerStatefulWidget {
  const AdminOrderManagementScreen({super.key});

  @override
  ConsumerState<AdminOrderManagementScreen> createState() => _AdminOrderManagementScreenState();
}

class _AdminOrderManagementScreenState extends ConsumerState<AdminOrderManagementScreen> {
  String _selectedStatus = 'All';
  String _selectedSortBy = 'date';
  bool _sortAscending = false;

  final List<String> _statuses = ['All', 'pending', 'processing', 'ready', 'delivered', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.background,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order Management',
                              style: AppTheme.authTitleStyle.copyWith(
                                fontSize: 28,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Manage customer orders and deliveries',
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 16,
                                color: AppColors.secondary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Filters and Controls
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Status Filter
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                          style: AppTheme.elegantBodyStyle.copyWith(color: AppColors.secondary),
                          items: _statuses.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status == 'All' ? 'All Statuses' : status.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Sort Button
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _sortAscending = !_sortAscending;
                        });
                      },
                      child: Icon(
                        _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Orders List
            Expanded(
              child: _buildOrdersList(orders),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    // Filter orders by status
    List<Order> filteredOrders = orders;
    if (_selectedStatus != 'All') {
      filteredOrders = orders.where((order) => order.status == _selectedStatus).toList();
    }

    // Sort orders
    _sortOrders(filteredOrders);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
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
                        'Order #${order.orderNumber ?? 'N/A'}',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        '${order.items.length} items • \$${order.finalTotal.toStringAsFixed(2)}',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.secondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
          ),

          // Order Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Customer Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                                                     Text(
                             order.customerName ?? 'N/A',
                             style: AppTheme.elegantBodyStyle.copyWith(
                               fontSize: 16,
                               fontWeight: FontWeight.w600,
                               color: AppColors.secondary,
                             ),
                           ),
                           Text(
                             order.customerEmail ?? 'N/A',
                             style: AppTheme.elegantBodyStyle.copyWith(
                               fontSize: 14,
                               color: AppColors.secondary.withOpacity(0.7),
                             ),
                           ),
                           Text(
                             order.customerPhone ?? 'N/A',
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

                const SizedBox(height: 16),

                // Delivery Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.cardColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delivery Address',
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                                                     Text(
                             order.deliveryAddress ?? 'N/A',
                             style: AppTheme.elegantBodyStyle.copyWith(
                               fontSize: 14,
                               color: AppColors.secondary.withOpacity(0.7),
                             ),
                           ),
                          if (order.deliveryTime != null)
                            Text(
                              'Delivery Time: ${_formatDeliveryTime(order.deliveryTime!)}',
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

                const SizedBox(height: 16),

                // Order Items
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Items',
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.productName} x${item.quantity}',
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 14,
                                color: AppColors.secondary,
                              ),
                            ),
                            Text(
                              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: AppTheme.elegantBodyStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        'View Details',
                        Icons.visibility_rounded,
                        AppColors.primary,
                        () => _viewOrderDetails(order),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActionButton(
                        'Update Status',
                        Icons.edit_rounded,
                        AppColors.accent,
                        () => _updateOrderStatus(order),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        icon = Icons.schedule_rounded;
        break;
      case 'processing':
        color = Colors.blue;
        icon = Icons.pending_rounded;
        break;
      case 'ready':
        color = Colors.green;
        icon = Icons.check_circle_rounded;
        break;
      case 'delivered':
        color = Colors.green;
        icon = Icons.delivery_dining_rounded;
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel_rounded;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(
        text,
        style: AppTheme.buttonTextStyle.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'No Orders Yet',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 24,
              color: AppColors.secondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Orders will appear here once customers start placing them',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _sortOrders(List<Order> orders) {
    switch (_selectedSortBy) {
      case 'date':
        orders.sort((a, b) => _sortAscending
            ? a.createdAt.compareTo(b.createdAt)
            : b.createdAt.compareTo(a.createdAt));
        break;
      case 'amount':
        orders.sort((a, b) => _sortAscending
            ? a.finalTotal.compareTo(b.finalTotal)
            : b.finalTotal.compareTo(a.finalTotal));
        break;
      case 'status':
        orders.sort((a, b) => _sortAscending
            ? a.status.compareTo(b.status)
            : b.status.compareTo(a.status));
        break;
    }
  }

  String _formatDeliveryTime(DateTime deliveryTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deliveryDate = DateTime(deliveryTime.year, deliveryTime.month, deliveryTime.day);
    
    if (deliveryDate.isAtSameMomentAs(today)) {
      return 'Today at ${deliveryTime.hour.toString().padLeft(2, '0')}:${deliveryTime.minute.toString().padLeft(2, '0')}';
    } else if (deliveryDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Tomorrow at ${deliveryTime.hour.toString().padLeft(2, '0')}:${deliveryTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${deliveryDate.month}/${deliveryDate.day} at ${deliveryTime.hour.toString().padLeft(2, '0')}:${deliveryTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void _viewOrderDetails(Order order) {
    // TODO: Navigate to detailed order view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing details for order #${order.orderNumber}')),
    );
  }

  void _updateOrderStatus(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Status: ${order.status.toUpperCase()}'),
            const SizedBox(height: 16),
            Text('Select new status:'),
            const SizedBox(height: 16),
            ...['pending', 'processing', 'ready', 'delivered', 'cancelled'].map((status) {
              return ListTile(
                title: Text(status.toUpperCase()),
                leading: Radio<String>(
                  value: status,
                  groupValue: order.status,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    if (value != null) {
                      _confirmStatusUpdate(order, value);
                    }
                  },
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _confirmStatusUpdate(Order order, String newStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Status Update'),
        content: Text('Are you sure you want to change the status from ${order.status.toUpperCase()} to ${newStatus.toUpperCase()}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performStatusUpdate(order, newStatus);
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _performStatusUpdate(Order order, String newStatus) async {
    try {
      await ref.read(ordersProvider.notifier).updateOrderStatus(order.id, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to ${newStatus.toUpperCase()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order status: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
