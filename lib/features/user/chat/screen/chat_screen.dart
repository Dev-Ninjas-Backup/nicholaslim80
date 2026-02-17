import 'package:ZipBee/core/service/external_launcher_service.dart';
import 'package:ZipBee/features/user/chat/controllers/chat_controller.dart';
import 'package:ZipBee/features/user/chat/widget/chat_bubble.dart';
import 'package:ZipBee/features/user/chat/widget/order_info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final String receiverId;
  final String senderName;
  final String orderId;
  final String vehicleType;
  final String totalCost;
  final String assignRiderPhone;
  ChatScreen({
    required this.receiverId,
    Key? key,
    required this.senderName,
    required this.orderId,
    required this.vehicleType,
    required this.totalCost,
    required this.assignRiderPhone,
  }) : super(key: key);

  final UserMessageController controller = Get.put(UserMessageController());

  @override
  Widget build(BuildContext context) {
    // ensure controller knows current orderId (comes from previous screen)
    controller.orderId = orderId;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            Text(
              senderName.isNotEmpty ? senderName : "Rider Name",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text(
            //   "Active 2 min ago",
            //   style: TextStyle(color: Colors.grey, fontSize: 12),
            // ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.phone_forwarded_outlined,
              color: Colors.amber,
            ),
            onPressed: () {
              ExternalLauncherService.openDialer(assignRiderPhone);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          OrderInfoCard(
            orderId: orderId,

            vehicleType: vehicleType,
            totalCost: totalCost.isNotEmpty ? double.parse(totalCost) : 0.0,
            fromName: '',
            toName: '',
            // totalCost: 0.0,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "24 Aug, 10.10 AM",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          /// Messages
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(message: controller.messages[index]);
                },
              );
            }),
          ),

          /// Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: controller.textController,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(receiverId),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => controller.sendMessage(receiverId),
            ),
          ],
        ),
      ),
    );
  }
}
