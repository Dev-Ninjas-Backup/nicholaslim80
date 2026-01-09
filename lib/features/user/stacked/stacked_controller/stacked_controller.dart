import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:get/get.dart';

class StackedVehicleModel {
  final String iconPath;
  StackedVehicleModel(this.iconPath);
}

/// Model to store address data returned from destination API
class AddressData {
  final int id;
  final String address;
  final String addressFromApr;
  final String floorUnit;
  final String contactName;
  final String contactNumber;
  final String noteToDriver;
  final bool isSaved;
  final String type; // SENDER or RECEIVER

  AddressData({
    required this.id,
    required this.address,
    required this.addressFromApr,
    required this.floorUnit,
    required this.contactName,
    required this.contactNumber,
    required this.noteToDriver,
    required this.isSaved,
    required this.type,
  });
}

class StackedLocationController extends GetxController {
  // trip/time state
  var isRoundTrip = false.obs;
  var isNowSelected = true.obs;

  // editing state used by widgets that allow inline title edit
  var isEditing = false.obs;

  // Sender and Receiver address data
  var senderData = Rxn<AddressData>();
  var receiverData = Rxn<AddressData>();

  // vehicles
  var vehicleList = <StackedVehicleModel>[].obs;

  // selected vehicle state
  var selectedVehicle = Rxn<StackedVehicleModel>();

  @override
  void onInit() {
    super.onInit();
    loadVehicleData();
  }

  // Load initial vehicles
  void loadVehicleData() {
    vehicleList.value = [
      StackedVehicleModel(IconPath.car2),
      StackedVehicleModel(IconPath.bike2),
      StackedVehicleModel(IconPath.shopcar),
      StackedVehicleModel(IconPath.shipment),
    ];
  }

  void selectNow() => isNowSelected.value = true;
  void selectSchedule() => isNowSelected.value = false;
  void toggleTripType(bool isRound) => isRoundTrip.value = isRound;
  
  void selectVehicle(StackedVehicleModel vehicle) {
    selectedVehicle.value = vehicle;
  }

  /// Update sender data when saved from schedule sender screen
  void updateSenderData(AddressData data) {
    senderData.value = data;
  }

  /// Update receiver data when saved from schedule recipient screen
  void updateReceiverData(AddressData data) {
    receiverData.value = data;
  }

  /// Get sender display text (name + address)
  String get senderDisplayName => senderData.value?.contactName ?? 'Sender Name';
  String get senderDisplayAddress => senderData.value?.addressFromApr ?? 'Sender Address';

  /// Get receiver display text (name + address)
  String get receiverDisplayName => receiverData.value?.contactName ?? 'Recipient Name';
  String get receiverDisplayAddress => receiverData.value?.addressFromApr ?? 'Delivered Address';
}
