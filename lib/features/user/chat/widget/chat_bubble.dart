import 'package:ZipBee/features/user/chat/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      decoration: BoxDecoration(
        color: message.isMe ? Color(0xFFFFCC00) : Color(0xFFEFEFEF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: message.isMe ? Radius.circular(20) : Radius.circular(0),
          bottomRight: message.isMe ? Radius.circular(0) : Radius.circular(20),
        ),
      ),
      child: Text(
        message.text,
        style: TextStyle(color: Colors.black, fontSize: 15),
      ),
    );
  }
}
