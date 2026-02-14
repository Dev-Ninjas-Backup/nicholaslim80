import 'package:intl/intl.dart';

class Notification1Model {
  final String id; // ✅ REQUIRED for delete
  final String title;
  final String subTitle;
  final String date;
  final String time;

  Notification1Model({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.date,
    required this.time,
  });

  factory Notification1Model.fromJson(Map<String, dynamic> json) {
    final createdAtStr = json['createdAt'] ?? json['created_at'];
    final createdAt = createdAtStr != null
        ? DateTime.parse(createdAtStr).toLocal()
        : DateTime.now();

    return Notification1Model(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? '',
      subTitle: json['message'] ?? '',
      date: DateFormat('dd-MM-yyyy').format(createdAt),
      time: DateFormat('hh:mm a').format(createdAt),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subTitle": subTitle,
    "date": date,
    "time": time,
  };
}
