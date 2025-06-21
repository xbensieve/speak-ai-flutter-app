import "dart:convert";

import "package:english_app_with_ai/config/api_configuration.dart";
import "package:english_app_with_ai/models/api_response_model.dart";
import "package:english_app_with_ai/models/course_model.dart";
import "package:english_app_with_ai/models/course_response_model.dart";
import "package:english_app_with_ai/models/enrolled_course.dart";
import "package:english_app_with_ai/models/login_request.dart";
import "package:english_app_with_ai/models/login_response.dart";
import "package:english_app_with_ai/models/query_model.dart";
import "package:http/http.dart" as http;

import "../../models/course_detail_model.dart";
import "../../models/response_model.dart";
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
  Future<LoginResponse> registerCustomer({
    required String userName,
    required String password,
    required String confirmedPassword,
    required String email,
    required String fullName,
    required String birthday,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.registerCustomerEndpoint}',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': userName,
          'password': password,
          'confirmedPassword': confirmedPassword,
          'email': email,
          'fullName': fullName,
          'birthday': birthday,
          'gender': gender,
        }),
      );
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<ResponseModel<UserModel>> getUserInfo() async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    print(userId);
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

  @override
  Future<ResponseModel<CourseResult>?> getCourseById(
    String courseId,
  ) async {
    if (courseId == null) {
      throw Exception("CourseId cannot null");
    }
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.getCourseByIdEndpoint}$courseId/details',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ResponseModel<CourseResult>.fromJson(
          jsonData,
          (json) => CourseResult.fromJson(json),
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to load course: $e');
    }
  }

  @override
  Future<String?> createOrder() async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.createOrderEndpoint}/$userId',
    );
    try {
      final response = await http.post(url);
      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['result'];
      }
      throw Exception('Create order failed');
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<String?> createPayment(
    String orderId,
    String paymentMethod,
  ) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.createPaymentEndpoint}',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'orderId': orderId,
          'paymentMethod': paymentMethod,
        }),
      );
      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData['result'];
      }
      throw Exception('Create payment failed');
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  @override
  Future<bool> confirmPayment(String orderId) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.confirmPaymentEndpoint}/$orderId',
    );
    try {
      final response = await http.post(url);
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        if (jsonData["isSuccess"] == true) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }

  @override
  Future<String?> checkEnrolledCourse(
    String courseId,
  ) async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.checkEnrolledCourseEndpoint}/$userId/courses/$courseId/enrollment-status',
    );
    try {
      final response = await http.get(url);
      final jsonData = jsonDecode(response.body);
      if (jsonData['result'] == null) {
        return null;
      }
      return jsonData['result']['enrolledCourseId'];
    } catch (e) {
      throw Exception(
        'Failed to check enrolled course: $e',
      );
    }
  }

  @override
  Future<bool> enrollCourse(String courseId) async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.enrollCourseEndpoint}/$courseId/enrollments',
    );
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userId),
      );
      if (response.statusCode == 201 ||
          response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Failed to enroll course: $e');
    }
  }

  @override
  Future<ResponseModel<List<EnrolledCourseModel>>>
  getEnrolledCourses() async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.getEnrolledCoursesEndpoint}/$userId/enrolled-courses',
    );
    try {
      final response = await http.get(url);

      final jsonData = jsonDecode(response.body);

      return ResponseModel<List<EnrolledCourseModel>>(
        statusCode: jsonData['statusCode'],
        message: jsonData['message'],
        isSuccess: jsonData['isSuccess'],
        result:
            (jsonData['result'] as List)
                .map(
                  (item) =>
                      EnrolledCourseModel.fromJson(item),
                )
                .toList(),
      );
    } catch (e) {
      throw Exception('Failed to get enrolled courses: $e');
    }
  }

  @override
  Future<ApiResponse> getEnrolledCourseTopics(
    String enrolledCourseId,
  ) async {
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.getEnrolledCourseTopicEndpoint}$enrolledCourseId',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData =
            jsonDecode(response.body)
                as Map<String, dynamic>;
        print(jsonData);
        return ApiResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to fetch enrollment: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to get enrolled course topics: $e',
      );
    }
  }

  @override
  Future<LoginResponse> confirmEmail(String otp) async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.confirmOtpEndpoint}?userId=$userId&otpCode=$otp',
    );
    try {
      final response = await http.post(url);
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    } catch (e) {
      throw Exception('Failed to confirm email: $e');
    }
  }

  @override
  Future<LoginResponse> sendOtpToEmail() async {
    final tokenData = getDecodedAccessToken();
    if (tokenData == null) throw Exception('Invalid token');
    String? userId = tokenData['Id'];
    final url = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.confirmEmailEndpoint}?userID=$userId',
    );
    try {
      final response = await http.post(url);
      return LoginResponse.fromJson(
        jsonDecode(response.body),
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }
}
