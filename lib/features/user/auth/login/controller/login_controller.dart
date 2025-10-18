import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoginSelected = true.obs;
  var phoneNumber = ''.obs;
  var selectedCountry = '🇺🇸 +1'.obs;
  late TextEditingController phoneController;

  final List<String> countries = [
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

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
