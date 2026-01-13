import 'package:ZipBee/core/api_end_point/api_end_point.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserSocketService {
  static IO.Socket? _socket;

  /// CONNECT SOCKET
  static void connect({
    required String token,
    //required String? userId,
  }) {
    debugPrint("🔌 Connecting to user socket...");
    debugPrint("Token: $token ");

     _socket = IO.io('https://api.zipbee.sg/api/v1/messages', {
        'transports': ['websocket', 'polling'],
        'extraHeaders': {'Cookie': token},
        'reconnection': true,
        'reconnectionDelayMax': 5000,
        'pingInterval': 25000,
        'pingTimeout': 60000,
        'forceNew': false,
        'upgrade': true,
        'rememberUpgrade': true,
      });


    debugPrint("🔧 Socket options initialized");

    _socket!.connect();

    // ✅ Socket connected
    _socket!.onConnect((_) {
      debugPrint('✅ User socket connected');
      _socket!.emit('register', {
        // 'userId': userId,
        'role': 'user',
      });
    });

    // ❌ Socket disconnected
    _socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    // ⚠️ Connection error
    _socket!.onConnectError((e) {
      print('⚠️ Socket connect error: $e');
    });

    // ⚠️ General error
    _socket!.onError((e) {
      print('⚠️ Socket error: $e');
    });

    // 🔁 Reconnect attempt
    _socket!.onReconnectAttempt((attempt) {
      print('🔄 Reconnect attempt #$attempt');
    });

    // 🔁 Successful reconnect
    _socket!.onReconnect((_) {
      print('🔁 Socket reconnected');
    });
  }

  /// USER → RAIDER (SEND MESSAGE)
  static void sendMessage({
    required String receiverId,
    required String content,
    String messageType = "TEXT",
  }) {
    final payload = {
      "receiverId": receiverId,
      "content": content,
      "messageType": messageType,
    };

    print("📤 Sending: $payload");

    _socket?.emit('send_message', payload);
  }

  /// RAIDER → USER (RECEIVE MESSAGE)
  static void onReceiveMessage(Function(Map<String, dynamic>) callback) {
    _socket?.on('receive_message', (data) {
      print("📩 Received: $data");
      callback(Map<String, dynamic>.from(data));
    });
  }

  /// DISCONNECT
  static void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    print('🔌 Socket disconnected manually');
  }
}
