import 'package:ZipBee/features/user/user_support/support_chat_screen/model/support_chat_model.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <Message>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialMessages();
  }

  void loadInitialMessages() {
    messages.addAll([
      Message(
        sender: "Sandy",
        text: "Hi Daniel, good day!How may \nI help you today?",
        isUser: false,
      ),

      Message(
        sender: "Sandy",
        text:
            "You may want to ask:\n• How I speed up my parcel delivery?\n• What if I confirmed the wrong order?\n• How do I raise a return/refund request?\n• Other Frequently Asked Questions?",
        isUser: false,
      ),
    ]);
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    messages.add(Message(sender: "Daniel", text: text, isUser: true));
    Future.delayed(Duration(seconds: 1), () {
      messages.add(
        Message(
          sender: "Sandy",
          text: "Thank you for your message. How can I assist you further?",
          isUser: false,
        ),
      );
    });
  }
}
