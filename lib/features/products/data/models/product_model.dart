import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.productId,
    required super.name,
    required super.description,
    required super.category,
    required super.price,
    required super.images,
    required super.ingredients,
    required super.nutritionalInfo,
    required super.availability,
    required super.stockQuantity,
    required super.createdAt,
    required super.updatedAt,
  });

  // Getter for backward compatibility - returns first image or empty string
  String get imageUrl => images.isNotEmpty ? images.first : '';

  // Create a copy with updated values
  ProductModel copyWith({
    String? productId,
    String? name,
    String? description,
    String? category,
    double? price,
    List<String>? images,
    List<String>? ingredients,
    Map<String, dynamic>? nutritionalInfo,
    bool? availability,
    int? stockQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      images: images ?? this.images,
      ingredients: ingredients ?? this.ingredients,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      availability: availability ?? this.availability,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      price: _parsePrice(map['price']),
      images: List<String>.from(map['images'] ?? []),
      ingredients: List<String>.from(map['ingredients'] ?? []),
      nutritionalInfo: Map<String, dynamic>.from(map['nutritionalInfo'] ?? {}),
      availability: map['availability'] ?? true,
      stockQuantity: map['stockQuantity'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'images': images,
      'ingredients': ingredients,
      'nutritionalInfo': nutritionalInfo,
      'availability': availability,
      'stockQuantity': stockQuantity,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
