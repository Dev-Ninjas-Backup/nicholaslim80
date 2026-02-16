class ApiEndPoint {
  static const String baseUrl = 'https://api.zipbee.sg/api/v1';
  static const String socketUrl = 'https://api.zipbee.sg';

  // static const String baseUrl = 'http://10.10.20.130:3000/api/v1';

  static const String login = '$baseUrl/auth/login';
  static const String upload = '$baseUrl/auth/upload';
  static const String signUp = '$baseUrl/auth/signup';
  static const String verifyOtp = '$baseUrl/auth/verify';
  static const String forgetPass = '$baseUrl/auth/forgot-password';
  static const String notificationID = '$baseUrl/notifications/{id}';
  static const String notification = '$baseUrl/notifications';
  static const String notificationFCM = '$baseUrl/notifications/fcm-token';
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
  static const String support =
      '$baseUrl/additional-services/service-email-number';
  static const String addRider = '$baseUrl/my-raider';
  static const String getDestination = '$baseUrl/destination';
  static const String homePageAd = '$baseUrl/advertise/role-based';
  static const String adImpression = '$baseUrl/advertise/{id}/impression';
  static const String adClick = '$baseUrl/advertise/{id}/click';
  static const String walletHistory =
      '$baseUrl/wallet/user/walletHistory/{userId}';
  static const String createOrder = '$baseUrl/order/indivitual';
  // Canonical create order endpoint (public)
  static const String orderCreate = '$baseUrl/order';
  static const String orderUpdateDetails = '$baseUrl/order/{id}/update-details';
  static const String orderId = '$baseUrl/order/{id}';
  static const String orderEstimate = '$baseUrl/coin-management/redeem-coin';

  // Destination endpoints
  static const String createDestination = '$baseUrl/destination';
  static const String addDestinationToOrder =
      '$baseUrl/order/{orderId}/destinations/add';

  // Order GET endpoints
  static const String getOrder = '$baseUrl/order/{orderId}';
  static const String additionalService = '$baseUrl/additional-services';
  static const String additionOrder =
      '$baseUrl/order/{order_id}/apply-addition/{serviceId}';
  static const String additionOrderD =
      '$baseUrl/order/{order_id}/remove-addition/{serviceId}';
  static const String cancelOrder = '$baseUrl/order/{orderId}/cancel';
  static const String notifyOrder = '$baseUrl/order/{orderId}/notify-rider';

  static const String getUserProfile = '$baseUrl/users/me';
  static const String rating = '$baseUrl/ratings';
  static const String ratingId = '$baseUrl/ratings/{type}/{id}';
  static const String faq = '$baseUrl/faq';
  static const String tip = '$baseUrl/tips/{order_id}/tip';
  static const String faqRole = '$baseUrl/faq/faqs-by-role';

  // Order discount & promo endpoints
  static const String applyDiscount = '$baseUrl/order/{orderId}/apply-discount';
  static const String notifyRider = '$baseUrl/order/{orderId}/notify-rider';
  static const String followedRider =
      '$baseUrl/order/followed-rider/order/{orderId}';

  // Stripe endpoints
  static const String stripeCredentials = '$baseUrl/stripe/credentials';
  static const String placeOrder = '$baseUrl/order/{orderId}/place';

  static const String addMoney = '$baseUrl/wallet/add-money/mobile';
  static const String confirmSetupIntent =
      '$baseUrl/wallet/confirm-setup-intent';

  static const String createSetupIntent = '$baseUrl/wallet/create-setup-intent';

  static const String saveCard = '$baseUrl/wallet/save-card';
  static const String getSavedCard = "$baseUrl/wallet/get-saved-card";

  //redeem-point
  static const String redeemPoint = '$baseUrl/referloyality/redeem-point';
  //make favorite
  static const String makeFavorite = '$baseUrl/my-raider/makefav/{id}';
  static const String impression = '$baseUrl/advertise/{id}/impression';
  //
  static const String supportChat = '$baseUrl/users/admin';
}
