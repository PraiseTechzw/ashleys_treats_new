class AssetImageHelper {
  static const String _basePath = 'assets/images/';
  
  // Available product images from assets
  static const List<String> availableImages = [
    'brownies.jpeg',
    'brownies1.jpeg',
    'brownies3.jpeg',
    'cake-pops.jpeg',
    'cake-slice.jpeg',
    'cake-Smooth.jpeg',
    'cake-tasters.jpeg',
    'cake-tasters2.jpeg',
    'cookies.jpeg',
    'cupcakes.jpeg',
    'donuts.jpeg',
    'donuts1.jpeg',
    'donuts2.jpeg',
    'muffins.jpeg',
    'muffins1.jpeg',
  ];

  // Get full asset path for an image
  static String getImagePath(String imageName) {
    return '$_basePath$imageName';
  }

  // Get all available image paths
  static List<String> getAllImagePaths() {
    return availableImages.map((image) => getImagePath(image)).toList();
  }

  // Get random image path
  static String getRandomImagePath() {
    final random = DateTime.now().millisecondsSinceEpoch % availableImages.length;
    return getImagePath(availableImages[random]);
  }

  // Get image path by index
  static String getImagePathByIndex(int index) {
    if (index >= 0 && index < availableImages.length) {
      return getImagePath(availableImages[index]);
    }
    return getImagePath(availableImages[0]); // fallback to first image
  }

  // Get image name without extension
  static String getImageNameWithoutExtension(String imagePath) {
    final fileName = imagePath.split('/').last;
    return fileName.split('.').first;
  }

  // Check if image exists in assets
  static bool hasImage(String imageName) {
    return availableImages.contains(imageName);
  }
}
