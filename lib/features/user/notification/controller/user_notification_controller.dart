import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nicholaslim80/core/api_end_point/api_end_point.dart';
import 'package:nicholaslim80/features/user/notification/model/notification1_model.dart';

import '../../../../core/shared_prefference_service/shared_pref.dart';

class UserNotificationController extends GetxController {
  final RxInt selectNotificationListIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxInt page = 1.obs;

  final int limit = 10;
  final RxList<Notification1Model> notificationList =
      <Notification1Model>[].obs;

  final notificationTabs = ["Notifications", "Order Updates", "Promotions"];

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  /// Fetch notifications from API
  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      if (loadMore) {
        page.value++;
      } else {
        page.value = 1;
        notificationList.clear();
      }

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar('Auth Error', 'Token not found');
        return;
      }

      final uri = Uri.parse(
        "${ApiEndPoint.notification}?target_role=RAIDER&type=SMS&isRead=true&page=${page.value}&limit=$limit",
      );

      final response = await http.get(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      print('📡 API CALL: $uri');
      print('🔹 STATUS: ${response.statusCode}');
      print('📝 BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List data = decoded['data'] ?? [];
        final items = data.map((e) => Notification1Model.fromJson(e)).toList();
        notificationList.addAll(items);
      } else {
        if (loadMore) page.value--; // revert page increment on failure
        Get.snackbar(
          'Error',
          'Failed to load notifications (${response.statusCode})',
        );
      }
    } catch (e) {
      if (loadMore) page.value--; // revert page increment on exception
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
