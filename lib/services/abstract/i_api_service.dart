import "package:english_app_with_ai/models/course_model.dart";
import "package:english_app_with_ai/models/course_response_model.dart";
import "package:english_app_with_ai/models/login_request.dart";
import "package:english_app_with_ai/models/login_response.dart";
import "package:english_app_with_ai/models/response_model.dart";

import "../../models/query_model.dart";
import "../../models/user_model.dart";

abstract class IApiService {
  Future<LoginResponse> login(LoginRequest request);
  Future<LoginResponse> loginWithGoogle(String idToken);
  Future<ResponseModel<UserModel>> getUserInfo();
  Future<ResponseModel<CourseResponseModel<CourseModel>>> getCourses(
    QueryModel query,
  );
}
