import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Request permissions
    await _requestPermissions();

    // Configure Firebase messaging
    await _configureFirebaseMessaging();

    _isInitialized = true;
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

  void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.messageId}');

    // Show local notification
    print(
      'Firebase Message: ${message.notification?.title ?? 'New Message'} - ${message.notification?.body ?? 'You have a new message'}',
    );
    // TODO: Implement local notification when flutter_local_notifications is added
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Received background message: ${message.messageId}');
    // Handle background message if needed
  }

  void _handleNotificationOpenedApp(RemoteMessage message) {
    print('Notification opened app: ${message.messageId}');
    // TODO: Navigate to specific screen based on message data
  }

  // Show order status notification
  Future<void> showOrderStatusNotification({
    required String orderNumber,
    required String status,
    required String message,
  }) async {
    print('Order Status Notification: Order #$orderNumber - $status: $message');
    // TODO: Implement local notification when flutter_local_notifications is added
  }

  // Show order confirmation notification
  Future<void> showOrderConfirmationNotification({
    required String orderNumber,
    required double total,
  }) async {
    print(
      'Order Confirmation Notification: Order #$orderNumber confirmed for \$${total.toStringAsFixed(2)}',
    );
    // TODO: Implement local notification when flutter_local_notifications is added
  }

  // Show delivery notification
  Future<void> showDeliveryNotification({
    required String orderNumber,
    required String estimatedTime,
  }) async {
    print(
      'Delivery Notification: Order #$orderNumber out for delivery. ETA: $estimatedTime',
    );
    // TODO: Implement local notification when flutter_local_notifications is added
  }

  // Show promotional notification
  Future<void> showPromotionalNotification({
    required String title,
    required String message,
  }) async {
    print('Promotional Notification: $title - $message');
    // TODO: Implement local notification when flutter_local_notifications is added
  }

  // Show low stock notification (for admin)
  Future<void> showLowStockNotification({
    required String productName,
    required int currentStock,
  }) async {
    print(
      'Low Stock Notification: $productName is running low. Current stock: $currentStock',
    );
    // TODO: Implement local notification when flutter_local_notifications is added
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
}
