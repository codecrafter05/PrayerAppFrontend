class OccasionImage {
  final int id;
  final String imageUrl;
  final String createdAt;

  OccasionImage({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
  });

  factory OccasionImage.fromJson(Map<String, dynamic> json) {
    return OccasionImage(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

