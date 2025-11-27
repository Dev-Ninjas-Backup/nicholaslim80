import 'package:get/get.dart';

class StackedOrderController extends GetxController {
  var orderNumber = '#1233'.obs;
  var isDriverAssigned = false.obs;
  var countdown = 10.obs;
  
  // New properties for Order Confirmation Details
  var totalAmount = 0.0; // Will be set before showing dialog
  var redeemCoins = false.obs;
  var favoriteRiders = false.obs;

  void toggleRedeemCoins(bool value) {
    redeemCoins.value = value;
  }

  void toggleFavoriteRiders(bool value) {
    favoriteRiders.value = value;
  }

// @override
// void onInit() {
//   super.onInit();

//   // // COUNTDOWN TIMER
//   // ever(countdown, (value) {
//   //   if (countdown.value == 0) return;
//   // });

//   // countdownTimer();
//   autoNavigate();
// }

// void countdownTimer() async {
//   for (int i = 10; i >= 0; i--) {
//     await Future.delayed(const Duration(seconds: 1));
//     countdown.value = i;
//   }
// }
}
