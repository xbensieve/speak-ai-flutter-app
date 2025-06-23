import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:english_app_with_ai/models/response_model.dart';

abstract class ICourseService {
  Future<CourseContentModel> getCourseContent(
    String courseId,
  );

  Future<ResponseModel<dynamic>> submitAnswer(
    String exerciseId,
    double earnedPoints,
  );
}
