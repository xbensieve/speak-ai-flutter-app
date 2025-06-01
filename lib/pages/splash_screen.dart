import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:english_app_with_ai/pages/login_page.dart';
import 'package:english_app_with_ai/components/navigation_menu.dart';

import '../view_models/login_view_model.dart';
import '../view_models/user_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animation duration
    );

    // Initialize Fade Animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Initialize Scale Animation
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Start the animation
    _controller.forward();

    // Call authentication check
    _checkAuthentication();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    final loginViewModel = Get.put(LoginViewModel());
    final userViewModel = Get.put(UserViewModel());
    await Future.delayed(const Duration(seconds: 3));
    String? accessToken = loginViewModel.getAccessToken();

    if (accessToken == null) {
      Get.off(() => LoginPage());
    }

    try {
      var response = userViewModel.user.value;
      if (response != null) {
        Get.off(() => const NavigationMenu());
      } else {
        Get.off(() => LoginPage());
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
      Get.off(() => LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double logoWidth = screenWidth * 0.4;
    final double logoHeight = screenHeight * 0.2;

    return Scaffold(
      body: Container(
        color: const Color(0xFF1e3a8a),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: logoWidth + 20,
                    height: logoHeight + 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'lib/assets/images/EchoNexus.png',
                      fit: BoxFit.contain,
                      width: logoWidth,
                      height: logoHeight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Echo Nexus',
                  style: GoogleFonts.dancingScript(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
