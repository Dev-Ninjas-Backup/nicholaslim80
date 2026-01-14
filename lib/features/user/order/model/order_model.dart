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

  // Coordinates
  final double? pickupLat;
  final double? pickupLong;
  final double? dropOffLat;
  final double? dropOffLong;

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
    this.pickupLat,
    this.pickupLong,
    this.dropOffLat,
    this.dropOffLong,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: (json['id'] ?? '').toString(),
      status: (json['order_status'] ?? json['status'] ?? '').toString(),
      date: (json['collect_time'] ?? '').toString() == "ASAP"
          ? "Pick-up ASAP"
          : "Scheduled Delivery",
      pickupAddress: (json['pickup_address'] ?? "Collect from").toString(),
      senderName: (json['sender_name'] ?? "Collect from").toString(),
      dropOffAddress: (json['drop_off_address'] ?? "Deliver to").toString(),
      deliveryLocation: (json['delivery_location'] ?? "").toString(),
      vehicleType: _vehicleName(json['vehicle_type_id']),
      total: double.tryParse((json['total_cost'] ?? '0').toString()) ?? 0,
      showReceipt:
          (json['order_status'] ?? json['status'] ?? '').toString() ==
          "COMPLETED",
      riderId: json['assign_rider_id'] is int
          ? json['assign_rider_id']
          : int.tryParse((json['assign_rider_id'] ?? '').toString()),
      scheduledTime: (json['scheduled_time'] ?? json['collect_time'] ?? "")
          .toString(),
      pickupLat: double.tryParse(json['pickup_lat']?.toString() ?? ''),
      pickupLong: double.tryParse(json['pickup_long']?.toString() ?? ''),
      dropOffLat: double.tryParse(json['drop_off_lat']?.toString() ?? ''),
      dropOffLong: double.tryParse(json['drop_off_long']?.toString() ?? ''),
    );
  }

  OrderModel copyWith({
    String? assignRiderName,
    String? assignRiderPhone,
    String? assignRiderImage,
    double? assignRiderRating,
    int? assignRiderReviews,
    double? pickupLat,
    double? pickupLong,
    double? dropOffLat,
    double? dropOffLong,
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
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLong: pickupLong ?? this.pickupLong,
      dropOffLat: dropOffLat ?? this.dropOffLat,
      dropOffLong: dropOffLong ?? this.dropOffLong,
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
