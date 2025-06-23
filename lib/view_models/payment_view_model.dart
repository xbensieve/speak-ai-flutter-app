import 'package:english_app_with_ai/components/navigation_menu.dart';
import 'package:english_app_with_ai/services/abstract/i_api_service.dart';
import 'package:english_app_with_ai/services/implement/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class PaymentViewModel extends GetxController {
  IApiService apiService = ApiService();
  var isLoading = false.obs;
  var orderId = ''.obs;

  Future<String?> processPayment({
    String paymentMethod = 'PayOs',
  }) async {
    try {
      isLoading.value = true;
      debugPrint("Create order processing...");
      final orderResponse = await apiService.createOrder();
      if (orderResponse != null) {
        orderId.value = orderResponse;
        debugPrint("Create payment processing...");
        final paymentResponse = await apiService
            .createPayment(orderId.value, paymentMethod);
        if (paymentResponse != null) {
          return paymentResponse;
        } else {
          throw Exception(
            'Payment creation returned null result',
          );
        }
      } else {
        throw Exception(
          'Order creation returned null result',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to process payment: $e',
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handlePaymentSuccess(
    String paymentId,
  ) async {
    try {
      isLoading.value = true;
      final result = await confirmPayment();

      if (result) {
        Get.offAll(() => NavigationMenu());
      } else {
        Get.snackbar(
          'Error',
          'Payment confirmation failed',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to handle payment success: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> confirmPayment() async {
    try {
      final result = await apiService.confirmPayment(
        orderId.value,
      );
      return result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to confirm payment: $e',
      );
      return false;
    }
  }

  Future<bool> handlePaymentResponse(
    String transactionInfo,
    String transactionNumber,
  ) async {
    try {
      final result = await apiService.handlePaymentResponse(
        transactionInfo,
        transactionNumber,
      );
      return result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to handle payment response: $e',
      );
      return false;
    }
  }
}
