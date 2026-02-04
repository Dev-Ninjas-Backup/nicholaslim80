/// Stripe API Keys Configuration
/// Secure key storage for Stripe payment processing
class StripeKeys {
  // Stripe Secret Key (Backend use only)
  static const String stripeSecretKey =
      'sk_test_51SknuvDXBOtCRfi2FGjiPc9fgJMRLuYHtDPYJiNpTTTxgvRmSBt8ZSNKnPVHQygbxtcydniGg8jvluY9HY0PLYuF00Udg0Ihhz';

  // Stripe Public Key (Client side)
  static const String stripePublicKey =
      'pk_test_51SknuvDXBOtCRfi2drGBAdKBna0ZOkJLdUfkHRbxsuJIS5gd4QWFpPVNowaNyCUZDDeKRfkU5BFQY1H0BzxQ3a6Q00Z5dHGGgY';

  // Merchant display name
  static const String merchantDisplayName = 'ZipBee Delivery';

  /// Validate keys are properly configured
  static bool isConfigured() {
    return stripeSecretKey.isNotEmpty &&
        stripePublicKey.isNotEmpty &&
        stripePublicKey.startsWith('pk_');
  }
}
