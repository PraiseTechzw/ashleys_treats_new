import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 22,
            color: AppColors.secondary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              // TODO: Implement edit profile functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit profile functionality coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Avatar
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child:
                        user?.displayName != null &&
                            user!.displayName.isNotEmpty
                        ? Center(
                            child: Text(
                              user.displayName[0].toUpperCase(),
                              style: AppTheme.girlishHeadingStyle.copyWith(
                                fontSize: 40,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    user?.displayName ?? 'User',
                    style: AppTheme.girlishHeadingStyle.copyWith(
                      fontSize: 24,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // User Email
                  Text(
                    user?.email ?? 'user@example.com',
                    style: AppTheme.elegantBodyStyle.copyWith(
                      fontSize: 16,
                      color: AppColors.secondary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // User Role
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      user?.role == 'admin' ? 'Admin' : 'Customer',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Orders',
                    '12',
                    Icons.receipt_long,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Favorites',
                    '8',
                    Icons.favorite,
                    AppColors.accent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Reviews',
                    '5',
                    Icons.star,
                    AppColors.secondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Menu Items
            _buildMenuSection('Account', [
              _buildMenuItem('Personal Information', Icons.person_outline, () {
                // TODO: Navigate to personal info
              }),
              _buildMenuItem('Addresses', Icons.location_on_outlined, () {
                // TODO: Navigate to addresses
              }),
              _buildMenuItem('Payment Methods', Icons.payment, () {
                // TODO: Navigate to payment methods
              }),
            ]),

            const SizedBox(height: 24),

            _buildMenuSection('Preferences', [
              _buildMenuItem('Notifications', Icons.notifications_outlined, () {
                // TODO: Navigate to notifications
              }),
              _buildMenuItem('Language', Icons.language, () {
                // TODO: Navigate to language settings
              }),
              _buildMenuItem('Theme', Icons.palette_outlined, () {
                // TODO: Navigate to theme settings
              }),
            ]),

            const SizedBox(height: 24),

            _buildMenuSection('Support', [
              _buildMenuItem('Help Center', Icons.help_outline, () {
                // TODO: Navigate to help center
              }),
              _buildMenuItem('Contact Us', Icons.contact_support_outlined, () {
                // TODO: Navigate to contact
              }),
              _buildMenuItem('About App', Icons.info_outline, () {
                // TODO: Navigate to about
              }),
            ]),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: AppTheme.buttonTextStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // App Version
            Center(
              child: Text(
                'Ashley\'s Treats v1.0.0',
                style: AppTheme.elegantBodyStyle.copyWith(
                  fontSize: 12,
                  color: AppColors.secondary.withOpacity(0.5),
                ),
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
          const SizedBox(height: 8),
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
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 18,
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
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTheme.elegantBodyStyle.copyWith(
          fontSize: 16,
          color: AppColors.secondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.secondary.withOpacity(0.5),
      ),
      onTap: onTap,
    );
  }
}
