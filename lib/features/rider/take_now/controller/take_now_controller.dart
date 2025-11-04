import 'package:get/get.dart';

class TakeNowController extends GetxController {
  var isSlideCompleted = false.obs;

  void onSlideComplete() {
    isSlideCompleted.value = true;
  }
}
