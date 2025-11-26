import 'package:get/get.dart';
import 'package:nicholaslim80/features/user/Sechedule_veycale_type/models/vehicle_data_model.dart';

class VehicleSelectionController extends GetxController {
  // Observables
  final Rxn<Vehicle> selectedVehicle = Rxn<Vehicle>();
  final RxList<AdditionalService> selectedServices = <AdditionalService>[].obs;

  // Get total amount
  double get totalAmount {
    final base = selectedVehicle.value?.price ?? 0.0;
    final services = selectedServices.fold(0.0, (sum, s) => sum + s.price);
    return base + services;
  }

  bool get isOrderReady => selectedVehicle.value != null;

  // Get vehicles by type
  List<Vehicle> getVehiclesByType(String type) {
    return VehicleData.allVehicles.where((v) => v.type == type).toList();
  }

  // Get available services for selected vehicle
  List<AdditionalService> get availableServices {
    final vehicle = selectedVehicle.value;
    if (vehicle == null) return [];
    return VehicleData.allServices
        .where((s) => s.applicableTo.contains(vehicle.type))
        .toList();
  }

  // Select vehicle
  void selectVehicle(Vehicle vehicle) {
    if (selectedVehicle.value == vehicle) {
      selectedVehicle.value = null;
      selectedServices.clear();
    } else {
      selectedVehicle.value = vehicle;
      selectedServices.clear();
    }
  }

  // Toggle additional service
  void toggleService(AdditionalService service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
  }

  // Calculation history
  List<String> get calculationHistory {
    final history = <String>[];
    if (selectedVehicle.value != null) {
      history.add(
        "${selectedVehicle.value!.name}: S\$${selectedVehicle.value!.price.toStringAsFixed(2)}",
      );
    }
    for (var s in selectedServices) {
      history.add("${s.name}: S\$${s.price.toStringAsFixed(2)}");
    }
    return history;
  }
}
