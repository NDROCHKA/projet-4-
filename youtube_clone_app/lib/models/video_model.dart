class Video {
  final String id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String description;

  Video({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.description,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['_id'],
      title: json['title'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
