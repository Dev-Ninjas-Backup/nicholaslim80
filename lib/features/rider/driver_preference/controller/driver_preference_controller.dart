import 'package:get/get.dart';

class DriverPreferenceController extends GetxController {
  var isOffline = false.obs;
  var isAutoPopup = false.obs;
  var distanceRadius = 5.0.obs;

  void toggleOffline(bool value) {
    isOffline.value = value;
  }

  void toggleAutoPopup(bool value) {
    isAutoPopup.value = value;
  }

  void markAsDone() {}

  void cancelOrder() {}
}
