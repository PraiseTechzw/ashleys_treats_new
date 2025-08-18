import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'models/order.dart';

class FirestoreOrderService {
  static final FirestoreOrderService _instance =
      FirestoreOrderService._internal();
  factory FirestoreOrderService() => _instance;
  FirestoreOrderService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  // Create a new order
  Future<Order> createOrder({
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    required double deliveryFee,
    required String paymentMethod,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String deliveryAddress,
    DateTime? deliveryTime,
    String? notes,
  }) async {
    try {
      // Generate order number
      final orderNumber = _generateOrderNumber();

      // Create order data
      final orderData = {
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'deliveryFee': deliveryFee,
        'finalTotal': totalAmount + deliveryFee,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'deliveryTime': deliveryTime != null
            ? Timestamp.fromDate(deliveryTime)
            : null,
        'paymentMethod': paymentMethod,
        'deliveryAddress': deliveryAddress,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'notes': notes,
        'orderNumber': orderNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add order to Firestore
      final docRef = await _ordersCollection.add(orderData);

      // Get the created document to return the order with ID
      final doc = await docRef.get();
      final data = doc.data()!;

      // Update user's order history
      await _updateUserOrderHistory(userId, doc.id);

      return Order.fromMap(data, doc.id);
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get all orders for a user
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _ordersCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Order.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user orders: $e');
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final doc = await _ordersCollection.doc(orderId).get();
      if (doc.exists) {
        return Order.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get order: $e');
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(String status) async {
    try {
      final querySnapshot = await _ordersCollection
          .where('status', isEqualTo: status)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Order.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get orders by status: $e');
    }
  }

  // Get all orders (for admin)
  Future<List<Order>> getAllOrders() async {
    try {
      final querySnapshot = await _ordersCollection
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Order.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all orders: $e');
    }
  }

  // Get total revenue
  Future<double> getTotalRevenue() async {
    try {
      final querySnapshot = await _ordersCollection
          .where('status', whereIn: ['completed', 'delivered'])
          .get();

      double total = 0.0;
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        if (data['finalTotal'] != null) {
          total += (data['finalTotal'] as num).toDouble();
        }
      }
      return total;
    } catch (e) {
      throw Exception('Failed to get total revenue: $e');
    }
  }

  // Get total orders count
  Future<int> getTotalOrdersCount() async {
    try {
      final querySnapshot = await _ordersCollection.get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get orders count: $e');
    }
  }

  // Delete order (for admin)
  Future<void> deleteOrder(String orderId) async {
    try {
      await _ordersCollection.doc(orderId).delete();
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }

  // Update user's order history
  Future<void> _updateUserOrderHistory(String userId, String orderId) async {
    try {
      await _usersCollection.doc(userId).update({
        'orderHistory': FieldValue.arrayUnion([orderId]),
        'lastOrderAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // If user document doesn't exist, create it
      await _usersCollection.doc(userId).set({
        'orderHistory': [orderId],
        'lastOrderAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // Generate unique order number
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond % 1000;
    return 'AT${timestamp.toString().substring(timestamp.toString().length - 6)}$random';
  }

  // Stream orders for real-time updates
  Stream<List<Order>> streamUserOrders(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Stream all orders (for admin)
  Stream<List<Order>> streamAllOrders() {
    return _ordersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Order.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
