import 'package:ZipBee/core/shared_prefference_service/shared_pref.dart';
import 'package:ZipBee/features/user/chat/models/message_model.dart';
import 'package:ZipBee/features/user/chat/socket_service.dart/socket_service.dart';
import 'package:get/get.dart';

class UserMessageController extends GetxController {
  var messages = <MessageModel>[].obs;

  Future<void> initSocket() async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final userId = await SharedPreferencesHelper.getUserId();
    if (token == null || userId == null) return;

    UserSocketService.connect(token: token, userId: userId);

    UserSocketService.onReceiveMessage((data) {
      messages.add(MessageModel.fromSocket(data: data, isMe: false));
    });
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
