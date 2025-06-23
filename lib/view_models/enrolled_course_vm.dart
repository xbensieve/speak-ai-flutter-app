import 'package:english_app_with_ai/services/implement/api_service.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/enrolled_course.dart';
import '../services/abstract/i_api_service.dart';

class EnrolledCourseViewModel extends GetxController {
  final IApiService _apiService = ApiService();

  // Observable variables for state management
  final RxList<EnrolledCourseModel> enrolledCourses =
      <EnrolledCourseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response =
          await _apiService.getEnrolledCourses();

      if (response.isSuccess) {
        enrolledCourses.assignAll(response.result ?? []);
      } else {
        errorMessage.value =
            response.message ??
            'Failed to load enrolled courses';
      }
    } catch (e) {
      errorMessage.value =
          'Error fetching enrolled courses: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Method to refresh the data
  Future<void> refreshEnrolledCourses() async {
    enrolledCourses.clear();
    await fetchEnrolledCourses();
  }
}
