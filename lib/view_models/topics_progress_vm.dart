import 'package:english_app_with_ai/models/api_response_model.dart';
import 'package:english_app_with_ai/services/abstract/i_api_service.dart';
import 'package:get/get.dart';

import '../services/implement/api_service.dart';

class TopicProgressVM extends GetxController {
  final IApiService apiService = ApiService();

  RxList<Topic> topics = <Topic>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchTopics(String courseId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await apiService
          .getEnrolledCourseTopics(courseId);
      topics.assignAll(response.result.topics);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
    }
  }
}
