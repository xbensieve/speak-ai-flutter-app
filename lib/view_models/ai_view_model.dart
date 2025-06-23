import 'package:english_app_with_ai/services/abstract/i_api_service.dart';
import 'package:english_app_with_ai/services/implement/api_service.dart';
import 'package:get/get.dart';

class AIViewModel extends GetxController {
  IApiService apiService = ApiService();

  var isLoading = false.obs;

  Future<String?> getScenarioByTopicId(int topicId) async {
    try {
      isLoading.value = true;
      final response = await apiService
          .getScenarioByTopicId(topicId);
      isLoading.value = false;
      return response;
    } catch (e) {
      isLoading.value = false;
      return null;
    }
  }
}
