import 'package:get/get.dart';
import 'package:english_app_with_ai/models/user_model.dart';

import '../services/abstract/i_api_service.dart';
import '../services/implement/api_service.dart';

class UserViewModel extends GetxController {
  IApiService apiService = ApiService();
  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;
      final response = await apiService.getUserInfo();
      user.value = response.result;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
