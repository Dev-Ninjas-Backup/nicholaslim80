class ProfileModel {
  final String title;
  final String subtitle;

  ProfileModel({required this.title, required this.subtitle});

}

class UserModel {
  final String username;  // Name
  final String email;
  final String phone;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
  });

  // Factory method to create UserModel from JSON (Map<String, dynamic>)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['data']['username'],
      email: json['data']['email'],
      phone: json['data']['phone'],
    );
  }

  // Method to convert UserModel to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
    };
  }
}
