class OrderModel {
  final String orderId;
  final String status;
  final String date;
  final String pickupAddress;
  final String dropOffAddress;
  final String vehicleType;
  final double total;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.date,
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.vehicleType,
    required this.total,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      /// 🔹 API has `id`
      orderId: json['id']?.toString() ?? '',

      /// 🔹 API status comes from tab (ONGOING / COMPLETED / CANCELLED)
      status: json['status'] ?? '',

      /// 🔹 API has no date → fallback text
      date: "ASAP Delivery",

      /// 🔹 API has no pickup address → fallback
      pickupAddress: "Collect from sender",

      /// 🔹 API has no dropoff address → fallback using stops
      dropOffAddress: "Deliver to ${json['total_stops'] ?? 1} destination(s)",

      /// 🔹 vehicle_type_id mapping
      vehicleType: json['vehicle_type_id'] == 1 ? "Motorbike" : "Vehicle",

      /// 🔹 API total_cost is STRING
      total: double.tryParse(json['total_cost']?.toString() ?? '0') ?? 0,
    );
  }
}
