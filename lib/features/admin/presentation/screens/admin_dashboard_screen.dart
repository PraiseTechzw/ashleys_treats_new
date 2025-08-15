import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Mock data for dashboard
  final Map<String, dynamic> _stats = {
    'totalOrders': 156,
    'pendingOrders': 23,
    'totalRevenue': 2847.50,
    'activeProducts': 45,
  };

  final List<Map<String, dynamic>> _recentOrders = [
    {
      'orderNo': '1001',
      'customer': 'John Doe',
      'amount': 18.50,
      'status': 'Pending',
      'time': '2 min ago',
    },
    {
      'orderNo': '1000',
      'customer': 'Jane Smith',
      'amount': 24.00,
      'status': 'In Progress',
      'time': '15 min ago',
    },
    {
      'orderNo': '0999',
      'customer': 'Mike Johnson',
      'amount': 12.50,
      'status': 'Completed',
      'time': '1 hour ago',
    },
  ];

  final List<Map<String, dynamic>> _topProducts = [
    {'name': 'Rainbow Cupcake', 'sales': 89, 'revenue': 400.50},
    {'name': 'Chocolate Brownie', 'sales': 67, 'revenue': 268.00},
    {'name': 'Vanilla Cake Slice', 'sales': 54, 'revenue': 270.00},
    {'name': 'Chocolate Chip Cookie', 'sales': 123, 'revenue': 307.50},
  ];

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return AppColors.primary;
      case 'completed':
        return Colors.green;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.cardColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, Admin!',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 20,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Here\'s what\'s happening with your bakery today',
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

            const SizedBox(height: 24),

            // Stats Grid
            Text(
              'Overview',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  'Total Orders',
                  '${_stats['totalOrders']}',
                  Icons.receipt_long,
                  AppColors.primary,
                ),
                _buildStatCard(
                  'Pending Orders',
                  '${_stats['pendingOrders']}',
                  Icons.schedule,
                  Colors.orange,
                ),
                _buildStatCard(
                  'Total Revenue',
                  '\$${_stats['totalRevenue'].toStringAsFixed(0)}',
                  Icons.attach_money,
                  Colors.green,
                ),
                _buildStatCard(
                  'Active Products',
                  '${_stats['activeProducts']}',
                  Icons.inventory_2,
                  AppColors.accent,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Recent Orders
            Text(
              'Recent Orders',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentOrders.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final order = _recentOrders[index];
                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _statusColor(order['status']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color: _statusColor(order['status']),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Order #${order['orderNo']}',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    subtitle: Text(
                      '${order['customer']} • ${order['time']}',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${order['amount'].toStringAsFixed(2)}',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(
                              order['status'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order['status'],
                            style: AppTheme.elegantBodyStyle.copyWith(
                              fontSize: 12,
                              color: _statusColor(order['status']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navigate to order details
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Top Products
            Text(
              'Top Products',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _topProducts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final product = _topProducts[index];
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
                      product['name'],
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    subtitle: Text(
                      '${product['sales']} sales',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 14,
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                    ),
                    trailing: Text(
                      '\$${product['revenue'].toStringAsFixed(2)}',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      // TODO: Navigate to product details
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Quick Actions
            Text(
              'Quick Actions',
              style: AppTheme.girlishHeadingStyle.copyWith(
                fontSize: 20,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Add Product',
                    Icons.add_circle_outline,
                    AppColors.primary,
                    () {
                      // TODO: Navigate to add product
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    'View Orders',
                    Icons.list_alt,
                    AppColors.accent,
                    () {
                      // TODO: Navigate to orders
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Analytics',
                    Icons.analytics,
                    AppColors.secondary,
                    () {
                      // TODO: Navigate to analytics
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    'Settings',
                    Icons.settings,
                    AppColors.cardColor,
                    () {
                      // TODO: Navigate to settings
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Delivery Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
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
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Status',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_stats['pendingOrders']} orders ready for delivery',
                          style: AppTheme.elegantBodyStyle.copyWith(
                            fontSize: 14,
                            color: AppColors.secondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Navigate to delivery management
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                    ),
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 24,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 12,
              color: AppColors.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
