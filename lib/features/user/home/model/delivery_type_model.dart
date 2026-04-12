class DeliveryTypeModel {
  final int id;
  final String name;
  final int deliveryTime;
  final String deliveryUnit;
  final String? priceMultiplier;

  DeliveryTypeModel({
    required this.id,
    required this.name,
    required this.deliveryTime,
    required this.deliveryUnit,
    required this.priceMultiplier,
  });

  factory DeliveryTypeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTypeModel(
      id: json['id'],
      name: json['name'],
      deliveryTime: json['delivery_time'] ?? 0,
      deliveryUnit: json['delivery_unit'] ?? 'MINUTES',
      priceMultiplier: json['price_multiplier'],
    );
  }

  String get formattedSubtitle {
    return "Delivery within $deliveryTime ${deliveryUnit.toLowerCase()} of collection";
  }
}
