import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

class GariModel {
  final String iconPath;
  GariModel(this.iconPath);
}

class LocationController extends GetxController {
  var isRoundTrip = false.obs;
  var isNowSelected = true.obs;

  var gariList = <GariModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadGariData();
  }

  // Load initial vehicles
  void loadGariData() {
    gariList.value = [
      GariModel(IconPath.car2),
      GariModel(IconPath.bike2),
      GariModel(IconPath.shopcar),
    ];
  }

  void selectNow() => isNowSelected.value = true;

  void selectSchedule() => isNowSelected.value = false;

  void toggleTripType(bool isRound) {
    isRoundTrip.value = isRound;
  }
}
