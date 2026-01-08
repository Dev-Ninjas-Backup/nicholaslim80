class OrderModel {
  final String orderId;
  final String status;
  final String date;
  final String pickupAddress;
  final String senderName;
  final String dropOffAddress;
  final String deliveryLocation;
  final String vehicleType;
  final double total;
  final bool showReceipt;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.date,
    required this.pickupAddress,
    required this.senderName,
    required this.dropOffAddress,
    required this.deliveryLocation,
    required this.vehicleType,
    required this.total,
    required this.showReceipt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['id']?.toString() ?? '',
      status: json['status'] ?? '',
      date: json['collect_time'] == "ASAP"
          ? "Pick-up ASAP"
          : "Scheduled Delivery",
      pickupAddress: json['pickup_address'] ?? "Collect from",
      senderName: json['sender_name'] ?? "Collect from",
      dropOffAddress: json['drop_off_address'] ?? "Deliver to",
      deliveryLocation: json['delivery_location'] ?? "",
      vehicleType: _vehicleName(json['vehicle_type_id']),
      total: double.tryParse(json['total_cost']?.toString() ?? '0') ?? 0,
      showReceipt: json['status'] == "COMPLETED",
    );
  }

  /// ✅ Add this method to convert OrderModel to JSON
  Map<String, dynamic> toJson() => {
    'id': orderId,
    'status': status,
    'collect_time': date,
    'pickup_address': pickupAddress,
    'sender_name': senderName,
    'drop_off_address': dropOffAddress,
    'delivery_location': deliveryLocation,
    'vehicle_type': vehicleType,
    'total_cost': total,
    'showReceipt': showReceipt,
  };

  // ✅ vehicle name mapping
  static String _vehicleName(dynamic id) {
    switch (id) {
      case 1:
        return "Motorbike";
      case 2:
        return "Bicycle";
      case 3:
        return "Car";
      case 4:
        return "Truck";
      default:
        return "Vehicle";
    }
  }
}
