
// import 'package:ZipBee/v/models/v_models.dart';
// import 'package:get/get.dart';

// class VehicleController extends GetxController {
//   // 0 = Bike, 1 = Car, 2 = Van, 3 = Truck
//   final selectedCategoryIndex = 1.obs;
//   final selectedVehicleId = ''.obs;

//   final List<List<VModels>> vehicleCategories = [
//     // Bike
//     [
//       VModels(
//         id: 'v1',
//         name: 'Courier',
//         description: 'Perfect for small goods, with a faster order pickup time',
//         dimensions: '40 x 30 x 30 cm - Up to 8 kg',
//         price: 10.0,
//         imagePath: 'assets/bike.png', 
//       ),
//     ],

//     // Car
//     [
//       VModels(
//         id: 'v2',
//         name: 'Car',
//         description: 'Car delivery of medium size items',
//         dimensions: '70 x 50 x 50 cm - Up to 20 kg',
//         price: 15.0,
//         imagePath: 'assets/car.png', 
//       ),
//       VModels(
//         id: 'v3',
//         name: 'MPV (Weight < 25 kg x 2)',
//         description: 'Ideal for small medium size carbon boxes',
//         dimensions: '110 x 80 x 50 cm - Up to 50 kg',
//         price: 22.0,
//         imagePath: 'assets/mpv.png', 
//       ),
//     ],

//     // Van
//     [
//       VModels(
//         id: 'v4',
//         name: 'Van',
//         description: 'Large goods delivery',
//         dimensions: '200 x 120 x 120 cm - Up to 500 kg',
//         price: 40.0,
//         imagePath: 'assets/van.png', 
//       ),
//     ],

//     // Truck
//     [
//       VModels(
//         id: 'v5',
//         name: '10 ft Truck',
//         description: 'Large & bulky items',
//         dimensions: '290 x 140 x 170 cm - Up to 1200 kg',
//         price: 55.0,
//         imagePath: 'assets/truck_10.png', 
//       ),
//       VModels(
//         id: 'v6',
//         name: '14 ft Truck',
//         description: 'Large & bulky items',
//         dimensions: '420 x 170 x 190 cm - Up to 2000 kg',
//         price: 85.0,
//         imagePath: 'assets/truck_14.png', 
//       ),
//     ],
//   ];

//   final services = <ServiceV1>[
//     ServiceV1(
//       name: 'Controlled zone (extra delivery time required)',
//       price: 15.0,
//     ),
//     ServiceV1(
//       name: 'Get for me (Food / beverage only)',
//       price: 15.0,
//     ),
//     ServiceV1(
//       name: 'Tailboard',
//       price: 20.0,
//     ),
//   ].obs;

//   double get totalPrice {
//     double vehiclePrice = 0.0;

//     for (final category in vehicleCategories) {
//       for (final vehicle in category) {
//         if (vehicle.id == selectedVehicleId.value) {
//           vehiclePrice = vehicle.price;
//           break;
//         }
//       }
//     }

//     final serviceTotal = services
//         .where((s) => s.isSelected.value)
//         .fold(0.0, (sum, s) => sum + s.price);

//     return vehiclePrice + serviceTotal;
//   }

//   void selectCategory(int index) {
//     selectedCategoryIndex.value = index;

//     if (vehicleCategories[index].isNotEmpty) {
//       selectedVehicleId.value = vehicleCategories[index].first.id;
//     } else {
//       selectedVehicleId.value = '';
//     }

//     for (final service in services) {
//       service.isSelected.value = false;
//     }
//   }
// }
