class EnrolledCourseModel {
  final bool isCompleted;
  final double progressPoints;
  final DateTime updatedAt;
  final String userId;
  final String courseId;
  final dynamic user;
  final dynamic course;
  final dynamic topicProgresses;
  final String id;
  final DateTime createdAt;

  EnrolledCourseModel({
    required this.isCompleted,
    required this.progressPoints,
    required this.updatedAt,
    required this.userId,
    required this.courseId,
    this.user,
    this.course,
    this.topicProgresses,
    required this.id,
    required this.createdAt,
  });

  factory EnrolledCourseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EnrolledCourseModel(
      isCompleted: json['isCompleted'] as bool,
      progressPoints: json['progressPoints'] as double,
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      user: json['user'],
      course: json['course'],
      topicProgresses: json['topicProgresses'],
      id: json['id'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isCompleted': isCompleted,
      'progressPoints': progressPoints,
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
      'courseId': courseId,
      'user': user,
      'course': course,
      'topicProgresses': topicProgresses,
      'id': id,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
