import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/chat/models/message_model.dart';
import 'package:ZipBee/features/user/chat/socket_service.dart/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMessageController extends GetxController {
  final messages = <MessageModel>[].obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    initSocket();

    /// auto scroll when message list updates
    ever(messages, (_) => _scrollToBottom());
  }

  /// Initialize socket connection
  Future<void> initSocket() async {
    debugPrint("Initializing socket connection...");

    final token = await SharedPreferencesHelper.getAccessToken();
    final userId = (await SharedPreferencesHelper.getUserId())?.toString();
    //|| userId == null
    if (token == null) {
      debugPrint("Token or UserId missing");
      return;
    }

    await UserSocketService().loadToken();
    UserSocketService().connect(userId: userId);

    UserSocketService().on('receive_message', (data) {
      debugPrint("📩 Received message");

      messages.add(
        MessageModel.fromSocket(
          data: Map<String, dynamic>.from(data),
          isMe: false,
        ),
      );
    });
  }

  /// Send message
  void sendMessage(String receiverId, {String? orderId}) {
    debugPrint("Sending message tofddfddddd receiverId: $receiverId ");
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final parsedReceiverId = int.tryParse(receiverId);
    // final parsedOrderId = orderId != null ? int.tryParse(orderId) : null;

    final payload = {
      "receiverId": parsedReceiverId,
      "content": text,
      "messageType": "TEXT",
      // if (parsedOrderId != null) "orderId": parsedOrderId else if (orderId != null) "orderId": orderId,
    };

    UserSocketService().emit('send_message', payload);

    messages.add(MessageModel(text: text, isMe: true, time: _now()));

    textController.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _now() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    UserSocketService().dispose();
    super.onClose();
  }
}
