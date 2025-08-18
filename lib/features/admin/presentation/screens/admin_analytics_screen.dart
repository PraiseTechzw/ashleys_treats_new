import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../orders/data/order_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';

class AdminAnalyticsScreen extends ConsumerWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(ordersProvider);
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                            Icons.analytics_rounded,
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
                                'Analytics Dashboard',
                                style: AppTheme.authTitleStyle.copyWith(
                                  fontSize: 28,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Track your bakery\'s performance',
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

              // Key Metrics
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Total Orders',
                            '${orderState.length}',
                            Icons.shopping_cart,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Total Revenue',
                            '\$${_calculateTotalRevenue(orderState).toStringAsFixed(2)}',
                            Icons.attach_money,
                            AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricCard(
                            'Total Products',
                            '${productState.products.length}',
                            Icons.inventory,
                            AppColors.secondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMetricCard(
                            'Avg Order Value',
                            '\$${_calculateAverageOrderValue(orderState).toStringAsFixed(2)}',
                            Icons.trending_up,
                            AppColors.cardColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Order Status Breakdown
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Status Breakdown',
                      style: AppTheme.authTitleStyle.copyWith(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderStatusBreakdown(orderState),
                  ],
                ),
              ),

              // Top Products
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Performing Products',
                      style: AppTheme.authTitleStyle.copyWith(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTopProducts(productState.products),
                  ],
                ),
              ),

              // Revenue Chart Placeholder
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Trends',
                      style: AppTheme.authTitleStyle.copyWith(
                        fontSize: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRevenueChartPlaceholder(),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTheme.authTitleStyle.copyWith(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatusBreakdown(List orders) {
    if (orders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.pie_chart_outline,
              color: AppColors.primary.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 16,
                color: AppColors.secondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // Mock status breakdown for now
    final statuses = [
      {'status': 'Pending', 'count': 5, 'color': Colors.orange},
      {'status': 'Processing', 'count': 3, 'color': Colors.blue},
      {'status': 'Delivered', 'count': 12, 'color': Colors.green},
      {'status': 'Cancelled', 'count': 1, 'color': Colors.red},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: statuses.map((status) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: status['color'] as Color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    status['status'] as String,
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                Text(
                  '${status['count']}',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: status['color'] as Color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopProducts(List products) {
    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary.withOpacity(0.5),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No products yet',
              style: AppTheme.elegantBodyStyle.copyWith(
                fontSize: 16,
                color: AppColors.secondary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    // Show top 5 products by price (mock data)
    final topProducts = products.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: topProducts.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        product.category,
                        style: AppTheme.elegantBodyStyle.copyWith(
                          fontSize: 14,
                          color: AppColors.secondary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRevenueChartPlaceholder() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Lottie.asset(
            'assets/animations/loading.json',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 16),
          Text(
            'Revenue Chart Coming Soon',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Interactive charts and detailed analytics will be available here',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateTotalRevenue(List orders) {
    if (orders.isEmpty) return 0.0;
    // Mock calculation - in real app, sum actual order totals
    return orders.length * 25.0; // Mock average order value
  }

  double _calculateAverageOrderValue(List orders) {
    if (orders.isEmpty) return 0.0;
    return _calculateTotalRevenue(orders) / orders.length;
  }
}
