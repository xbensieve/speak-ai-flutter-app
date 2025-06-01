import "dart:convert";
import "package:english_app_with_ai/models/response_model.dart";
import "package:english_app_with_ai/models/user_model.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:english_app_with_ai/config/api_configuration.dart";
import "package:english_app_with_ai/models/login_request.dart";
import "package:english_app_with_ai/models/login_response.dart";

import "../../utils/decode_token.dart";
import "../abstract/i_api_service.dart";

class ApiService implements IApiService {
  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Login failed');
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
  Future<LoginResponse> loginWithGoolge(String idToken) async {
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
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}
