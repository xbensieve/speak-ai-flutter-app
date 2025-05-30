import "package:english_app_with_ai/models/login_request.dart";
import "package:english_app_with_ai/models/login_response.dart";
import "package:english_app_with_ai/models/response_model.dart";
import "package:english_app_with_ai/models/user_model.dart";

abstract class IApiService {
  Future<LoginResponse> login(LoginRequest request);
  Future<ResponseModel<UserModel>> getUserInfo();
}
