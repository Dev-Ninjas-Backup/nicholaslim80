import 'package:ZipBee/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';

import 'core/service/firebase/notification_permission.dart';
import 'core/service/firebase/notification_receve.dart';
import 'firebase_options.dart';

void _configEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.black.withValues(alpha: .5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String stripePublicKey = 'pk_test_51SknuvDXBOtCRfi2drGBAdKBna0ZOkJLdUfkHRbxsuJIS5gd4QWFpPVNowaNyCUZDDeKRfkU5BFQY1H0BzxQ3a6Q00Z5dHGGgY';

  // Merchant display name

  Stripe.publishableKey = stripePublicKey;
  await Stripe.instance.applySettings();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint("Firebase already initialized: $e");
  }

  // Initialize local notifications
  await FirebaseNotificationReceive.initializeLocalNotifications();

  // Request notification permission
  await requestNotificationPermission();

  // Setup background message handler
  FirebaseNotificationReceive.setupBackgroundMessageHandler();

  // Listen for foreground messages
  FirebaseNotificationReceive.listenForegroundMessages();

  // Listen for token refresh
  listenTokenRefresh();

  _configEasyLoading();

  // GetStorage
  await GetStorage.init();

 // SharedPreferencesHelper prefs = SharedPreferencesHelper();
    // SocketService().connect(await SharedPreferencesHelper.getAccessToken() ?? '');


  runApp(const Nicholaslim());
}
