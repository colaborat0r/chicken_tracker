class GuideArticle {
  final String id;
  final String title;
  final String category;
  final String difficulty;
  final String season;
  final int readMinutes;
  final List<String> tags;
  final DateTime updatedAt;
  final List<GuideBlock> blocks;

  const GuideArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.season,
    required this.readMinutes,
    required this.tags,
    required this.updatedAt,
    required this.blocks,
  });

  factory GuideArticle.fromJson(Map<String, dynamic> json) {
    return GuideArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      season: json['season'] as String,
      readMinutes: json['readMinutes'] as int,
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => tag.toString())
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      blocks: (json['blocks'] as List<dynamic>)
          .map((block) => GuideBlock.fromJson(block as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GuideBlock {
  final String type;
  final String? title;
  final String? text;
  final List<String>? items;
  final String? label;
  final String? url;

  const GuideBlock({
    required this.type,
    this.title,
    this.text,
    this.items,
    this.label,
    this.url,
  });

  factory GuideBlock.fromJson(Map<String, dynamic> json) {
    return GuideBlock(
      type: json['type'] as String,
      title: json['title'] as String?,
      text: json['text'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => item.toString())
          .toList(),
      label: json['label'] as String?,
      url: json['url'] as String?,
    );
  }
}

class GuideReadProgress {
  final String guideId;
  final int progressPercent;
  final bool completed;
  final DateTime? lastReadAt;

  const GuideReadProgress({
    required this.guideId,
    required this.progressPercent,
    required this.completed,
    required this.lastReadAt,
  });
}
