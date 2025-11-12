import 'package:get/get.dart';

class YourRewardsController extends GetxController {
  var totalCredits = 40.obs;
  var currencyValue = 50.04.obs;
  var referralHistory = [
    {'name': 'Din Tin', 'date': '20 Aug 25'},
    {'name': 'John Poh', 'date': '20 Aug 25'},
  ].obs;

  void redeemCredits() {
    // Action when button is pressed
  }
}
