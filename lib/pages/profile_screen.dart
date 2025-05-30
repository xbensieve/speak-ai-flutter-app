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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF007BFF), Color(0xFF87CEFA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Obx(() {
                  if (userViewModel.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userViewModel.user.value != null) {
                    final user = userViewModel.user.value!;
                    return RefreshIndicator(
                      onRefresh: () async => _loadUser(),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildProfileHeader(user),
                          const SizedBox(height: 24),
                          _buildInfoCard(user),
                          const SizedBox(height: 24),
                          _buildUpgradeButton(),
                        ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Profile',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Get.defaultDialog(
                title: 'Logout',
                titleStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                middleText: 'Are you sure you want to logout?',
                middleTextStyle: GoogleFonts.inter(fontSize: 16),
                textConfirm: 'Yes',
                textCancel: 'No',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                cancelTextColor: Colors.black87,
                onConfirm: () {
                  loginViewModel.logout();
                  Get.offAll(() => const LoginPage());
                },
                onCancel: () => Get.back(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              user.fullName[0].toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF007BFF),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Username', user.userName),
            _buildDivider(),
            _buildInfoRow('Verified', user.isVerified ? 'Yes' : 'No'),
            _buildDivider(),
            _buildInfoRow('Premium', user.isPremium ? 'Yes' : 'No'),
            _buildDivider(),
            _buildInfoRow('Points', user.point.toString()),
            _buildDivider(),
            _buildInfoRow('Level', user.levelName),
            _buildDivider(),
            _buildInfoRow('Birthday', user.birthday.toString().split(' ')[0]),
            _buildDivider(),
            _buildInfoRow('Gender', user.gender),
            if (user.premiumExpiredTime != null) ...[
              _buildDivider(),
              _buildInfoRow(
                'Premium Expires',
                user.premiumExpiredTime.toString().split(' ')[0],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 1, thickness: 1);
  }

  Widget _buildUpgradeButton() {
    return ElevatedButton(
      onPressed: () {
        Get.defaultDialog(
          title: 'Upgrade Account',
          titleStyle: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          middleText: 'Proceed to upgrade your account via VNPay?',
          middleTextStyle: GoogleFonts.inter(fontSize: 16),
          textConfirm: 'Yes',
          textCancel: 'No',
          confirmTextColor: Colors.white,
          buttonColor: Colors.green,
          cancelTextColor: Colors.black87,
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
        'Upgrade to Premium',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
