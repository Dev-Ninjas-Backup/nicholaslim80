import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/auth/login/auth_service/auth_service.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class VerificationController extends GetxController {
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  RxString otp = ''.obs;
  RxInt secondsLeft = 50.obs;
  RxBool isVerifying = false.obs;
  RxString phone = ''.obs;
  RxString email = ''.obs;

  // 🔹 UPDATED: mode to distinguish login/signup
  RxString mode = 'signup'.obs; // default signup

  Timer? timer;

  bool get canResend => secondsLeft.value == 0;
  bool get canVerify => otp.value.length == 4 && !isVerifying.value;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args.containsKey('phone')) phone.value = args['phone'];
      if (args.containsKey('email')) email.value = args['email'];
      if (args.containsKey('mode')) mode.value = args['mode']; // 🔹 UPDATED
    }

    for (var c in pinControllers) {
      c.addListener(_onPinsChanged);
    }

    _startTimer();
  }

  void _onPinsChanged() {
    otp.value = pinControllers.map((c) => c.text).join();
  }

  void _startTimer({int from = 50}) {
    timer?.cancel();
    secondsLeft.value = from;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft.value == 0) {
        t.cancel();
      } else {
        secondsLeft.value--;
      }
    });
  }

  Future<void> resendCode() async {
    if (!canResend) return;

    _startTimer(from: 50);

    try {
      await AuthService.resendOtp(phone: phone.value);
      Get.snackbar(
        'Success',
        'OTP sent again',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.white,
      );
    } catch (e) {
      final msg = e.toString();
      if (msg.contains("OTP sent")) {
        Get.snackbar(
          'Info',
          'OTP already sent. Please wait.',
          snackPosition: SnackPosition.TOP,
          // ignore: deprecated_member_use
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          msg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  // 🔹 UPDATED: verifyCode now handles both login & signup
  Future<void> verifyCode() async {
    if (!canVerify) return;

    isVerifying.value = true;
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await AuthService.verifyOtp(
        phone: phone.value,
        otp: otp.value,
        email: email.value,
      );

      Get.back(); // close loader

      if (mode.value == 'login') {
        // 🔹 UPDATED: after login OTP verification
        Get.offAllNamed(AppRoutes.bottomNavbarScreen);
        Get.snackbar(
          'Success',
          'Login OTP Verified Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        // 🔹 UPDATED: after signup OTP verification
        Get.offAllNamed(AppRoutes.bottomNavbarScreen);
        Get.snackbar(
          'Success',
          'Signup OTP Verified Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // close loader
      Get.snackbar(
        'Verification Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  void onPinChanged(String value, int index) {
    if (value.length > 1) {
      final last = value.substring(value.length - 1);
      pinControllers[index].text = last;
      pinControllers[index].selection = TextSelection.collapsed(
        offset: last.length,
      );
    }
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void clearPins() {
    for (var c in pinControllers) c.clear();
    focusNodes[0].requestFocus();
  }

  @override
  void onClose() {
    timer?.cancel();
    for (var c in pinControllers) {
      c.removeListener(_onPinsChanged);
      c.dispose();
    }
    for (var f in focusNodes) f.dispose();
    super.onClose();
  }
}
