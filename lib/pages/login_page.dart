import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../components/loading_overlay.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../components/navigation_menu.dart';
import '../components/snackbar_service.dart';
import '../components/square_tile.dart';
import '../view_models/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final loginViewModel = Get.put(LoginViewModel());
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: dotenv.env['GOOGLE_CLIENT_ID'],
  );
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  Future<void> _handleSignInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();
      if (googleUser == null) {
        SnackbarService.showSnackbar(
          title: 'Sign-In Cancelled',
          message: 'You cancelled the sign-in process.',
          type: SnackbarType.info,
          durationSeconds: 3,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        SnackbarService.showSnackbar(
          title: 'Sign-In Error',
          message:
              'Google sign-in failed. Please try again.',
          type: SnackbarType.error,
          durationSeconds: 3,
        );
        return;
      }
      bool success = await loginViewModel.signInWithGoogle(
        idToken,
      );
      if (success) {
        Get.off(() => const NavigationMenu());
      } else {
        SnackbarService.showSnackbar(
          title: 'Sign-In Error',
          message:
              'Google sign-in failed. Please try again.',
          type: SnackbarType.error,
          durationSeconds: 3,
        );
      }
    } catch (error) {
      String errorMessage =
          'Google sign-in failed. Please try again.';
      if (error.toString().contains('403') ||
          error.toString().contains('access_denied')) {
        errorMessage =
            'Access denied: This app is in testing mode. Please contact the developer to be added as a test user.';
      }
      SnackbarService.showSnackbar(
        title: 'Sign-In Error',
        message: errorMessage,
        type: SnackbarType.error,
        durationSeconds: 3,
      );
    }
  }

  Future<void> _handleSignIn(
    String username,
    String password,
  ) async {
    if (username.isEmpty || password.isEmpty) {
      SnackbarService.showSnackbar(
        title: 'Error',
        message:
            'Please fill in both username and password',
        type: SnackbarType.error,
        durationSeconds: 3,
      );
      return;
    }
    bool success = await loginViewModel.signIn(
      username,
      password,
    );
    if (success) {
      Get.off(() => const NavigationMenu());
    } else {
      passwordController.clear();
      SnackbarService.showSnackbar(
        title: 'Sign-In Error',
        message: 'Invalid credentials. Please try again.',
        type: SnackbarType.error,
        durationSeconds: 3,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTabletOrLarger = size.width >= 600;
    final padding = size.width * 0.06;
    final fontScale = isTabletOrLarger ? 1.2 : 1.0;
    return Obx(
      () => LoadingOverlay(
        isLoading: loginViewModel.isLoading.value,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6A89FF),
                  Color(0xFF2C2C48),
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: padding,
                            vertical: size.height * 0.03,
                          ),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .center,
                                    children: [
                                      Image.asset(
                                        'lib/assets/images/2.png',
                                        width:
                                            size.width *
                                            0.2,
                                        // 20% of screen width
                                        height:
                                            size.width *
                                            0.2,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width:
                                            size.width *
                                            0.02,
                                      ),
                                      Text(
                                        "I R S M",
                                        style:
                                            GoogleFonts.roboto(
                                              color:
                                                  Colors
                                                      .white,
                                              fontSize:
                                                  40 *
                                                  fontScale,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.03,
                                  ),
                                  Text(
                                    "Welcome back!",
                                    style:
                                        GoogleFonts.roboto(
                                          color:
                                              Colors.white,
                                          fontSize:
                                              30 *
                                              fontScale,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.04,
                                  ),
                                  MyTextField(
                                    controller:
                                        usernameController,
                                    hintText: 'Username',
                                    obscureText: false,
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.015,
                                  ),
                                  MyTextField(
                                    controller:
                                        passwordController,
                                    hintText: 'Password',
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.03,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(
                                          horizontal:
                                              padding,
                                        ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // TODO: Implement forgot password functionality
                                          },
                                          child: Text(
                                            "Forgot password?",
                                            style: GoogleFonts.roboto(
                                              color:
                                                  Colors
                                                      .white,
                                              fontSize:
                                                  16 *
                                                  fontScale,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.03,
                                  ),
                                  MyButton(
                                    onTap: () async {
                                      String username =
                                          usernameController
                                              .text
                                              .trim();
                                      String password =
                                          passwordController
                                              .text
                                              .trim();
                                      await _handleSignIn(
                                        username,
                                        password,
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.04,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(
                                          horizontal:
                                              padding,
                                        ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Divider(
                                            thickness: 1.2,
                                            color:
                                                Colors
                                                    .white70,
                                            endIndent:
                                                size.width *
                                                0.02,
                                          ),
                                        ),
                                        Text(
                                          "Or continue with",
                                          style: GoogleFonts.roboto(
                                            color:
                                                Colors
                                                    .white,
                                            fontSize:
                                                16 *
                                                fontScale,
                                            fontWeight:
                                                FontWeight
                                                    .w500,
                                            letterSpacing:
                                                0.5,
                                          ),
                                        ),
                                        Expanded(
                                          child: Divider(
                                            thickness: 1.2,
                                            color:
                                                Colors
                                                    .white70,
                                            indent:
                                                size.width *
                                                0.02,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.04,
                                  ),
                                  SquareTile(
                                    imagePath:
                                        'lib/assets/images/google_logo.webp',
                                    onTap:
                                        _handleSignInWithGoogle,
                                  ),
                                  SizedBox(
                                    height:
                                        size.height * 0.03,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [
                                      Text(
                                        "Not a member? ",
                                        style: GoogleFonts.roboto(
                                          color:
                                              Colors
                                                  .white70,
                                          fontSize:
                                              16 *
                                              fontScale,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //Get.to(() => RegisterPage());
                                        },
                                        child: Text(
                                          "Register now",
                                          style: GoogleFonts.roboto(
                                            color:
                                                Colors
                                                    .white,
                                            fontSize:
                                                16 *
                                                fontScale,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
