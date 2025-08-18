import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Pick an image from camera or gallery
  Future<File?> pickImage({
    required ImageSource source,
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Pick multiple images for products
  Future<List<File>> pickMultipleImages({
    double maxWidth = 1024,
    double maxHeight = 1024,
    int imageQuality = 85,
    int maxImages = 5,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFiles.length > maxImages) {
        pickedFiles.removeRange(maxImages, pickedFiles.length);
      }

      return pickedFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      return [];
    }
  }

  /// Compress image to reduce file size
  Future<File?> compressImage({
    required File imageFile,
    double maxWidth = 800,
    double maxHeight = 800,
    int quality = 85,
  }) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      // Calculate new dimensions while maintaining aspect ratio
      double width = image.width.toDouble();
      double height = image.height.toDouble();

      if (width > maxWidth || height > maxHeight) {
        if (width > height) {
          height = (height * maxWidth) / width;
          width = maxWidth;
        } else {
          width = (width * maxHeight) / height;
          height = maxHeight;
        }
      }

      final img.Image resizedImage = img.copyResize(
        image,
        width: width.toInt(),
        height: height.toInt(),
        interpolation: img.Interpolation.linear,
      );

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String fileName =
          'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '$tempPath/$fileName';

      // Save compressed image
      final File compressedFile = File(filePath);
      final Uint8List compressedBytes = img.encodeJpg(
        resizedImage,
        quality: quality,
      );
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  /// Generate thumbnail for image
  Future<File?> generateThumbnail({
    required File imageFile,
    double size = 150,
  }) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      final img.Image thumbnail = img.copyResize(
        image,
        width: size.toInt(),
        height: size.toInt(),
        interpolation: img.Interpolation.linear,
      );

      // Get temporary directory
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final String fileName =
          'thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '$tempPath/$fileName';

      // Save thumbnail
      final File thumbnailFile = File(filePath);
      final Uint8List thumbnailBytes = img.encodeJpg(thumbnail, quality: 80);
      await thumbnailFile.writeAsBytes(thumbnailBytes);

      return thumbnailFile;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  /// Upload image to storage (placeholder for Firebase Storage integration)
  Future<String?> uploadImage({
    required File imageFile,
    required String path,
    String? fileName,
  }) async {
    try {
      // TODO: Implement actual Firebase Storage upload
      // For now, return a placeholder path
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload delay

      final String finalFileName =
          fileName ?? '${DateTime.now().millisecondsSinceEpoch}.jpg';
      return '$path/$finalFileName';
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Delete image from storage
  Future<bool> deleteImage(String imagePath) async {
    try {
      // TODO: Implement actual Firebase Storage deletion
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate deletion delay
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Show image picker dialog
  Future<File?> showImagePickerDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(dialogContext).pop();
                  final File? image = await pickImage(
                    source: ImageSource.camera,
                  );
                  Navigator.of(dialogContext).pop(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(dialogContext).pop();
                  final File? image = await pickImage(
                    source: ImageSource.gallery,
                  );
                  Navigator.of(dialogContext).pop(image);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Validate image file
  bool validateImage(File imageFile) {
    try {
      final int fileSize = imageFile.lengthSync();
      final int maxSize = 10 * 1024 * 1024; // 10MB

      if (fileSize > maxSize) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get image info
  Future<Map<String, dynamic>?> getImageInfo(File imageFile) async {
    try {
      final Uint8List bytes = await imageFile.readAsBytes();
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      return {
        'width': image.width,
        'height': image.height,
        'size': imageFile.lengthSync(),
        'format': 'JPEG', // Assuming JPEG for now
      };
    } catch (e) {
      print('Error getting image info: $e');
      return null;
    }
  }
}
