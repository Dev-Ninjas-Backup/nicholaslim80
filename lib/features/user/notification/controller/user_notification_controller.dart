import 'dart:convert';

import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:ZipBee/features/user/notification/model/notification1_model.dart';
import 'package:flutter/material.dart';
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

  final notificationTabs = ["Notifications", "Order Update", "Promotions"];

  @override
  void onInit() {
    super.onInit();
    debugPrint("Controller initialized");
    fetchNotifications();
  }

  /// ================= FETCH =================
  Future<void> fetchNotifications({bool loadMore = false}) async {
    debugPrint("Fetch notifications called. loadMore=$loadMore");

    if (isLoading.value || (!hasMore && loadMore)) {
      debugPrint(
        "Fetch skipped: isLoading=${isLoading.value}, hasMore=$hasMore, loadMore=$loadMore",
      );
      return;
    }

    isLoading.value = true;
    debugPrint("Loading set to true");

    try {
      if (loadMore) {
        page.value++;
        debugPrint("Loading more: page=${page.value}");
      } else {
        page.value = 1;
        hasMore = true;
        notificationList.clear();
        debugPrint("Reset notifications list, page=${page.value}");
      }

      final token = await SharedPreferencesHelper.getAccessToken();
      debugPrint("Token fetched: $token");

      if (token == null || token.isEmpty) {
        EasyLoading.showError('Token not found');
        debugPrint("Token not found, exiting fetch");
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
      }
      debugPrint(
        "Selected tab index: ${selectNotificationListIndex.value}, type: $type",
      );

      final uri = Uri.parse(
        "${ApiEndPoint.notification}"
        "?target_role=USER"
        "${type.isNotEmpty ? "&type=$type" : ""}"
        "&page=${page.value}"
        "&limit=$limit",
      );

      debugPrint("Fetching notifications from: $uri");

      final response = await http.get(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      debugPrint(
        "Response received. Status: ${response.statusCode}, Body: ${response.body}",
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List list = decoded['data']?['data'] ?? [];
        final items = list.map((e) => Notification1Model.fromJson(e)).toList();

        final int total = decoded['data']?['total'] ?? 0;
        hasMore = page.value * limit < total;

        debugPrint(
          "Total items from API: $total, Has more: $hasMore, Adding ${items.length} items to list",
        );

        notificationList.addAll(items);
      } else {
        if (loadMore) page.value--;
        EasyLoading.showError('Failed (${response.statusCode})');
        debugPrint("Fetch failed with status ${response.statusCode}");
      }
    } catch (e, s) {
      if (loadMore) page.value--;
      EasyLoading.showError(e.toString());
      debugPrint("Exception in fetchNotifications: $e\nStackTrace: $s");
    } finally {
      isLoading.value = false;
      debugPrint("Loading set to false");
    }
  }

  /// ================= CHANGE TAB =================
  void changeTab(int index) {
    debugPrint("Tab change requested: $index");
    if (selectNotificationListIndex.value != index) {
      selectNotificationListIndex.value = index;
      debugPrint("Tab changed to $index. Fetching notifications...");
      fetchNotifications();
    } else {
      debugPrint("Tab already selected: $index, no fetch needed");
    }
  }

  /// ================= CONFIRM DELETE =================
  void confirmDelete(String notificationID) {
    debugPrint("Confirm delete called for ID: $notificationID");

    Get.defaultDialog(
      title: "Delete Notification",
      middleText: "Are you sure you want to delete this notification?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () {
        Get.back();
        debugPrint("User confirmed delete for ID: $notificationID");
        deleteNotification(notificationID);
      },
    );
  }

  /// ================= DELETE API =================
  Future<void> deleteNotification(String notificationID) async {
    debugPrint("Delete notification called for ID: $notificationID");

    try {
      EasyLoading.show(status: "Deleting...");
      debugPrint("EasyLoading shown");

      final token = await SharedPreferencesHelper.getAccessToken();
      debugPrint("Token fetched for delete: $token");

      if (token == null || token.isEmpty) {
        EasyLoading.showError("Token not found");
        debugPrint("Token not found, exiting delete");
        return;
      }

      final uri = Uri.parse(
        ApiEndPoint.notificationID.replaceAll('{id}', notificationID),
      );

      debugPrint("DELETE request URL: $uri");

      final response = await http.delete(
        uri,
        headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
      );

      debugPrint(
        "DELETE response. Status: ${response.statusCode}, Body: ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        notificationList.removeWhere((element) => element.id == notificationID);
        EasyLoading.showSuccess("Deleted successfully");
        debugPrint("Notification removed from list: $notificationID");
      } else {
        EasyLoading.showError("Delete failed (${response.statusCode})");
        debugPrint("Delete failed with status: ${response.statusCode}");
      }
    } catch (e, s) {
      EasyLoading.showError(e.toString());
      debugPrint("Exception in deleteNotification: $e\nStackTrace: $s");
    } finally {
      EasyLoading.dismiss();
      debugPrint("EasyLoading dismissed after delete");
    }
  }
}
