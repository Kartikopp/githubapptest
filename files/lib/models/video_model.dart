class VideoModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String videoUrl;
  final Duration duration;
  final int sequenceNumber;
  final String? thumbnailUrl;

  VideoModel({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.sequenceNumber,
    this.thumbnailUrl,
  });

  factory VideoModel.fromMap(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? '',
      courseId: map['courseId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      duration: Duration(seconds: map['duration'] ?? 0),
      sequenceNumber: map['sequenceNumber'] ?? 0,
      thumbnailUrl: map['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'duration': duration.inSeconds,
      'sequenceNumber': sequenceNumber,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}