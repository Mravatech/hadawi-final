import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebScreen extends StatefulWidget {
  final String checkoutId;

  PaymentWebScreen({required this.checkoutId, required integrity});

  @override
  _PaymentWebScreenState createState() => _PaymentWebScreenState();
}

class _PaymentWebScreenState extends State<PaymentWebScreen> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

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
                    script-src 'self' https://eu-test.oppwa.com 'unsafe-inline';
                    style-src 'self' https://eu-test.oppwa.com 'unsafe-inline';
                    frame-src 'self' https://eu-test.oppwa.com;
                    connect-src 'self' wss://* https://p11.techlab-cdn.com;
                    img-src 'self' https://eu-test.oppwa.com;">
      </head>
      <body>
          <div style="text-align: center; margin-top: 20px;">
              <h3>Complete your payment</h3>
          </div>
          
          <!-- Load Hyperpay Payment Widget -->
          <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}"></script>
          
          <!-- Required script for 3D Secure redirection -->
          <script type="text/javascript"> 
          var wpwlOptions = {
            paymentTarget: "_top",
            style: "card",
            showCVVHint: true,
            brandDetection: true,
            onReady: function() {
              // Change the order of payment methods to show MADA first
              var madaDiv = document.querySelector('.wpwl-brand-MADA');
              if (madaDiv) {
                var brandsDiv = madaDiv.parentNode;
                brandsDiv.insertBefore(madaDiv, brandsDiv.firstChild);
              }
            }
          }
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
          </script>

          <!-- Payment Form with MADA first -->
          <form class="paymentWidgets" data-brands="MADA VISA MASTER"></form>
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

            // Check for payment result URL
            if (change.url != null && change.url!.contains("https://hadawi.netlify.app/payment-result")) {
              Uri uri = Uri.parse(change.url!);
              String resourcePath = uri.queryParameters['resourcePath'] ?? '';

              if (resourcePath.isNotEmpty) {
                await verifyPayment(resourcePath);
              } else {
                String checkoutId = uri.queryParameters['id'] ?? '';
                if (checkoutId.isNotEmpty) {
                  await verifyPayment("/v1/checkouts/$checkoutId/payment");
                }
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

  Future<void> verifyPayment(String resourcePath) async {
    try {
      if (!resourcePath.startsWith('/')) {
        resourcePath = '/$resourcePath';
      }

      final response = await http.get(
        Uri.parse("https://eu-test.oppwa.com$resourcePath"),
        headers: {
          "Authorization": "Bearer OGFjN2E0Yzc5NWEwZjcyZjAxOTVhMzc1MjY1NjAzZjV8Sz9DcD9QeFV4PTVGUWJ1S2MlUHU=",
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        String resultCode = data['result']['code'] ?? '';
        String resultDescription = data['result']['description'] ?? 'Unknown status';
        String transactionId = data['id'] ?? '';

        handlePaymentResult(resultCode, resultDescription, transactionId, data);
      } else {
        debugPrint("Error verifying payment: ${response.statusCode} - ${response.body}");
        showPaymentError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception verifying payment: $e");
      showPaymentError("Failed to verify payment status");
    }
  }

  void handlePaymentResult(String resultCode, String description, String transactionId, Map<String, dynamic> fullData) {
    // Success codes typically start with 000.000., 000.100., or 000.200.
    if (resultCode.startsWith('000.000.') ||
        resultCode.startsWith('000.100.') ||
        resultCode.startsWith('000.200.')) {
      debugPrint("✅ Payment Successful: $transactionId");
      showPaymentSuccess(transactionId, description);
    }
    // Pending codes typically start with 000.200.
    else if (resultCode.startsWith('000.200.')) {
      debugPrint("⏳ Payment Pending: $transactionId");
      showPaymentPending(transactionId, description);
    }
    // Failure codes can vary
    else {
      debugPrint("❌ Payment Failed: $resultCode - $description");
      showPaymentFailure(resultCode, description);
    }
  }

  void showPaymentSuccess(String transactionId, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Payment Successful"),
        content: Text("Your payment was completed successfully!\n\nTransaction ID: $transactionId"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop({
                "success": true,
                "transactionId": transactionId,
                "description": description
              });
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void showPaymentPending(String transactionId, String description) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Payment Pending"),
        content: Text("Your payment is being processed.\n\nTransaction ID: $transactionId\n\nDescription: $description"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop({
                "success": false,
                "pending": true,
                "transactionId": transactionId,
                "description": description
              });
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
        title: Text("Payment Failed"),
        content: Text("Your payment was not completed.\n\nError Code: $resultCode\n\nDescription: $description"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop({
                "success": false,
                "resultCode": resultCode,
                "description": description
              });
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
              Navigator.of(context).pop({
                "success": false,
                "error": message
              });
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
      appBar: AppBar(
        title: Text("Complete Payment"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop({
              "success": false,
              "resultCode": "canceled_by_user"
            });
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
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}