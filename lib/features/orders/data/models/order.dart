import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final double deliveryFee;
  final double finalTotal;
  final String status;
  final DateTime createdAt;
  final DateTime? deliveryTime;
  final String paymentMethod;
  final String? deliveryAddress;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? notes;
  final String? orderNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryFee,
    required this.finalTotal,
    required this.status,
    required this.createdAt,
    this.deliveryTime,
    required this.paymentMethod,
    this.deliveryAddress,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.notes,
    this.orderNumber,
  });

  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? totalAmount,
    double? deliveryFee,
    double? finalTotal,
    String? status,
    DateTime? createdAt,
    DateTime? deliveryTime,
    String? paymentMethod,
    String? deliveryAddress,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? notes,
    String? orderNumber,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      finalTotal: finalTotal ?? this.finalTotal,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'deliveryFee': deliveryFee,
      'finalTotal': finalTotal,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deliveryTime': deliveryTime?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'notes': notes,
      'orderNumber': orderNumber,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      finalTotal: (json['finalTotal'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      deliveryTime: json['deliveryTime'] != null
          ? DateTime.parse(json['deliveryTime'] as String)
          : null,
      paymentMethod: json['paymentMethod'] as String,
      deliveryAddress: json['deliveryAddress'] as String?,
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
      notes: json['notes'] as String?,
      orderNumber: json['orderNumber'] as String?,
    );
  }

  // Factory constructor for Firestore data
  factory Order.fromMap(Map<String, dynamic> data, String id) {
    return Order(
      id: id,
      userId: data['userId'] as String,
      items: (data['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (data['totalAmount'] as num).toDouble(),
      deliveryFee: (data['deliveryFee'] as num).toDouble(),
      finalTotal: (data['finalTotal'] as num).toDouble(),
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deliveryTime: data['deliveryTime'] != null
          ? (data['deliveryTime'] as Timestamp).toDate()
          : null,
      paymentMethod: data['paymentMethod'] as String,
      deliveryAddress: data['deliveryAddress'] as String?,
      customerName: data['customerName'] as String?,
      customerEmail: data['customerEmail'] as String?,
      customerPhone: data['customerPhone'] as String?,
      notes: data['notes'] as String?,
      orderNumber: data['orderNumber'] as String?,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
