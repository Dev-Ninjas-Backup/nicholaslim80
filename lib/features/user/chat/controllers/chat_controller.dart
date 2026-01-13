import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/chat/models/message_model.dart';
import 'package:ZipBee/features/user/chat/socket_service.dart/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMessageController extends GetxController {
  var messages = <MessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initSocket();
  }

  /// Initialize socket connection
  Future<void> initSocket() async {
    debugPrint("Initializing socket connection...");

    final token = await SharedPreferencesHelper.getAccessToken();
    final userId = (await SharedPreferencesHelper.getUserId())?.toString();

    if (token == null) {
      debugPrint("Token or UserId is null, cannot connect to socket.");
      return;
    }

    // Load token into service first
    await UserSocketService().loadToken();

    // Connect socket
    UserSocketService().connect(userId: userId);

    // Listen for incoming messages
    UserSocketService().on('receive_message', (data) {
      debugPrint("📩 Received on User: $data");

      messages.add(
        MessageModel.fromSocket(
          data: Map<String, dynamic>.from(data),
          isMe: false,
        ),
      );
    });
  }

  /// Send message
  void sendMessage({required String receiverId, required String content}) {
    if (content.trim().isEmpty) return;

    final payload = {
      "receiverId": 28, // ✅ fixed: use parameter
      "content": content,
      "messageType": "TEXT",
    };

    // Send via generic emit
    UserSocketService().emit('send_message', payload);

    // Add locally
    messages.add(MessageModel(text: content, isMe: true, time: _now()));
  }

  String _now() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    UserSocketService().dispose();
    super.onClose();
  }
}
