import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:http/http.dart' as http;

class DeliveryTypeModel {
  final int id;
  final String name;
  final int deliveryTime;
  final String deliveryUnit;

  DeliveryTypeModel({
    required this.id,
    required this.name,
    required this.deliveryTime,
    required this.deliveryUnit,
  });

  factory DeliveryTypeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTypeModel(
      id: json['id'],
      name: json['name'],
      deliveryTime: json['delivery_time'] ?? 0,
      deliveryUnit: json['delivery_unit'] ?? 'MINUTES',
    );
  }

  // Subtitle logic: Convert minutes to hours if unit is HOURS
  String get formattedSubtitle {
    if (deliveryUnit.toUpperCase() == "HOURS") {
      int hours = deliveryTime ~/ 60; // 180 / 60 = 3
      return "Delivery within $hours hours of collection";
    }
    return "Delivery within $deliveryTime minutes of collection";
  }
}