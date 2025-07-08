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

class ApplePayWebView extends StatefulWidget {
  final String checkoutId;
  final String occasionId;
  final String occasionName;
  final String transactionId;
  final double paymentAmount;
  final double remainingPrice;
  final String paymentMethod;
  final OccasionEntity occasionEntity;

  const ApplePayWebView({
    super.key,
    required this.checkoutId,
    required this.occasionId,
    required this.occasionName,
    required this.paymentAmount,
    required this.transactionId,
    required this.remainingPrice,
    required this.paymentMethod,
    required this.occasionEntity,
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
              default-src 'self' https:;
              script-src 'self' https://eu-prod.oppwa.com https://applepay.cdn-apple.com https://js.stripe.com 'unsafe-inline' 'unsafe-eval';
              style-src 'self' https://eu-prod.oppwa.com 'unsafe-inline';
              frame-src 'self' https://eu-prod.oppwa.com https://js.stripe.com;
              connect-src 'self' wss://* https://*.apple.com https://eu-prod.oppwa.com https://hadawi.netlify.app;
              img-src 'self' https://eu-prod.oppwa.com data:;
              font-src 'self' data:;">
              
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
            color: #666;
        }
        #apple-pay-not-available p {
            margin-bottom: 20px;
        }
        #apple-pay-not-available .wpwl-button {
            max-width: 300px;
            margin: 0 auto;
        }
        .loading-spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #${primaryBlueHex};
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 2s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .paymentWidgets {
            margin-top: 20px;
        }
        /* Override default Apple Pay button styles */
        .wpwl-wrapper-brand-APPLEPAY {
            width: 100% !important;
        }
        .wpwl-button-brand-APPLEPAY {
            width: 100% !important;
            margin: 0 !important;
        }
        .wpwl-wrapper {
            margin: 0 !important;
            padding: 0 !important;
        }
        .wpwl-form {
            margin: 0 !important;
            padding: 0 !important;
        }
        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
        }
        .retry-button {
            background-color: #${primaryBlueHex};
            color: white;
            border: none;
            border-radius: 8px;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h3>Complete your payment with Apple Pay</h3>
    </div>
    
    <!-- Apple Pay Container -->
    <div class="apple-pay-container">
        <div class="apple-pay-details">
            <div class="apple-pay-amount">${widget.paymentAmount.toStringAsFixed(2)} SAR</div>
            <div class="apple-pay-description">${widget.occasionName}</div>
        </div>

        <div id="loading-container">
            <div class="loading-spinner"></div>
            <p>Loading Apple Pay...</p>
        </div>
        
        <div id="apple-pay-not-available" style="display: none;">
            <p>Apple Pay is not available on this device or browser.</p>
            <p>Please try using a different device or payment method.</p>
            <div id="error-details" class="error-message" style="display: none;"></div>
            <button class="retry-button" onclick="retryPayment()">Retry</button>
        </div>
        
        <div id="apple-pay-available" style="display: none;">
            <form class="paymentWidgets" data-brands="APPLEPAY"></form>
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
        console.log('Starting Apple Pay initialization...');
        console.log('User Agent:', navigator.userAgent);
        console.log('Checkout ID:', '${widget.checkoutId}');
        
        let initializationAttempts = 0;
        const maxAttempts = 3;
        
        // Global error handler
        window.addEventListener('error', function(e) {
            console.error('Global error:', e.error);
            showError('JavaScript Error: ' + e.message);
        });
        
        // Function to show error details
        function showError(message) {
            const errorDiv = document.getElementById('error-details');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }
        
        // Retry function
        function retryPayment() {
            console.log('Retrying payment initialization...');
            document.getElementById('loading-container').style.display = 'block';
            document.getElementById('apple-pay-not-available').style.display = 'none';
            document.getElementById('apple-pay-available').style.display = 'none';
            
            // Clear error details
            const errorDiv = document.getElementById('error-details');
            errorDiv.style.display = 'none';
            
            // Retry initialization
            setTimeout(initializePayment, 1000);
        }
        
        // Initialize payment function
        function initializePayment() {
            initializationAttempts++;
            console.log('Initialization attempt:', initializationAttempts);
            
            // Check if HyperPay script is loaded
            if (typeof wpwlOptions === 'undefined') {
                console.log('HyperPay script not loaded, loading...');
                loadHyperPayScript();
                return;
            }
            
            // Configure Apple Pay options
            window.wpwlOptions = {
                paymentTarget: "_top",
                locale: "en",
                applePay: {
                    merchantCapabilities: ['supports3DS', 'supportsDebit', 'supportsCredit'],
                    supportedNetworks: ['visa', 'masterCard', 'mada', 'amex'],
                    supportedCountries: ["SA"],
                    currencyCode: 'SAR',
                    countryCode: 'SA',
                    buttonStyle: 'black',
                    buttonType: 'buy',
                    merchantIdentifier: 'merchant.com.hadawi.app',
                    total: { 
                        label: "${widget.occasionName}",
                        amount: "${widget.paymentAmount.toStringAsFixed(2)}"
                    },
                    requiredBillingContactFields: ['postalAddress', 'name', 'email'],
                    requiredShippingContactFields: [],
                    billingContact: {
                        countryCode: 'SA'
                    }
                },
                
                onReady: function() {
                    console.log("Payment widget is ready");
                    document.getElementById('loading-container').style.display = 'none';
                    checkApplePayAvailability();
                },
                
                onError: function(error) {
                    console.error('Payment widget error:', error);
                    showError('Payment widget error: ' + JSON.stringify(error));
                    document.getElementById('loading-container').style.display = 'none';
                    document.getElementById('apple-pay-available').style.display = 'none';
                    document.getElementById('apple-pay-not-available').style.display = 'block';
                },
                
                onLoad: function() {
                    console.log('Payment widget loaded');
                },
                
                onBeforeSubmit: function(data) {
                    console.log('Before submit:', data);
                    return true;
                },
                
                onAfterSubmit: function(data) {
                    console.log('After submit:', data);
                }
            };
        }
        
        // Load HyperPay script dynamically
        function loadHyperPayScript() {
            const script = document.createElement('script');
            script.src = 'https://eu-prod.oppwa.com/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}';
            script.onload = function() {
                console.log('HyperPay script loaded successfully');
                setTimeout(initializePayment, 500);
            };
            script.onerror = function() {
                console.error('Failed to load HyperPay script');
                showError('Failed to load payment script. Please check your internet connection.');
                document.getElementById('loading-container').style.display = 'none';
                document.getElementById('apple-pay-not-available').style.display = 'block';
            };
            document.head.appendChild(script);
        }
        
        // Check Apple Pay availability
        function checkApplePayAvailability() {
            console.log('Checking Apple Pay availability...');
            
            // Check if we're on iOS
            const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent);
            const isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);
            
            console.log('Is iOS:', isIOS);
            console.log('Is Safari:', isSafari);
            
            if (!isIOS) {
                console.log('Not on iOS device');
                showError('Apple Pay is only available on iOS devices');
                document.getElementById('apple-pay-available').style.display = 'none';
                document.getElementById('apple-pay-not-available').style.display = 'block';
                return;
            }
            
            if (window.ApplePaySession) {
                console.log('ApplePaySession exists');
                console.log('Apple Pay version:', ApplePaySession.version);
                
                if (ApplePaySession.canMakePayments()) {
                    console.log("Apple Pay can make payments");
                    
                    // Check if user has cards set up
                    ApplePaySession.canMakePaymentsWithActiveCard('merchant.com.hadawi.app')
                        .then(function(canMakePayments) {
                            console.log('Can make payments with active card:', canMakePayments);
                            
                            if (canMakePayments) {
                                document.getElementById('apple-pay-available').style.display = 'block';
                                document.getElementById('apple-pay-not-available').style.display = 'none';
                            } else {
                                console.log('No active cards available');
                                showError('Please add a payment card to your Apple Wallet to use Apple Pay');
                                document.getElementById('apple-pay-available').style.display = 'none';
                                document.getElementById('apple-pay-not-available').style.display = 'block';
                            }
                        })
                        .catch(function(error) {
                            console.error('Error checking active cards:', error);
                            showError('Error checking Apple Pay cards: ' + error.message);
                            document.getElementById('apple-pay-available').style.display = 'none';
                            document.getElementById('apple-pay-not-available').style.display = 'block';
                        });
                } else {
                    console.log("Apple Pay cannot make payments");
                    showError('Apple Pay is not enabled on this device');
                    document.getElementById('apple-pay-available').style.display = 'none';
                    document.getElementById('apple-pay-not-available').style.display = 'block';
                }
            } else {
                console.log("ApplePaySession not available");
                showError('Apple Pay is not supported on this browser/device');
                document.getElementById('apple-pay-available').style.display = 'none';
                document.getElementById('apple-pay-not-available').style.display = 'block';
            }
        }
        
        // Initialize when DOM is ready
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing payment...');
            initializePayment();
        });
        
        // Fallback timeout
        setTimeout(function() {
            if (document.getElementById('loading-container').style.display !== 'none') {
                console.log('Fallback: Timeout reached');
                if (initializationAttempts < maxAttempts) {
                    console.log('Retrying initialization...');
                    retryPayment();
                } else {
                    console.log('Max attempts reached, showing error');
                    showError('Payment initialization timed out after multiple attempts.');
                    document.getElementById('loading-container').style.display = 'none';
                    document.getElementById('apple-pay-not-available').style.display = 'block';
                }
            }
        }, 10000);
    </script>
</body>
</html>
""";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1")
      ..enableZoom(false)
      ..setBackgroundColor(Colors.white)
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

            // Additional debugging
            controller.runJavaScript("""
              console.log('Page finished loading, environment check...');
              console.log('Current URL:', window.location.href);
              console.log('User Agent:', navigator.userAgent);
              console.log('ApplePaySession available:', typeof ApplePaySession !== 'undefined');
              console.log('Online status:', navigator.onLine);
              
              // Check if we're in a WebView
              console.log('Is WebView:', window.webkit && window.webkit.messageHandlers);
              console.log('Screen size:', window.screen.width + 'x' + window.screen.height);
            """);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView error: ${error.description}");
            debugPrint("Error code: ${error.errorCode}");
            debugPrint("Error type: ${error.errorType}");
          },
          onHttpError: (HttpResponseError error) {
            debugPrint("HTTP error: ${error.response?.statusCode}");
          },
          onUrlChange: (UrlChange change) async {
            debugPrint("URL changed to: ${change.url}");

            if (change.url != null && change.url!.contains("https://hadawi.netlify.app/payment-result")) {
              try {
                await context.read<PaymentCubit>().checkApplePaymentStatus(widget.checkoutId, context);
                if (mounted) {
                  Navigator.pop(context);
                  final paymentResult = context.read<PaymentCubit>().paymentStatusList.last;
                  handlePaymentResult(
                    paymentResult['result']['code'],
                    paymentResult['result']['description'],
                    paymentResult,
                  );
                }
              } catch (e) {
                debugPrint("Error checking payment status: $e");
                if (mounted) {
                  showPaymentError("Failed to verify payment status: $e");
                }
              }
            }
          },
        ),
      )
      ..setOnConsoleMessage((JavaScriptConsoleMessage message) {
        debugPrint('WebView Console [${message.level}]: ${message.message}');
      })
      ..loadRequest(Uri.dataFromString(
        hyperpayHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
  }

  void handlePaymentResult(String resultCode, String description, Map<String, dynamic> fullData) {
    debugPrint("Payment result: $resultCode - $description");

    // Success codes
    if (resultCode.startsWith('000.000.') ||
        resultCode.startsWith('000.100.')) {
      debugPrint("✅ Payment Successful");
      showPaymentSuccess(description);
    }
    // Pending codes
    else if (resultCode.startsWith('000.200.')) {
      debugPrint("⏳ Payment Pending");
      showPaymentPending(description);
    }
    // Failure codes
    else {
      debugPrint("❌ Payment Failed: $resultCode - $description");
      showPaymentFailure(resultCode, description);
    }
  }

  void showPaymentSuccess(String description) {
    if (!mounted) return;

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
              customPushReplacement(context, OccasionDetails(occasionId: widget.occasionId, fromHome: true));

              try {
                await PaymentCubit.get(context).addPaymentData(
                  context: context,
                  transactionId: widget.transactionId,
                  occasionId: widget.occasionId,
                  remainingPrince: widget.remainingPrice.toString(),
                  status: "success",
                  occasionName: widget.occasionName,
                  paymentAmount: widget.paymentAmount,
                );
              } catch (e) {
                debugPrint("Error adding payment data: $e");
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentPending(String description) {
    if (!mounted) return;

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
              customPushReplacement(context, OccasionDetails(occasionId: widget.occasionId, fromHome: true));

              try {
                await PaymentCubit.get(context).addPaymentData(
                  context: context,
                  occasionId: widget.occasionId,
                  transactionId: widget.transactionId,
                  remainingPrince: widget.remainingPrice.toString(),
                  status: "pending",
                  occasionName: widget.occasionName,
                  paymentAmount: widget.paymentAmount,
                );
              } catch (e) {
                debugPrint("Error adding payment data: $e");
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentFailure(String resultCode, String description) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('paymentFailed').toString()),
        content: Text("${AppLocalizations.of(context)!.translate('paymentFailedMessage').toString()}\n\nCode: $resultCode\n$description"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to payment selection
            },
            child: Text("Try Again"),
          ),
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
    if (!mounted) return;

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
              Navigator.of(context).pop(); // Go back to payment selection
            },
            child: Text("Try Again"),
          ),
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
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        return true;
      },
      child: Scaffold(
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
                fontSize: 18,
              ),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: ColorManager.primaryBlue,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading Apple Pay...',
                        style: TextStyle(
                          color: ColorManager.primaryBlue,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}