import 'package:get/get.dart';

class StackedOrderController extends GetxController {
  var orderNumber = '#1233'.obs;
  var isDriverAssigned = false.obs;
  var countdown = 10.obs;

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
