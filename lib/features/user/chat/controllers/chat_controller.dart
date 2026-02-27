import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/chat/auth_sevice/history.dart';
import 'package:ZipBee/features/user/chat/models/message_model.dart';
import 'package:ZipBee/features/user/chat/socket_service.dart/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserMessageController extends GetxController {
  final messages = <MessageModel>[].obs;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  String? orderId;
  String? receiverId;
  String? currentUserId;

  @override
  // void onInit() {
  //   super.onInit();
  //   final args = Get.arguments as Map<String, dynamic>?;
  //   orderId = args?['orderId']?.toString();
  //   receiverId = args?['receiverId']?.toString();
  //   initSocket();
  //   /// auto scroll when message list updates
  //   ever(messages, (_) => _scrollToBottom());
  // }
  @override
  // void onInit() {
  //   super.onInit();
  //   final args = Get.arguments as Map<String, dynamic>?;
  //   orderId = args?['orderId']?.toString();
  //   receiverId = args?['receiverId']?.toString();
  //   initSocket();
  //   loadChatHistory(); //
  //   ever(messages, (_) => _scrollToBottom());
  // }
  @override
  @override
  void onInit() async {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    orderId = args?['orderId']?.toString();
    receiverId = args?['receiverId']?.toString();

    debugPrint("orderId: $orderId");
    debugPrint("receiverId: $receiverId");

    // ✅ fetch userId once
    //  final currentUserId =
    //   (await SharedPreferencesHelper.getUserId())?.toString().trim();

    await loadChatHistory();
    await initSocket();

    ever(messages, (_) => _scrollToBottom());
  }

  /// Initialize socket connection
  Future<void> initSocket() async {
    debugPrint("Initializing socket connection...");

    final token = await SharedPreferencesHelper.getAccessToken();
    final userId = await SharedPreferencesHelper.getOrExtractUserId();
    debugPrint("Current---- UserId: $userId");

    if (token == null) {
      debugPrint("Token missing");
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
  void sendMessage(String receiverId) {
    debugPrint("Sending message to receiverId: $receiverId");
    debugPrint("OrderId: $orderId");

    final text = textController.text.trim();
    if (text.isEmpty) return;

    final payload = {
      "receiverId": receiverId,
      "orderId": orderId,
      "content": text,
      "messageType": "TEXT",
    };

    UserSocketService().emit('send_message', payload);

    messages.add(MessageModel(text: text, isMe: true, time: _now()));

    textController.clear();
  }

  //  ─── Load Chat History ─────────────────────────────────────────────

  Future<void> loadChatHistory() async {
    if (receiverId == null || orderId == null) return;

    try {
      // final currentUserId = (await SharedPreferencesHelper.getUserId())
      //     ?.toString()
      //     .trim();
      // debugPrint("currentUserId: $currentUserId");
      final currentUserId = (await SharedPreferencesHelper.getUserId())
          ?.toString()
          .trim();

      final List<dynamic>? rawMessages = await ChatApiService.getChatHistory(
        receiverId: receiverId!,
        orderId: orderId!,
      );

      if (rawMessages == null || rawMessages.isEmpty) return;

      final List<MessageModel> history = rawMessages.map((msg) {
        final senderIdDynamic = msg['senderId'] ?? msg['sender']?['id'];
        final senderId = senderIdDynamic?.toString().trim() ?? '';

        final isMe = senderId == currentUserId;

        final createdAt = msg['createdAt'] ?? msg['created_at'];

        return MessageModel(
          text: msg['content'] ?? '',
          isMe: isMe,
          time: createdAt != null ? _formatTime(createdAt.toString()) : _now(),
        );
      }).toList();

      messages.assignAll(history);

      debugPrint("📜 Loaded ${history.length} messages from history");
      debugPrint("ownId: ${currentUserId}");
    } catch (e) {
      debugPrint("loadChatHistory error: $e");
    }
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

  String _formatTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return _now();
    }
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
