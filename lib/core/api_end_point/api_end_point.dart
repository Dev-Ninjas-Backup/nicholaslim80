class ApiEndPoint {
  static const String baseUrl = 'https://api.zipbee.sg/api/v1';
  //static const String baseUrl = 'http://10.10.20.130:3000/api/v1';
  static const String login = '$baseUrl/auth/login';
  static const String signUp = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String forgetPass = '$baseUrl/auth/forgot-password';
  static const String notificationID = '$baseUrl/notifications/{id}';
  static const String notification = '$baseUrl/notifications';
  static const String logOut = '$baseUrl/auth/logout';
  static const String resetPass = '$baseUrl/auth/forgot/reset-password';
  static const String order = '$baseUrl/order/mine';
  static const String addRaider = '$baseUrl/my-raider';
  static const String getRaider = '$baseUrl/my-raider/my-raider';
  static const String deleteRaider = '$baseUrl/my-raider';
  static const String profile = '$baseUrl/users/me';
  static const String updateProfile = '$baseUrl/users/{id}';
  static const String coinBasePrice = '$baseUrl/coin-management/base-price';
  static const String redeemCoin = '$baseUrl/coin-management/redeem-coin';
  static const String referLoyalty = '$baseUrl/referloyality';
  static const String vehicleTypes = '$baseUrl/admin/vehicle-types';
  static const String serviceZone = '$baseUrl/service-zone';
  static const String userProfile = '$baseUrl/users/{id}';
  static const String toggleFavorite = '$baseUrl/my-raider';
  static const String getDestination = '$baseUrl/destination';
  static const String homePageAd = '$baseUrl/advertise/role-based';
  static const String adImpression = '$baseUrl/advertise/{id}/impression';
  static const String adClick = '$baseUrl/advertise/{id}/click';
  static const String walletHistory =
      '$baseUrl/wallet/user/walletHistory/{userId}';
  static const String createOrder = '$baseUrl/order/indivitual';
  // Canonical create order endpoint (public)
  static const String orderCreate = '$baseUrl/order';
  static const String orderEstimate = '$baseUrl/coin-management/redeem-coin';
  static const String orderEstimate = '$baseUrl/order/{id}';

}
