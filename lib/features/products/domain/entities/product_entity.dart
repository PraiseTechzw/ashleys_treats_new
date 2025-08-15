class ProductEntity {
  final String productId;
  final String name;
  final String description;
  final String category;
  final double price;
  final List<String> images;
  final List<String> ingredients;
  final Map<String, dynamic> nutritionalInfo;
  final bool availability;
  final int stockQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductEntity({
    required this.productId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.images,
    required this.ingredients,
    required this.nutritionalInfo,
    required this.availability,
    required this.stockQuantity,
    required this.createdAt,
    required this.updatedAt,
  });
}
