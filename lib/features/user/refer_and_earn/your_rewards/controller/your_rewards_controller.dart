import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/your_rewards/service/your_rewards_service.dart';
import 'package:nicholaslim80/features/user/refer_and_earn/widget/redeem_credits_suscess_widget.dart';

class YourRewardsController extends GetxController {
  var totalCredits = 1.obs;
  var currencyValue = 0.0.obs;
  var referralHistory = [
    {'name': 'Din Tin', 'date': '20 Aug 25'},
    {'name': 'John Poh', 'date': '20 Aug 25'},
  ].obs;

  YourRewardsController({int initialCredits = 0}) {
    totalCredits.value = initialCredits;
  }

  @override
  void onInit() {
    super.onInit();
    _loadBasePrice();
  }

  Future<void> _loadBasePrice() async {
    final result = await YourRewardsService.fetchBasePrice();
    debugPrint('fetchBasePrice result: $result');
    if (result['statusCode'] == 200) {
      final body = result['body'];
      final value = body is Map && body.containsKey('data') ? body['data'] : null;
      if (value != null) {
        currencyValue.value = (value as num).toDouble();
      }
    }
  }

  Future<void> redeemCredits() async {
    final coin = totalCredits.value;
    if (coin <= 0) {
      Get.snackbar('Error', 'No credits to redeem');
      return;
    }

    final result = await YourRewardsService.redeemCoin(coin: coin);
    debugPrint('redeemCredits result: $result');

    final statusCode = result['statusCode'] as int;
    final body = result['body'];

    String message = 'Something went wrong';

    if (body is Map) {
      if (body.containsKey('message')) {
        message = body['message'].toString();
      } else if (body.containsKey('error') && body['error'] is Map && body['error'].containsKey('message')) {
        message = body['error']['message'].toString();
      }
    }

    Get.snackbar(statusCode == 200 ? 'Success' : 'Error', message);

    if (statusCode == 200) {
      // Navigate to success screen
      Get.to(() => RedeemSuccessScreen());
    }
  }
}
