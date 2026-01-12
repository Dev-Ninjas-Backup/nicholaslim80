import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserSocketService {
  static IO.Socket? _socket;

  /// CONNECT SOCKET
  static void connect({
    required String token,
    required String userId,
  }) {
    _socket = IO.io(
      'wss://api.zipbee.sg/api/v1/messages',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            'Authorization': 'Bearer $token',
          })
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('✅ User socket connected');

      _socket!.emit('register', {
        'userId': userId,
        'role': 'user',
      });
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    _socket!.onConnectError((e) {
      print('⚠️ Socket error: $e');
    });
  }

  /// ✅ USER → RAIDER (SEND MESSAGE)
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

  /// ✅ RAIDER → USER (RECEIVE MESSAGE)
  static void onReceiveMessage(
    Function(Map<String, dynamic>) callback,
  ) {
    _socket?.on('receive_message', (data) {
      print("📩 Received: $data");
      callback(Map<String, dynamic>.from(data));
    });
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
