import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'core/shared_prefference_service/shared_pref.dart';

/// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If using other Firebase services, initialize Firebase
  debugPrint(' Background message received: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

class FirebaseMsg {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    //  Request notification permission (iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('Permission status: ${settings.authorizationStatus}');

    //  Get initial FCM token
    String? token = await _messaging.getToken();
    if (token != null) {
      debugPrint(' Firebase Messaging Token: $token');
      await SharedPreferencesHelper.saveToken(
        token,
      ); // Save to SharedPreferences
    } else {
      debugPrint(' FCM token is null');
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint(' FCM token refreshed: $newToken');
      await SharedPreferencesHelper.saveToken(newToken); // Save updated token
    });

    //  Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(' Foreground message received: ${message.messageId}');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
    });

    //  App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(' Notification clicked: ${message.messageId}');
    });

    //  Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}
