import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/login_request.dart';
import '../services/api_service.dart';

class LoginViewModel extends GetxController {
  final ApiService _apiService = ApiService();
  final storage = GetStorage();
  var isLoading = false.obs;

  Future<bool> signIn(String username, String password) async {
    try {
      isLoading.value = true;
      final request = LoginRequest(userName: username, password: password);
      final response = await ApiService.login(request);

      if (response.isSuccess && response.result != null) {
        // Store tokens securely
        await storage.write('accessToken', response.result!.accessToken);
        await storage.write('refreshToken', response.result!.refreshToken);
        debugPrint(
          'Sign-in successful! Token: ${response.result!.accessToken}',
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Optional: Method to retrieve the access token later
  String? getAccessToken() {
    return storage.read('accessToken');
  }

  String? getRefreshToken() {
    return storage.read('refreshToken');
  }
}
