import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/logout_button.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
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
                    // Profile avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // User name
                    Text(
                      user?.displayName ?? 'Sweet Friend',
                      style: AppTheme.authTitleStyle.copyWith(
                        fontSize: 28,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // User email
                    Text(
                      user?.email ?? 'No email available',
                      style: AppTheme.elegantBodyStyle.copyWith(
                        fontSize: 16,
                        color: AppColors.secondary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Profile options
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Update your personal information',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.location_on_outlined,
                      title: 'Delivery Address',
                      subtitle: 'Manage your delivery locations',
                      onTap: () {
                        // TODO: Navigate to address management
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      subtitle: 'Manage your payment options',
                      onTap: () {
                        // TODO: Navigate to payment methods
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Customize your notification preferences',
                      onTap: () {
                        // TODO: Navigate to notification settings
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.security_outlined,
                      title: 'Privacy & Security',
                      subtitle: 'Manage your account security',
                      onTap: () {
                        // TODO: Navigate to privacy settings
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: () {
                        // TODO: Navigate to help section
                      },
                    ),
                    _buildProfileOption(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Learn more about Ashley\'s Treats',
                      onTap: () {
                        // TODO: Navigate to about section
                      },
                    ),
                  ],
                ),
              ),

              // Logout section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Divider(height: 32),
                    const LogoutButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        title: Text(
          title,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.elegantBodyStyle.copyWith(
            fontSize: 14,
            color: AppColors.secondary.withOpacity(0.7),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppColors.secondary.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }
}
