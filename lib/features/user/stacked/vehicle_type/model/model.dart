class StackVehicle {
  final int? id;
  final String name; // vehicle_type or friendly name
  final String type; // normalized type e.g., 'CAR', 'VAN', 'TRUCK', 'MOTORCYCLE'
  final double price; // use basePrice as primary price
  final double? basePrice;
  final double? perKmPrice;
  final String details; // dimension + max_load
  final String? dimension;
  final String? maxLoad;
  final bool? isActive;
  final String? imageAsset; // optional
  final String? subtitle; // optional

  StackVehicle({
    this.id,
    required this.name,
    required this.type,
    required this.price,
    this.basePrice,
    this.perKmPrice,
    required this.details,
    this.dimension,
    this.maxLoad,
    this.isActive,
    this.imageAsset,
    this.subtitle,
  });

  factory StackVehicle.fromApi(Map<String, dynamic> map) {
    // API fields: vehicle_type, base_price, per_km_price, dimension, max_load
    final vehicleType = (map['vehicle_type'] ?? '').toString();
    double? bp;
    double? pk;
    try {
      bp = map['base_price'] != null ? double.tryParse(map['base_price'].toString()) : null;
    } catch (_) {
      bp = null;
    }
    try {
      pk = map['per_km_price'] != null ? double.tryParse(map['per_km_price'].toString()) : null;
    } catch (_) {
      pk = null;
    }

    final dim = map['dimension']?.toString();
    final maxLoad = map['max_load']?.toString();

    final detailsParts = <String>[];
    if (dim != null && dim.isNotEmpty) detailsParts.add(dim);
    if (maxLoad != null && maxLoad.isNotEmpty) detailsParts.add('Up to $maxLoad');

    return StackVehicle(
      id: map['id'] is int ? map['id'] as int : int.tryParse(map['id']?.toString() ?? ''),
      name: vehicleType,
      type: vehicleType,
      price: bp ?? 0.0,
      basePrice: bp,
      perKmPrice: pk,
      details: detailsParts.join(' - '),
      dimension: dim,
      maxLoad: maxLoad,
      isActive: map['isActive'] == true || map['isActive'].toString() == 'true',
    );
  }
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


