import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/database/app_database.dart';
import '../models/guide_models.dart';

class GuidesRepository {
  final AppDatabase database;

  GuidesRepository(this.database);

  List<GuideArticle>? _cachedGuides;

  Future<List<GuideArticle>> getAllGuides() async {
    if (_cachedGuides != null) {
      return _cachedGuides!;
    }

    final rawJson = await rootBundle.loadString('assets/guides/guides_v1.json');
    final decoded = jsonDecode(rawJson) as List<dynamic>;

    _cachedGuides = decoded
        .map((item) => GuideArticle.fromJson(item as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return _cachedGuides!;
  }

  Future<GuideArticle?> getGuideById(String id) async {
    final guides = await getAllGuides();
    for (final guide in guides) {
      if (guide.id == id) return guide;
    }
    return null;
  }

  Future<List<GuideArticle>> searchGuides({
    String query = '',
    String? category,
  }) async {
    final guides = await getAllGuides();
    final normalizedQuery = query.trim().toLowerCase();

    return guides.where((guide) {
      final categoryMatch =
          category == null || category == 'All' || guide.category == category;
      if (!categoryMatch) return false;

      if (normalizedQuery.isEmpty) return true;

      final inTitle = guide.title.toLowerCase().contains(normalizedQuery);
      final inTags = guide.tags
          .map((tag) => tag.toLowerCase())
          .any((tag) => tag.contains(normalizedQuery));
      final inBlocks = guide.blocks.any(
        (block) => (block.text ?? '').toLowerCase().contains(normalizedQuery),
      );

      return inTitle || inTags || inBlocks;
    }).toList();
  }

  Stream<Set<String>> watchBookmarkedGuideIds() {
    return database.watchSavedGuides().map(
          (rows) => rows.map((row) => row.guideId).toSet(),
        );
  }

  Future<void> setBookmarked(String guideId, bool isSaved) async {
    if (isSaved) {
      await database.saveGuide(guideId);
    } else {
      await database.unsaveGuide(guideId);
    }
  }

  Future<void> toggleBookmark(String guideId) async {
    final isSaved = await database.isGuideSaved(guideId);
    await setBookmarked(guideId, !isSaved);
  }

  Stream<Map<String, GuideReadProgress>> watchReadProgressMap() {
    return database.watchReadGuides().map((rows) {
      return {
        for (final row in rows)
          row.guideId: GuideReadProgress(
            guideId: row.guideId,
            progressPercent: row.progressPercent,
            completed: row.completed,
            lastReadAt: row.lastReadAt,
          ),
      };
    });
  }

  Future<void> markGuideRead(
    String guideId, {
    int progressPercent = 100,
    bool completed = true,
  }) async {
    await database.upsertReadGuide(
      guideId,
      progressPercent: progressPercent,
      completed: completed,
    );
  }

  Stream<List<GuideArticle>> watchSavedGuides() async* {
    final guides = await getAllGuides();
    yield* watchBookmarkedGuideIds().map((savedIds) {
      final saved = guides.where((guide) => savedIds.contains(guide.id)).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return saved;
    });
  }
}
