import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/features/user/auth/login/auth_service/auth_service.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class LoginSignupController extends GetxController {
  // ------------------- Text Controllers -------------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ------------------- Password Visibility -------------------
  RxBool isLoginPasswordVisible = false.obs;
  RxBool isSignUpPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  // ------------------- Login / Signup Toggle -------------------
  RxBool isLogin = true.obs;
  RxBool isLoading = false.obs;

  void toggleAuthMode() {
    isLogin.value = !isLogin.value;
    debugPrint("Auth Mode Toggled: isLogin=${isLogin.value}");
  }

  // ------------------- Submit -------------------
  Future<void> submit() async {
    if (isLogin.value) {
      await login();
    } else {
      await signup();
    }
  }

  // ------------------- LOGIN -------------------
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    debugPrint(
      "Login Attempt: email=$email, password=${'*' * password.length}",
    );

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email & Password required");
      debugPrint("Login Failed: Email or Password empty");
      return;
    }

    isLoading.value = true;

    try {
      final result = await AuthService.login(email: email, password: password);
      debugPrint("Login API Response: $result");

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        final token = result['body']['access_token'];
        debugPrint("Login Success, token: $token");

        await SharedPreferencesHelper.saveToken(token);
        // await SharedPreferencesHelper.saveUserEmail(email);
        // await SharedPreferencesHelper.setLoggedIn(true);

        Get.offAllNamed(AppRoutes.bottomNavbarScreen);
      } else {
        Get.snackbar("Login Failed", result['body']['message'] ?? 'Error');
        debugPrint("Login Failed: ${result['body']['message']}");
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------- SIGNUP -------------------
  Future<void> signup() async {
    final username = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    debugPrint(
      "Signup Attempt: username=$username, email=$email, phone=$phone, password=${'*' * password.length}, confirmPassword=${'*' * confirmPassword.length}",
    );

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      debugPrint("Signup Failed: Some fields empty");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      debugPrint("Signup Failed: Passwords do not match");
      return;
    }

    isLoading.value = true;

    try {
      final result = await AuthService.signup(
        username: username,
        email: email,
        phone: phone,
        password: password,
      );

      debugPrint("Signup API Response: $result");

      if (result['statusCode'] == 201) {
        // navigate to verification screen
        debugPrint("Signup Success, navigating to verification screen");
        Get.toNamed(
          AppRoutes.verificationScreen,
          arguments: {"email": email, "mode": "signup"},
        );
      } else {
        debugPrint("Signup Failed: ${result['body']['message']}");
        Get.snackbar("Signup Failed", result['body']['message'] ?? 'Error');
      }
    } finally {
      isLoading.value = false;
    }
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
