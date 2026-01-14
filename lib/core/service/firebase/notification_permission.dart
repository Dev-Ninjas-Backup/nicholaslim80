import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../api_end_point/api_end_point.dart';
import '../../shared_prefference_service/shared_pref.dart';

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permission granted');
  }
}

Future<String?> getFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
  return token;
}

Future<void> sendFcmTokenToBackend(String token) async {
  final userToken = await SharedPreferencesHelper.getAccessToken();
  debugPrint("FCM Token final token: $token");
  final response = await http.patch(
    Uri.parse('${ApiEndPoint.notificationFCM}'),
    headers: {
      "Authorization": "Bearer $userToken",
      "Content-Type": "application/json",
    },
    body: jsonEncode({"fcm_token": token}),
  );

  debugPrint("FCM Token Response: ${response.body}");
}

void listenTokenRefresh() {
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    sendFcmTokenToBackend(newToken);
  });
}
