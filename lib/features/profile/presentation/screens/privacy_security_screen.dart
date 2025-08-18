import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class PrivacySecurityScreen extends ConsumerStatefulWidget {
  const PrivacySecurityScreen({super.key});

  @override
  ConsumerState<PrivacySecurityScreen> createState() =>
      _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends ConsumerState<PrivacySecurityScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;
  bool _locationSharing = true;
  bool _analyticsEnabled = true;
  bool _marketingEmails = false;
  bool _orderNotifications = true;
  bool _promotionalNotifications = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Privacy & Security',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 20,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(
                'Account Security',
                Icons.security_rounded,
                'Protect your account with advanced security features',
              ),
              const SizedBox(height: 16),
              _buildSecurityCard(),
              const SizedBox(height: 24),

              _buildSectionHeader(
                'Data Privacy',
                Icons.privacy_tip_rounded,
                'Control how your data is collected and used',
              ),
              const SizedBox(height: 16),
              _buildPrivacyCard(),
              const SizedBox(height: 24),

              _buildSectionHeader(
                'App Permissions',
                Icons.settings_applications_rounded,
                'Manage what the app can access on your device',
              ),
              const SizedBox(height: 16),
              _buildPermissionsCard(),
              const SizedBox(height: 24),

              _buildSectionHeader(
                'Data Management',
                Icons.storage_rounded,
                'Control your personal data',
              ),
              const SizedBox(height: 16),
              _buildDataManagementCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
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
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.girlishHeadingStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
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
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchSetting(
            'Two-Factor Authentication',
            'Add an extra layer of security to your account',
            _twoFactorEnabled,
            (value) => setState(() => _twoFactorEnabled = value),
            Icons.verified_user_rounded,
          ),
          _buildDivider(),
          _buildSwitchSetting(
            'Biometric Login',
            'Use fingerprint or face ID to sign in',
            _biometricEnabled,
            (value) => setState(() => _biometricEnabled = value),
            Icons.fingerprint_rounded,
          ),
          _buildDivider(),
          _buildActionSetting(
            'Change Password',
            'Update your account password',
            Icons.lock_rounded,
            () {
              // TODO: Navigate to change password screen
            },
          ),
          _buildDivider(),
          _buildActionSetting(
            'Active Sessions',
            'View and manage your active logins',
            Icons.devices_rounded,
            () {
              // TODO: Navigate to active sessions screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSwitchSetting(
            'Location Sharing',
            'Allow us to use your location for delivery',
            _locationSharing,
            (value) => setState(() => _locationSharing = value),
            Icons.location_on_rounded,
          ),
          _buildDivider(),
          _buildSwitchSetting(
            'Analytics & Performance',
            'Help us improve the app with anonymous usage data',
            _analyticsEnabled,
            (value) => setState(() => _analyticsEnabled = value),
            Icons.analytics_rounded,
          ),
          _buildDivider(),
          _buildSwitchSetting(
            'Marketing Communications',
            'Receive promotional emails and offers',
            _marketingEmails,
            (value) => setState(() => _marketingEmails = value),
            Icons.email_rounded,
          ),
          _buildDivider(),
          _buildSwitchSetting(
            'Order Notifications',
            'Get updates about your orders and delivery',
            _orderNotifications,
            (value) => setState(() => _orderNotifications = value),
            Icons.shopping_bag_rounded,
          ),
          _buildDivider(),
          _buildSwitchSetting(
            'Promotional Notifications',
            'Receive special offers and discounts',
            _promotionalNotifications,
            (value) => setState(() => _promotionalNotifications = value),
            Icons.local_offer_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionSetting(
            'Camera Access',
            'Take photos for profile and reviews',
            Icons.camera_alt_rounded,
            () {
              // TODO: Request camera permission
            },
          ),
          _buildDivider(),
          _buildActionSetting(
            'Location Access',
            'Find nearby stores and delivery options',
            Icons.my_location_rounded,
            () {
              // TODO: Request location permission
            },
          ),
          _buildDivider(),
          _buildActionSetting(
            'Notifications',
            'Receive important updates and offers',
            Icons.notifications_rounded,
            () {
              // TODO: Request notification permission
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActionSetting(
            'Download My Data',
            'Get a copy of all your personal data',
            Icons.download_rounded,
            () {
              // TODO: Implement data export
            },
          ),
          _buildDivider(),
          _buildActionSetting(
            'Delete Account',
            'Permanently remove your account and data',
            Icons.delete_forever_rounded,
            () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
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
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
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
          color: AppColors.secondary.withValues(alpha: 0.7),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.secondary.withValues(alpha: 0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: AppColors.secondary.withValues(alpha: 0.1),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: AppTheme.girlishHeadingStyle.copyWith(
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              color: AppColors.secondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.secondary.withValues(alpha: 0.7),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement account deletion
              },
              child: Text(
                'Delete',
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
