class MessageModel {
  final String text;
  final bool isMe;
  final String time;

  MessageModel({
    required this.text,
    required this.isMe,
    required this.time,
  });

  factory MessageModel.fromSocket({
    required Map<String, dynamic> data,
    required bool isMe,
  }) {
    return MessageModel(
      text: data['content'] ?? '',
      isMe: isMe,
      time: _formatTime(DateTime.now()),
    );
  }

  static String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
