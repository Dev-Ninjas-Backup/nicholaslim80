// lib/controllers/otp_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nicholaslim80/routes/app_routes.dart';

class VerificationController extends GetxController {
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  RxString otp = ''.obs;

  final RxInt secondsLeft = 50.obs;
  Timer? timer;

  final RxBool isVerifying = false.obs;

  bool get canResend => secondsLeft.value == 0;
  bool get canVerify => otp.value.length == 4 && !isVerifying.value;

  @override
  void onInit() {
    super.onInit();
    for (var c in pinControllers) {
      c.addListener(onPinsChanged);
    }
    startTimer();
  }

  void onPinsChanged() {
    final combined = pinControllers.map((c) => c.text).join();
    otp.value = combined;
  }

  void startTimer({int from = 50}) {
    timer?.cancel();
    secondsLeft.value = from;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsLeft.value == 0) {
        timer.cancel();
        secondsLeft.value = 0;
      } else {
        secondsLeft.value = secondsLeft.value - 1;
      }
    });
  }

  void resendCode() {
    if (!canResend) return;
    startTimer(from: 50);
  }

  Future<void> verifyCode() async {
    if (!canVerify) return;
    isVerifying.value = true;
    try {
      await Future.delayed(Duration(seconds: 1));

      Get.offAllNamed(AppRoutes.getbottomNavbarScreen());
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
    for (var c in pinControllers) {
      c.clear();
    }
    focusNodes[0].requestFocus();
  }

  @override
  void onClose() {
    timer?.cancel();
    for (var c in pinControllers) {
      c.removeListener(onPinsChanged);
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
