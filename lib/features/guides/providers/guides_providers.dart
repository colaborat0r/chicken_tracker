import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../models/guide_models.dart';

final allGuidesProvider = FutureProvider<List<GuideArticle>>((ref) async {
  return ref.watch(guidesRepositoryProvider).getAllGuides();
});

final guideCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final guides = await ref.watch(allGuidesProvider.future);
  final categories = guides.map((guide) => guide.category).toSet().toList()
    ..sort();
  return ['All', ...categories];
});

final guideByIdProvider =
    FutureProvider.family<GuideArticle?, String>((ref, id) async {
  return ref.watch(guidesRepositoryProvider).getGuideById(id);
});

final guideSearchQueryProvider = StateProvider<String>((ref) => '');

final selectedGuideCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredGuidesProvider = FutureProvider<List<GuideArticle>>((ref) async {
  final query = ref.watch(guideSearchQueryProvider);
  final category = ref.watch(selectedGuideCategoryProvider);

  return ref.watch(guidesRepositoryProvider).searchGuides(
        query: query,
        category: category,
      );
});

final bookmarkedGuideIdsProvider = StreamProvider<Set<String>>((ref) {
  return ref.watch(guidesRepositoryProvider).watchBookmarkedGuideIds();
});

final savedGuidesProvider = StreamProvider<List<GuideArticle>>((ref) {
  return ref.watch(guidesRepositoryProvider).watchSavedGuides();
});

final readProgressMapProvider = StreamProvider<Map<String, GuideReadProgress>>((
  ref,
) {
  return ref.watch(guidesRepositoryProvider).watchReadProgressMap();
});
