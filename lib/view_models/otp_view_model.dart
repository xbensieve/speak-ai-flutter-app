import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/abstract/i_api_service.dart';
import '../services/implement/api_service.dart';

class OtpViewModel extends GetxController {
  IApiService apiService = ApiService();
  var isLoading = false.obs;

  Future<void> sendOtp() async {
    try {
      isLoading.value = true;
      final response = await apiService.sendOtpToEmail();
      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'OTP sent to your email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to send OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> confirmOtp(String otp) async {
    try {
      isLoading.value = true;
      final response = await apiService.confirmEmail(otp);
      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Email verified successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Invalid OTP',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to verify OTP: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
