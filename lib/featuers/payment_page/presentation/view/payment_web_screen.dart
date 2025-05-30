import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebScreen extends StatefulWidget {
  final String checkoutId;
  final String occasionId;
  final String occasionName;
  final String transactionId;
  final double paymentAmount;
  final double remainingPrice;
  final String paymentMethod;
  final OccasionEntity occasionEntity;


  const PaymentWebScreen({super.key, required this.checkoutId, required integrity, required this.occasionId, required this.occasionName, required this.paymentAmount, required this.transactionId, required this.remainingPrice, required this.paymentMethod, required this.occasionEntity});

  @override
  _PaymentWebScreenState createState() => _PaymentWebScreenState();
}

class _PaymentWebScreenState extends State<PaymentWebScreen> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Get the primary blue color from ColorManager as a hex string
    final primaryBlueHex = ColorManager.primaryBlue.value.toRadixString(16).substring(2);

    String hyperpayHtml = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>

    <!-- Updated Content Security Policy (CSP) -->
    <meta http-equiv="Content-Security-Policy"
          content="
              default-src 'self';
              script-src 'self' https://eu-prod.oppwa.com 'unsafe-inline';
              style-src 'self' https://eu-prod.oppwa.com 'unsafe-inline';
              frame-src 'self' https://eu-prod.oppwa.com;
              connect-src 'self' wss://* https://p11.techlab-cdn.com;
              img-src 'self' https://eu-prod.oppwa.com data:;">
              
    <!-- Custom Styling -->
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .header h3 {
            color: #333;
            margin: 0;
            font-size: 18px;
            font-weight: 500;
        }
        .wpwl-form {
            background-color: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: 0 auto;
        }
        .wpwl-label {
            color: #495057;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .wpwl-control {
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 12px;
            width: 100%;
            font-size: 16px;
        }
        /* Remove padding for all input fields */
        .wpwl-control-cardNumber, 
        .wpwl-control-cvv,
        .wpwl-control-brand,
        select.wpwl-control {
            padding: 8px !important;
        }
        .wpwl-button {
            background-color: #${primaryBlueHex};
            color: white;
            border: none;
            border-radius: 8px;
            padding: 14px 20px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
            margin-top: 15px;
            transition: background-color 0.2s;
        }
        .wpwl-button:hover {
            background-color: #${primaryBlueHex}DD;
        }
        .wpwl-group {
            margin-bottom: 15px;
        }
        .wpwl-brand-card {
            margin-right: 10px;
        }
        .wpwl-brand-MADA {
            margin-right: 10px;
        }
        .wpwl-terms {
            font-size: 12px;
            color: #6c757d;
            text-align: center;
            margin-top: 20px;
        }
        .secure-badge {
            text-align: center;
            margin-top: 20px;
            color: #6c757d;
            font-size: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .secure-badge svg {
            margin-right: 5px;
        }
        /* Ensure placeholder text is visible */
        ::placeholder {
            color: #999 !important;
            opacity: 1 !important;
        }
        :-ms-input-placeholder {
            color: #999 !important;
        }
        ::-ms-input-placeholder {
            color: #999 !important;
        }
    </style>
</head>
<body>
    <div class="header">
        <h3>Complete your secure payment</h3>
    </div>
    
    <!-- Load Hyperpay Payment Widget -->
    <script src="https://eu-prod.oppwa.com/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}"></script>
    
    <!-- Configuration options for payment widget -->
    <script type="text/javascript"> 
        var wpwlOptions = {
            paymentTarget: "_top",
            style: "card",
            locale: "en",
            onReady: function() {
                console.log("Payment widget is ready");
                
                // Change text of the pay button
                var submitButton = document.querySelector('.wpwl-button-pay');
                if(submitButton) {
                    submitButton.textContent = "Pay Securely";
                    submitButton.style.backgroundColor = "#${primaryBlueHex}";
                }
                
                // Adjust padding for brand dropdown
                var brandSelect = document.querySelector('select.wpwl-control');
                if (brandSelect) {
                    brandSelect.style.padding = "8px";
                }
                
                // Target specific input fields to apply custom styles directly
                var cardNumberInput = document.querySelector('input.wpwl-control-cardNumber');
                if (cardNumberInput) {
                    cardNumberInput.style.padding = "8px";
                    cardNumberInput.placeholder = "Card Number";
                }
                
                var cardHolderInput = document.querySelector('input.wpwl-control-cardHolder');
                if (cardHolderInput) {
                    cardHolderInput.style.padding = "8px";
                    cardHolderInput.placeholder = "Card holder";
                }
                
                var cvvInput = document.querySelector('input.wpwl-control-cvv');
                if (cvvInput) {
                    cvvInput.style.padding = "8px";
                    cvvInput.placeholder = "CVV";
                }
                
                var expiryInput = document.querySelector('input.wpwl-control-expiry');
                if (expiryInput) {
                    expiryInput.style.padding = "8px";
                    expiryInput.placeholder = "MM / YY";
                }
                
                // Add card icons where applicable
                var brandDetection = document.querySelector('.wpwl-brand-card');
                if (brandDetection) {
                    brandDetection.setAttribute('aria-label', 'Card brand');
                }
            },
            onBeforeSubmitCard: function() {
                // Custom validation before submission
                return true;
            }
        };
        
        // Card display options
        wpwlOptions.card = {
            showCVV: true,
            showExpiryDate: true,
            brandDetection: true,
            numberFormat: "grouped",
            placeholders: {
                number: "Card Number",
                cvv: "CVV",
                holder: "Card holder",
                expiry: "MM / YY"
            }
        };
    </script>
    
    <!-- Adding MADA compliance scripts -->
    <script>
        function setupMadaCompliance() {
            var madaDiv = document.querySelector('.wpwl-brand-MADA');
            if (madaDiv) {
                madaDiv.setAttribute('role', 'img');
                madaDiv.setAttribute('aria-label', 'mada');
            }
        }
        
        // Apply MADA compliance after the widget loads
        window.addEventListener('load', setupMadaCompliance);
        
        // Additional script to ensure reduced padding is applied
        window.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                // Apply reduced padding to brand dropdown
                var brandSelect = document.querySelector('select.wpwl-control');
                if (brandSelect) {
                    brandSelect.style.padding = "8px";
                }
                
                // Apply reduced padding to other fields
                var allInputs = document.querySelectorAll('input.wpwl-control');
                allInputs.forEach(function(input) {
                    input.style.padding = "8px";
                });
                
                // Set button color to app primary color
                var payButton = document.querySelector('.wpwl-button-pay');
                if (payButton) {
                    payButton.style.backgroundColor = "#${primaryBlueHex}";
                }
            }, 500);
        });
    </script>

    <!-- Payment Form with MADA first -->
    <form class="paymentWidgets" data-brands=${widget.paymentMethod}></form>
    
    <!-- Secure payment badge -->
    <div class="secure-badge">
        <svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M8 0C5.8 0 4 1.8 4 4V6H3C2.4 6 2 6.4 2 7V15C2 15.6 2.4 16 3 16H13C13.6 16 14 15.6 14 15V7C14 6.4 13.6 6 13 6H12V4C12 1.8 10.2 0 8 0ZM8 2C9.1 2 10 2.9 10 4V6H6V4C6 2.9 6.9 2 8 2ZM8 9C8.6 9 9 9.4 9 10C9 10.6 8.6 11 8 11C7.4 11 7 10.6 7 10C7 9.4 7.4 9 8 9Z" fill="#6c757d"/>
        </svg>
        Secured by SSL encryption
    </div>
    
    <div class="wpwl-terms">
        By proceeding with the payment, you agree to our terms and conditions.
    </div>
</body>
</html>
""";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            debugPrint("Page started loading: $url");
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            debugPrint("Page finished loading: $url");
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView error: ${error.description}");
          },
          onUrlChange: (UrlChange change) async {
            debugPrint("URL changed to: ${change.url}");

            await context.read<PaymentCubit>().checkPaymentStatus(widget.checkoutId, context);

            if (change.url != null && change.url!.contains("https://hadawi.netlify.app/payment-result")) {

              Navigator.pop(context);
              handlePaymentResult(context.read<PaymentCubit>().paymentStatusList.last['result']['code'], context.read<PaymentCubit>().paymentStatusList.last['result']['description'], context.read<PaymentCubit>().paymentStatusList.last);
            }
          },
        ),
      )
      ..setOnConsoleMessage((JavaScriptConsoleMessage message) {
        debugPrint('Console message: ${message.message}');
      })
      ..loadRequest(Uri.dataFromString(
        hyperpayHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
  }

  void handlePaymentResult(String resultCode, String description, Map<String, dynamic> fullData){
    // Success codes typically start with 000.000., 000.100., or 000.200.
    if (resultCode.startsWith('000.000.') ||
        resultCode.startsWith('000.100.') ||
        resultCode.startsWith('000.200.')){
      debugPrint("✅ Payment Successful");
      showPaymentSuccess(description);
    }
    // Pending codes typically start with 000.200.
    else if (resultCode.startsWith('000.200.')) {
      debugPrint("⏳ Payment Pending");
      showPaymentPending(description);
    }
    // Failure codes can vary
    else {
      debugPrint("❌ Payment Failed: $resultCode - $description");
      showPaymentFailure(resultCode, description);
    }
  }

  void showPaymentSuccess(String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentSuccess').toString()),
        content: Text(AppLocalizations.of(context)!.translate('paymentSuccessMessage').toString()),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              customPushReplacement(context, OccasionDetails(occasionId: widget.occasionId, fromHome: true,));
              await PaymentCubit.get(context).addPaymentData(
                context: context,
                transactionId: widget.transactionId,
                occasionId: widget.occasionId,
                remainingPrince: widget.remainingPrice.toString(),
                status: "success",
                occasionName: widget.occasionName,
                paymentAmount: widget.paymentAmount,
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentPending(String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentPending').toString()),
        content: Text("${AppLocalizations.of(context)!.translate('paymentPendingMessage').toString()}\n\n$description"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              customPushReplacement(context, OccasionDetails(occasionId: widget.occasionId, fromHome: true,));
              await PaymentCubit.get(context).addPaymentData(
                context: context,
                occasionId: widget.occasionId,
                transactionId: widget.transactionId,
                remainingPrince: widget.remainingPrice.toString(),
                status: "pending",
                occasionName: widget.occasionName,
                paymentAmount: widget.paymentAmount,
              );
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentFailure(String resultCode, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentFailed').toString()),
        content: Text("${AppLocalizations.of(context)!.translate('paymentFailedMessage').toString()}\n\n$description"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentError(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Payment Error"),
        content: Text("An error occurred: $message"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.gray,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            AppLocalizations.of(context)!.translate('completePayment').toString(),
            style: TextStyle(
                color: ColorManager.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image(image: AssetImage(AssetsManager.logoWithoutBackground)),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorManager.primaryBlue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}