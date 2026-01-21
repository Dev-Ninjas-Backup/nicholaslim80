/// Stripe API Keys Configuration
/// Secure key storage for Stripe payment processing
class StripeKeys {
  // Stripe Secret Key (Backend use only)
  static const String stripeSecretKey =
      'sk_test_51SajilBojBeI3sJoFuVgMDmZn0uVQHPnqEHVfOAQnUeXxctPoGEBt7B2eM4J85UQD8mBPmpuPihI7H929dJtd3VA0006Dmswby';

  // Stripe Public Key (Client side)
  static const String stripePublicKey =
      'pk_test_51SajilBojBeI3sJoqnjO7VaXEhgQzV4gSeMoTiWXdHuhMXIfC6AuFM74xedRQWNupvpuEErGwn65ju98t301lTQM00ChLOeiyE';

  // Merchant display name
  static const String merchantDisplayName = 'ZipBee Delivery';

  /// Validate keys are properly configured
  static bool isConfigured() {
    return stripeSecretKey.isNotEmpty &&
        stripePublicKey.isNotEmpty &&
        stripePublicKey.startsWith('pk_');
  }
}
