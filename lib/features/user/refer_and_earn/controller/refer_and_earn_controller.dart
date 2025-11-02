import 'package:get/get.dart';
import 'package:flutter/services.dart';

class ReferAndEarnController extends GetxController {
  final referralCode = 'A22443366'.obs;
  final referralLink = 'https://www..sg/referral/abx...'.obs;

  Future<void> copyCode() async {
    await Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      'Copied',
      'Referral code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> copyLink() async {
    await Clipboard.setData(ClipboardData(text: referralLink.value));
    Get.snackbar(
      'Copied',
      'Referral link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void onInvitePressed() {
    Get.snackbar(
      'Invite',
      'Open share sheet or navigate to share UI.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openRewards() {
    // Get.to(() => RewardsScreen());
    Get.snackbar(
      'Navigate',
      'Open Rewards screen',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openHowItWorks() {
    // Get.to(() => HowItWorksScreen());
    Get.snackbar(
      'Navigate',
      'Open How It Works',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
