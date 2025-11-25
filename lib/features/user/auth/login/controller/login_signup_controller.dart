// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class LoginSignupController extends GetxController {
  var isLoginSelected = true.obs;
  var phoneNumber = ''.obs;
  var selectedCountry = '🇺🇸 +1'.obs;

  // New: selected user type
  var selectedUserType = 'USER'.obs;

  late TextEditingController phoneController;
  late TextEditingController nameController;
  late TextEditingController emailController;

  final RxList<String> countries = [
    '🇺🇸 +1',
    '🇨🇦 +1',
    '🇬🇧 +44',
    '🇦🇺 +61',
    '🇮🇳 +91',
    '🇩🇪 +49',
    '🇫🇷 +33',
    '🇯🇵 +81',
  ].obs;

  // New: user type options
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

    phoneController.addListener(() {
      phoneNumber.value = phoneController.text;
    });
  }

  void clearPhone() {
    phoneController.clear();
    phoneNumber.value = '';
  }

  void selectCountry(String country) {
    selectedCountry.value = country;
  }

  // New: select user type
  void selectUserType(String type) {
    selectedUserType.value = type;
  }

  void onLoginPressed() {
    if (phoneNumber.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your phone number',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withValues(alpha: .8),
        colorText: Colors.white,
      );
      return;
    }

    // Navigate to VerifyScreen
    Get.offAllNamed(AppRoutes.bottomNavbarScreen, arguments: phoneNumber.value);
  }

  void onSignUpContinuePressed() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Send to verification screen
    Get.toNamed(AppRoutes.verificationScreen, arguments: phoneController.text);
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

  @override
  void onClose() {
    // phoneController.dispose();
    // nameController.dispose();
    // emailController.dispose();
    super.onClose();
  }
}
