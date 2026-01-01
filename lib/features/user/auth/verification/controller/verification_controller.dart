import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/auth/login/auth_service/auth_service.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class VerificationController extends GetxController {
  // ------------------- OTP Input Controllers -------------------
  final List<TextEditingController> pinControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  RxString otp = ''.obs;
  RxInt secondsLeft = 50.obs;
  RxBool isVerifying = false.obs;

  // ------------------- User Info -------------------
  RxString phone = ''.obs;
  RxString email = ''.obs;

  // Mode: 'login' or 'signup'
  RxString mode = 'signup'.obs;

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
      if (args.containsKey('mode')) mode.value = args['mode'];
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

  // ------------------- Resend OTP -------------------
  Future<void> resendCode() async {
    if (!canResend) return;

    _startTimer(from: 50);

    try {
      await AuthService.verifyOtp(
        email: email.value,
        otp: "0000", // server expects a POST, but resend may require separate API
      );

      Get.snackbar(
        'Success',
        'OTP sent again',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // ------------------- Verify OTP -------------------
  Future<void> verifyCode() async {
    if (!canVerify) return;

    isVerifying.value = true;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final result = await AuthService.verifyOtp(
        email: email.value,
        otp: otp.value,
      );

      Get.back(); // close loader

      if (result['statusCode'] == 201) {
        // Login or Signup redirect
        if (mode.value == 'login') {
          Get.offAllNamed(AppRoutes.bottomNavbarScreen);
          Get.snackbar(
            'Success',
            'Login OTP Verified',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          Get.offAllNamed(AppRoutes.bottomNavbarScreen);
          Get.snackbar(
            'Success',
            'Signup OTP Verified',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Verification Failed',
          result['body']['message'] ?? 'Error',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  // ------------------- Handle OTP Input -------------------
  void onPinChanged(String value, int index) {
    if (value.length > 1) {
      final last = value.substring(value.length - 1);
      pinControllers[index].text = last;
      pinControllers[index].selection =
          TextSelection.collapsed(offset: last.length);
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
