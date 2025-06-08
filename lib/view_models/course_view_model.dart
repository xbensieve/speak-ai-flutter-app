import 'package:english_app_with_ai/models/enrolled_course_model.dart';
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
  var enrolledCourses = <CourseModel>[].obs;

  final query = QueryModel(pageNumber: 1, pageSize: 10);
  int _retryCount = 0;
  static const int _maxRetries = 3;

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

  Future<List<EnrolledCourseModel>>
  getEnrolledCourses() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response =
          await apiService.getEnrolledCourses();
      return response.result;
    } catch (e) {
      error.value = 'Failed to get enrolled courses: $e';
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllEnrolledCourseDetails() async {
    if (isLoading.value) return;

    isLoading.value = true;
    error.value = '';
    _retryCount = 0;

    while (_retryCount < _maxRetries) {
      try {
        final enrolledList =
            await apiService.getEnrolledCourses();
        final courseList = <CourseModel>[];

        await Future.wait(
          enrolledList.result.map((enrolled) async {
            try {
              final courseResponse = await apiService
                  .getCourseById(enrolled.courseId);
              if (courseResponse?.result != null) {
                courseList.add(courseResponse!.result!);
              }
            } catch (e) {
              print(
                'Error fetching course ${enrolled.courseId}: $e',
              );
            }
          }),
          eagerError: true,
        );

        enrolledCourses.assignAll(courseList);
        break; // Exit loop on success
      } catch (e) {
        _retryCount++;
        if (_retryCount == _maxRetries) {
          error.value = _handleNetworkError(e);
        }
        await Future.delayed(
          Duration(seconds: _retryCount),
        ); // Exponential backoff
      }
    }

    if (_retryCount == _maxRetries) {
      error.value =
          'Failed to load enrolled courses after $_maxRetries attempts';
    }

    isLoading.value = false;
  }

  String _handleNetworkError(dynamic e) {
    if (e.toString().contains('Connection reset by peer')) {
      return 'Network connection failed. Please check your internet connection and try again.';
    }
    return 'An error occurred: $e';
  }
}
