import 'package:english_app_with_ai/pages/login_page.dart';
import 'package:english_app_with_ai/pages/premium_intro_screen.dart';
import 'package:english_app_with_ai/view_models/login_view_model.dart';
import 'package:english_app_with_ai/view_models/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/payment_view_model.dart';
import 'otp_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
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

  void _logout() {
    Get.defaultDialog(
      title: 'Confirmation',
      titleStyle: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      middleText:
          'Are you sure? You cannot undo this action.',
      middleTextStyle: GoogleFonts.roboto(
        fontSize: 18,
        color: Colors.black,
      ),
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
      onCancel: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width;
    final double screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (userViewModel.isLoading.value) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: Colors.white,
              ),
            );
          } else if (userViewModel.user.value != null) {
            final user = userViewModel.user.value!;
            return RefreshIndicator(
              onRefresh: () async => _loadUser(),
              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.01,
                  ),
                  child: Column(
                    children: [
                      _buildHeader(
                        user,
                        screenWidth,
                        screenHeight,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      _buildOptionsList(),
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
                  fontSize: screenWidth * 0.045,
                  // Responsive font size
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

  Widget _buildHeader(
    user,
    double screenWidth,
    double screenHeight,
  ) {
    final now = DateTime(
      2025,
      6,
      21,
      18,
      10,
    ); // Updated to current date and time: 06:10 PM +07
    final daysRemaining =
        user.premiumExpiredTime?.difference(now).inDays;
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'PROFILE',
            style: GoogleFonts.roboto(
              fontSize: screenWidth * 0.0625,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.015),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(
                  screenWidth * 0.025,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.05,
                  ),
                  border: Border.all(
                    color: Colors.white24,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      user.gender.toLowerCase() == "male"
                          ? "lib/assets/images/male-avatar.png"
                          : "lib/assets/images/female-avatar.png",
                      width: size.width * 0.5,
                      height: size.height * 0.15,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          user.userName,
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.0625,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (user.isVerified)
                          Icon(
                            Icons.verified,
                            color: Colors.green,
                            size: screenWidth * 0.05,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: screenWidth * 0.9,
                padding: EdgeInsets.all(
                  screenWidth * 0.025,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      daysRemaining != null
                          ? 'Your plan: $daysRemaining Days'
                          : 'Your plan: Free',
                      style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.04,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    if (!user.isPremium)
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.01,
                        ),
                        child: _buildGetAccountProButton(
                          screenWidth,
                          screenHeight,
                        ),
                      ),
                    if (!user.isVerified)
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.01,
                        ),
                        child: _buildVerifyButton(
                          screenWidth,
                          screenHeight,
                        ),
                      ),
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
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: ListTile(
                title: Text(
                  option,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color:
                        isLogout
                            ? Colors.red
                            : Colors.white,
                    fontWeight:
                        isLogout
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color:
                      isLogout
                          ? Colors.red
                          : Colors.white70,
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

  Widget _buildGetAccountProButton(
    double screenWidth,
    double screenHeight,
  ) {
    final paymentViewModel = Get.put(PaymentViewModel());

    return ElevatedButton(
      onPressed: () {
        Get.to(() => const PremiumIntroPage());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.015,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            screenWidth * 0.03,
          ),
          side: const BorderSide(
            color: Colors.yellow,
            width: 1.5,
          ),
        ),
        elevation: 2,
        minimumSize: Size(
          screenWidth * 2,
          screenHeight * 0.05,
        ),
      ),
      child: Text(
        'Upgrade',
        style: GoogleFonts.roboto(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ),
      ),
    );
  }

  Widget _buildVerifyButton(
    double screenWidth,
    double screenHeight,
  ) {
    return ElevatedButton(
      onPressed: () {
        Get.to(() => const OTPScreen());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.015,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            screenWidth * 0.03,
          ),
          side: const BorderSide(
            color: Colors.blue,
            width: 1.5,
          ),
        ),
        elevation: 2,
        minimumSize: Size(
          screenWidth * 2,
          screenHeight * 0.05,
        ),
      ),
      child: Text(
        'Verify Email',
        style: GoogleFonts.roboto(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}
