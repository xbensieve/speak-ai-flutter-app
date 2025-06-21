import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/otp_view_model.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final OtpViewModel _otpViewModel = Get.put(
    OtpViewModel(),
  );
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );
  bool _canResend = true;
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _otpViewModel.sendOtp();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendCountdown = 900;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (
      timer,
    ) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _verifyOtp() async {
    final otp =
        _otpControllers
            .map((controller) => controller.text)
            .join();
    if (otp.length == 6) {
      final success = await _otpViewModel.confirmOtp(otp);
      if (success) {
        Get.back();
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter a 6-digit OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth =
        MediaQuery.of(context).size.width;
    final double screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verify Email',
          style: GoogleFonts.roboto(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 1,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter the 6-digit OTP sent to your email',
                    style: GoogleFonts.roboto(
                      fontSize: screenWidth * 0.045,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: screenWidth * 0.12,
                        child: TextField(
                          controller:
                              _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType:
                              TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.06,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white
                                .withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                    screenWidth * 0.02,
                                  ),
                              borderSide: const BorderSide(
                                color: Colors.white24,
                              ),
                            ),
                            enabledBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        screenWidth * 0.02,
                                      ),
                                  borderSide:
                                      const BorderSide(
                                        color:
                                            Colors.white24,
                                      ),
                                ),
                            focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        screenWidth * 0.02,
                                      ),
                                  borderSide:
                                      const BorderSide(
                                        color: Colors.blue,
                                        width: 2,
                                      ),
                                ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                index < 5) {
                              _focusNodes[index + 1]
                                  .requestFocus();
                            } else if (value.isEmpty &&
                                index > 0) {
                              _focusNodes[index - 1]
                                  .requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  _otpViewModel.isLoading.value
                      ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                      : ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.2,
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  screenWidth * 0.03,
                                ),
                          ),
                        ),
                        child: Text(
                          'Verify',
                          style: GoogleFonts.roboto(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  SizedBox(height: screenHeight * 0.02),
                  TextButton(
                    onPressed:
                        _canResend
                            ? () {
                              _otpViewModel.sendOtp();
                              _startResendTimer();
                            }
                            : null,
                    child: Text(
                      _canResend
                          ? 'Resend OTP'
                          : 'Resend in $_resendCountdown s',
                      style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.04,
                        color:
                            _canResend
                                ? Colors.blue
                                : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
