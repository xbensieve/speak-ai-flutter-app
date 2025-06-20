import "package:english_app_with_ai/models/api_response_model.dart";
import "package:english_app_with_ai/models/course_model.dart";
import "package:english_app_with_ai/models/course_response_model.dart";
import "package:english_app_with_ai/models/enrolled_course.dart";
import "package:english_app_with_ai/models/login_request.dart";
import "package:english_app_with_ai/models/login_response.dart";
import "package:english_app_with_ai/models/response_model.dart";

import "../../models/course_detail_model.dart";
import "../../models/query_model.dart";
import "../../models/user_model.dart";

abstract class IApiService {
  Future<LoginResponse> login(LoginRequest request);

  Future<LoginResponse> registerCustomer({
    required String userName,
    required String password,
    required String confirmedPassword,
    required String email,
    required String fullName,
    required String birthday,
    required String gender,
  });

  Future<LoginResponse> loginWithGoogle(String idToken);

  Future<ResponseModel<UserModel>> getUserInfo();

  Future<ResponseModel<CourseResponseModel<CourseModel>>>
  getCourses(QueryModel query);

  Future<String?> getScenarioByTopicId(int topicId);

  Future<ResponseModel<CourseResult>?> getCourseById(
    String courseId,
  );

  Future<String?> checkEnrolledCourse(String courseId);

  Future<bool> enrollCourse(String courseId);

  Future<ResponseModel<List<EnrolledCourseModel>>>
  getEnrolledCourses();

  Future<ApiResponse> getEnrolledCourseTopics(
    String courseId,
  );

  Future<String?> createOrder();

  Future<String?> createPayment(
    String orderId,
    String paymentMethod,
  );

  Future<bool> confirmPayment(String orderId);
}
