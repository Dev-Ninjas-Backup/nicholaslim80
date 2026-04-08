import 'package:get/get.dart';
import 'package:ZipBee/features/user/home/controller/home_controller.dart';

class BottomNavbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    if (index == 0 && Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().resetHomeSelection();
    }
    currentIndex.value = index;
  }
}
