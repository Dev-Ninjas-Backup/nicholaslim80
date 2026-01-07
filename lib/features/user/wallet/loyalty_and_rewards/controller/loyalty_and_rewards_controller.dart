import 'package:ZipBee/features/user/wallet/loyalty_and_rewards/widget/redeem_bottom_shit.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoyaltyAndRewardsController extends GetxController {
  RxInt points = 60.obs;
  RxDouble dollarValue = 50.04.obs;

  RxList<Map<String, dynamic>> history = [
    {"orderId": "#1088", "date": "20 Aug 25"},
    {"orderId": "#1087", "date": "20 Aug 25"},
  ].obs;

  void onBack() => Get.back();
  void showRedeemBottomSheet() {
    Get.bottomSheet(
      RedeemBottomSheet(
        onRedeem: () {
          Get.back();
          EasyLoading.showSuccess('Redeem clicked');
        },
        onCancel: () {
          Get.back();
        },
      ),
      isScrollControlled: true,
    );
  }

  void onInfoTap() {
    EasyLoading.showInfo('Loyalty & Rewards Information');
  }

  void onConvertPoints() {
    EasyLoading.showInfo('Points convert action triggered');
  }
}
