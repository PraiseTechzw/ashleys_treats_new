import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firestore_order_service.dart';
import 'models/order.dart';

final orderRepositoryProvider = Provider<FirestoreOrderService>((ref) {
  return FirestoreOrderService();
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((
  ref,
) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrdersNotifier(repository);
});

final userOrdersProvider =
    StateNotifierProvider.family<UserOrdersNotifier, List<Order>, String>((
      ref,
      userId,
    ) {
      final repository = ref.watch(orderRepositoryProvider);
      return UserOrdersNotifier(repository, userId);
    });

final orderStatusProvider =
    StateNotifierProvider.family<OrderStatusNotifier, String, String>((
      ref,
      orderId,
    ) {
      final repository = ref.watch(orderRepositoryProvider);
      return OrderStatusNotifier(repository, orderId);
    });

class OrdersNotifier extends StateNotifier<List<Order>> {
  final FirestoreOrderService _repository;

  OrdersNotifier(this._repository) : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await _repository.getAllOrders();
    state = orders;
  }

  Future<void> addOrder(Order order) async {
    // For Firestore, we don't need to manually add to state as it's handled by streams
    // This method is kept for compatibility but the actual order creation is done via createOrder
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _repository.updateOrderStatus(orderId, newStatus);
    state = [
      for (final order in state)
        if (order.id == orderId) order.copyWith(status: newStatus) else order,
    ];
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
    final order = await _repository.createOrder(
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      deliveryFee: deliveryFee,
      paymentMethod: paymentMethod,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      deliveryTime: deliveryTime,
      notes: notes,
    );

    state = [...state, order];
    return order;
  }

  List<Order> getOrdersByStatus(String status) {
    return state.where((order) => order.status == status).toList();
  }

  int getTotalOrdersCount() {
    return state.length;
  }

  double getTotalRevenue() {
    double total = 0.0;
    for (final order in state) {
      total += order.finalTotal;
    }
    return total;
  }
}

class UserOrdersNotifier extends StateNotifier<List<Order>> {
  final FirestoreOrderService _repository;
  final String _userId;

  UserOrdersNotifier(this._repository, this._userId) : super([]) {
    _loadUserOrders();
  }

  Future<void> _loadUserOrders() async {
    final orders = await _repository.getUserOrders(_userId);
    state = orders;
  }

  Future<void> refresh() async {
    await _loadUserOrders();
  }

  List<Order> getOrdersByStatus(String status) {
    return state.where((order) => order.status == status).toList();
  }

  Order? getLatestOrder() {
    if (state.isEmpty) return null;
    state.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return state.first;
  }
}

class OrderStatusNotifier extends StateNotifier<String> {
  final FirestoreOrderService _repository;
  final String _orderId;

  OrderStatusNotifier(this._repository, this._orderId) : super('pending') {
    _loadOrderStatus();
  }

  Future<void> _loadOrderStatus() async {
    final order = await _repository.getOrderById(_orderId);
    if (order != null) {
      state = order.status;
    }
  }

  Future<void> updateStatus(String newStatus) async {
    await _repository.updateOrderStatus(_orderId, newStatus);
    state = newStatus;
  }
}
