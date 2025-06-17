class Topic {
  final String id;
  final double progress;
  final bool isCompleted;
  final String enrolledCourseId;
  final String topicName;

  Topic({
    required this.id,
    required this.progress,
    required this.isCompleted,
    required this.enrolledCourseId,
    required this.topicName,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      progress: json['progress'],
      isCompleted: json['isCompleted'],
      enrolledCourseId: json['enrolledCourseId'],
      topicName: json['topicName'],
    );
  }
}
