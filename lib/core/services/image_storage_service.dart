import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Service for handling image storage for chicken photos
class ImageStorageService {
  static const String _photosDirectory = 'chicken_photos';

  /// Save an image file to app documents directory
  /// Returns the path to the saved image
  Future<String> saveImageToAppDirectory(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/$_photosDirectory');

      // Create directory if it doesn't exist
      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      // Generate unique filename based on timestamp
      final fileName = 'chicken_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${photoDir.path}/$fileName';

      // Copy file to app directory
      final savedFile = await imageFile.copy(savedPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Get image file from stored path
  Future<File?> getImageFile(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        return file;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Delete an image file
  Future<void> deleteImage(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Silently fail - file might already be deleted
    }
  }

  /// Check if a photo path is valid and exists
  Future<bool> photoExists(String photoPath) async {
    try {
      final file = File(photoPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}


