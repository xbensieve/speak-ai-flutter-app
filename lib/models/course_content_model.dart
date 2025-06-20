class CourseContentModel {
  final int statusCode;
  final String message;
  final bool isSuccess;
  final CourseResult result;

  CourseContentModel({
    required this.statusCode,
    required this.message,
    required this.isSuccess,
    required this.result,
  });

  factory CourseContentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CourseContentModel(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      isSuccess: json['isSuccess'] as bool,
      result: CourseResult.fromJson(
        json['result'] as Map<String, dynamic>,
      ),
    );
  }
}

class CourseResult {
  final String id;
  final String courseName;
  final String description;
  final double maxPoint;
  final bool isPremium;
  final bool isActive;
  final int levelId;
  final String imgUrl;
  final List<Topic> topics;

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
      maxPoint: (json['maxPoint'] as num).toDouble(),
      isPremium: json['isPremium'] as bool,
      isActive: json['isActive'] as bool,
      levelId: json['levelId'] as int,
      imgUrl: json['imgUrl'] as String,
      topics:
          (json['topics'] as List<dynamic>)
              .map(
                (topic) => Topic.fromJson(
                  topic as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class Topic {
  final String id;
  final String topicName;
  final double maxPoint;
  final bool isActive;
  final List<Exercise> exercises;

  Topic({
    required this.id,
    required this.topicName,
    required this.maxPoint,
    required this.isActive,
    required this.exercises,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      topicName: json['topicName'] as String,
      maxPoint: (json['maxPoint'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      exercises:
          (json['exercises'] as List<dynamic>)
              .map(
                (exercise) => Exercise.fromJson(
                  exercise as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class Exercise {
  final String id;
  final String content;
  final double maxPoint;
  final bool isActive;
  final List<Question> questions;

  Exercise({
    required this.id,
    required this.content,
    required this.maxPoint,
    required this.isActive,
    required this.questions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      content: json['content'] as String,
      maxPoint: (json['maxPoint'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      questions:
          (json['questions'] as List<dynamic>)
              .map(
                (question) => Question.fromJson(
                  question as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class Question {
  final String id;
  final String content;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.content,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      content: json['content'] as String,
      answers:
          (json['answers'] as List<dynamic>)
              .map(
                (answer) => Answer.fromJson(
                  answer as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}

class Answer {
  final String id;
  final String content;
  final bool isCorrect;

  Answer({
    required this.id,
    required this.content,
    required this.isCorrect,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      content: json['content'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }
}
