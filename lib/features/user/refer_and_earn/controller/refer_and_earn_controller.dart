import 'package:get/get.dart';
import 'package:flutter/services.dart';

class ReferAndEarnController extends GetxController {
  final referralCode = 'A22443366'.obs;
  final referralLink = 'https://www..sg/referral/abx...'.obs;

  Future<void> copyCode() async {
    await Clipboard.setData(ClipboardData(text: referralCode.value));
  }

  Future<void> copyLink() async {
    await Clipboard.setData(ClipboardData(text: referralLink.value));
  }

  void onInvitePressed() {}

  void openRewards() {
    // Get.to(() => RewardsScreen());
  }

  void openHowItWorks() {
    // Get.to(() => HowItWorksScreen());
  }
}
