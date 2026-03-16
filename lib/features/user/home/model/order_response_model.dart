class OrderResponseModel {
  final bool? success;
  final String? message;
  final OrderData? data;

  OrderResponseModel({this.success, this.message, this.data});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final int? id;
  final String? deliveryType;
  final String? orderStatus;

  OrderData({this.id, this.deliveryType, this.orderStatus});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      deliveryType: json['delivery_type'],
      orderStatus: json['order_status'],
    );
  }
}