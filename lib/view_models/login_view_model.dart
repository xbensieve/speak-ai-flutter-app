import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/login_request.dart';
import '../services/abstract/i_api_service.dart';
import '../services/implement/api_service.dart';

class LoginViewModel extends GetxController {
  IApiService apiService = ApiService();
  final storage = GetStorage();
  var isLoading = false.obs;

  Future<bool> signIn(String username, String password) async {
    try {
      isLoading.value = true;
      final request = LoginRequest(userName: username, password: password);
      final response = await apiService.login(request);

      if (response.isSuccess && response.result != null) {
        await storage.write('accessToken', response.result!.accessToken);
        await storage.write('refreshToken', response.result!.refreshToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle(String idToken) async {
    try {
      final response = await apiService.loginWithGoolge(idToken);
      if (response.isSuccess && response.result != null) {
        await storage.write('accessToken', response.result!.accessToken);
        await storage.write('refreshToken', response.result!.refreshToken);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      return false;
    }
  }

  String? getAccessToken() {
    return storage.read('accessToken');
  }

  String? getRefreshToken() {
    return storage.read('refreshToken');
  }

  void logout() {
    storage.remove('accessToken');
    storage.remove('refreshToken');
  }
}
