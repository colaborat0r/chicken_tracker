import 'dart:io';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

/// Service for handling image storage for chicken and care log photos.
class ImageStorageService {
  static const String _photosDirectory = 'chicken_photos';
  static const String _careLogPhotosDirectory = 'care_log_photos';
  static const String _galleryAlbum = 'Chicken Tracker';

  /// Save an image file to app documents directory.
  /// Returns the path to the saved image.
  Future<String> saveImageToAppDirectory(File imageFile) async {
    return _saveToSubdirectory(imageFile, _photosDirectory, 'chicken');
  }

  /// Save a care log image to the app documents directory.
  Future<String> saveCareLogImage(File imageFile) async {
    return _saveToSubdirectory(imageFile, _careLogPhotosDirectory, 'care_log');
  }

  Future<String> _saveToSubdirectory(
    File imageFile,
    String directoryName,
    String prefix,
  ) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final photoDir = Directory('${appDir.path}/$directoryName');

      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
      }

      final fileName = '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${photoDir.path}/$fileName';
      final savedFile = await imageFile.copy(savedPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  /// Copy an image into the device photo gallery.
  Future<String?> saveImageToGallery(String filePath) async {
    try {
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          throw Exception('Gallery access was denied');
        }
      }

      await Gal.putImage(filePath, album: _galleryAlbum);
      return filePath;
    } catch (e) {
      throw Exception('Failed to save image to gallery: $e');
    }
  }

  /// Get image file from stored path.
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

  /// Delete an image file.
  Future<void> deleteImage(String photoPath) async {
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Silently fail - file might already be deleted.
    }
  }

  /// Check if a photo path is valid and exists.
  Future<bool> photoExists(String photoPath) async {
    try {
      final file = File(photoPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
