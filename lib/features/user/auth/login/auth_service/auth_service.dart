import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://10.10.20.130:3000/api/v1/auth";

  // ------------------- SIGNUP -------------------
  static Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String phone,
    required String password,
    String roleName = "USER",
  }) async {
    final url = Uri.parse("$baseUrl/signup");

    final body = jsonEncode({
      "username": username,
      "email": email,
      "phone": phone,
      "password": password,
      "role_name": roleName,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "body": data,
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"message": e.toString()},
      };
    }
  }

  // ------------------- VERIFY -------------------
  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse("$baseUrl/verify");

    final body = jsonEncode({"email": email, "otp": otp});

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "body": data,
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"message": e.toString()},
      };
    }
  }

  // ------------------- LOGIN -------------------
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    final body = jsonEncode({
      "email": email,
      "password": password,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final data = jsonDecode(response.body);

      return {
        "statusCode": response.statusCode,
        "body": data,
      };
    } catch (e) {
      return {
        "statusCode": 500,
        "body": {"message": e.toString()},
      };
    }
  }
}
