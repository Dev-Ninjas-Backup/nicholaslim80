class OrderModel {
  final String orderId;
  final String status;
  final String date;
  final String pickupAddress;
  final String senderName;
  final String recipientName;
  final String dropOffAddress;
  final String deliveryLocation;
  final String vehicleType;
  final double total;
  final bool showReceipt;
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

  // ✅ rawOrderStops field added to handle multiple stops in controller
  final List? rawOrderStops;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.date,
    required this.pickupAddress,
    required this.senderName,
    this.recipientName = "",
    required this.dropOffAddress,
    required this.deliveryLocation,
    required this.vehicleType,
    required this.total,
    required this.showReceipt,
    this.assignRiderName = "",
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
    this.rawOrderStops,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final collectTime = (json['collect_time'] ?? '').toString();
    final orderStops = json['orderStops'] as List? ?? [];

    Map<String, dynamic>? pickupStop;
    Map<String, dynamic>? dropStop;

    for (var stop in orderStops) {
      if (stop['type'] == 'PICKUP') {
        pickupStop = stop;
      } else if (stop['type'] == 'DROP') {
        dropStop = stop;
      }
    }

    final vehicle = json['vehicle'] as Map<String, dynamic>?;
    final rider = json['assign_rider'] as Map<String, dynamic>?;
    final riderRegistrations = rider?['registrations'] as List? ?? [];
    final riderData = riderRegistrations.isNotEmpty
        ? riderRegistrations[0]
        : null;

    // ✅ Logic updated: use created_at if scheduled_time is null
    final String timeValue = (json['scheduled_time'] != null && json['scheduled_time'].toString() != "null") 
        ? json['scheduled_time'].toString() 
        : (json['created_at'] ?? '').toString();

    return OrderModel(
      orderId: (json['id'] ?? '').toString(),
      status: (json['order_status'] ?? json['status'] ?? '').toString(),
      date: collectTime == "ASAP" ? "Pick-up ASAP" : collectTime,
      pickupAddress: (pickupStop?['address'] ?? json['pickup_address'] ?? "")
          .toString(),
      senderName:
          (pickupStop?['destination']?['contact_name'] ??
                  json['sender_name'] ??
                  "")
              .toString(),
      recipientName:
          (dropStop?['destination']?['contact_name'] ??
                  json['recipient_name'] ??
                  "")
              .toString(),
      dropOffAddress: (dropStop?['address'] ?? json['drop_off_address'] ?? "")
          .toString(),
      deliveryLocation: (json['delivery_location'] ?? "").toString(),
      vehicleType: (vehicle?['vehicle_type'] ?? "").toString(),
      total: double.tryParse((json['total_cost'] ?? '0').toString()) ?? 0,
      showReceipt:
          (json['order_status'] ?? json['status'] ?? '').toString() ==
          "COMPLETED",
      riderId: json['assign_rider_id'] is int
          ? json['assign_rider_id']
          : int.tryParse((json['assign_rider_id'] ?? '').toString()),
      scheduledTime: timeValue, // ✅ now holds created_at if scheduled is null
      pickupLat: double.tryParse(
        pickupStop?['latitude']?.toString() ??
            json['pickup_lat']?.toString() ??
            '',
      ),
      pickupLong: double.tryParse(
        pickupStop?['longitude']?.toString() ??
            json['pickup_long']?.toString() ??
            '',
      ),
      dropOffLat: double.tryParse(
        dropStop?['latitude']?.toString() ??
            json['drop_off_lat']?.toString() ??
            '',
      ),
      dropOffLong: double.tryParse(
        dropStop?['longitude']?.toString() ??
            json['drop_off_long']?.toString() ??
            '',
      ),
      assignRiderName: (riderData?['raider_name'] ?? "").toString(),
      assignRiderPhone: (riderData?['contact_number'] ?? "").toString(),
      assignRiderRating:
          double.tryParse(rider?['rankScore']?.toString() ?? '0') ?? 0.0,
      assignRiderReviews:
          int.tryParse(rider?['reviews_count']?.toString() ?? '0') ?? 0,
      rawOrderStops: orderStops, // ✅ mapping raw list for controller
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
    String? recipientName,
    List? rawOrderStops,
  }) {
    return OrderModel(
      orderId: orderId,
      status: status,
      date: date,
      pickupAddress: pickupAddress,
      senderName: senderName,
      recipientName: recipientName ?? this.recipientName,
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
      rawOrderStops: rawOrderStops ?? this.rawOrderStops,
    );
  }
}