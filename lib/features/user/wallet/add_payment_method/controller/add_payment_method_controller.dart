import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPaymentMethodController extends GetxController {
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final nameController = TextEditingController();

  var isButtonEnabled = false.obs;

  @override
  void onInit() {
    cardNumberController.addListener(_validate);
    expiryController.addListener(_validate);
    cvvController.addListener(_validate);
    nameController.addListener(_validate);
    super.onInit();
  }

  void _validate() {
    if (cardNumberController.text.length >= 8 &&
        expiryController.text.isNotEmpty &&
        cvvController.text.length >= 3 &&
        nameController.text.isNotEmpty) {
      isButtonEnabled.value = true;
    } else {
      isButtonEnabled.value = false;
    }
  }

  void saveCard() {}

  @override
  void onClose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
