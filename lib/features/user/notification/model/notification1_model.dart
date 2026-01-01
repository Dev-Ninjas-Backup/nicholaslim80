class Notification1Model {
  final String title;
  final String subTitle;
  final String date;
  final String time;

  Notification1Model({
    required this.title,
    required this.subTitle,
    required this.date,
    required this.time,
  });

  factory Notification1Model.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(
      json['createdAt'] ?? DateTime.now().toString(),
    );

    return Notification1Model(
      title: json['title'] ?? '',
      subTitle: json['message'] ?? '',
      date:
          "${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year}",
      time:
          "${createdAt.hour % 12 == 0 ? 12 : createdAt.hour % 12}:${createdAt.minute.toString().padLeft(2, '0')} ${createdAt.hour >= 12 ? 'PM' : 'AM'}",
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "subTitle": subTitle,
    "date": date,
    "time": time,
  };
}
