class ApiResponse {
  final int statusCode;
  final String message;
  final bool isSuccess;
  final Result result;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.isSuccess,
    required this.result,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      isSuccess: json['isSuccess'] as bool,
      result: Result.fromJson(
        json['result'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'isSuccess': isSuccess,
      'result': result.toJson(),
    };
  }
}

class Result {
  final Course course;
  final int progress;
  final List<Topic> topics;

  Result({
    required this.course,
    required this.progress,
    required this.topics,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      course: Course.fromJson(
        json['course'] as Map<String, dynamic>,
      ),
      progress:
          (json['progress'] is int)
              ? json['progress'] as int
              : (json['progress'] as double).toInt(),
      topics:
          (json['topics'] as List<dynamic>?)
              ?.map(
                (e) => Topic.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'course': course.toJson(),
      'progress': progress,
      'topics': topics.map((e) => e.toJson()).toList(),
    };
  }
}

class Course {
  final String id;
  final String courseName;
  final String description;
  final int maxPoint;
  final bool isPremium;
  final bool isActive;
  final int levelId;
  final String? imgUrl;
  final List<dynamic>? topics;

  Course({
    required this.id,
    required this.courseName,
    required this.description,
    required this.maxPoint,
    required this.isPremium,
    required this.isActive,
    required this.levelId,
    this.imgUrl,
    this.topics,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      description: json['description'] as String,
      maxPoint:
          (json['maxPoint'] is int)
              ? json['maxPoint'] as int
              : (json['maxPoint'] as double).toInt(),
      isPremium: json['isPremium'] as bool,
      isActive: json['isActive'] as bool,
      levelId:
          (json['levelId'] is int)
              ? json['levelId'] as int
              : (json['levelId'] as double).toInt(),
      imgUrl: json['imgUrl'] as String?,
      topics: json['topics'] as List<dynamic>?,
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

class Topic {
  final String id;
  final int progress;
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
      id: json['id'] as String,
      progress:
          (json['progress'] is int)
              ? json['progress'] as int
              : (json['progress'] as double).toInt(),
      isCompleted: json['isCompleted'] as bool,
      enrolledCourseId: json['enrolledCourseId'] as String,
      topicName: json['topicName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'progress': progress,
      'isCompleted': isCompleted,
      'enrolledCourseId': enrolledCourseId,
      'topicName': topicName,
    };
  }
}
