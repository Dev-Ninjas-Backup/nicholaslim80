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
  final phoneController = TextEditingController(text: '+65');
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
  // Login with dynamic identifier (email/phone/username)
  Future<void> login() async {
    final identifier = emailController.text.trim(); // email/phone/username
    final password = passwordController.text.trim();

    if (identifier.isEmpty) {
      EasyLoading.showError("Email, phone or username is required");
      return;
    }
    if (password.isEmpty) {
      EasyLoading.showError("Password is required");
      return;
    }

    Map<String, dynamic> requestBody = {"password": password};

    if (GetUtils.isEmail(identifier)) {
      requestBody["email"] = identifier;
    } else if (RegExp(r'^[0-9+]+$').hasMatch(identifier)) {
      requestBody["phone"] = identifier;
    } else {
      requestBody["username"] = identifier;
    }

    isLoading.value = true;
    EasyLoading.show(status: "Logging in...");

    try {
      // call login API service with dynamic identifier
      final result = await AuthService.login(requestBody);

      debugPrint('📡 Login Response: ${result}');
      debugPrint('➡️ Login result: $result');

      if (result['statusCode'] == 200 || result['statusCode'] == 201) {
        final token = result['body']['access_token'];
        final refreshToken = result['body']['refresh_token'];
        final expiresIn = result['body']['expires_in'];

        // Save in access token
        await SharedPreferencesHelper.saveToken(token);

        final userIdFromBody = _extractUserIdFromLoginBody(result['body']);
        final userId =
            userIdFromBody ??
            SharedPreferencesHelper.extractUserIdFromToken(token);
        if (userId != null && userId.isNotEmpty) {
          await SharedPreferencesHelper.saveUserId(userId);
          debugPrint('💾 Saved User ID: $userId');
        }

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
        Get.offAllNamed(AppRoutes.bottomNavbarScreen);
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

    if (name.isEmpty) {
      EasyLoading.showError("User Name is required");
      return;
    }

    if (email.isEmpty) {
      EasyLoading.showError("Email is required");
      return;
    }

    if (phone.isEmpty) {
      EasyLoading.showError("Phone is required");
      return;
    }

    if (password.isEmpty) {
      EasyLoading.showError("Password is required");
      return;
    }

    if (confirm.isEmpty) {
      EasyLoading.showError("Confirm password is required");
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
        // final userId = result['body']['user']['id'].toString();
        // await SharedPreferencesHelper.saveUserId(userId);
        // debugPrint('💾 Saved User ID after signup: $userId');

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

  String? _extractUserIdFromLoginBody(dynamic body) {
    if (body is! Map) return null;

    final root = Map<String, dynamic>.from(body);
    final directCandidates = [
      root['userId'],
      root['user_id'],
      root['id'],
    ];
    for (final candidate in directCandidates) {
      final value = candidate?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }

    final user = root['user'];
    if (user is Map) {
      final nestedCandidates = [user['id'], user['userId'], user['user_id']];
      for (final candidate in nestedCandidates) {
        final value = candidate?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    final data = root['data'];
    if (data is Map) {
      final nestedCandidates = [data['id'], data['userId'], data['user_id']];
      for (final candidate in nestedCandidates) {
        final value = candidate?.toString().trim();
        if (value != null && value.isNotEmpty) return value;
      }
    }

    return null;
  }
}
