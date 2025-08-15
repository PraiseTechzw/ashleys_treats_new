import '../../../features/products/data/models/product_model.dart';
import '../../../features/products/data/product_repository.dart';
import 'asset_image_helper.dart';

class DemoDataSeeder {
  static final ProductRepository _productRepository = ProductRepository();

  static Future<void> seedDemoData() async {
    try {
      // Check if products already exist
      final existingProducts = await _productRepository.getAllProducts();
      if (existingProducts.isNotEmpty) {
        print('Products already exist, skipping demo data seeding');
        return;
      }

      final demoProducts = [
        ProductModel(
          productId: '',
          name: 'Chocolate Cupcakes',
          description: 'Delicious chocolate cupcakes with creamy frosting',
          category: 'Cupcakes',
          price: 3.99,
          images: [AssetImageHelper.getImagePath('cupcakes.jpeg')],
          ingredients: ['Flour', 'Sugar', 'Cocoa', 'Eggs', 'Milk'],
          nutritionalInfo: {'calories': 250, 'fat': 12, 'carbs': 35},
          availability: true,
          stockQuantity: 50,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          productId: '',
          name: 'Vanilla Cake Slice',
          description: 'Moist vanilla cake slice with buttercream frosting',
          category: 'Cakes',
          price: 4.99,
          images: [AssetImageHelper.getImagePath('cake-slice.jpeg')],
          ingredients: ['Flour', 'Sugar', 'Vanilla', 'Eggs', 'Butter'],
          nutritionalInfo: {'calories': 320, 'fat': 15, 'carbs': 42},
          availability: true,
          stockQuantity: 30,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          productId: '',
          name: 'Chocolate Brownies',
          description: 'Rich and fudgy chocolate brownies',
          category: 'Brownies',
          price: 2.99,
          images: [AssetImageHelper.getImagePath('brownies.jpeg')],
          ingredients: ['Chocolate', 'Butter', 'Sugar', 'Eggs', 'Flour'],
          nutritionalInfo: {'calories': 280, 'fat': 18, 'carbs': 28},
          availability: true,
          stockQuantity: 40,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          productId: '',
          name: 'Chocolate Chip Cookies',
          description: 'Classic chocolate chip cookies with crispy edges',
          category: 'Cookies',
          price: 1.99,
          images: [AssetImageHelper.getImagePath('cookies.jpeg')],
          ingredients: ['Flour', 'Butter', 'Sugar', 'Chocolate Chips', 'Eggs'],
          nutritionalInfo: {'calories': 150, 'fat': 8, 'carbs': 18},
          availability: true,
          stockQuantity: 100,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          productId: '',
          name: 'Glazed Donuts',
          description: 'Fresh glazed donuts with a sweet finish',
          category: 'Donuts',
          price: 2.49,
          images: [AssetImageHelper.getImagePath('donuts.jpeg')],
          ingredients: ['Flour', 'Yeast', 'Sugar', 'Milk', 'Eggs'],
          nutritionalInfo: {'calories': 220, 'fat': 10, 'carbs': 30},
          availability: true,
          stockQuantity: 60,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          productId: '',
          name: 'Blueberry Muffins',
          description: 'Fresh baked muffins with juicy blueberries',
          category: 'Muffins',
          price: 2.99,
          images: [AssetImageHelper.getImagePath('muffins.jpeg')],
          ingredients: ['Flour', 'Sugar', 'Blueberries', 'Eggs', 'Milk'],
          nutritionalInfo: {'calories': 200, 'fat': 7, 'carbs': 32},
          availability: true,
          stockQuantity: 45,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ProductModel(
          productId: '',
          name: 'Cake Pops',
          description: 'Fun and delicious cake pops on sticks',
          category: 'Cake Pops',
          price: 3.49,
          images: [AssetImageHelper.getImagePath('cake-pops.jpeg')],
          ingredients: ['Cake', 'Frosting', 'Chocolate', 'Sprinkles'],
          nutritionalInfo: {'calories': 180, 'fat': 9, 'carbs': 25},
          availability: true,
          stockQuantity: 35,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      // Add all demo products to Firebase
      for (final product in demoProducts) {
        await _productRepository.addOrUpdateProduct(product);
      }

      print(
        'Demo data seeded successfully! Added ${demoProducts.length} products',
      );
    } catch (e) {
      print('Error seeding demo data: $e');
    }
  }

  static Future<void> clearAllData() async {
    try {
      final products = await _productRepository.getAllProducts();
      for (final product in products) {
        await _productRepository.deleteProduct(product.productId);
      }
      print('All demo data cleared successfully!');
    } catch (e) {
      print('Error clearing demo data: $e');
    }
  }
}
