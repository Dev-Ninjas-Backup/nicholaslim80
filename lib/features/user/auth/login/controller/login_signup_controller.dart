import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/auth/login/auth_service/auth_service.dart';
import 'package:ZipBee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoginSignupController extends GetxController {
  // ---------------- TEXT CONTROLLERS ----------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ---------------- UI STATE ----------------
  RxBool isLogin = true.obs;
  RxBool isLoading = false.obs;

  RxBool isLoginPasswordVisible = false.obs;
  RxBool isSignUpPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // ---------------- SUBMIT ----------------
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
      EasyLoading.showError("Email & Password required");
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: "Logging in...");

    try {
      final result = await AuthService.login(email: email, password: password);

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        final token = result['body']['access_token'];

        if (token == null || token.toString().isEmpty) {
          EasyLoading.showError("Invalid token received");
          return;
        }

        // ✅ SAVE TOKEN FIRST
        await SharedPreferencesHelper.saveToken(token);

        // ✅ SMALL DELAY TO STABILIZE STORAGE & CONTROLLERS
        await Future.delayed(const Duration(milliseconds: 300));

        EasyLoading.dismiss();

        // ✅ RESET NAVIGATION STACK
        Get.offAllNamed(AppRoutes.getbottomNavbarScreen());
      } else {
        EasyLoading.showError(result['body']['message'] ?? "Login failed");
      }
    } catch (e) {
      EasyLoading.showError("Login error");
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
      EasyLoading.showError("All fields are required");
      return;
    }

    if (password != confirm) {
      EasyLoading.showError("Passwords do not match");
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: "Creating account...");

    try {
      final result = await AuthService.signup(
        username: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (result['statusCode'] == 201) {
        EasyLoading.dismiss();
        Get.toNamed(AppRoutes.verificationScreen, arguments: {"email": email});
      } else {
        EasyLoading.showError(result['body']['message'] ?? "Signup failed");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ---------------- LOGOUT ----------------
  Future<void> logout() async {
    await SharedPreferencesHelper.clearAllData();
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
