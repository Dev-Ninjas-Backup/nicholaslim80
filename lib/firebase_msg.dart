import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/shared_prefference_service/shared_pref.dart';
import 'features/user/notification/controller/user_notification_controller.dart';
import 'features/user/notification/model/notification1_model.dart';

/// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  // Optional: save to local storage for later use
}

class FirebaseMsg {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Request permission (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Permission status: ${settings.authorizationStatus}');

    // Get initial FCM token
    String? token = await _messaging.getToken();
    if (token != null) {
      debugPrint('Firebase Messaging Token: $token');
      await SharedPreferencesHelper.saveAccessToken(token);
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint('FCM token refreshed: $newToken');
      await SharedPreferencesHelper.saveAccessToken(newToken);
    });

    // Get controller instance
    final notificationController = Get.put(UserNotificationController());

    // Foreground notifications → add to in-app list
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.messageId}');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');

      // Create notification model safely
      final now = DateTime.now();
      final notification = Notification1Model(
        title: message.notification?.title ?? 'No Title',
        subTitle: message.notification?.body ?? 'No Body',
        date:
            "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}",
        time:
            "${now.hour % 12 == 0 ? 12 : now.hour % 12}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}",
      );

      // Add to top of the list
      notificationController.notificationList.insert(0, notification);
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification clicked: ${message.messageId}');
      // Optionally navigate to your notification screen
    });

    // Background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
