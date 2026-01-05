// import 'package:get/get.dart';
// import 'package:nicholaslim80/features/user/profile/model/profile_model.dart';

// class ProfileController extends GetxController {
//   var profileItem = [].obs;
//   @override
//   void onInit() {
//     profileItem.addAll([
//       ProfileModel(title: "Name", subtitle: "Daniel Tan"),

//       ProfileModel(title: "Phone number", subtitle: "+65 9977 6666"),

//       ProfileModel(title: "Email address", subtitle: "daniel.tan@gmail.com"),
//     ]);
//     super.onInit();
//   }
// }

// 


import 'dart:convert';
import 'package:flutter/material.dart'; // Make sure to import for TextEditingController
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nicholaslim80/core/api_end_point/api_end_point.dart';
import 'package:nicholaslim80/core/shared_prefference_service/shared_pref.dart';
import 'package:nicholaslim80/features/user/profile/model/profile_model.dart';

class ProfileController extends GetxController {
  // Reactive variables for user profile
  var userProfile = {}.obs;
  var profileItem = [].obs;

  // TextEditingController instances for editable fields
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  // Fetch the stored access token from SharedPreferences
  Future<String?> getStoredAccessToken() async {
    return await SharedPreferencesHelper.getAccessToken();
  }

  // Fetch the stored user ID from SharedPreferences
  Future<String?> getStoredUserId() async {
    return await SharedPreferencesHelper.getUserId();
  }

  // Helper function to handle HTTP requests and responses
  Future<void> _handleRequest({
    required String url,
    required Map<String, String> headers,
    required dynamic Function(String) onSuccess,
  }) async {
    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        // Parse the response and trigger the onSuccess callback
        onSuccess(response.body);
      } else {
        debugPrint('Failed to load user profile: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  // Fetch user profile
  Future<void> fetchUserProfile() async {
    final token = await getStoredAccessToken();

    if (token == null) {
      debugPrint('No access token found');
      return;
    }

    final url = ApiEndPoint.profile;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    await _handleRequest(
      url: url,
      headers: headers,
      onSuccess: (responseBody) {
        userProfile.value = json.decode(responseBody)['data'];

        // Initialize TextEditingController with fetched data
        nameController.text = userProfile["username"] ?? "";
        phoneController.text = userProfile["phone"] ?? "";
        emailController.text = userProfile["email"] ?? "";
      },
    );
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    final token = await getStoredAccessToken();
    final userId = await getStoredUserId(); // Make sure to get the userId

    if (token == null || userId == null) {
      debugPrint('No access token or userId found');
      return;
    }

    final url = ApiEndPoint.updateProfile.replaceAll(
      "{id}",
      userId,
    ); // Replace the {id} placeholder with actual userId
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        userProfile.value = json.decode(response.body)['data'];
      } else {
        debugPrint('Failed to update user profile: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  @override
  void onInit() {
    // Initialize controllers
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();

    // Fetch user profile data
    fetchUserProfile();

    profileItem.addAll([
      ProfileModel(
        title: "Name",
        subtitle: userProfile["username"] ?? "Daniel Tan",
      ),
      ProfileModel(
        title: "Phone number",
        subtitle: userProfile["phone"] ?? "+65 9977 6666",
      ),
      ProfileModel(
        title: "Email address",
        subtitle: userProfile["email"] ?? "daniel.tan@gmail.com",
      ),
    ]);

    super.onInit();
  }

  @override
  void onClose() {
    // Dispose controllers when no longer needed
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
