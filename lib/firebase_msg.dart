import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  initFCM() async {
    await msgService.requestPermission();

    var token = await msgService.getToken();
    debugPrint("Firebase Messaging Token: $token");

    FirebaseMessaging.onBackgroundMessage(handleNotification);
  }

  Future<void> handleNotification(RemoteMessage message) async {
    debugPrint("Notification Received: $message");
  }
}
