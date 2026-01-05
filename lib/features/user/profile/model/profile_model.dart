class ProfileModel {
  final String title;
  final String subtitle;

  ProfileModel({required this.title, required this.subtitle});

  // factory ProfileModel.fromJson(Map<String, dynamic> json) {
  //   return ProfileModel(
  //     title: json['title'] ?? '',
  //     subtitle: json['subtitle'] ?? '',
  //   );
  // }

  // Map<String, dynamic> toJson() => {"title": title, "subtitle": subtitle};
}
