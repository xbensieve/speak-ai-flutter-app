import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/abstract/i_api_service.dart';

class RegisterViewModel extends GetxController {
  final IApiService apiService;

  RegisterViewModel({required this.apiService});

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final birthdayController = TextEditingController();
  final genderController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedGender = 'Male'.obs;
  var selectedDate = DateTime.now().obs;

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? validateBirthday(String? value) {
    if (value == null || value.isEmpty) {
      return 'Birthday is required';
    }
    try {
      DateFormat('yyyy-MM-dd').parse(value);
      return null;
    } catch (e) {
      return 'Invalid date format';
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      birthdayController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(picked);
    }
  }

  Future<bool> register() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.registerCustomer(
        userName: userNameController.text,
        password: passwordController.text,
        confirmedPassword: confirmPasswordController.text,
        email: emailController.text,
        fullName: fullNameController.text,
        birthday: birthdayController.text,
        gender: selectedGender.value,
      );

      isLoading.value = false;

      if (result.isSuccess) {
        Get.snackbar(
          'Success',
          'Registration successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        errorMessage.value = result.message;
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }
    return false;
  }

  @override
  void onClose() {
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    birthdayController.dispose();
    genderController.dispose();
    super.onClose();
  }
}
