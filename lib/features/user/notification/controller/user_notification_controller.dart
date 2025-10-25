import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/notification/model/notification1_model.dart';

class UserNotificationController extends GetxController {
  final RxInt selectNotificationListIndex = 0.obs;

  var notificationList = [
    "Notifications (1)",
    "Order Updates (2)",
    "Promotions (3)",
  ];

  final RxList notification1 = [].obs;

  @override
  void onInit() {

  notification1Item;
   

    super.onInit();
  }


  void get notification1Item => notification1.addAll([
      Notification1Model(
        title: "Wallet Credited",
        subTitle: "7 coins added to your wallet successfully.",
        date: "20-09-25",
        time: "10:30 am",
      ),
      Notification1Model(
        title: "Promo Applied",
        subTitle: "10% off applied to your last order!",
        date: "20-09-25",
        time: "10:30 am",
      ),

      Notification1Model(
        title: "Order Confirmed",
        subTitle: "Your order #12345 has been confirmed.",
        date: "20-09-25",
        time: "10:30 am",
      ),
    ]);
}
