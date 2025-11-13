// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:nicholaslim80/core/utils/constants/icon_path.dart';
import 'package:nicholaslim80/features/user/Veicale_Type_on_Exprees_Delivery/models/data_model.dart';

class VehicleController extends GetxController {
  final selectedVehicle = Rxn<Vehicle>();
  final selectedServices = <AdditionalService>[].obs;
  final calculationHistory = <String>[].obs;

  final List<Vehicle> _allVehicles = [
    Vehicle(
      name: 'Courier',
      type: 'Courier',
      subtitle: 'Perfect for small goods, with a faster order pickup time',
      price: 15.0,
      details: '40x30x30 cm - Up to 8 kg',
      imageAsset: IconPath.courierIcon,
    ),
    Vehicle(
      name: 'Car',
      type: 'Car',
      subtitle: 'Car delivery of medium size items',
      price: 15.0,
      details: '70x50x50 cm - Up to 20 kg',
      imageAsset: IconPath.realCar,
    ),
    Vehicle(
      name: 'MPV',
      type: 'Car',
      subtitle: 'Ideal for small-medium size carton boxes, mini hamper',
      price: 25.0,
      details: '110x80x50 cm - Up to 50 kg',
      imageAsset: IconPath.realCar,
    ),
    Vehicle(
      name: '1.7 m Van',
      type: 'Van',
      subtitle: 'Truck delivery of large & bulky items',
      price: 30.0,
      details: '160x120x100 cm - Up to 400 kg',
      imageAsset: IconPath.van,
    ),
    Vehicle(
      name: '2.4 m Van',
      type: 'Van',
      subtitle: 'Van delivery of medium-large size items',
      price: 30.0,
      details: '160x120x100 cm - Up to 400 kg',
      imageAsset: IconPath.van,
    ),
    Vehicle(
      name: '10 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple large & bulky items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk1,
    ),
    Vehicle(
      name: '14 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple large & bulky items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk2,
    ),
    Vehicle(
      name: '24 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple very large & bulky items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk3,
    ),
  ];

  final List<AdditionalService> _allServices = [
    AdditionalService(
      name: 'Controlled zone',
      price: 15.0,
      applicableTo: ['Courier', 'Car'],
    ),
    AdditionalService(
      name: 'Get for me (Food / beverage only)',
      price: 30.0,
      applicableTo: ['Courier'],
    ),
    AdditionalService(
      name: 'Get for me (Others except food / beverage)',
      price: 20.0,
      applicableTo: ['Courier'],
    ),
    AdditionalService(name: 'Door-to-door', price: 30.0, applicableTo: ['Van']),
    AdditionalService(name: 'Tailboard', price: 20.0, applicableTo: ['Truck']),
    AdditionalService(name: 'Open/Box', price: 20.0, applicableTo: ['Truck']),
  ];

  List<Vehicle> getVehiclesForType(String type) =>
      _allVehicles.where((v) => v.type == type).toList();

  List<AdditionalService> getAdditionalServicesForType(String type) {
    final vehicle = selectedVehicle.value;
    if (vehicle == null) return [];
    return _allServices
        .where((s) => s.applicableTo.contains(vehicle.type))
        .toList();
  }

  void selectVehicle(Vehicle vehicle) {
    if (selectedVehicle.value == vehicle) {
      // unselect
      selectedVehicle.value = null;
      selectedServices.clear();
      calculationHistory.clear();
    } else {
      selectedVehicle.value = vehicle;
      selectedServices.clear();
      _updateHistory();
    }
  }

  void toggleService(AdditionalService service) {
    selectedServices.contains(service)
        ? selectedServices.remove(service)
        : selectedServices.add(service);

    _updateHistory();
  }

  double calculateTotal() {
    double total = selectedVehicle.value?.price ?? 0;

    total += selectedServices.fold(0.0, (sum, item) => sum + item.price);

    return total;
  }

  void _updateHistory() {
    calculationHistory.clear();

    if (selectedVehicle.value != null) {
      calculationHistory.add(
        "${selectedVehicle.value!.name}: S\$${selectedVehicle.value!.price.toStringAsFixed(2)}",
      );
    }

    for (var s in selectedServices) {
      calculationHistory.add("${s.name}: S\$${s.price.toStringAsFixed(2)}");
    }
  }

  bool get isOrderReady => selectedVehicle.value != null;
}
