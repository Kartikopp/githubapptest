class CourseModel {
  final String id;
  final String title;
  final String description;
  final String category; // Class 9, 10, 11, 12, Competitive Exams
  final String teacherName;
  final double price;
  final String thumbnailUrl;
  final List<String> videoIds;
  final int enrolledCount;
  final double rating;
  final DateTime createdAt;
  final bool isFeatured;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.teacherName,
    required this.price,
    required this.thumbnailUrl,
    this.videoIds = const [],
    this.enrolledCount = 0,
    this.rating = 0.0,
    required this.createdAt,
    this.isFeatured = false,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      teacherName: map['teacherName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      thumbnailUrl: map['thumbnailUrl'] ?? '',
      videoIds: List<String>.from(map['videoIds'] ?? []),
      enrolledCount: map['enrolledCount'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      isFeatured: map['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'teacherName': teacherName,
      'price': price,
      'thumbnailUrl': thumbnailUrl,
      'videoIds': videoIds,
      'enrolledCount': enrolledCount,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'isFeatured': isFeatured,
    };
  }
}