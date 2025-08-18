import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../services/notification_service.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();

  bool _pushNotificationsEnabled = true;
  bool _orderUpdatesEnabled = true;
  bool _deliveryUpdatesEnabled = true;
  bool _promotionalNotificationsEnabled = true;
  bool _lowStockAlertsEnabled = false;
  bool _emailNotificationsEnabled = true;
  bool _smsNotificationsEnabled = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _quietHoursEnabled = false;
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    // TODO: Load actual settings from SharedPreferences or backend
    // For now, using default values
  }

  Future<void> _saveNotificationSettings() async {
    // TODO: Save settings to SharedPreferences or backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _testNotification() async {
    await _notificationService.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: '🔔 Test Notification',
      body: 'This is a test notification to verify your settings!',
      payload: 'test_notification',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: AppTheme.girlishHeadingStyle.copyWith(
            fontSize: 24,
            color: AppColors.secondary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.secondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton(
            onPressed: _testNotification,
            child: Text(
              'Test',
              style: AppTheme.buttonTextStyle.copyWith(
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.accent.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
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
                    child: Icon(
                      Icons.notifications_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stay Updated',
                          style: AppTheme.girlishHeadingStyle.copyWith(
                            fontSize: 20,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Customize how you receive notifications',
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
            ),

            const SizedBox(height: 24),

            // General Notifications
            _buildSettingsSection(
              'General Notifications',
              Icons.notifications_rounded,
              [
                _buildSwitchSetting(
                  'Push Notifications',
                  'Enable all push notifications',
                  _pushNotificationsEnabled,
                  (value) => setState(() => _pushNotificationsEnabled = value),
                ),
                if (_pushNotificationsEnabled) ...[
                  _buildSwitchSetting(
                    'Sound',
                    'Play sound for notifications',
                    _soundEnabled,
                    (value) => setState(() => _soundEnabled = value),
                  ),
                  _buildSwitchSetting(
                    'Vibration',
                    'Vibrate for notifications',
                    _vibrationEnabled,
                    (value) => setState(() => _vibrationEnabled = value),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 24),

            // Order Notifications
            _buildSettingsSection(
              'Order Notifications',
              Icons.shopping_bag_rounded,
              [
                _buildSwitchSetting(
                  'Order Updates',
                  'Get notified about order status changes',
                  _orderUpdatesEnabled,
                  (value) => setState(() => _orderUpdatesEnabled = value),
                ),
                _buildSwitchSetting(
                  'Delivery Updates',
                  'Get notified about delivery progress',
                  _deliveryUpdatesEnabled,
                  (value) => setState(() => _deliveryUpdatesEnabled = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Promotional Notifications
            _buildSettingsSection(
              'Promotional Notifications',
              Icons.local_offer_rounded,
              [
                _buildSwitchSetting(
                  'Special Offers',
                  'Get notified about discounts and promotions',
                  _promotionalNotificationsEnabled,
                  (value) => setState(() => _promotionalNotificationsEnabled = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Admin Notifications
            _buildSettingsSection(
              'Admin Notifications',
              Icons.admin_panel_settings_rounded,
              [
                _buildSwitchSetting(
                  'Low Stock Alerts',
                  'Get notified when products are running low',
                  _lowStockAlertsEnabled,
                  (value) => setState(() => _lowStockAlertsEnabled = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Communication Channels
            _buildSettingsSection(
              'Communication Channels',
              Icons.message_rounded,
              [
                _buildSwitchSetting(
                  'Email Notifications',
                  'Receive notifications via email',
                  _emailNotificationsEnabled,
                  (value) => setState(() => _emailNotificationsEnabled = value),
                ),
                _buildSwitchSetting(
                  'SMS Notifications',
                  'Receive notifications via SMS',
                  _smsNotificationsEnabled,
                  (value) => setState(() => _smsNotificationsEnabled = value),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Quiet Hours
            _buildSettingsSection(
              'Quiet Hours',
              Icons.bedtime_rounded,
              [
                _buildSwitchSetting(
                  'Enable Quiet Hours',
                  'Mute notifications during specified hours',
                  _quietHoursEnabled,
                  (value) => setState(() => _quietHoursEnabled = value),
                ),
                if (_quietHoursEnabled) ...[
                  _buildTimeSetting(
                    'Start Time',
                    _quietHoursStart,
                    (time) => setState(() => _quietHoursStart = time),
                  ),
                  _buildTimeSetting(
                    'End Time',
                    _quietHoursEnd,
                    (time) => setState(() => _quietHoursEnd = time),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveNotificationSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Save Settings'),
              ),
            ),

            const SizedBox(height: 16),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _pushNotificationsEnabled = true;
                    _orderUpdatesEnabled = true;
                    _deliveryUpdatesEnabled = true;
                    _promotionalNotificationsEnabled = true;
                    _lowStockAlertsEnabled = false;
                    _emailNotificationsEnabled = true;
                    _smsNotificationsEnabled = false;
                    _soundEnabled = true;
                    _vibrationEnabled = true;
                    _quietHoursEnabled = false;
                    _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
                    _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                  side: BorderSide(color: AppColors.secondary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Reset to Defaults'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
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
                    color: AppColors.primary.withValues(alpha: 0.2),
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
            color: AppColors.primary.withValues(alpha: 0.1),
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
                    color: AppColors.secondary.withValues(alpha: 0.7),
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

  Widget _buildTimeSetting(
    String title,
    TimeOfDay time,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
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
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: AppTheme.elegantBodyStyle.copyWith(
                    fontSize: 14,
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: time,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.primary,
                        onPrimary: Colors.white,
                        surface: AppColors.surface,
                        onSurface: AppColors.secondary,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (selectedTime != null) {
                onChanged(selectedTime);
              }
            },
            icon: Icon(
              Icons.access_time_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
