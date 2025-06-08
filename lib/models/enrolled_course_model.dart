class EnrolledCourseModel {
  final String id;
  final String courseId;
  final bool isCompleted;
  final double progressPoints;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime updateAt;

  EnrolledCourseModel({
    required this.id,
    required this.courseId,
    required this.isCompleted,
    required this.progressPoints,
    required this.createdAt,
    required this.updatedAt,
    required this.updateAt,
  });

  factory EnrolledCourseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EnrolledCourseModel(
      id: json['id'],
      courseId: json['courseId'],
      isCompleted: json['isCompleted'],
      progressPoints: json['progressPoints'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      updateAt: DateTime.parse(json['updateAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'isCompleted': isCompleted,
      'progressPoints': progressPoints,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}
