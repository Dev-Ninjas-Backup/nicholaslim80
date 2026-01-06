import 'package:ZipBee/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  late PageController pageController;

  final List<Map<String, String>> onboardingData = [
    {
      "image": ImagePath.onboarding1,
      "title": "Cash on Delivery or e-payment",
      "subtitle":
          "Our delivery ensure your items are delivered right to the door steps",
    },
    {
      "image": ImagePath.onboarding2,
      "title": "Real-time Tracking",
      "subtitle":
          "Track your packages / items from the comfort of your home till final design",
    },
    {
      "image": ImagePath.onboarding3,
      "title": "Deliver Right to Your Door Step",
      "subtitle": "Our delivery ensure your items are delivered right to the door steps",
    },
  ];

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) {
      pageController.nextPage(
        
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }else {
      Get.offNamed('/loginScreen');
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
