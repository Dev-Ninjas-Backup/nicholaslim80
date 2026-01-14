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

  // Rider info
  final String assignRiderName;
  final String assignRiderPhone;
  final String assignRiderImage;
  final double assignRiderRating;
  final int assignRiderReviews;
  final int? riderId;
  final String scheduledTime;

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
    this.assignRiderName = "Rider",
    this.assignRiderPhone = "",
    this.assignRiderImage = "",
    this.assignRiderRating = 0.0,
    this.assignRiderReviews = 0,
    this.riderId,
    required this.scheduledTime,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['id']?.toString() ?? '',
      status: json['order_status'] ?? json['status'] ?? '',
      date: json['collect_time']?.toString() == "ASAP"
          ? "Pick-up ASAP"
          : "Scheduled Delivery",
      pickupAddress: json['pickup_address']?.toString() ?? "Collect from",
      senderName: json['sender_name']?.toString() ?? "Collect from",
      dropOffAddress: json['drop_off_address']?.toString() ?? "Deliver to",
      deliveryLocation: json['delivery_location']?.toString() ?? "",
      vehicleType: _vehicleName(json['vehicle_type_id']),
      total: double.tryParse(json['total_cost']?.toString() ?? '0') ?? 0,
      showReceipt:
          (json['order_status'] ?? json['status'])?.toString() == "COMPLETED",
      riderId: json['assign_rider_id'],
      scheduledTime:
          json['scheduled_time']?.toString() ??
          json['collect_time']?.toString() ??
          "",
    );
  }

  OrderModel copyWith({
    String? assignRiderName,
    String? assignRiderPhone,
    String? assignRiderImage,
    double? assignRiderRating,
    int? assignRiderReviews,
  }) {
    return OrderModel(
      orderId: orderId,
      status: status,
      date: date,
      pickupAddress: pickupAddress,
      senderName: senderName,
      dropOffAddress: dropOffAddress,
      deliveryLocation: deliveryLocation,
      vehicleType: vehicleType,
      total: total,
      showReceipt: showReceipt,
      assignRiderName: assignRiderName ?? this.assignRiderName,
      assignRiderPhone: assignRiderPhone ?? this.assignRiderPhone,
      assignRiderImage: assignRiderImage ?? this.assignRiderImage,
      assignRiderRating: assignRiderRating ?? this.assignRiderRating,
      assignRiderReviews: assignRiderReviews ?? this.assignRiderReviews,
      riderId: riderId,
      scheduledTime: scheduledTime,
    );
  }

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
