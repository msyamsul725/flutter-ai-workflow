import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final isEmailValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupEmailValidation();
  }

  void _setupEmailValidation() {
    emailController.addListener(() {
      final email = emailController.text;
      isEmailValid.value = _isValidEmail(email);
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  void togglePasswordVisibility() {
    isPasswordHidden.toggle();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Simulasi delay untuk server request
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Ganti dengan API call yang sebenarnya
      if (password.length >= 6) {
        Get.snackbar(
          'Success',
          'Login berhasil',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Navigate ke home atau dashboard
        // Get.offNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Error',
          'Password minimal 6 karakter',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void goToSignUp() {
    Get.snackbar(
      'Info',
      'Fitur Sign Up belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate ke sign up page
    // Get.toNamed(Routes.SIGNUP);
  }

  void resetPassword() {
    Get.snackbar(
      'Info',
      'Fitur Reset Password belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate ke reset password page
    // Get.toNamed(Routes.FORGOT_PASSWORD);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
