import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:english_app_with_ai/services/abstract/i_course_service.dart';
import 'package:get/get.dart';

class CourseContentViewModel extends GetxController {
  final ICourseService courseService;
  final String courseId;
  final String topicId;

  // Reactive state
  final Rx<CourseContentModel?> courseContent =
      Rx<CourseContentModel?>(null);
  final RxList<Exercise> exercises = RxList<Exercise>([]);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  CourseContentViewModel({
    required this.courseService,
    required this.courseId,
    required this.topicId,
  });

  @override
  void onInit() {
    super.onInit();
    fetchCourseContent();
  }

  Future<void> fetchCourseContent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Fetch course content using the provided courseId
      final content = await courseService.getCourseContent(
        courseId,
      );
      courseContent.value = content;

      // Filter exercises for the specified topicId
      final topic = content.result.topics.firstWhere(
        (topic) => topic.id == topicId,
        orElse:
            () =>
                throw Exception(
                  'Topic with ID $topicId not found',
                ),
      );

      exercises.assignAll(topic.exercises);
    } catch (e) {
      errorMessage.value = e.toString();
      exercises.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
