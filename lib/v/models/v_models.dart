import 'package:get/get.dart';

class Vehicle {
  final String id;
  final String name;
  final String description;
  final String dimensions;
  final String imagePath; // Your asset path
  final double price;

  Vehicle({
    required this.id,
    required this.name,
    required this.description,
    required this.dimensions,
    required this.imagePath,
    required this.price,
  });
}

class Service {
  final String name;
  final double price;
  // We use RxBool so the checkbox updates instantly in the UI
  RxBool isSelected = false.obs;

  Service({required this.name, required this.price});
}
