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

  int? userId; // store fetched userId

  // ================= FETCH USER PROFILE =================
  Future<void> fetchUserProfile() async {
    debugPrint(' Fetching user profile...');
    final token = await SharedPreferencesHelper.getAccessToken();

    if (token == null || token.isEmpty) {
      errorMessage('No access token found');
      debugPrint(' No access token found');
      return;
    }

    isLoading(true);
    errorMessage('');

    final url = ApiEndPoint.profile; // /users/me
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      debugPrint('📥 Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        final data = parsedResponse['data'];
        if (data != null) {
          userProfile.value = UserModel.fromJsonData(data);
          userId = data['id']; // store ID in memory
          debugPrint('✅ User profile loaded: ${userProfile.value.toJson()}');

          usernameController.text = userProfile.value.username;
          emailController.text = userProfile.value.email;
          phoneController.text = userProfile.value.phone;

          updateProfileItems();
        }
      } else if (response.statusCode == 401) {
        errorMessage('Session expired. Please login again.');
        debugPrint('⚠️ Token expired');
        Get.offAllNamed('/login');
      } else {
        errorMessage('Failed to load profile: ${response.statusCode}');
        debugPrint('❌ Failed to load profile: ${response.statusCode}');
      }
    } catch (error) {
      errorMessage('Error fetching profile: $error');
      debugPrint('❌ Exception fetching profile: $error');
    } finally {
      isLoading(false);
      debugPrint('⬅️ Finished fetching profile');
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
    debugPrint(
      '📄 Updated profile items: ${profileItem.map((e) => e.toJson())}',
    );
  }

  // ================= EDITING =================
  void startEditing(int index) {
    editingIndex.value = index;
    debugPrint('✏️ Start editing index: $index');
  }

  void cancelEditing() {
    usernameController.text = userProfile.value.username;
    emailController.text = userProfile.value.email;
    phoneController.text = userProfile.value.phone;
    editingIndex.value = -1;
    debugPrint('❌ Editing canceled');
  }

  // ================= UPDATE PROFILE API =================
  Future<void> updateUserProfile({
    String? username,
    String? email,
    String? phone,
  }) async {
    if (userId == null) {
      errorMessage('User ID not found. Cannot update.');
      return;
    }

    debugPrint('➡️ Updating user profile...');
    final token = await SharedPreferencesHelper.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage('No access token found');
      return;
    }

    isLoading(true);
    errorMessage('');

    final url = ApiEndPoint.userProfile.replaceAll('{id}', userId.toString());
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final bodyData = <String, dynamic>{};
    if (username != null) bodyData['username'] = username;
    if (email != null) bodyData['email'] = email;
    if (phone != null) bodyData['phone'] = phone;

    debugPrint('📡 PATCH $url');
    debugPrint('📝 Body: $bodyData');

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode(bodyData),
      );
      debugPrint('📥 Response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final parsedResponse = json.decode(response.body);
        final data = parsedResponse['data'];
        if (data != null) {
          userProfile.value = UserModel.fromJsonData(data);
        } else {
          userProfile.value = UserModel(
            username: username ?? userProfile.value.username,
            email: email ?? userProfile.value.email,
            phone: phone ?? userProfile.value.phone,
          );
        }
        updateProfileItems();
        editingIndex.value = -1;
        debugPrint('✅ Profile updated successfully');
      } else if (response.statusCode == 401) {
        errorMessage('Session expired. Please login again.');
        Get.offAllNamed('/login');
      } else {
        errorMessage('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      errorMessage('Update error: $error');
      debugPrint('❌ Exception updating profile: $error');
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
    super.onInit();
    debugPrint('📌 ProfileController initialized');
    fetchUserProfile();
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

  Map<String, dynamic> toJson() => {'title': title, 'subtitle': subtitle};
}

class UserModel {
  final String username;
  final String email;
  final String phone;

  UserModel({required this.username, required this.email, required this.phone});

  factory UserModel.fromJsonData(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'phone': phone,
  };
}
