import 'dart:math';
import 'models/order.dart';

class OrderRepository {
  final List<Order> _orders = [];
  final Random _random = Random();

  Future<List<Order>> getAllOrders() async {
    return _orders;
  }

  Future<List<Order>> getOrdersByUserId(String userId) async {
    return _orders.where((order) => order.userId == userId).toList();
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      final updatedOrder = order.copyWith(status: newStatus);
      _orders[orderIndex] = updatedOrder;
    }
  }

  String _generateOrderNumber() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomPart = String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(_random.nextInt(chars.length))),
    );
    return 'AT${timestamp.substring(timestamp.length - 6)}$randomPart';
  }

  String _generateOrderId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           _random.nextInt(9999).toString().padLeft(4, '0');
  }

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
    final orderId = _generateOrderId();
    final orderNumber = _generateOrderNumber();
    final finalTotal = totalAmount + deliveryFee;

    final order = Order(
      id: orderId,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      finalTotal: finalTotal,
      status: 'pending',
      createdAt: DateTime.now(),
      deliveryTime: deliveryTime,
      paymentMethod: paymentMethod,
      deliveryAddress: deliveryAddress,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      notes: notes,
      orderNumber: orderNumber,
    );

    await addOrder(order);
    return order;
  }

  Future<List<Order>> getOrdersByStatus(String status) async {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<int> getTotalOrdersCount() async {
    return _orders.length;
  }

  Future<double> getTotalRevenue() async {
    double total = 0.0;
    for (final order in _orders) {
      total += order.finalTotal;
    }
    return total;
  }
}
