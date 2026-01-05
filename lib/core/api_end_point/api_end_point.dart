class ApiEndPoint {
  static const String baseUrl = 'https://api.zipbee.sg/api/v1';

  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String forgetPass = '$baseUrl/auth/forgot-password';
  static const String notificationID = '$baseUrl/notifications/{id}';
  static const String notification = '$baseUrl/notifications';
  static const String logOut = '$baseUrl/auth/logout';
  static const String resetPass = '$baseUrl/auth/forgot/reset-password';
  static const String order = '$baseUrl/order';

  //raider add
  static const String addRaider = '$baseUrl/my-raider';
  static const String getRaider = '$baseUrl/my-raider/my-raider';
}
