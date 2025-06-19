class CourseResult {
  final String id;
  final String courseName;
  final String description;
  final double maxPoint;
  final bool isPremium;
  final bool isActive;
  final int levelId;
  final String imgUrl;
  final List<dynamic> topics;

  CourseResult({
    required this.id,
    required this.courseName,
    required this.description,
    required this.maxPoint,
    required this.isPremium,
    required this.isActive,
    required this.levelId,
    required this.imgUrl,
    required this.topics,
  });

  factory CourseResult.fromJson(Map<String, dynamic> json) {
    return CourseResult(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      description: json['description'] as String,
      maxPoint: json['maxPoint'] as double,
      isPremium: json['isPremium'] as bool,
      isActive: json['isActive'] as bool,
      levelId: json['levelId'] as int,
      imgUrl: json['imgUrl'] as String,
      topics: json['topics'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'description': description,
      'maxPoint': maxPoint,
      'isPremium': isPremium,
      'isActive': isActive,
      'levelId': levelId,
      'imgUrl': imgUrl,
      'topics': topics,
    };
  }
}
