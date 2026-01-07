import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/shared_prefference_service/shared_pref.dart';
import 'features/user/notification/controller/user_notification_controller.dart';
import 'features/user/notification/model/notification1_model.dart';

/// Background handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔕 Background message: ${message.messageId}');
}

class FirebaseMsg {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Get FCM token
    final fcmToken = await _messaging.getToken();
    if (fcmToken != null) {
      debugPrint('🔥 FCM Token: $fcmToken');
      await SharedPreferencesHelper.saveFcmToken(fcmToken);
    }

    // Token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint('🔄 FCM Token refreshed');
      await SharedPreferencesHelper.saveFcmToken(newToken);
    });

    // Notification controller
    final notificationController = Get.put(
      UserNotificationController(),
      permanent: true,
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final now = DateTime.now();

      final notification = Notification1Model(
        title: message.notification?.title ?? 'No Title',
        subTitle: message.notification?.body ?? 'No Body',
        date:
            "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}",
        time:
            "${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}",
      );

      notificationController.notificationList.insert(0, notification);
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('📲 Notification clicked');
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
