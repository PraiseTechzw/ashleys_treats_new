import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Initialize timezone (for scheduled notifications)
    try {
      initializeTimeZones();
    } catch (_) {
      // ignore if already initialized
    }

    // Request permissions
    await _requestPermissions();

    // Configure Firebase messaging
    await _configureFirebaseMessaging();

    _isInitialized = true;
  }

  Future<void> _initializeLocalNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
    // TODO: Navigate to specific screen based on payload
  }

  Future<void> _requestPermissions() async {
    // Request Firebase messaging permissions
    final messagingSettings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print(
      'Firebase messaging permissions: ${messagingSettings.authorizationStatus}',
    );
  }

  Future<void> _configureFirebaseMessaging() async {
    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      // TODO: Send token to your backend
      await _saveFCMToken(token);
    }

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
      _saveFCMToken(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification taps when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);
  }

  Future<void> _saveFCMToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  Future<String?> getFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');

    // Show local notification
    await showLocalNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? 'You have a new message',
      payload: message.data.toString(),
    );
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.messageId}');
    // Handle background message if needed
  }

  void _handleNotificationOpenedApp(RemoteMessage message) {
    print('Notification opened app: ${message.messageId}');
    // TODO: Navigate to specific screen based on message data
  }

  // Show local notification
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    try {
      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails ?? _getDefaultNotificationDetails(),
        payload: payload,
      );
    } catch (e) {
      print('Error showing local notification: $e');
    }
  }

  // Get default notification details
  NotificationDetails _getDefaultNotificationDetails() {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'ashleys_treats_channel',
          'Ashley\'s Treats Notifications',
          channelDescription:
              'Notifications for orders, promotions, and updates',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          enableLights: true,
          color: Color(0xFFE91E63), // Pink color matching app theme
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(android: androidDetails, iOS: iOSDetails);
  }

  // Show order status notification
  Future<void> showOrderStatusNotification({
    required String orderNumber,
    required String status,
    required String message,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'order_status_channel',
        'Order Status Updates',
        channelDescription: 'Notifications for order status changes',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Color(0xFF4CAF50), // Green for success
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await showLocalNotification(
      id: orderNumber.hashCode,
      title: 'Order #$orderNumber - $status',
      body: message,
      payload: 'order_status:$orderNumber',
      notificationDetails: notificationDetails,
    );
  }

  // Show order confirmation notification
  Future<void> showOrderConfirmationNotification({
    required String orderNumber,
    required double total,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'order_confirmation_channel',
        'Order Confirmations',
        channelDescription: 'Notifications for order confirmations',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Color(0xFF2196F3), // Blue for info
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await showLocalNotification(
      id: orderNumber.hashCode,
      title: 'Order Confirmed! 🎉',
      body:
          'Order #$orderNumber has been confirmed for \$${total.toStringAsFixed(2)}',
      payload: 'order_confirmation:$orderNumber',
      notificationDetails: notificationDetails,
    );
  }

  // Show delivery notification
  Future<void> showDeliveryNotification({
    required String orderNumber,
    required String estimatedTime,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'delivery_channel',
        'Delivery Updates',
        channelDescription: 'Notifications for delivery status',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Color(0xFFFF9800), // Orange for delivery
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await showLocalNotification(
      id: orderNumber.hashCode,
      title: '🚚 Out for Delivery!',
      body: 'Order #$orderNumber is on its way! ETA: $estimatedTime',
      payload: 'delivery:$orderNumber',
      notificationDetails: notificationDetails,
    );
  }

  // Show promotional notification
  Future<void> showPromotionalNotification({
    required String title,
    required String message,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'promotional_channel',
        'Promotions & Offers',
        channelDescription: 'Notifications for special offers and promotions',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Color(0xFFE91E63), // Pink for promotions
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await showLocalNotification(
      id: title.hashCode,
      title: '🎂 $title',
      body: message,
      payload: 'promotional:$title',
      notificationDetails: notificationDetails,
    );
  }

  // Show low stock notification (for admin)
  Future<void> showLowStockNotification({
    required String productName,
    required int currentStock,
  }) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'admin_channel',
        'Admin Notifications',
        channelDescription: 'Notifications for administrators',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Color(0xFFF44336), // Red for alerts
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await showLocalNotification(
      id: productName.hashCode,
      title: '⚠️ Low Stock Alert',
      body: '$productName is running low. Current stock: $currentStock',
      payload: 'low_stock:$productName',
      notificationDetails: notificationDetails,
    );
  }

  // Show scheduled notification
  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationDetails? notificationDetails,
  }) async {
    try {
      final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );
      await _localNotifications.zonedSchedule(
        id,
        title,
        body,
        tzScheduledDate,
        notificationDetails ?? _getDefaultNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  // Cancel notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _localNotifications.pendingNotificationRequests();
  }

  // Get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  // Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Subscribe to order updates
  Future<void> subscribeToOrderUpdates(String userId) async {
    await _firebaseMessaging.subscribeToTopic('orders_$userId');
  }

  // Subscribe to promotional updates
  Future<void> subscribeToPromotions() async {
    await _firebaseMessaging.subscribeToTopic('promotions');
  }

  // Subscribe to admin notifications
  Future<void> subscribeToAdminNotifications(String adminId) async {
    await _firebaseMessaging.subscribeToTopic('admin_$adminId');
  }

  // Show welcome notification for new users
  Future<void> showWelcomeNotification(String userName) async {
    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'welcome_channel',
        'Welcome Messages',
        channelDescription: 'Welcome notifications for new users',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        color: Color(0xFF9C27B0), // Purple for welcome
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await showLocalNotification(
      id: 'welcome_${userName.hashCode}'.hashCode,
      title: '🎉 Welcome to Ashley\'s Treats!',
      body:
          'Hi $userName! We\'re so excited to have you here. Start exploring our delicious treats!',
      payload: 'welcome:$userName',
      notificationDetails: notificationDetails,
    );
  }

  // Show reminder notification
  Future<void> showReminderNotification({
    required String title,
    required String body,
    required DateTime reminderTime,
    String? payload,
  }) async {
    await showScheduledNotification(
      id: title.hashCode,
      title: title,
      body: body,
      scheduledDate: reminderTime,
      payload: payload,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Reminder notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
          enableVibration: true,
          enableLights: true,
          color: Color(0xFF607D8B), // Blue-grey for reminders
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }
}
