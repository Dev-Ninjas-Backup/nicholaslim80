import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationReceive {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static void listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.notification?.title}');
      print('Message body: ${message.notification?.body}');

      // Show Android notification in status bar
      _showAndroidNotification(message);
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    print("Background message: ${message.messageId}");
    print("Background message title: ${message.notification?.title}");

    // Show Android notification in status bar
    _showAndroidNotification(message);
  }

  static void setupBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _showAndroidNotification(RemoteMessage message) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'default_channel',
          'Default Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'Notification',
      message.notification?.body ?? 'You have a new message',
      details,
      payload: message.data.toString(),
    );
  }
}
