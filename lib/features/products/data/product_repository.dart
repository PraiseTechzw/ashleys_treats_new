import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['productId'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  Future<void> addOrUpdateProduct(ProductModel product) async {
    try {
      if (product.productId.isEmpty) {
        // Add new product
        await _firestore.collection(_collection).add(product.toMap());
      } else {
        // Update existing product
        await _firestore
            .collection(_collection)
            .doc(product.productId)
            .update(product.toMap());
      }
    } catch (e) {
      print('Error saving product: $e');
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collection).doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  Future<ProductModel?> getProductById(String productId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(productId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        data['productId'] = doc.id;
        return ProductModel.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['productId'] = doc.id;
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }
}
