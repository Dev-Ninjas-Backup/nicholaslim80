
import 'package:ZipBee/core/utils/constants/icon_path.dart';
import 'package:ZipBee/features/user/stacked/vehicle_type/model/model.dart';
import 'package:get/get.dart';



class StackedVehicleController extends GetxController {
  final selectedVehicle = Rxn<StackVehicle>();
  final selectedServices = <StackedAdditionalService>[].obs;
  final calculationHistory = <String>[].obs;

  final List<StackVehicle> _allVehicles = [
    StackVehicle(
      name: 'Courier',
      type: 'Courier',
      subtitle: 'Perfect for small goods, with a faster order pickup time',
      price: 15.0,
      details: '40x30x30 cm - Up to 8 kg',
      imageAsset: IconPath.courierIcon,
    ),
    StackVehicle(
      name: 'Car',
      type: 'Car',
      subtitle: 'Car delivery of medium size items',
      price: 15.0,
      details: '70x50x50 cm - Up to 20 kg',
      imageAsset: IconPath.realCar,
    ),
    StackVehicle(
      name: 'MPV',
      type: 'Car',
      subtitle: 'Ideal for small-medium size carton boxes, mini hamper',
      price: 25.0,
      details: '110x80x50 cm - Up to 50 kg',
      imageAsset: IconPath.realCar,
    ),
    StackVehicle(
      name: '1.7 m Van',
      type: 'Van',
      subtitle: 'Truck delivery of large & bulky items',
      price: 30.0,
      details: '160x120x100 cm - Up to 400 kg',
      imageAsset: IconPath.van,
    ),
    StackVehicle(
      name: '2.4 m Van',
      type: 'Van',
      subtitle: 'Van delivery of medium-large size items',
      price: 30.0,
      details: '160x120x100 cm - Up to 400 kg',
      imageAsset: IconPath.van,
    ),
    StackVehicle(
      name: '10 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple large & bulky items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk1,
    ),
    StackVehicle(
      name: '14 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple large & bulky items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk2,
    ),
    StackVehicle(
      name: '24 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple very large & bulky items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk3,
    ),
  ];

  final List<StackedAdditionalService> _allServices = [
    StackedAdditionalService(
      name: 'Controlled zone',
      price: 15.0,
      applicableTo: ['Courier', 'Car'],
    ),
    StackedAdditionalService(
      name: 'Get for me (Food / beverage only)',
      price: 30.0,
      applicableTo: ['Courier'],
    ),
    StackedAdditionalService(
      name: 'Get for me (Others except food / beverage)',
      price: 20.0,
      applicableTo: ['Courier'],
    ),
    StackedAdditionalService(name: 'Door-to-door', price: 30.0, applicableTo: ['Van']),
    StackedAdditionalService(name: 'Tailboard', price: 20.0, applicableTo: ['Truck']),
    StackedAdditionalService(name: 'Open/Box', price: 20.0, applicableTo: ['Truck']),
  ];

  List<StackVehicle> getVehiclesForType(String type) =>
      _allVehicles.where((v) => v.type == type).toList();

  List<StackedAdditionalService> getAdditionalServicesForType(String type) {
    final vehicle = selectedVehicle.value;
    if (vehicle == null) return [];
    return _allServices
        .where((s) => s.applicableTo.contains(vehicle.type))
        .toList();
  }

  void selectVehicle(StackVehicle vehicle) {
    if (selectedVehicle.value == vehicle) {
      selectedVehicle.value = null;
      selectedServices.clear();
      calculationHistory.clear();
    } else {
      selectedVehicle.value = vehicle;
      selectedServices.clear();
      _updateHistory();
    }
  }

  void toggleService(StackedAdditionalService service) {
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
