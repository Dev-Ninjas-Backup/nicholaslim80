import 'package:get/get.dart';

class KamrulExpressController extends GetxController {
  var isRoundTrip = false.obs;
  var collectNow = true.obs;
  var selectedVehicle = 0.obs;

  var senderName = "Athena Lin".obs;
  var receiverName = "Joseph Low".obs;

  void toggleTrip(bool value) {
    isRoundTrip.value = value;
  }

  void toggleCollect(bool now) {
    collectNow.value = now;
  }

  void selectVehicle(int index) {
    selectedVehicle.value = index;
  }

  var isNow = true.obs;

  var selectedDateTime = DateTime.now().obs;

  void setNow(bool value) {
    isNow.value = value;
  }

  void setDateTime(DateTime dt) {
    selectedDateTime.value = dt;
    isNow.value = false;
  }
}
