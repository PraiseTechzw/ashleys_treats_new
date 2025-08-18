import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/screens/change_password_screen.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _autoOrderConfirmation = true;
  bool _lowStockAlerts = true;
  String _selectedCurrency = 'USD';
  String _selectedLanguage = 'English';
  double _deliveryRadius = 10.0;
  int _maxDeliveryTime = 45;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

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
                            Icons.settings_rounded,
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
                                'Admin Settings',
                                style: AppTheme.authTitleStyle.copyWith(
                                  fontSize: 28,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Configure your bakery app settings',
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

              // Settings Sections
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSettingsSection(
                      'Notifications',
                      Icons.notifications_rounded,
                      [
                        _buildSwitchSetting(
                          'Enable Notifications',
                          'Receive push notifications for orders and updates',
                          _notificationsEnabled,
                          (value) =>
                              setState(() => _notificationsEnabled = value),
                        ),
                        if (_notificationsEnabled) ...[
                          _buildSwitchSetting(
                            'Email Notifications',
                            'Send order confirmations and updates via email',
                            _emailNotifications,
                            (value) =>
                                setState(() => _emailNotifications = value),
                          ),
                          _buildSwitchSetting(
                            'SMS Notifications',
                            'Send order updates via SMS',
                            _smsNotifications,
                            (value) =>
                                setState(() => _smsNotifications = value),
                          ),
                          _buildSwitchSetting(
                            'Auto Order Confirmation',
                            'Automatically confirm orders when received',
                            _autoOrderConfirmation,
                            (value) =>
                                setState(() => _autoOrderConfirmation = value),
                          ),
                          _buildSwitchSetting(
                            'Low Stock Alerts',
                            'Get notified when products are running low',
                            _lowStockAlerts,
                            (value) => setState(() => _lowStockAlerts = value),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildSettingsSection(
                      'Business Settings',
                      Icons.business_rounded,
                      [
                        _buildDropdownSetting(
                          'Currency',
                          'Select your preferred currency',
                          _selectedCurrency,
                          ['USD', 'EUR', 'GBP', 'CAD', 'AUD'],
                          (value) => setState(() => _selectedCurrency = value!),
                        ),
                        _buildDropdownSetting(
                          'Language',
                          'Select your preferred language',
                          _selectedLanguage,
                          ['English', 'Spanish', 'French', 'German'],
                          (value) => setState(() => _selectedLanguage = value!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildSettingsSection(
                      'Delivery Settings',
                      Icons.delivery_dining_rounded,
                      [
                        _buildSliderSetting(
                          'Delivery Radius (miles)',
                          'Maximum delivery distance from your bakery',
                          _deliveryRadius,
                          5.0,
                          25.0,
                          (value) => setState(() => _deliveryRadius = value),
                        ),
                        _buildSliderSetting(
                          'Max Delivery Time (minutes)',
                          'Maximum time customers can wait for delivery',
                          _maxDeliveryTime.toDouble(),
                          30.0,
                          120.0,
                          (value) =>
                              setState(() => _maxDeliveryTime = value.toInt()),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildSettingsSection(
                      'App Settings',
                      Icons.app_settings_alt_rounded,
                      [
                        _buildActionSetting(
                          'Clear Cache',
                          'Clear app cache and temporary files',
                          Icons.cleaning_services_rounded,
                          () => _clearCache(),
                        ),
                        _buildActionSetting(
                          'Export Data',
                          'Export orders and product data',
                          Icons.download_rounded,
                          () => _exportData(),
                        ),
                        _buildActionSetting(
                          'Backup Settings',
                          'Create a backup of your current settings',
                          Icons.backup_rounded,
                          () => _backupSettings(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _buildSettingsSection(
                      'Account Settings',
                      Icons.account_circle_rounded,
                      [
                        _buildActionSetting(
                          'Change Password',
                          'Update your admin account password',
                          Icons.lock_rounded,
                          () => _changePassword(),
                        ),
                        _buildActionSetting(
                          'Two-Factor Authentication',
                          'Enable 2FA for enhanced security',
                          Icons.security_rounded,
                          () => _enableTwoFactorAuth(),
                        ),
                        _buildActionSetting(
                          'Logout',
                          'Sign out of your admin account',
                          Icons.logout_rounded,
                          () => _logout(),
                        ),
                      ],
                    ),

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

  Widget _buildSettingsSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTheme.authTitleStyle.copyWith(
                    fontSize: 18,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String subtitle,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                style: AppTheme.elegantBodyStyle.copyWith(
                  color: AppColors.secondary,
                ),
                items: options.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    String subtitle,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTheme.elegantBodyStyle.copyWith(
              fontSize: 14,
              color: AppColors.secondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: ((max - min) / 5).round(),
                  activeColor: AppColors.primary,
                  inactiveColor: AppColors.primary.withOpacity(0.3),
                  onChanged: onChanged,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionSetting(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
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

  void _clearCache() {
    // TODO: Implement cache clearing
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cache cleared successfully')));
  }

  void _exportData() {
    // TODO: Implement data export
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data export started')));
  }

  void _backupSettings() {
    // TODO: Implement settings backup
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings backed up successfully')),
    );
  }

  void _changePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );
  }

  void _enableTwoFactorAuth() {
    // TODO: Implement 2FA
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Two-factor authentication coming soon')),
    );
  }

  void _logout() {
    ref.read(authProvider.notifier).logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
