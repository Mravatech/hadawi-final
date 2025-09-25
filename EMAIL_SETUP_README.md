# Email Notification Setup for Hadawi App

This document explains how to set up email notifications that are automatically sent when an occasion reaches its target amount.

## Overview

The email notification system automatically sends an email to a specified admin email address whenever an occasion's `moneyGiftAmount` reaches or exceeds its `giftPrice` target.

## Files Added/Modified

### New Files:
1. `lib/utiles/services/email_service.dart` - Main email service
2. `lib/utiles/config/email_config.dart` - Email configuration
3. `EMAIL_SETUP_README.md` - This setup guide

### Modified Files:
1. `lib/featuers/payment_page/presentation/controller/payment_cubit.dart` - Added email notification logic

## Setup Instructions

### Option 1: Using EmailJS (Recommended)

1. **Sign up for EmailJS**:
   - Go to [https://www.emailjs.com/](https://www.emailjs.com/)
   - Create a free account
   - Create a new service (Gmail, Outlook, etc.)

2. **Create an Email Template**:
   - In EmailJS dashboard, go to "Email Templates"
   - Create a new template with the following variables:
     ```
     {{occasion_name}}
     {{occasion_id}}
     {{target_amount}}
     {{current_amount}}
     {{person_name}}
     {{person_email}}
     {{person_phone}}
     {{occasion_date}}
     {{gift_name}}
     {{gift_price}}
     {{completion_date}}
     {{message}}
     ```

3. **Update Configuration**:
   - Open `lib/utiles/config/email_config.dart`
   - Replace the placeholder values:
     ```dart
     static const String emailJsServiceId = 'your_service_id_here';
     static const String emailJsTemplateId = 'your_template_id_here';
     static const String emailJsPublicKey = 'your_public_key_here';
     static const String adminEmail = 'your_admin_email@domain.com';
     ```

### Option 2: Using Custom Backend

1. **Set up your backend email service**:
   - Create an API endpoint that accepts email data
   - Implement email sending logic (using Nodemailer, SendGrid, etc.)

2. **Update Configuration**:
   - Open `lib/utiles/config/email_config.dart`
   - Set `emailProvider` to `'backend'`
   - Update the backend URL and API key:
     ```dart
     static const String emailProvider = 'backend';
     static const String backendEmailUrl = 'https://your-backend.com/api/send-email';
     static const String backendApiKey = 'your_api_key_here';
     ```

## How It Works

### Automatic Trigger
The email notification is automatically triggered in the `addPaymentData` method of `PaymentCubit`:

1. **Payment Processing**: When a payment is successfully processed
2. **Amount Update**: The `moneyGiftAmount` is updated in Firestore
3. **Completion Check**: The system checks if `moneyGiftAmount >= giftPrice`
4. **Email Sending**: If target is reached, an email notification is sent
5. **Status Update**: The occasion is marked as completed in Firestore

### Manual Trigger
You can also manually trigger the email check:

```dart
await PaymentCubit.get(context).checkOccasionCompletionAndSendEmail(
  occasionId: 'your_occasion_id',
);
```

## Email Content

The email includes:
- Occasion name and ID
- Target amount vs. current amount
- Person details (name, email, phone)
- Occasion date and gift information
- Completion timestamp
- Formatted message

## Configuration Options

### EmailConfig Settings:
- `emailProvider`: Choose between 'emailjs' or 'backend'
- `adminEmail`: Email address to receive notifications
- `debugMode`: Enable/disable debug logging
- `emailTimeoutSeconds`: Timeout for email sending

### Debug Mode
Set `debugMode = true` in `EmailConfig` to see detailed logs:
```
🎯 Checking occasion completion: occasion_123
💰 Current amount: 1000.0, Target amount: 1000.0
🎉 Occasion target reached! Sending email notification...
✅ Email notification sent successfully for occasion: occasion_123
```

## Testing

1. **Test Configuration**:
   ```dart
   print(EmailConfig.getConfigurationStatus());
   ```

2. **Test Email Sending**:
   - Create a test occasion with a low target amount
   - Make a payment that reaches the target
   - Check the admin email for the notification

## Troubleshooting

### Common Issues:

1. **"Email service not configured"**:
   - Update `EmailConfig.dart` with your credentials
   - Ensure all placeholder values are replaced

2. **"Failed to send email"**:
   - Check your EmailJS service configuration
   - Verify template variables match the code
   - Check network connectivity

3. **"Occasion document not found"**:
   - Ensure the occasion ID is valid
   - Check Firestore permissions

### Debug Steps:
1. Enable debug mode in `EmailConfig`
2. Check console logs for detailed error messages
3. Verify Firestore data structure
4. Test email service independently

## Security Notes

- Never commit real API keys to version control
- Use environment variables for production
- Consider rate limiting for email sending
- Implement proper error handling

## Production Considerations

1. **Rate Limiting**: Implement rate limiting to prevent spam
2. **Error Handling**: Add retry logic for failed emails
3. **Monitoring**: Set up monitoring for email delivery
4. **Backup**: Consider backup notification methods (SMS, push notifications)

## Support

For issues or questions:
1. Check the debug logs
2. Verify configuration settings
3. Test with a simple email template
4. Contact the development team

---

**Note**: This email notification system is designed to be lightweight and reliable. Make sure to test thoroughly before deploying to production.


