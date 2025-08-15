import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    Icons.receipt_long,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Order History',
                    style: AppTheme.authTitleStyle.copyWith(
                      fontSize: 24,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _buildOrderHistory(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistory() {
    // For now, show a placeholder since we don't have order data yet
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
            'No orders yet',
            style: AppTheme.authTitleStyle.copyWith(
              fontSize: 24,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your order history will appear here once you place your first order',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Ready to order?',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Browse our delicious treats and place your first order!',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
