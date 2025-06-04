import 'package:english_app_with_ai/components/navigation_menu.dart';
import 'package:english_app_with_ai/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward();

    _checkAuthentication();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthentication() async {
    Get.lazyPut(() => LoginViewModel());
    Get.lazyPut(() => UserViewModel());

    await Future.delayed(const Duration(seconds: 3));

    String? accessToken =
        Get.find<LoginViewModel>().getAccessToken();
    if (accessToken == null) {
      Get.off(() => LoginPage());
    } else {
      Get.off(() => const NavigationMenu());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset(
                    'lib/assets/images/1.png',
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
