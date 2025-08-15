import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> fetchProducts({int page = 1, int pageSize = 20});
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<ProductEntity>> filterByCategory(String category);
  Future<ProductEntity?> getProductById(String productId);
}
