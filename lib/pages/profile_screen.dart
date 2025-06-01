import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:english_app_with_ai/pages/login_page.dart';
import 'package:english_app_with_ai/view_models/login_view_model.dart';
import 'package:english_app_with_ai/view_models/user_view_model.dart';

final Uri _url = Uri.parse(
  'https://sandbox.vnpayment.vn/paymentv2/Payment/Error.html?code=03',
);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final loginViewModel = Get.put(LoginViewModel());
  final userViewModel = Get.put(UserViewModel());

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    userViewModel.fetchUserInfo();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _logout() {
    Get.defaultDialog(
      title: 'Log Out',
      titleStyle: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      middleText: 'Are you sure you want to log out?',
      middleTextStyle: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.white70,
      backgroundColor: Colors.grey[900],
      onConfirm: () {
        loginViewModel.logout();
        Get.offAll(() => const LoginPage());
      },
      onCancel: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (userViewModel.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (userViewModel.user.value != null) {
            final user = userViewModel.user.value!;
            return RefreshIndicator(
              onRefresh: () async => _loadUser(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(user),
                      const SizedBox(height: 16),
                      _buildOptionsList(),
                      const SizedBox(height: 16),
                      if (user.premiumExpiredTime == null)
                        _buildGetAccountProButton(),
                      const SizedBox(height: 24), // Extra padding at the bottom
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "No user info available",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _buildHeader(user) {
    final now = DateTime(2025, 5, 31);
    final daysRemaining =
        user.premiumExpiredTime != null
            ? user.premiumExpiredTime.difference(now).inDays
            : null;
    return Column(
      children: [
        Text(
          'YOUR PROFILE',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: const Icon(Icons.star, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          user.userName,
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          daysRemaining != null
              ? 'Account: $daysRemaining Days Remaining'
              : 'Account: Not Premium',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildOptionsList() {
    final options = [
      'Edit your profile',
      'Learning & Sound settings',
      'Feedback & Sharing',
      'Notifications',
      'Terms',
      'Policy',
      'Log out',
    ];

    return Column(
      children:
          options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isLogout = option == 'Log out';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                child: ListTile(
                  title: Text(
                    option,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: isLogout ? Colors.red : Colors.white,
                      fontWeight:
                          isLogout ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isLogout ? Colors.red : Colors.white70,
                  ),
                  onTap: () {
                    if (isLogout) {
                      _logout();
                    } else {
                      Get.snackbar(
                        'Tapped',
                        'Selected $option',
                        backgroundColor: Colors.grey[800],
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildGetAccountProButton() {
    return ElevatedButton(
      onPressed: () {
        Get.defaultDialog(
          title: 'Upgrade Account',
          titleStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          middleText: 'Proceed to upgrade your account via VNPay?',
          middleTextStyle: GoogleFonts.inter(
            fontSize: 16,
            color: Colors.white70,
          ),
          textConfirm: 'Yes',
          textCancel: 'No',
          confirmTextColor: Colors.white,
          buttonColor: Colors.green,
          cancelTextColor: Colors.white70,
          backgroundColor: Colors.grey[900],
          onConfirm: () {
            _launchUrl();
            Get.back();
          },
          onCancel: () => Get.back(),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(
        'Get Account Pro',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
