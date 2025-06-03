class CourseModel {
  final String courseName;
  final String description;
  final double maxPoint;
  final bool isLock;
  final bool isDeleted;
  final bool isActive;
  final DateTime updatedAt;
  final bool isPremium;
  final int levelId;
  final int displayOrder;
  final String imageUrl;
  final dynamic level;
  final dynamic enrolledCourses;
  final dynamic topics;
  final String id;
  final DateTime createdAt;
  final DateTime updateAt;

  CourseModel({
    required this.courseName,
    required this.description,
    required this.maxPoint,
    required this.isLock,
    required this.isDeleted,
    required this.isActive,
    required this.updatedAt,
    required this.isPremium,
    required this.levelId,
    required this.displayOrder,
    required this.imageUrl,
    this.level,
    this.enrolledCourses,
    this.topics,
    required this.id,
    required this.createdAt,
    required this.updateAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      courseName: json['courseName'],
      description: json['description'],
      maxPoint: json['maxPoint'],
      isLock: json['isLock'],
      isDeleted: json['isDeleted'],
      isActive: json['isActive'],
      updatedAt: DateTime.parse(json['updatedAt']),
      isPremium: json['isPremium'],
      levelId: json['levelId'],
      displayOrder: json['displayOrder'],
      imageUrl: json['imageUrl'],
      level: json['level'],
      enrolledCourses: json['enrolledCourses'],
      topics: json['topics'],
      id: json['id'],
      createdAt: DateTime.parse(json['createdAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseName': courseName,
      'description': description,
      'maxPoint': maxPoint,
      'isLock': isLock,
      'isDeleted': isDeleted,
      'isActive': isActive,
      'updatedAt': updatedAt.toIso8601String(),
      'isPremium': isPremium,
      'levelId': levelId,
      'displayOrder': displayOrder,
      'imageUrl': imageUrl,
      'level': level,
      'enrolledCourses': enrolledCourses,
      'topics': topics,
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}
