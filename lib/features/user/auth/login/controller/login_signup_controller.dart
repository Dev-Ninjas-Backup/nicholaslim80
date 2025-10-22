import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class LoginSignupController extends GetxController {
  var isLoginSelected = true.obs;
  var phoneNumber = ''.obs;
  var selectedCountry = '🇺🇸 +1'.obs;

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

  void onLoginPressed() {
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

    // Navigate to VerifyScreen
    Get.toNamed(AppRoutes.verificationScreen, arguments: phoneNumber.value);
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
