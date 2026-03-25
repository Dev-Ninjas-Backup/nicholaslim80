import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class VehicleTypeService {
  // static Future<Map<String, dynamic>> fetchVehicleTypes() async {
  //   try {
  //     final token = await SharedPreferencesHelper.getAccessToken();

  //     final response = await http.get(
  //       Uri.parse(ApiEndPoint.vehicleTypes),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         if (token != null) 'Authorization': 'Bearer $token',
  //       },
  //     );

  //     debugPrint('VEHICLE TYPES RESPONSE: ${response.body}');

  //     return {
  //       'statusCode': response.statusCode,
  //       'body': jsonDecode(response.body),
  //     };
  //   } catch (e) {
  //     debugPrint('VehicleTypeService error: $e');
  //     return {'statusCode': 500, 'body': {}};
  //   }
  // }

  /// Update vehicle type for an order
  static Future<Map<String, dynamic>> updateVehicleType({
    required int orderId,
    required int vehicleTypeId,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final url = ApiEndPoint.orderUpdateDetails.replaceAll(
        '{id}',
        orderId.toString(),
      );

      final body = {'vehicle_type_id': vehicleTypeId};

      debugPrint('➡️ UPDATE VEHICLE URL: $url');
      debugPrint('➡️ UPDATE VEHICLE REQUEST BODY: ${jsonEncode(body)}');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint(
        '⬅️ UPDATE VEHICLE RESPONSE: ${response.statusCode} ${response.body}',
      );

      return {
        'statusCode': response.statusCode,
        'body': jsonDecode(response.body),
      };
    } catch (e) {
      debugPrint('❌ updateVehicleType error: $e');
      return {'statusCode': 500, 'body': {}};
    }
  }
}
