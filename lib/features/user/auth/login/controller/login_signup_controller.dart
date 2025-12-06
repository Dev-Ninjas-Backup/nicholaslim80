// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/auth/login/auth_service/auth_service.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class LoginSignupController extends GetxController {
  var isLoginSelected = true.obs;
  var phoneNumber = ''.obs; // Full phone with country code
  var selectedCountry = '+1'.obs; // Only dial code now

  // User type (default USER)
  var selectedUserType = 'USER'.obs;

  late TextEditingController phoneController;
  late TextEditingController nameController;
  late TextEditingController emailController;

  final List<String> userTypes = ['USER'];

  void toggleSelection(bool isLogin) {
    isLoginSelected.value = isLogin;
  }

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    nameController = TextEditingController();
    emailController = TextEditingController();

    // Update phoneNumber.value automatically with country code
    phoneController.addListener(() {
      updatePhoneNumber();
    });
  }

  void updatePhoneNumber() {
    final text = phoneController.text;
    if (text.isNotEmpty) {
      phoneNumber.value = '${selectedCountry.value}$text';
    } else {
      phoneNumber.value = '';
    }
  }

  void clearPhone() {
    phoneController.clear();
    phoneNumber.value = '';
  }

  void selectCountry(String countryCode) {
    selectedCountry.value = countryCode;
    updatePhoneNumber(); // Update full phone whenever country changes
  }

  void selectUserType(String type) {
    selectedUserType.value = type;
  }

  // ================= LOGIN =================
  void onLoginPressed() async {
    if (phoneNumber.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.toNamed(
        AppRoutes.verificationScreen,
        arguments: {
          "phone": phoneNumber.value,
          "email": emailController.text, // Add email if available
          "mode": "login",
        },
      );
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    }
  }

  // ================= SIGNUP =================
  void onSignUpContinuePressed() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Signup API call with phone + email (if API supports)
      await AuthService.signUp(
        phone: phoneNumber.value,
        email: emailController.text, // Send email too
        name: nameController.text, // Send name if needed
      );

      Get.back();

      // Navigate to OTP Verification screen
      Get.toNamed(
        AppRoutes.verificationScreen,
        arguments: {
          "phone": phoneNumber.value,
          "email": emailController.text, // Email required for OTP verification
          "mode": "signup",
        },
      );
    } catch (e) {
      // Close loading
      Get.back();

      Get.snackbar(
        "Signup Failed",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void logout() {
    phoneNumber.value = '';
    selectedUserType.value = 'USER';
    isLoginSelected.value = true;

    phoneController.clear();
    nameController.clear();
    emailController.clear();

    Get.offAllNamed(AppRoutes.loginScreen);
  }
}
