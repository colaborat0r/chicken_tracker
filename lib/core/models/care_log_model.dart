class CareLogPhotoModel {
  final int id;
  final int careLogId;
  final String filePath;
  final String? galleryUri;
  final String? caption;
  final DateTime createdAt;

  const CareLogPhotoModel({
    required this.id,
    required this.careLogId,
    required this.filePath,
    this.galleryUri,
    this.caption,
    required this.createdAt,
  });

  CareLogPhotoModel copyWith({
    int? id,
    int? careLogId,
    String? filePath,
    String? galleryUri,
    String? caption,
    DateTime? createdAt,
  }) {
    return CareLogPhotoModel(
      id: id ?? this.id,
      careLogId: careLogId ?? this.careLogId,
      filePath: filePath ?? this.filePath,
      galleryUri: galleryUri ?? this.galleryUri,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CareLogModel {
  final int id;
  final DateTime date;
  final String title;
  final String? notes;
  final DateTime createdAt;
  final List<CareLogPhotoModel> photos;

  const CareLogModel({
    required this.id,
    required this.date,
    required this.title,
    this.notes,
    required this.createdAt,
    this.photos = const [],
  });

  CareLogModel copyWith({
    int? id,
    DateTime? date,
    String? title,
    String? notes,
    DateTime? createdAt,
    List<CareLogPhotoModel>? photos,
  }) {
    return CareLogModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      photos: photos ?? this.photos,
    );
  }
}

class CareLogGalleryItem {
  final CareLogPhotoModel photo;
  final CareLogModel log;

  const CareLogGalleryItem({
    required this.photo,
    required this.log,
  });
}
