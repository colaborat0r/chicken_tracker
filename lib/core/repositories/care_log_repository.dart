import 'dart:io';

import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../models/care_log_model.dart';
import '../services/image_storage_service.dart';

class CareLogRepository {
  final AppDatabase database;
  final ImageStorageService imageStorage;

  CareLogRepository(this.database, this.imageStorage);

  Stream<List<CareLogModel>> watchAllCareLogs() async* {
    await for (final logs in database.watchAllCareLogs()) {
      final result = <CareLogModel>[];
      for (final log in logs) {
        final photos = await database.getPhotosForCareLog(log.id);
        result.add(_careLogFromDb(log, photos));
      }
      yield result;
    }
  }

  Future<CareLogModel?> getCareLogById(int id) async {
    final log = await database.getCareLogById(id);
    if (log == null) return null;
    final photos = await database.getPhotosForCareLog(id);
    return _careLogFromDb(log, photos);
  }

  Future<List<CareLogGalleryItem>> getGalleryItems() async {
    final logs = await database.watchAllCareLogs().first;
    final items = <CareLogGalleryItem>[];
    for (final log in logs) {
      final photos = await database.getPhotosForCareLog(log.id);
      final model = _careLogFromDb(log, photos);
      for (final photo in model.photos) {
        items.add(CareLogGalleryItem(photo: photo, log: model));
      }
    }
    items.sort((a, b) => b.photo.createdAt.compareTo(a.photo.createdAt));
    return items;
  }

  Future<int> addCareLog({
    required DateTime date,
    required String title,
    String? notes,
    required List<PendingCareLogPhoto> pendingPhotos,
  }) async {
    final now = DateTime.now();
    final id = await database.addCareLog(
      CareLogsCompanion(
        date: Value(date),
        title: Value(title),
        notes: Value(notes),
        createdAt: Value(now),
      ),
    );

    for (final pending in pendingPhotos) {
      await _persistPhoto(
        careLogId: id,
        sourceFile: pending.sourceFile,
        caption: pending.caption,
      );
    }

    return id;
  }

  Future<void> updateCareLog({
    required CareLogModel existing,
    required DateTime date,
    required String title,
    String? notes,
    required List<PendingCareLogPhoto> newPhotos,
    required List<int> removedPhotoIds,
    required Map<int, String?> updatedCaptions,
  }) async {
    await database.updateCareLog(
      CareLog(
        id: existing.id,
        date: date,
        title: title,
        notes: notes,
        createdAt: existing.createdAt,
      ),
    );

    for (final photoId in removedPhotoIds) {
      await deletePhoto(photoId);
    }

    for (final entry in updatedCaptions.entries) {
      final photo = existing.photos.firstWhere((p) => p.id == entry.key);
      await database.updateCareLogPhoto(
        CareLogPhoto(
          id: photo.id,
          careLogId: photo.careLogId,
          filePath: photo.filePath,
          galleryUri: photo.galleryUri,
          caption: entry.value,
          createdAt: photo.createdAt,
        ),
      );
    }

    for (final pending in newPhotos) {
      await _persistPhoto(
        careLogId: existing.id,
        sourceFile: pending.sourceFile,
        caption: pending.caption,
      );
    }
  }

  Future<void> deleteCareLog(CareLogModel log) async {
    for (final photo in log.photos) {
      await imageStorage.deleteImage(photo.filePath);
    }
    await database.deleteCareLog(log.id);
  }

  Future<void> deletePhoto(int photoId) async {
    final photo = await database.getCareLogPhotoById(photoId);
    if (photo == null) return;
    await imageStorage.deleteImage(photo.filePath);
    await database.deleteCareLogPhoto(photoId);
  }

  Future<void> _persistPhoto({
    required int careLogId,
    required File sourceFile,
    String? caption,
  }) async {
    final savedPath = await imageStorage.saveCareLogImage(sourceFile);
    String? galleryUri;
    try {
      galleryUri = await imageStorage.saveImageToGallery(savedPath);
    } catch (_) {
      galleryUri = null;
    }

    await database.addCareLogPhoto(
      CareLogPhotosCompanion(
        careLogId: Value(careLogId),
        filePath: Value(savedPath),
        galleryUri: Value(galleryUri),
        caption: Value(caption),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  CareLogModel _careLogFromDb(CareLog log, List<CareLogPhoto> photos) {
    return CareLogModel(
      id: log.id,
      date: log.date,
      title: log.title,
      notes: log.notes,
      createdAt: log.createdAt,
      photos: photos.map(_photoFromDb).toList(),
    );
  }

  CareLogPhotoModel _photoFromDb(CareLogPhoto photo) => CareLogPhotoModel(
        id: photo.id,
        careLogId: photo.careLogId,
        filePath: photo.filePath,
        galleryUri: photo.galleryUri,
        caption: photo.caption,
        createdAt: photo.createdAt,
      );
}

class PendingCareLogPhoto {
  final File sourceFile;
  final String? caption;

  const PendingCareLogPhoto({
    required this.sourceFile,
    this.caption,
  });
}
