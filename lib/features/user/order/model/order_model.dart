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
          : (json['collect_time'] ?? "Scheduled Delivery"),
      pickupAddress: json['pickup_address'] ?? "Collect from",
      senderName: json['sender_name'] ?? "Unknown",
      dropOffAddress:
          json['drop_off_address'] ??
          "Deliver to ${json['total_stops'] ?? 1} destination(s)",
      deliveryLocation: json['delivery_location'] ?? "",
      vehicleType: json['vehicle_type_id'] == 1 ? "Motorbike" : "Vehicle",
      total: double.tryParse(json['total_cost']?.toString() ?? '0') ?? 0,
      showReceipt: json['status'] == "COMPLETED",
    );
  }
}
