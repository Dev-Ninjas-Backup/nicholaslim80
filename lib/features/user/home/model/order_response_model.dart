class OrderResponseModel {
  final bool? success;
  final String? message;
  final OrderData? data;

  OrderResponseModel({this.success, this.message, this.data});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? "Something went wrong",
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final int? id;
  final String? deliveryType;

  OrderData({this.id, this.deliveryType});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      deliveryType: json['delivery_type'],
    );
  }
}