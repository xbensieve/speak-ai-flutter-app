import 'dart:convert';

import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:english_app_with_ai/services/abstract/i_course_service.dart';
import 'package:http/http.dart' as http;

import '../../config/api_configuration.dart';

class CourseService implements ICourseService {
  @override
  Future<CourseContentModel> getCourseContent(
    String courseId,
  ) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.getCourseByIdEndpoint}$courseId/details',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CourseContentModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to fetch course content: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching course content: $e');
    }
  }
}
