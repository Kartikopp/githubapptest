class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profilePhotoUrl;
  final List<String> purchasedCourses;
  final DateTime createdAt;
  final bool isAdmin;
  final Map<String, double> courseProgress; // courseId: progress

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profilePhotoUrl,
    this.purchasedCourses = const [],
    required this.createdAt,
    this.isAdmin = false,
    this.courseProgress = const {},
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      profilePhotoUrl: map['profilePhotoUrl'],
      purchasedCourses: List<String>.from(map['purchasedCourses'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      isAdmin: map['isAdmin'] ?? false,
      courseProgress: Map<String, double>.from(map['courseProgress'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profilePhotoUrl': profilePhotoUrl,
      'purchasedCourses': purchasedCourses,
      'createdAt': createdAt.toIso8601String(),
      'isAdmin': isAdmin,
      'courseProgress': courseProgress,
    };
  }
}