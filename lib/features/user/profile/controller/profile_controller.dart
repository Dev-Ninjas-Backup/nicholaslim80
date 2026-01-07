import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  // ================= OBSERVABLES =================
  var userProfile = UserModel(username: '', email: '', phone: '').obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var profileItem = <ProfileModel>[].obs;
  var editingIndex = (-1).obs; // Which field is being edited

  // ================= TEXT CONTROLLERS =================
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // ================= SHARED PREF HELPERS =================
  Future<String?> getStoredAccessToken() async {
    return await SharedPreferencesHelper.getAccessToken();
  }

  Future<String?> getStoredUserID() async {
    return await SharedPreferencesHelper.getUserId();
  }

  // ================= FETCH USER PROFILE =================
  Future<void> fetchUserProfile() async {
    final token = await getStoredAccessToken();

    if (token == null) {
      errorMessage('No access token found');
      return;
    }

    isLoading(true);
    errorMessage('');

    final url = ApiEndPoint.profile;
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint('Fetch Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        userProfile.value = UserModel.fromJson(parsedResponse);

        // Set text controllers
        usernameController.text = userProfile.value.username;
        emailController.text = userProfile.value.email;
        phoneController.text = userProfile.value.phone;

        // Update list for UI
        updateProfileItems();
      } else {
        errorMessage('Failed to load profile: ${response.statusCode}');
      }
    } catch (error) {
      errorMessage('Error fetching profile: $error');
    } finally {
      isLoading(false);
    }
  }

  // ================= UPDATE PROFILE LIST =================
  void updateProfileItems() {
    profileItem.clear();
    profileItem.add(
      ProfileModel(title: 'Username', subtitle: userProfile.value.username),
    );
    profileItem.add(
      ProfileModel(title: 'Email', subtitle: userProfile.value.email),
    );
    profileItem.add(
      ProfileModel(title: 'Phone', subtitle: userProfile.value.phone),
    );
  }

  // ================= EDITING =================
  void startEditing(int index) {
    editingIndex.value = index;
  }

  void cancelEditing() {
    usernameController.text = userProfile.value.username;
    emailController.text = userProfile.value.email;
    phoneController.text = userProfile.value.phone;
    editingIndex.value = -1;
  }

  // ================= UPDATE PROFILE API =================
  Future<void> updateUserProfile({
    String? username,
    String? email,
    String? phone,
  }) async {
    final token = await getStoredAccessToken();
    final userId = await getStoredUserID();

    if (token == null || userId == null) {
      errorMessage('No access token or user ID found');
      return;
    }

    isLoading(true);
    errorMessage('');

    final url = ApiEndPoint.userProfile.replaceAll('{id}', userId);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final bodyData = <String, dynamic>{};
    if (username != null) bodyData['username'] = username;
    if (email != null) bodyData['email'] = email;
    if (phone != null) bodyData['phone'] = phone;

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode(bodyData),
      );
      debugPrint('Update Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedResponse = json.decode(response.body);
        if (parsedResponse['data'] != null) {
          userProfile.value = UserModel.fromJson(parsedResponse);
        } else {
          userProfile.value = UserModel(
            username: username ?? userProfile.value.username,
            email: email ?? userProfile.value.email,
            phone: phone ?? userProfile.value.phone,
          );
        }
        updateProfileItems();
        editingIndex.value = -1;
      } else {
        errorMessage('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      errorMessage('Update error: $error');
    } finally {
      isLoading(false);
    }
  }

  TextEditingController getControllerForIndex(int index) {
    switch (index) {
      case 0:
        return usernameController;
      case 1:
        return emailController;
      case 2:
        return phoneController;
      default:
        return TextEditingController();
    }
  }

  @override
  void onInit() {
    fetchUserProfile();
    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

// ================= MODELS =================
class ProfileModel {
  final String title;
  final String subtitle;
  ProfileModel({required this.title, required this.subtitle});
}

class UserModel {
  final String username;
  final String email;
  final String phone;

  UserModel({required this.username, required this.email, required this.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['data']['username'],
      email: json['data']['email'],
      phone: json['data']['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'phone': phone};
  }
}
