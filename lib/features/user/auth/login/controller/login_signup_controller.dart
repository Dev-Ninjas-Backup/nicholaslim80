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

      debugPrint('📡 Login Response: ${result}');
      debugPrint('➡️ Login result: $result');

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        final token = result['body']['access_token'];
        final refreshToken = result['body']['refresh_token'];
        final expiresIn = result['body']['expires_in'];

        if (token == null || token.isEmpty) {
          EasyLoading.showError("Invalid token received");
          return;
        }

        // Save token
        await SharedPreferencesHelper.saveToken(token);

        // Optional: Save refresh token
        if (refreshToken != null) {
          await SharedPreferencesHelper.saveRefreshToken(refreshToken);
        }

        debugPrint('💾 Saved Access Token: $token');
        debugPrint('💾 Saved Refresh Token: $refreshToken');
        debugPrint('💾 Expires In: $expiresIn');

        // Small delay for smooth UI
        await Future.delayed(const Duration(milliseconds: 300));

        EasyLoading.dismiss();
        Get.offAllNamed(AppRoutes.homeScreen);
      } else {
        EasyLoading.showError(result['body']['message'] ?? "Login failed");
      }
    } catch (e) {
      debugPrint('❌ Login Exception: $e');
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

      debugPrint('➡️ Signup result: $result');

      if (result['statusCode'] == 201) {
        final userId = result['body']['user']['id'].toString();
        await SharedPreferencesHelper.saveUserId(userId);
        debugPrint('💾 Saved User ID after signup: $userId');

        EasyLoading.dismiss();
        Get.toNamed(AppRoutes.verificationScreen, arguments: {"email": email});
      } else {
        EasyLoading.showError(result['body']['message'] ?? "Signup failed");
      }
    } catch (e) {
      debugPrint('❌ Signup Exception: $e');
      EasyLoading.showError("Signup error");
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
