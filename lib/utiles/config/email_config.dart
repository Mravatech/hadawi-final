/// Email service configuration
/// 
/// This file contains configuration settings for the email notification service.
/// Update these values according to your email service provider.
class EmailConfig {
  // EmailJS Configuration (Recommended for Flutter apps)
  // Sign up at https://www.emailjs.com/ and get your credentials
  static const String emailJsServiceId = 'service_490xou9';
  static const String emailJsTemplateId = 'template_uojcu0d';
  static const String emailJsPublicKey = '0KggpA7MbOsBWSRrN';
  static const String emailJsPrivateKey = 'YOe3RmuNj2wX-4gFqNINE'; // Add your private key from EmailJS
  
  // Admin email to receive notifications
  static const String adminEmail = 'nouralsaid09@gmail.com';
  
  // Alternative: Custom backend email service
  static const String backendEmailUrl = 'https://your-backend-domain.com/api/send-email';
  static const String backendApiKey = 'YOUR_BACKEND_API_KEY';
  
  // Email template settings
  static const String emailSubject = '🎉 Occasion Target Reached - Hadawi App';
  static const String fromName = 'Hadawi App';
  
  // Email service provider selection
  // Set to 'emailjs' for EmailJS service or 'backend' for custom backend
  static const String emailProvider = 'emailjs'; // or 'backend'
  
  // Debug mode - set to true to see detailed logs
  static const bool debugMode = true;
  
  // Email sending timeout in seconds
  static const int emailTimeoutSeconds = 30;
  
  /// Get the appropriate email service URL based on provider
  static String getEmailServiceUrl() {
    switch (emailProvider) {
      case 'emailjs':
        return 'https://api.emailjs.com/api/v1.0/email/send';
      case 'backend':
        return backendEmailUrl;
      default:
        return 'https://api.emailjs.com/api/v1.0/email/send';
    }
  }
  
  /// Check if email service is properly configured
  static bool isEmailServiceConfigured() {
    switch (emailProvider) {
      case 'emailjs':
        return emailJsServiceId.isNotEmpty &&
               emailJsTemplateId.isNotEmpty &&
               emailJsPublicKey.isNotEmpty &&
               emailJsPrivateKey.isNotEmpty &&
               emailJsServiceId != 'YOUR_EMAILJS_SERVICE_ID' &&
               emailJsTemplateId != 'YOUR_EMAILJS_TEMPLATE_ID' &&
               emailJsPublicKey != 'YOUR_EMAILJS_PUBLIC_KEY' &&
               emailJsPrivateKey != 'YOUR_PRIVATE_KEY_HERE';
      case 'backend':
        return backendEmailUrl.isNotEmpty &&
               backendApiKey.isNotEmpty &&
               backendEmailUrl != 'https://your-backend-domain.com/api/send-email' &&
               backendApiKey != 'YOUR_BACKEND_API_KEY';
      default:
        return false;
    }
  }
  
  /// Get configuration status message
  static String getConfigurationStatus() {
    if (isEmailServiceConfigured()) {
      return '✅ Email service is properly configured';
    } else {
      return '❌ Email service needs configuration. Please update EmailConfig.dart with your credentials.';
    }
  }
  
  /// Debug method to print current configuration
  static void printConfiguration() {
    print('🔧 Email Configuration Debug:');
    print('Provider: $emailProvider');
    print('Service ID: $emailJsServiceId');
    print('Template ID: $emailJsTemplateId');
    print('Public Key: $emailJsPublicKey');
    print('Private Key: ${emailJsPrivateKey.substring(0, 8)}...'); // Only show first 8 chars for security
    print('Admin Email: $adminEmail');
    print('Is Configured: ${isEmailServiceConfigured()}');
    print('Service URL: ${getEmailServiceUrl()}');
  }
}
