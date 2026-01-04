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
      orderId: json['orderId'] ?? '',
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      pickupAddress: json['pickup_address'] ?? '',
      dropOffAddress: json['dropoff_address'] ?? '',
      vehicleType: json['vehicle_type'] ?? 'Car',
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}
