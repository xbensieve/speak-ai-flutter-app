import 'package:english_app_with_ai/pages/premium_intro_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      title: 'Confirmation',
      titleStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      middleText: 'Are you sure? You cannot undo this action.',
      middleTextStyle: GoogleFonts.roboto(fontSize: 18, color: Colors.black),
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: Colors.blue,
      cancelTextColor: Colors.black,
      backgroundColor: Colors.white,
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
            return const Center(child: CupertinoActivityIndicator(radius: 20));
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
                      // Extra padding at the bottom
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text(
                "No user info available",
                style: GoogleFonts.roboto(
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
    final daysRemaining = user.premiumExpiredTime?.difference(now).inDays;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PROFILE',
            style: GoogleFonts.roboto(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "lib/assets/images/female-avatar.png",
                      width: 400,
                      height: 120,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.userName,
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      daysRemaining != null
                          ? 'Your plan: $daysRemaining Days Remaining'
                          : 'Your plan: Free',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(width: 50), // space between text and button
                    _buildGetAccountProButton(),
                  ],
                ),
              ),
            ],
          ),
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
              child: ListTile(
                title: Text(
                  option,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: isLogout ? Colors.red : Colors.white,
                    fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
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
            );
          }).toList(),
    );
  }

  Widget _buildGetAccountProButton() {
    return ElevatedButton(
      onPressed: () {
        Get.to(() => const PremiumIntroPage());
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.yellow, width: 1.5),
        ),
        elevation: 2,
      ),
      child: Text(
        'Upgrade',
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
