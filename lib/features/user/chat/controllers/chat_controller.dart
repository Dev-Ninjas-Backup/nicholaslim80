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

  Future<void> initSocket() async {
    debugPrint("Initializing socket connection...");
    final token = await SharedPreferencesHelper.getAccessToken();
    final userId = await SharedPreferencesHelper.getUserId().toString();
    if (token == null){
      debugPrint("Token or UserId is null, cannot connect to socket.");
      return;
    };

    UserSocketService.connect(token: token, userId: userId.toString());

//    UserSocketService.onReceiveMessage((data) {
//     debugPrint('Received message');
//   print("📩 Received on User: $data"); // must show Rider message
//   messages.add(MessageModel.fromSocket(data: data, isMe: false));
// });

  }

  void sendMessage({required String receiverId, required String content}) {
    if (content.trim().isEmpty) return;

    UserSocketService.sendMessage(receiverId: receiverId, content: content);

    messages.add(MessageModel(
      text: content,
      isMe: true,
      time: _now(),
    ));
  }

  String _now() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  @override
  void onClose() {
    UserSocketService.disconnect();
    super.onClose();
  }
}
