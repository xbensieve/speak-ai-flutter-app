import 'package:english_app_with_ai/components/navigation_menu.dart';
import 'package:english_app_with_ai/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _checkAuthentication();
  }

  void _initializeVideo() {
    _videoController = VideoPlayerController.asset('lib/assets/splash_video.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController.setLooping(true);
          _videoController.play();
          debugPrint('Video initialized and playing');
        }
      }).catchError((error) {
        debugPrint('Error initializing video: $error');
        if (mounted) {
          setState(() {
            _isVideoInitialized = false;
          });
        }
      });
  }

  Future<void> _checkAuthentication() async {
    try {
      await Future.delayed(const Duration(seconds: 15));
      bool hasAccessToken = await _mockCheckAccessToken();
      debugPrint('Access token check result: $hasAccessToken');

      if (hasAccessToken) {
        debugPrint('Navigating to NavigationMenu');
        Get.off(() => const NavigationMenu());
      } else {
        debugPrint('Navigating to LoginPage');
        Get.off(() => LoginPage());
      }
    } catch (e) {
      debugPrint('Error in _checkAuthentication: $e');
    }
  }

  Future<bool> _mockCheckAccessToken() async {
    return false; // Set to true to test NavigationMenu
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _isVideoInitialized
                ? FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
                : Image.asset(
              'assets/images/google_logo.webp',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(74, 144, 226, 1), // Sky Blue
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}