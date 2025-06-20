import 'dart:convert';

import 'package:english_app_with_ai/models/course_content_model.dart';
import 'package:english_app_with_ai/models/response_model.dart';
import 'package:english_app_with_ai/services/abstract/i_course_service.dart';
import 'package:http/http.dart' as http;

import '../../config/api_configuration.dart';
import '../../utils/decode_token.dart';

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

  @override
  Future<ResponseModel> submitAnswer(
    String exerciseId,
    double earnedPoints,
  ) async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.submitAnswerEndpoint}$exerciseId/submissions',
    );
    final body = jsonEncode({
      'userId': '$userId',
      'earnedPoints': earnedPoints,
    });
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      return ResponseModel.fromJson(
        jsonDecode(response.body),
        (json) => null,
      );
    }
    throw Exception('Failed to submit answer');
  }
}
