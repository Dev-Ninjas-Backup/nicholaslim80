import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nicholaslim80/core/api_end_point/api_end_point.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final logger = Logger(printer: PrettyPrinter(methodCount: 0, colors: true));

class AuthService {
  // ================= SIGNUP =================
  static Future<bool> signUp({
    required String phone,
    required String username,
    required String email,
    required String password, // Added password
  }) async {
    final url = Uri.parse(ApiEndPoint.signUp);

    final body = jsonEncode({
      "phone": phone,
      "email": email,
      "username": username,
      "password": password, // Include password in request
      "role": "USER",
    });

    logger.i("SIGNUP REQUEST -> POST $url");
    logger.d("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      logger.d("SIGNUP RESPONSE: ${response.body}");
      logger.d("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Signup successful for phone: $phone");
        return true;
      }

      final error = _extractMessage(response.body) ?? "Signup Failed";
      logger.w("Signup failed: $error");
      throw Exception(error);
    } catch (e, st) {
      logger.e("Signup Exception", error: e, stackTrace: st);
      throw Exception("Signup Error: $e");
    }
  }

  // ================= LOGIN =================
  static Future<bool> login({
    String? phone,
    String? email,
    String? password, // Added password
  }) async {
    final url = Uri.parse('${ApiEndPoint.baseUrl}/auth/login/request-otp');

    // Include password if your backend requires it
    final body = jsonEncode({
      "phone": phone,
      if (password != null) "password": password,
      if (email != null) "email": email,
    });

    logger.i("LOGIN REQUEST -> POST $url");
    logger.d("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      logger.d("LOGIN RESPONSE: ${response.body}");
      logger.d("Status Code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        logger.i("Login success → OTP Sent");
        return true; // OTP sent successful
      }

      final error = _extractMessage(response.body) ?? "Login failed";
      throw Exception(error);
    } catch (e, st) {
      logger.e("Login Exception", error: e, stackTrace: st);
      throw Exception("Login Error: $e");
    }
  }

  // ================= VERIFY OTP =================
  static Future<String> verifyOtp({
    required String email,
    required String phone,
    required String otp,
  }) async {
    final url = Uri.parse('${ApiEndPoint.baseUrl}/auth/verify');

    final body = jsonEncode({"email": email, "phone": phone, "otp": otp});

    logger.i("VERIFY OTP REQUEST -> POST $url");
    logger.d("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      logger.d("VERIFY OTP RESPONSE: ${response.body}");
      logger.d("Status Code: ${response.statusCode}");

      if (response.statusCode == 201) {
        final data = _decodeJson(response.body);

        final token = data['access_token'];
        if (token == null || token.isEmpty) {
          throw Exception("Token not found in response");
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        logger.i("OTP verified successfully, token saved.");
        return token;
      }

      final error = _extractMessage(response.body) ?? "OTP Verification Failed";
      logger.w("OTP verification failed: $error");
      throw Exception(error);
    } catch (e, st) {
      logger.e("Verify OTP Exception", error: e, stackTrace: st);
      throw Exception("OTP Verification Error: $e");
    }
  }

  // ================= RESEND OTP =================
  static Future<void> resendOtp({required String phone}) async {
    final url = Uri.parse('${ApiEndPoint.baseUrl}/auth/resend-otp');
    final body = jsonEncode({"phone": phone});

    logger.i("RESEND OTP REQUEST -> POST $url");
    logger.d("Request body: $body");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      logger.d("RESEND OTP RESPONSE: ${response.body}");
      logger.d("Status Code: ${response.statusCode}");

      final responseData = _decodeJson(response.body);
      final message = responseData['message'] ?? "";

      if (response.statusCode == 201) {
        logger.i("OTP resent successfully to $phone");
      } else if (message.contains("OTP sent")) {
        logger.w("OTP already sent for $phone");
      } else {
        logger.w("Resend OTP failed: $message");
        throw Exception(message);
      }
    } catch (e, st) {
      logger.e("Resend OTP Exception", error: e, stackTrace: st);
      throw Exception("Resend OTP Error: $e");
    }
  }

  // =================== Helper Methods ===================
  static Map<String, dynamic> _decodeJson(String jsonString) {
    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static String? _extractMessage(String jsonString) {
    final data = _decodeJson(jsonString);
    return data['message']?.toString();
  }
}
