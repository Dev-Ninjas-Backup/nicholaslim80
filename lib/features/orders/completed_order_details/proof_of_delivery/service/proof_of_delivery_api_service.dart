import 'package:dio/dio.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';

class ProofOfDeliveryApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.zipbee.sg/api/v1",
      headers: {
        "Accept": "*/*",
      },
    ),
  );

  Future<Response> getOrderDetails(int orderId) async {
    final String? token = await SharedPreferencesHelper.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Access token not found");
    }

    return await _dio.get(
      "/order/$orderId",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}
