import 'package:english_app_with_ai/models/course_content_model.dart';

abstract class ICourseService {
  Future<CourseContentModel> getCourseContent(
    String courseId,
  );
}
