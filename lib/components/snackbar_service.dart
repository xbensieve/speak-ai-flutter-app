import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

enum SnackbarType { success, error, info }

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar({
    required String title,
    required String message,
    SnackbarType type = SnackbarType.info,
    int durationSeconds = 3,
  }) {
    Get.snackbar(
      title,
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _getBackgroundColor(type),
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      animationDuration: const Duration(milliseconds: 700),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      messageText: Text(
        message,
        style: GoogleFonts.roboto(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      icon: Icon(_getIcon(type), color: Colors.white),
    );
  }

  static Color _getBackgroundColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Colors.green;
      case SnackbarType.error:
        return Colors.red;
      case SnackbarType.info:
        return Colors.blue;
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_outline;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }
}
