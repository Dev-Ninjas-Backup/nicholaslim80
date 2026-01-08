import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// ─────────────────────────
/// Vehicle Model
/// ─────────────────────────
class VehicleModel {
  final String iconPath;
  VehicleModel(this.iconPath);
}

/// ─────────────────────────
/// Location Controller
/// ─────────────────────────
class LocationController extends GetxController {
  // ─────────────────────────
  // Trip & Time State
  // ─────────────────────────
  final RxBool isRoundTrip = false.obs;
  final RxBool isNowSelected = true.obs;
  final Rxn<DateTime> scheduledDateTime = Rxn<DateTime>();

  // ─────────────────────────
  // UI Editing State
  // ─────────────────────────
  final RxBool isEditing = false.obs;

  /// fallback title (optional, editable)
  final RxString title = 'Collected from (Sender: Athena Lin)'.obs;

  // ─────────────────────────
  // 🔥 Sender Info
  // ─────────────────────────
  final RxString senderName = ''.obs;
  final RxString senderAddress = ''.obs;

  // ─────────────────────────
  // 🔥 Receiver Info
  // ─────────────────────────
  final RxString receiverName = ''.obs;
  final RxString receiverAddress = ''.obs;

  // ─────────────────────────
  // Vehicle State
  // ─────────────────────────
  final RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
  final Rxn<VehicleModel> selectedVehicle = Rxn<VehicleModel>();

  // ─────────────────────────
  // Init
  // ─────────────────────────
  @override
  void onInit() {
    super.onInit();
    loadVehicleData();
  }

  // ─────────────────────────
  // Vehicle Logic
  // ─────────────────────────
  void loadVehicleData() {
    vehicleList.assignAll([
      VehicleModel(IconPath.bike2),
      VehicleModel(IconPath.car2),
      VehicleModel(IconPath.shopcar),
      VehicleModel(IconPath.shipment),
    ]);
  }

  void selectVehicle(VehicleModel vehicle) {
    selectedVehicle.value = vehicle;
  }

  // ─────────────────────────
  // Trip Type
  // ─────────────────────────
  void toggleTripType(bool isRound) {
    isRoundTrip.value = isRound;
  }

  // ─────────────────────────
  // Schedule / Now Logic
  // ─────────────────────────
  void selectNow() {
    isNowSelected.value = true;
    scheduledDateTime.value = null;
  }

  void selectSchedule([DateTime? time]) {
    isNowSelected.value = false;
    if (time != null) {
      scheduledDateTime.value = time;
    }
  }

  String get formattedScheduledDateTime {
    if (scheduledDateTime.value == null) {
      return 'Pick Date and Time';
    }
    return DateFormat(
      'EEE, dd MMM, hh:mm a',
    ).format(scheduledDateTime.value!);
  }

  // ─────────────────────────
  // 🔥 Sender / Receiver Setter
  // ─────────────────────────
  void setSender({
    required String name,
    required String address,
  }) {
    senderName.value = name;
    senderAddress.value = address;
  }

  void setReceiver({
    required String name,
    required String address,
  }) {
    receiverName.value = name;
    receiverAddress.value = address;
  }

  // ─────────────────────────
  // Optional Title Update
  // ─────────────────────────
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }
}
