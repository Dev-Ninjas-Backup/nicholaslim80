import 'package:get/get.dart';

class TakeNowController extends GetxController {
  var dragX = 0.0.obs;
  var isSlideCompleted = false.obs;

  void onSlideComplete() {
    isSlideCompleted.value = true;

    Future.delayed(Duration(milliseconds: 200), () {
      // Navigate to Google Map Screen
      // Get.toNamed('/googleMapScreen');
    });
  }

  void resetSlide() {
    dragX.value = 0.0;
  }
}
