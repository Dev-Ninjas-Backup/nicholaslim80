class ApiEndPoint {
  static const String baseUrl = 'https://api.zipbee.sg/api/v1';

  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String forgetPass = '$baseUrl/auth/forgot-password';
  static const String notificationID = '$baseUrl/notifications/{id}';
  static const String notification = '$baseUrl/notifications';
  static const String resetPass = '$baseUrl/auth/forgot/reset-password';
}
