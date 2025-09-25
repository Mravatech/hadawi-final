import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:hadawi_app/utiles/config/email_config.dart';

/// Email service for sending notifications when occasions reach their target amount
class EmailService {

  /// Send email notification when an occasion reaches its target amount
  /// 
  /// [occasionName] - Name of the occasion
  /// [occasionId] - Unique identifier of the occasion
  /// [targetAmount] - Target amount for the occasion
  /// [currentAmount] - Current collected amount
  /// [personName] - Name of the person who created the occasion
  /// [personEmail] - Email of the person who created the occasion
  /// [personPhone] - Phone of the person who created the occasion
  /// [occasionDate] - Date of the occasion
  /// [giftName] - Name of the gift
  /// [giftPrice] - Price of the gift
  /// 
  /// Returns true if email was sent successfully, false otherwise
  static Future<bool> sendOccasionCompletionNotification({
    required String occasionName,
    required String occasionId,
    required double targetAmount,
    required double currentAmount,
    required String personName,
    required String personEmail,
    required String personPhone,
    required String occasionDate,
    required String giftName,
    required double giftPrice,
  }) async {
    try {
      debugPrint('📧 Sending occasion completion email for: $occasionName');

      // Check if email service is configured
      if (!EmailConfig.isEmailServiceConfigured()) {
        debugPrint('❌ Email service not configured. Please update EmailConfig.dart');
        return false;
      }

      // Prepare email data
      final emailData = {
        'service_id': EmailConfig.emailJsServiceId,
        'template_id': EmailConfig.emailJsTemplateId,
        'user_id': EmailConfig.emailJsPublicKey,
        'accessToken': EmailConfig.emailJsPrivateKey,
        'template_params': {
          'to_email': EmailConfig.adminEmail,
          'to_name': 'Hadawi Admin',
          'occasion_name': occasionName,
          'occasion_id': occasionId,
          'target_amount': targetAmount.toStringAsFixed(2),
          'current_amount': currentAmount.toStringAsFixed(2),
          'person_name': personName,
          'person_email': personEmail,
          'person_phone': personPhone,
          'occasion_date': occasionDate,
          'gift_name': giftName,
          'gift_price': giftPrice.toStringAsFixed(2),
          'completion_date': DateTime.now().toIso8601String(),
          'message': _generateEmailMessage(
            occasionName: occasionName,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            personName: personName,
            giftName: giftName,
          ),
        }
      };

      // Send email via EmailJS
      final response = await http.post(
        Uri.parse(EmailConfig.getEmailServiceUrl()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(emailData),
      );
      
      debugPrint('📧 EmailJS Response Status: ${response.statusCode}');
      debugPrint('📧 EmailJS Response Body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('✅ Occasion completion email sent successfully');
        return true;
      } else {
        debugPrint('❌ Failed to send email. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending occasion completion email: $e');
      return false;
    }
  }

  /// Alternative method using a custom email service endpoint
  /// This method sends email through your own backend service
  static Future<bool> sendOccasionCompletionNotificationViaBackend({
    required String occasionName,
    required String occasionId,
    required double targetAmount,
    required double currentAmount,
    required String personName,
    required String personEmail,
    required String personPhone,
    required String occasionDate,
    required String giftName,
    required double giftPrice,
  }) async {
    try {
      debugPrint('📧 Sending occasion completion email via backend for: $occasionName');

      // Prepare email data for your backend
      final emailData = {
        'to': EmailConfig.adminEmail,
        'subject': '🎉 Occasion Target Reached - $occasionName',
        'occasion_name': occasionName,
        'occasion_id': occasionId,
        'target_amount': targetAmount,
        'current_amount': currentAmount,
        'person_name': personName,
        'person_email': personEmail,
        'person_phone': personPhone,
        'occasion_date': occasionDate,
        'gift_name': giftName,
        'gift_price': giftPrice,
        'completion_date': DateTime.now().toIso8601String(),
        'message': _generateEmailMessage(
          occasionName: occasionName,
          targetAmount: targetAmount,
          currentAmount: currentAmount,
          personName: personName,
          giftName: giftName,
        ),
      };

      // Send email via your backend service
      final response = await http.post(
        Uri.parse(EmailConfig.backendEmailUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EmailConfig.backendApiKey}',
        },
        body: jsonEncode(emailData),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Occasion completion email sent successfully via backend');
        return true;
      } else {
        debugPrint('❌ Failed to send email via backend. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending occasion completion email via backend: $e');
      return false;
    }
  }

  /// Generate email message content
  static String _generateEmailMessage({
    required String occasionName,
    required double targetAmount,
    required double currentAmount,
    required String personName,
    required String giftName,
  }) {
    return '''
    ''';
  }

  /// Send a test email to verify the email service is working
  static Future<bool> sendTestEmail({
    String? recipientEmail,
  }) async {
    try {
      debugPrint('🧪 Sending test email... to ${recipientEmail ?? EmailConfig.adminEmail}');

      // Check if email service is configured
      if (!EmailConfig.isEmailServiceConfigured()) {
        debugPrint('❌ Email service not configured. Please update EmailConfig.dart');
        EmailConfig.printConfiguration();
        return false;
      }
      
      debugPrint('✅ Email service is configured');
      EmailConfig.printConfiguration();

      final testRecipient = EmailConfig.adminEmail;
      
      final emailData = {
        'service_id': EmailConfig.emailJsServiceId,
        'template_id': EmailConfig.emailJsTemplateId,
        'user_id': EmailConfig.emailJsPublicKey,
        'accessToken': EmailConfig.emailJsPrivateKey,
        'template_params': {
          'to_email': testRecipient,
          'to_name': 'Test User',
          'occasion_name': 'Test Occasion - Birthday Party',
          'occasion_id': 'test_occasion_123',
          'target_amount': '1000.00',
          'current_amount': '1000.00',
          'person_name': 'Ahmed Al-Rashid',
          'person_email': 'ahmed@example.com',
          'person_phone': '+966501234567',
          'occasion_date': '2025-12-25',
          'gift_name': 'iPhone 15 Pro',
          'gift_price': '1000.00',
          'completion_date': DateTime.now().toIso8601String(),
          'message': _generateTestEmailMessage(),
        }
      };

      final response = await http.post(
        Uri.parse(EmailConfig.getEmailServiceUrl()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(emailData),
      );
      debugPrint('EmailConfig.getEmailServiceUrl(): ${EmailConfig.getEmailServiceUrl()}');

      if (response.statusCode == 200) {
        debugPrint('✅ Test email sent successfully to: $testRecipient');
        debugPrint('📧 Check your email inbox for the test notification');
        return true;
      } else {
        
        debugPrint('❌ Failed to send test email. Status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending test email: $e');
      return false;
    }
  }

  /// Generate test email message
  static String _generateTestEmailMessage() {
    return '''
    ''';
  }

  /// Send simple notification email (fallback method)
  static Future<bool> sendSimpleNotification({
    required String subject,
    required String message,
    required String recipientEmail,
  }) async {
    try {
      debugPrint('📧 Sending simple notification email');

      final emailData = {
        'service_id': EmailConfig.emailJsServiceId,
        'template_id': EmailConfig.emailJsTemplateId,
        'user_id': EmailConfig.emailJsPublicKey,
        'accessToken': EmailConfig.emailJsPrivateKey,
        'template_params': {
          'to_email': recipientEmail,
          'to_name': 'Hadawi User',
          'subject': subject,
          'message': message,
          'date': DateTime.now().toIso8601String(),
        }
      };

      final response = await http.post(
        Uri.parse(EmailConfig.getEmailServiceUrl()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(emailData),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Simple notification email sent successfully');
        return true;
      } else {
        debugPrint('❌ Failed to send simple notification email. Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error sending simple notification email: $e');
      return false;
    }
  }
}
