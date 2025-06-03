import 'package:english_app_with_ai/services/abstract/i_api_service.dart';
import 'package:get/get.dart';

import '../models/course_model.dart';
import '../models/query_model.dart';
import '../services/implement/api_service.dart';

class CourseViewModel extends GetxController {
  IApiService apiService = ApiService();

  var courses = <CourseModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  // Example default query
  final query = QueryModel(pageNumber: 1, pageSize: 10);

  void fetchCourses() async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await apiService.getCourses(query);
      courses.value = response.result.data;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
