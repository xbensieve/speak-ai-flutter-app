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
          '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackStyle: SnackStyle.FLOATING,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
          animationDuration: Duration(milliseconds: 700),
          forwardAnimationCurve: Curves.easeInOut,
          reverseAnimationCurve: Curves.easeInOut,
          messageText: Text(
            'Invalid username or password',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      Get.snackbar(
        'Error',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        animationDuration: Duration(milliseconds: 700),
        forwardAnimationCurve: Curves.easeInOut,
        reverseAnimationCurve: Curves.easeInOut,
        messageText: Text(
          'Please fill in both username and password',
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return false;
    } finally {
      isLoading.value = false;
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
