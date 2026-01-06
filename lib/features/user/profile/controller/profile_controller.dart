import 'dart:convert';
import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/profile/model/profile_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ProfileController extends GetxController {
  var userProfile = UserModel(username: '', email: '', phone: '').obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  var profileItem = <ProfileModel>[].obs;

  // Track which field is being edited
  var editingIndex = (-1).obs;

  // Text controllers for editing
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  Future<String?> getStoredAccessToken() async {
    return await SharedPreferencesHelper.getAccessToken();
  }

  Future<String?> getStoredUserID() async {
    return await SharedPreferencesHelper.getUserId();
  }

  Future<void> fetchUserProfile() async {
    final token = await getStoredAccessToken();

    if (token == null) {
      debugPrint('No access token found');
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
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var parsedResponse = json.decode(response.body);
        userProfile.value = UserModel.fromJson(parsedResponse);

        // Update text controllers
        usernameController.text = userProfile.value.username;
        emailController.text = userProfile.value.email;
        phoneController.text = userProfile.value.phone;

        // Update profileItem
        updateProfileItems();
      } else {
        errorMessage('Failed to load user profile: ${response.statusCode}');
      }
    } catch (error) {
      errorMessage('Error: $error');
      debugPrint('Fetch error: $error');
    } finally {
      isLoading(false);
    }
  }

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

  void startEditing(int index) {
    editingIndex.value = index;
    debugPrint('Started editing index: $index');
  }

  void cancelEditing() {
    // Reset controllers to original values
    usernameController.text = userProfile.value.username;
    emailController.text = userProfile.value.email;
    phoneController.text = userProfile.value.phone;
    editingIndex.value = -1;
    debugPrint('Cancelled editing');
  }

  Future<void> saveProfile(int index) async {
    final token = await getStoredAccessToken();
    final userId = await getStoredUserID();

    debugPrint('Token: $token');
    debugPrint('User ID: $userId');

    if (token == null || userId == null) {
      debugPrint('No access token or user ID found');
      return;
    }

    isLoading(true);
    errorMessage('');

    final url = ApiEndPoint.updateProfile.replaceAll('{id}', userId);
    debugPrint('Update URL: $url');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Prepare updated data
    final bodyData = {
      'username': usernameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };

    final body = json.encode(bodyData);
    debugPrint('Update body: $body');

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      debugPrint('Update Response status: ${response.statusCode}');
      debugPrint('Update Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsedResponse = json.decode(response.body);

        // Check if response has the same structure as fromJson expects
        if (parsedResponse['data'] != null) {
          userProfile.value = UserModel.fromJson(parsedResponse);
        } else {
          // If response structure is different, manually update
          userProfile.value = UserModel(
            username: usernameController.text,
            email: emailController.text,
            phone: phoneController.text,
          );
        }

        // Update profileItem
        updateProfileItems();

        // Exit editing mode
        editingIndex.value = -1;
      } else {
        debugPrint('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Update error: $error');
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
