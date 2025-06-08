import 'package:english_app_with_ai/pages/payment_url_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/payment_view_model.dart';

class PremiumIntroPage extends StatelessWidget {
  const PremiumIntroPage({super.key});

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.05,
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            ),
          ),
    );
  }

  void _upgradeToPremium() {
    final paymentViewModel = Get.put(PaymentViewModel());
    Get.defaultDialog(
      title: 'Confirmation',
      titleStyle: GoogleFonts.roboto(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      middleText:
          'Do you want to upgrade your account for 100,000 VND/month and unlock all premium courses?',
      middleTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.black,
      ),
      textConfirm: 'Upgrade',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.blue,
      backgroundColor: Colors.white,
      buttonColor: Colors.blue,
      onConfirm: () async {
        Get.back();
        _showLoadingDialog(Get.context!);
        final paymentUrl =
            await paymentViewModel.processPayment();
        Get.back();
        if (paymentUrl != null) {
          Get.to(() => PaymentWebView(url: paymentUrl));
        } else {
          Get.snackbar(
            'Error',
            'Failed to process payment. Please try again.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onCancel: () => Get.back(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Premium Plan',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.workspace_premium_outlined,
                  color: Colors.amberAccent,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'PREMIUM PLAN',
                  style: GoogleFonts.roboto(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[600],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Only 100,000 VND/month\nUnlimited access to all premium courses!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: const [
                    FeatureItem(
                      text:
                          'Unlimited access to all premium courses.',
                    ),
                    SizedBox(height: 15),
                    FeatureItem(
                      text:
                          'Exclusive access to advanced materials and exercises.',
                    ),
                    SizedBox(height: 15),
                    FeatureItem(
                      text:
                          'Priority support from instructors.',
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        _upgradeToPremium();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Center(
                          child: Text(
                            "Upgrade now",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String text;

  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle,
          color: Colors.greenAccent,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 14.5,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
