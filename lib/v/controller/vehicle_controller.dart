import 'package:get/get.dart';
import 'package:nicholaslim80/v/models/v_models.dart';

class Vcontroller extends GetxController {
  // 0 = Bike, 1 = Car, 2 = Van, 3 = Truck
  var selectedCategoryIndex = 1.obs;
  var selectedVehicleId = ''.obs;

  // Mock Data
  // REPLACE 'assets/...' WITH YOUR ACTUAL IMAGE PATHS
  final List<List<Vehicle>> vehicleCategories = [
    // 0: Motorbike
    [
      Vehicle(
        id: 'v1',
        name: 'Courier',
        description: 'Perfect for small goods, with a faster order pickup time',
        dimensions: '40 x 30 x 30 cm - Up to 8 kg',
        price: 10.00,
        imagePath: 'assets/bike.png',
      ),
    ],
    // 1: Car
    [
      Vehicle(
        id: 'v2',
        name: 'Car',
        description: 'Car delivery of medium size items',
        dimensions: '70 x 50 x 50 cm - Up to 20 kg',
        price: 15.00,
        imagePath: 'assets/car.png',
      ),
      Vehicle(
        id: 'v3',
        name: 'MPV (Weight < 25 kg x 2)',
        description: 'Ideal for small medium size carbon boxes, mini hamper',
        dimensions: '110 x 80 x 50 cm - Up to 50 kg',
        price: 22.00,
        imagePath: 'assets/mpv.png',
      ),
    ],
    // 2: Van
    [
      Vehicle(
        id: 'v4',
        name: 'Van',
        description: 'Large goods delivery',
        dimensions: '200 x 120 x 120 cm - Up to 500 kg',
        price: 40.00,
        imagePath: 'assets/van.png',
      ),
    ],
    // 3: Truck
    [
      Vehicle(
        id: 'v5',
        name: '10 ft Truck',
        description: 'Truck delivery of multiple large & bulky items',
        dimensions: '290 x 140 x 170 cm - Up to 1200 kg',
        price: 55.00,
        imagePath: 'assets/truck_10.png',
      ),
      Vehicle(
        id: 'v6',
        name: '14 ft Truck',
        description: 'Truck delivery of multiple large & bulky items',
        dimensions: '420 x 170 x 190 cm - Up to 2000 kg',
        price: 85.00,
        imagePath: 'assets/truck_14.png',
      ),
    ],
  ];

  // Additional Services Data
  var services = <Service>[
    Service(
      name: 'Controlled zone (extra delivery time required)',
      price: 15.00,
    ),
    Service(name: 'Get for me (Food / beverage only)', price: 15.00),
    Service(name: 'Tailboard', price: 20.00),
  ].obs;

  // Logic to calculate total
  double get totalPrice {
    double basePrice = 0.0;

    // Find price of selected vehicle
    for (var cat in vehicleCategories) {
      for (var v in cat) {
        if (v.id == selectedVehicleId.value) {
          basePrice = v.price;
          break;
        }
      }
    }

    // Add services
    double serviceTotal = services
        .where((s) => s.isSelected.value)
        .fold(0.0, (sum, item) => sum + item.price);

    return basePrice + serviceTotal;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
    // Auto select first vehicle in category for better UX
    if (vehicleCategories[index].isNotEmpty) {
      selectedVehicleId.value = vehicleCategories[index][0].id;
    } else {
      selectedVehicleId.value = '';
    }
    // Optional: Reset services when changing category
    // for (var s in services) s.isSelected.value = false;
  }
}
