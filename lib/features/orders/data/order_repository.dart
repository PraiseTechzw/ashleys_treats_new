import 'models/order.dart';

class OrderRepository {
  final List<Order> _orders = [];

  Future<List<Order>> getAllOrders() async {
    return _orders;
  }

  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }
}
