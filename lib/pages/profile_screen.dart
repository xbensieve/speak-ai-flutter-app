import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:english_app_with_ai/pages/login_page.dart';
import 'package:english_app_with_ai/view_models/login_view_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://flutter.dev');

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Get.put(LoginViewModel()); // Initialize ViewModel

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Show confirmation dialog before logout
              Get.defaultDialog(
                title: 'Logout',
                middleText: 'Are you sure you want to logout?',
                textConfirm: 'Yes',
                textCancel: 'No',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                cancelTextColor: Colors.black,
                onConfirm: () async {
                  await loginViewModel.logout(); // Clear tokens
                  Get.offAll(() => LoginPage()); // Navigate to LoginPage
                },
                onCancel: () {
                  Get.back(); // Close the dialog
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Profile Screen"),
            const SizedBox(height: 20),
            // Upgrade Account button for payment
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog before proceeding to payment
                Get.defaultDialog(
                  title: 'Upgrade Account',
                  middleText:
                      'Proceed to upgrade your account via VNPay? This is for testing purposes.',
                  textConfirm: 'Yes',
                  textCancel: 'No',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.green,
                  cancelTextColor: Colors.black,
                  onConfirm: () {
                    _launchUrl(); // Launch VNPay payment URL
                    Get.back(); // Close the dialog
                  },
                  onCancel: () {
                    Get.back(); // Close the dialog
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Upgrade Account (Test Payment)',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to add logout method to LoginViewModel
extension LogoutExtension on LoginViewModel {
  Future<void> logout() async {
    final storage = GetStorage(); // Use GetStorage for token storage
    await storage.remove('accessToken'); // Clear access token
    await storage.remove('refreshToken'); // Clear refresh token
    debugPrint('User logged out successfully.');
  }
}
