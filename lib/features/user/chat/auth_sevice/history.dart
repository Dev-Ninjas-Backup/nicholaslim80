import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:http/http.dart' as http;

class ChatApiService {
  static const String chatHistory = ApiEndPoint.chatHistory;

  static Future<List<dynamic>?> getChatHistory({
    required String receiverId,
    required String orderId,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.post(
        Uri.parse(chatHistory),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"otherUserId": receiverId, "orderId": orderId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data']['messages'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
