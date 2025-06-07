import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/implement/api_service.dart';
import '../view_models/register_view_model.dart';
import 'login_page.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterViewModel viewModel = Get.put(
    RegisterViewModel(apiService: ApiService()),
    tag: 'registerViewModel',
  );

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
              child: const CupertinoActivityIndicator(
                radius: 20,
                color: Colors.white,
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A89FF), Color(0xFF2C2C48)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical:
                  MediaQuery.of(context).padding.top + 16.0,
            ),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Create Your Account',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(
                    controller:
                        viewModel.userNameController,
                    label: 'Username',
                    icon: Icons.person,
                    validator: viewModel.validateUserName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: viewModel.emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType:
                        TextInputType.emailAddress,
                    validator: viewModel.validateEmail,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller:
                        viewModel.fullNameController,
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    validator: viewModel.validateFullName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller:
                        viewModel.birthdayController,
                    label: 'Birthday (YYYY-MM-DD)',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap:
                        () => viewModel.selectDate(context),
                    validator: viewModel.validateBirthday,
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => _buildDropdownField(
                      value: viewModel.selectedGender.value,
                      label: 'Gender',
                      icon: Icons.people,
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (value) {
                        if (value != null) {
                          viewModel.selectedGender.value =
                              value;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller:
                        viewModel.passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: viewModel.validatePassword,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller:
                        viewModel.confirmPasswordController,
                    label: 'Confirm Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                    validator:
                        viewModel.validateConfirmPassword,
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => ElevatedButton(
                      onPressed:
                          viewModel.isLoading.value
                              ? null
                              : () async {
                                _showLoadingDialog(context);
                                bool success =
                                    await viewModel
                                        .register();
                                Navigator.of(context).pop();
                                if (success) {
                                  Get.delete<
                                    RegisterViewModel
                                  >(
                                    tag:
                                        'registerViewModel',
                                  );
                                  Get.off(
                                    () => const LoginPage(),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(
                          0xFF6A89FF,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        elevation: 2,
                        textStyle: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () =>
                        viewModel
                                .errorMessage
                                .value
                                .isNotEmpty
                            ? Text(
                              viewModel.errorMessage.value,
                              style: GoogleFonts.roboto(
                                color: Colors.red[300],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            )
                            : const SizedBox(),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Get.off(() => const LoginPage());
                      Get.delete<RegisterViewModel>(
                        tag: 'registerViewModel',
                      );
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(
          color: Colors.white70,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      style: GoogleFonts.roboto(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required String label,
    required IconData icon,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(
          color: Colors.white70,
          fontSize: 16,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
      ),
      style: GoogleFonts.roboto(color: Colors.white),
      dropdownColor: const Color(0xFF2C2C48),
      items:
          items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: onChanged,
    );
  }
}
