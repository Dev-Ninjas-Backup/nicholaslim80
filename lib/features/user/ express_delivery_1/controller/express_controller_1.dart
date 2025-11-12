import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

class VehicleModel {
  final String iconPath;
  VehicleModel(this.iconPath);
}

class LocationController extends GetxController {
  // trip/time state
  var isRoundTrip = false.obs;
  var isNowSelected = true.obs;

  // editing state used by widgets that allow inline title edit
  var isEditing = false.obs;

  // a simple title property used by the CollectInfoWidget
  var title = 'Collected from (Sender: Athena Lin)'.obs;

  // vehicles
  var vehicleList = <VehicleModel>[].obs;

  // selected vehicle state
  var selectedVehicle = Rxn<VehicleModel>();

  @override
  void onInit() {
    super.onInit();
    loadVehicleData();
  }

  // Load initial vehicles
  void loadVehicleData() {
    vehicleList.value = [
      VehicleModel(IconPath.car2),
      VehicleModel(IconPath.bike2),
      VehicleModel(IconPath.shopcar),
      VehicleModel(IconPath.shipment),
    ];
  }

  void selectNow() => isNowSelected.value = true;
  void selectSchedule() => isNowSelected.value = false;
  void toggleTripType(bool isRound) => isRoundTrip.value = isRound;
  // void toggleEdit() => isEditing.value = !isEditing.value;
  void updateTitle(String newTitle) => title.value = newTitle;

  // 👉 new function to select vehicle
  void selectVehicle(VehicleModel vehicle) {
    selectedVehicle.value = vehicle;
  }
}
