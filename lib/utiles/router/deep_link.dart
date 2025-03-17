class DeepLinkUtils {
  // Base URL for your app's deep links
  static const String _scheme = 'hadawi';
  static const String _host = 'app';

  // Generate a deep link for an occasion
  static String generateOccasionDeepLink(String occasionId) {
    return '$_scheme://$_host/Occasion-details/$occasionId';
  }

  // Generate a deep link for a product
  static String generateProductDeepLink(String productId) {
    return '$_scheme://$_host/product/$productId';
  }

// Add more methods for other deep link types as needed
}