class StackVehicle {
  final String name;
  final String type; // Courier, Car, Van, Truck
  final double price;
  final String details;
  final String? imageAsset; // optional
  final String? subtitle; // optional

  StackVehicle({
    required this.name,
    required this.type,
    required this.price,
    required this.details,
    this.imageAsset,
    this.subtitle,
  });
}

class StackedAdditionalService {
  final String name;
  final double price;
  final List<String>
  applicableTo; // List of vehicle types this service applies to

  StackedAdditionalService({
    required this.name,
    required this.price,
    required this.applicableTo,
  });
}
