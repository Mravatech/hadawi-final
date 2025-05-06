import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApplePayWebView extends StatefulWidget {
  final String checkoutId;
  final String occasionId;
  final String occasionName;
  final String transactionId;
  final double paymentAmount;
  final double remainingPrice;
  final String paymentMethod;

  const ApplePayWebView({
    super.key,
    required this.checkoutId,
    required this.occasionId,
    required this.occasionName,
    required this.paymentAmount,
    required this.transactionId,
    required this.remainingPrice,
    required this.paymentMethod, required integrity
  });

  @override
  _ApplePayWebViewState createState() => _ApplePayWebViewState();
}

class _ApplePayWebViewState extends State<ApplePayWebView> {
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
    <title>Apple Pay</title>

    <!-- Updated Content Security Policy (CSP) for Apple Pay -->
    <meta http-equiv="Content-Security-Policy"
          content="
              default-src 'self';
              script-src 'self' https://eu-test.oppwa.com https://applepay.cdn-apple.com 'unsafe-inline';
              style-src 'self' https://eu-test.oppwa.com 'unsafe-inline';
              frame-src 'self' https://eu-test.oppwa.com;
              connect-src 'self' wss://* https://p11.techlab-cdn.com https://*.apple.com;
              img-src 'self' https://eu-test.oppwa.com data:;">
              
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
        .apple-pay-container {
            background-color: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 500px;
            margin: 0 auto;
            text-align: center;
        }
        .apple-pay-details {
            margin: 20px 0;
            padding: 15px;
            border-radius: 8px;
            background-color: #f8f9fa;
        }
        .apple-pay-amount {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }
        .apple-pay-description {
            font-size: 14px;
            color: #666;
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
        /* Required style for Apple Pay button to appear correctly */
        .wpwl-apple-pay-button {
            -webkit-appearance: -apple-pay-button !important;
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
        .wpwl-terms {
            font-size: 12px;
            color: #6c757d;
            text-align: center;
            margin-top: 20px;
        }
        #apple-pay-not-available {
            text-align: center;
            padding: 30px 20px;
        }
        #apple-pay-not-available p {
            margin-bottom: 20px;
            color: #666;
        }
        #apple-pay-not-available .wpwl-button {
            max-width: 300px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <div class="header">
        <h3>Complete your payment with Apple Pay</h3>
    </div>
    
    <!-- Load Hyperpay Payment Widget -->
    <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}"></script>
    
    <!-- Apple Pay Container -->
    <div class="apple-pay-container">
        <div id="apple-pay-not-available" style="display: none;">
            <p>Apple Pay is not available on this device or browser.</p>
            <p>Please try using a different device or payment method.</p>
        </div>
        
        <div id="apple-pay-available">
            <div class="apple-pay-details">
                <div class="apple-pay-amount">${double.parse(context.read<PaymentCubit>().paymentAmountController.text.toString())} SAR</div>
                <div class="apple-pay-description">${widget.occasionName}</div>
            </div>

            <script>
                // Configure Apple Pay options
                var wpwlOptions = {
                    paymentTarget: "_top",
                    applePay: {
                        displayName: "Hadawi",
                        merchantCapabilities: ["supports3DS", "supportsDebit", "supportsCredit"],
                        supportedNetworks: ["masterCard", "visa", "mada"],
                        supportedCountries: ["SA"],
                        merchantIdentifier: "merchant.com.hadawi",
                        countryCode: "SA",
                        currencyCode: "SAR",
                        buttonStyle: "black",
                        buttonType: "buy",
                        total: { 
                            label: "Hadawi App", 
                            amount: "${double.parse(context.read<PaymentCubit>().paymentAmountController.text.toString())}" 
                        }
                    },
                    
                    onReady: function() {
                        console.log("Payment widget is ready");
                        
                        // Check if Apple Pay is available
                        if (window.ApplePaySession && ApplePaySession.canMakePayments()) {
                            document.getElementById('apple-pay-not-available').style.display = 'none';
                            document.getElementById('apple-pay-button-container').style.display = 'block';
                        } else {
                            document.getElementById('apple-pay-not-available').style.display = 'block';
                            document.getElementById('apple-pay-button-container').style.display = 'none';
                        }
                    }
                };
            </script>
            
            <div id="apple-pay-button-container">
                <form action="https://hadawi.netlify.app/payment-result" class="paymentWidgets" data-brands="APPLEPAY"></form>
            </div>
        </div>
        
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
    </div>
    
    <script>
        // Check Apple Pay availability when the page loads
        window.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                if (window.ApplePaySession && ApplePaySession.canMakePayments()) {
                    document.getElementById('apple-pay-not-available').style.display = 'none';
                    document.getElementById('apple-pay-button-container').style.display = 'block';
                } else {
                    document.getElementById('apple-pay-not-available').style.display = 'block';
                    document.getElementById('apple-pay-button-container').style.display = 'none';
                }
            }, 500);
        });
    </script>
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
            // This ensures JavaScript on the page gets executed properly
            evaluateJavaScript();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView error: ${error.description}");
          },
          onUrlChange: (UrlChange change) async {
            debugPrint("URL changed to: ${change.url}");

            if (change.url != null) {
              await context.read<PaymentCubit>().checkApplePaymentStatus(widget.checkoutId, context);

              if (change.url!.contains("https://hadawi.netlify.app/payment-result")) {
                Navigator.pop(context);
                handlePaymentResult(
                    context.read<PaymentCubit>().paymentStatusList.last['result']['code'],
                    context.read<PaymentCubit>().paymentStatusList.last['result']['description'],
                    context.read<PaymentCubit>().paymentStatusList.last
                );
              }
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

  // Helper method to evaluate JavaScript after page has loaded
  void evaluateJavaScript() async {
    try {
      // Check Apple Pay availability
      final jsResult = await controller.runJavaScriptReturningResult('''
        (function() {
          if (window.ApplePaySession && ApplePaySession.canMakePayments()) {
            return true;
          } else {
            return false;
          }
        })()
      ''');

      debugPrint('Apple Pay available: $jsResult');
    } catch (e) {
      debugPrint('Error evaluating JavaScript: $e');
    }
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
              await PaymentCubit.get(context).addPaymentData(
                context: context,
                occasionId: widget.occasionId,
                transactionId: widget.transactionId,
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