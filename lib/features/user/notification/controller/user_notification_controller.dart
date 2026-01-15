import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/features/user/notification/model/notification1_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/shared_prefference_service/shared_pref.dart';

class UserNotificationController extends GetxController {
  final RxInt selectNotificationListIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxInt page = 1.obs;
  final int limit = 10;
  bool hasMore = true;

  final RxList<Notification1Model> notificationList =
      <Notification1Model>[].obs;

  final notificationTabs = ["Notifications", "Order Updates", "Promotions"];

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  
  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (isLoading.value || (!hasMore && loadMore)) return;

    isLoading.value = true;
    EasyLoading.show();

    try {
      if (loadMore) {
        page.value++;
      } else {
        page.value = 1;
        hasMore = true;
        notificationList.clear();
      }

      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        EasyLoading.dismiss();
        isLoading.value = false;
        EasyLoading.showError('Token not found');
        return;
      }

      String type = "";
      switch (selectNotificationListIndex.value) {
        case 1:
          type = "ORDER_UPDATE";
          break;
        case 2:
          type = "PROMOTION";
          break;
        default:
          type = ""; 
      }

      final uri = Uri.parse(
        "${ApiEndPoint.notification}"
        "?target_role=USER"
        "${type.isNotEmpty ? "&type=$type" : ""}"
        "&page=${page.value}"
        "&limit=$limit",
      );

      final response = await http.get(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      print('API CALL: $uri');
      print(' STATUS: ${response.statusCode}');
      print(' BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        final List list = decoded['data']?['data'] ?? [];
        final items = list.map((e) => Notification1Model.fromJson(e)).toList();

        final int total = decoded['data']?['total'] ?? 0;
        hasMore = page.value * limit < total;

        notificationList.addAll(items);
      } else {
        if (loadMore) page.value--;
        EasyLoading.showError(
          'Failed to load notifications (${response.statusCode})',
        );
      }
    } catch (e) {
      if (loadMore) page.value--;
      EasyLoading.showError(e.toString());
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  /// Change tab
  void changeTab(int index) {
    if (selectNotificationListIndex.value != index) {
      selectNotificationListIndex.value = index;
      fetchNotifications();
    }
  }
}
