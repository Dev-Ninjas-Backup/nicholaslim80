import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/common/styles/global_text_style.dart';
import '../../../chat/screen/chat_screen.dart';
import '../../model/order_model.dart';

class MessageCallSection extends StatelessWidget {
  final OrderModel order;
  const MessageCallSection({super.key, required this.order});

  void _callRider() async {
    if (order.assignRiderPhone.isNotEmpty) {
      final url = Uri.parse("tel:${order.assignRiderPhone}");
      if (await canLaunchUrl(url)) await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.to(ChatScreen(receiverId: order.orderId, senderName: order.assignRiderName)),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.message_outlined, size: 20, color: Colors.black),
                const SizedBox(width: 8),
                Text("Message", style: getTextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: OutlinedButton(
            onPressed: _callRider,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              side: const BorderSide(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.call_outlined, size: 20, color: Colors.black),
                const SizedBox(width: 8),
                Text("Call", style: getTextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}