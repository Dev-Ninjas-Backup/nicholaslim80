import 'package:nicholaslim80/core/utils/constants/icon_path.dart';

// --- Models ---
class Vehicle {
  final String name;
  final String type; // Courier, Car, Van, Truck
  final double price;
  final String details;
  final String? imageAsset;
  final String? subtitle;

  Vehicle({
    required this.name,
    required this.type,
    required this.price,
    required this.details,
    this.imageAsset,
    this.subtitle,
  });
}

class AdditionalService {
  final String name;
  final double price;
  final List<String> applicableTo;

  AdditionalService({
    required this.name,
    required this.price,
    required this.applicableTo,
  });
}

// --- Mock Data ---
class VehicleData {
  static final List<Vehicle> allVehicles = [
    Vehicle(
      name: 'Courier',
      type: 'Courier',
      subtitle: 'Perfect for small goods',
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
      subtitle: 'Ideal for small-medium size carton boxes',
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
      subtitle: 'Delivery of multiple large items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk1,
    ),
    Vehicle(
      name: '14 ft Truck',
      type: 'Truck',
      subtitle: 'Delivery of multiple large items',
      price: 50.0,
      details: '420x170x190 cm - Up to 2000 kg',
      imageAsset: IconPath.trunk2,
    ),
  ];

  static final List<AdditionalService> allServices = [
    AdditionalService(
      name: 'Controlled zone',
      price: 15.0,
      applicableTo: ['Courier', 'Car'],
    ),
    AdditionalService(
      name: 'Get for me (Food)',
      price: 30.0,
      applicableTo: ['Courier'],
    ),
    AdditionalService(
      name: 'Get for me (Others)',
      price: 20.0,
      applicableTo: ['Courier'],
    ),
    AdditionalService(name: 'Door-to-door', price: 30.0, applicableTo: ['Van']),
    AdditionalService(name: 'Tailboard', price: 20.0, applicableTo: ['Truck']),
    AdditionalService(name: 'Open/Box', price: 20.0, applicableTo: ['Truck']),
  ];
}
