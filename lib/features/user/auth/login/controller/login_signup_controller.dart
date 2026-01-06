import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/features/user/auth/login/auth_service/auth_service.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class LoginSignupController extends GetxController {
  // ---------------- Text Controllers ----------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ---------------- UI State ----------------
  RxBool isLogin = true.obs;
  RxBool isLoading = false.obs;

  RxBool isLoginPasswordVisible = false.obs;
  RxBool isSignUpPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // ---------------- Submit ----------------
  Future<void> submit() async {
    if (isLogin.value) {
      await login();
    } else {
      await signup();
    }
  }

  // ---------------- LOGIN ----------------
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email & Password required");
      return;
    }

    isLoading.value = true;

    try {
      final result = await AuthService.login(email: email, password: password);

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        final token = result['body']['access_token'];

        await SharedPreferencesHelper.saveAccessToken(token);

        // 🔥 reset navigation stack
        Get.offAllNamed(AppRoutes.bottomNavbarScreen);
      } else {
        // Get.snackbar("Login Failed", result['body']['message'] ?? 'Error');
        EasyLoading.showError(result['body']['message'] ?? 'Login Failed');
        EasyLoading.dismiss();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- SIGNUP ----------------
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (password != confirm) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;

    try {
      final result = await AuthService.signup(
        username: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (result['statusCode'] == 201) {
        Get.toNamed(AppRoutes.verificationScreen, arguments: {"email": email});
      } else {
          // Get.snackbar("Signup Failed", result['body']['message'] ?? 'Error');
          EasyLoading.showError(result['body']['message'] ?? 'Signup Failed');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await SharedPreferencesHelper.logout();
    Get.offAllNamed(AppRoutes.getOnboardingScreen());
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
