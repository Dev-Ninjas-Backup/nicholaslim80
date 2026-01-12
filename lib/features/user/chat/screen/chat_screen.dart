import 'package:ZipBee/features/user/chat/widget/chat_bubble.dart';
import 'package:ZipBee/features/user/chat/widget/order_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';


class ChatScreen extends StatelessWidget {
  final UserMessageController controller = Get.put(UserMessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text("John Conley", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Text("Active 2 min ago", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.phone_forwarded_outlined, color: Colors.amber[700]),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          OrderInfoCard(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text("24 Aug, 10.10 AM", style: TextStyle(color: Colors.grey[600])),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: controller.messages[index]);
              },
            )),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.emoji_emotions_outlined), onPressed: () {}),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.mic_none), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}