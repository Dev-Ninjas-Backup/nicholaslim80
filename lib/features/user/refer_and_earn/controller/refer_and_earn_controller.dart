import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/service/refer_and_earn_service.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/how_it_work/screen/how_it_work_screen.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/your_rewards/screen/your_rewards_screen.dart';
import 'package:nicholaslim80/core/api_end_point/api_end_point.dart';

class ReferAndEarnController extends GetxController {
  // observable values
  RxString referralCode = ''.obs;
  RxString referralLink = ''.obs;

  // future use
  RxInt rewardPoints = 0.obs;
  RxInt rewardMoney = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralInfo();
  }

  Future<void> fetchReferralInfo() async {
    final result = await ReferAndEarnService.fetchReferralData();

    if (result['statusCode'] == 200) {
      final responseBody = result['body'];
      // The API returns { success: ..., message: ..., data: { ...user... } }
      final data = responseBody is Map && responseBody.containsKey('data')
          ? responseBody['data'] as Map<String, dynamic>
          : (responseBody as Map<String, dynamic>);

      referralCode.value = data['referral_code'] ?? '';

      final rawLink = (data['referral_link'] ?? '').toString();
      if (rawLink.isNotEmpty) {
        if (rawLink.startsWith('http')) {
          referralLink.value = rawLink;
        } else {
          referralLink.value = '${ApiEndPoint.baseUrl.replaceAll(RegExp(r"/+"), '')}/$rawLink';
        }
      } else {
        referralLink.value = '';
      }

      rewardPoints.value = data['reward_points'] ?? 0;
      // also fetch rewardMoney from user data
      rewardMoney.value = data['rewardMoney'] ?? data['reward_money'] ?? 0;

      debugPrint('Referral Code: ${referralCode.value}');
      debugPrint('Referral Link: ${referralLink.value}');
      debugPrint('Reward Points: ${rewardPoints.value}');
      debugPrint('Reward Money: ${rewardMoney.value}');
    } else {
      debugPrint('Failed to fetch referral info');
    }
  }

  // ---------------- copy actions ----------------
  Future<void> copyCode() async {
    await Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar('Copied', 'Referral code copied');
  }

  Future<void> copyLink() async {
    await Clipboard.setData(ClipboardData(text: referralLink.value));
    Get.snackbar('Copied', 'Referral link copied');
  }

  // ---------------- navigation ----------------
  void openRewards() {
    // pass current reward points, reward money and referral code to the YourRewardsScreen
    Get.to(() => YourRewardsScreen(), arguments: {
      'totalCredits': rewardPoints.value,
      'rewardMoney': rewardMoney.value,
      'referralCode': referralCode.value,
    });
  }

  void openHowItWorks() {
    Get.to(() => HowItWorksScreen());
  }
}
