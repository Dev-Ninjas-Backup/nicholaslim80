// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/auth/login/auth_service/auth_service.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class LoginSignupController extends GetxController {
  // ================= STATE =================
  var isLoginSelected = true.obs;

  var phoneNumber = ''.obs; // Full phone number with country code
  var selectedCountry = '+1'.obs; // Dial code only

  var selectedUserType = 'USER'.obs;
  final List<String> userTypes = ['USER'];

  // ================= TEXT CONTROLLERS =================
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // ================= PASSWORD VISIBILITY =================
  var isLoginPasswordVisible = false.obs;
  var isSignUpPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    phoneController = TextEditingController();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    phoneController.addListener(updatePhoneNumber);
  }

  // ================= UI TOGGLE =================
  void toggleSelection(bool isLogin) {
    isLoginSelected.value = isLogin;
  }

  // ================= PHONE =================
  void updatePhoneNumber() {
    final text = phoneController.text.trim();
    phoneNumber.value = text.isNotEmpty ? '${selectedCountry.value}$text' : '';
  }

  void clearPhone() {
    phoneController.clear();
    phoneNumber.value = '';
  }

  void selectCountry(String countryCode) {
    selectedCountry.value = countryCode;
    updatePhoneNumber();
  }

  // ================= USER TYPE =================
  void selectUserType(String type) {
    selectedUserType.value = type;
  }

  // ================= LOGIN =================
  Future<void> onLoginPressed() async {
    if (phoneNumber.value.isEmpty && emailController.text.trim().isEmpty) {
      _showError("Please enter phone or email");
      return;
    }
    if (passwordController.text.trim().isEmpty) {
      _showError("Please enter your password");
      return;
    }

    try {
      _showLoader();

      // Call Login API
      await AuthService.login(
        phone: phoneNumber.value.isNotEmpty ? phoneNumber.value : null,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null,
        password: passwordController.text.trim(),
      );

      _hideLoader();

      Get.offAllNamed(AppRoutes.getbottomNavbarScreen());
    } catch (e) {
      _hideLoader();
      _showError("Login Failed: $e");
    }
  }

  // ================= SIGNUP =================
  Future<void> onSignUpContinuePressed() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      _showError("Passwords do not match");
      return;
    }

    if (passwordController.text.trim().length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    try {
      _showLoader();

      // Call Signup API
      await AuthService.signUp(
        phone: phoneNumber.value,
        username: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _hideLoader();

      // ✅ Navigate to OTP verification or Dashboard
      // If you want direct dashboard after signup, change to AppRoutes.dashboardScreen
      Get.toNamed(
        AppRoutes.verificationScreen,
        arguments: {
          "phone": phoneNumber.value,
          "email": emailController.text.trim(),
          "mode": "signup",
        },
      );
    } catch (e) {
      _hideLoader();
      _showError("Signup Failed: $e");
    }
  }

  // ================= LOGOUT =================
  void logout() {
    phoneNumber.value = '';
    selectedUserType.value = 'USER';
    isLoginSelected.value = true;

    phoneController.clear();
    emailController.clear();
    nameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    Get.offAllNamed(AppRoutes.loginScreen);
  }

  // ================= HELPERS =================
  void _showLoader() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
  }

  void _hideLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.85),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // ================= DISPOSE =================
  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
