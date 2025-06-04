import "dart:convert";

import "package:english_app_with_ai/config/api_configuration.dart";
import "package:english_app_with_ai/models/course_model.dart";
import "package:english_app_with_ai/models/course_response_model.dart";
import "package:english_app_with_ai/models/login_request.dart";
import "package:english_app_with_ai/models/login_response.dart";
import "package:english_app_with_ai/models/query_model.dart";
import "package:english_app_with_ai/models/response_model.dart";
import "package:http/http.dart" as http;

import "../../models/user_model.dart";
import "../../utils/decode_token.dart";
import "../abstract/i_api_service.dart";

class ApiService implements IApiService {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
          errorResponse['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<ResponseModel<UserModel>> getUserInfo() async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.userInfoEndpoint}/$userId',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(
          jsonDecode(response.body),
          (json) => UserModel.fromJson(json),
        );
      }
      throw Exception('Get user info failed');
    } catch (e) {
      throw Exception('Get user info error: $e');
    }
  }

  @override
  Future<LoginResponse> loginWithGoogle(
    String idToken,
  ) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.loginGoogleEndpoint}',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(
          jsonDecode(response.body),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
          errorResponse['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<ResponseModel<CourseResponseModel<CourseModel>>>
  getCourses(QueryModel query) async {
    final queryParams = {
      if (query.pageNumber != null)
        'PageNumber': query.pageNumber.toString(),
      if (query.pageSize != null)
        'PageSize': query.pageSize.toString(),
      if (query.sortBy != null) 'SortBy': query.sortBy,
      if (query.sortDescending != null)
        'SortDescending': query.sortDescending.toString(),
      if (query.keyword != null) 'Keyword': query.keyword,
      if (query.levelId != null)
        'LevelId': query.levelId.toString(),
      if (query.isPremium != null)
        'IsPremium': query.isPremium.toString(),
      if (query.isActive != null)
        'IsActive': query.isActive.toString(),
    };

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.coursesEndpoint}',
    ).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ResponseModel<
          CourseResponseModel<CourseModel>
        >.fromJson(
          jsonData,
          (data) =>
              CourseResponseModel<CourseModel>.fromJson(
                data,
                (item) => CourseModel.fromJson(item),
              ),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
          errorResponse['message'] ??
              'Unknown error occurred',
        );
      }
    } catch (e) {
      throw Exception('Failed to load courses: $e');
    }
  }

  @override
  Future<String?> getScenarioByTopicId(int topicId) async {
    if (topicId <= 0) {
      throw Exception('Invalid topicId');
    }
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.topicsEndpoint}',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'topicId': topicId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['scenarioPrompt'] as String?;
      } else {
        throw Exception(
          'API error: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load scenario: $e');
    }
  }
}
