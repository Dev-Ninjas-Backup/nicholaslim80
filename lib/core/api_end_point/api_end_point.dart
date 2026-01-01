class ApiEndPoint {
  static const String baseUrl = 'http://10.10.20.45:3000/api/v1';
  //Login
  static const String login = '$baseUrl/auth/login';
  //SignUp
  static const String signUp = '$baseUrl/auth/signup';
  static const String notificationID = '$baseUrl/notifications/{id}';
  static const String notification = '$baseUrl/notifications';
}
