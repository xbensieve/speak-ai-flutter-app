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
  var selectedCourse = Rxn<CourseModel>();
  var enrollmentStatus = Rxn<String?>();

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

  void fetchCourseById(String courseId) async {
    if (courseId.isEmpty) {
      error.value = 'Course ID cannot be null';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      final response = await apiService.getCourseById(
        courseId,
      );
      if (response != null) {
        selectedCourse.value = response.result;
      } else {
        error.value = 'Course not found';
      }
    } catch (e) {
      error.value = 'Failed to load course: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void checkEnrolledCourse(String courseId) async {
    if (courseId.isEmpty) {
      error.value = 'Course ID cannot be null';
      return;
    }

    isLoading.value = true;
    error.value = '';

    try {
      final enrolledCourseId = await apiService
          .checkEnrolledCourse(courseId);
      enrollmentStatus.value = enrolledCourseId;
    } catch (e) {
      error.value = 'Failed to check enrollment: $e';
      enrollmentStatus.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> enrollCourse(String courseId) async {
    if (courseId.isEmpty) {
      error.value = 'Course ID cannot be null';
      return false;
    }
    isLoading.value = true;
    error.value = '';
    try {
      final success = await apiService.enrollCourse(
        courseId,
      );
      print(success);
      if (success) {
        checkEnrolledCourse(courseId);
        return true;
      } else {
        error.value = 'Enrollment failed';
        return false;
      }
    } catch (e) {
      error.value = 'Failed to enroll course: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
