import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
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


  const PaymentWebScreen({super.key, required this.checkoutId, required integrity, required this.occasionId, required this.occasionName, required this.paymentAmount, required this.transactionId, required this.remainingPrice});

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

            await context.read<PaymentCubit>().checkPaymentStatus(widget.checkoutId, context);

            if (change.url != null && change.url!.contains("https://hadawi.netlify.app/payment-result")) {

             Navigator.pop(context);
             handlePaymentResult(context.read<PaymentCubit>().paymentStatusList.last['result']['code'], context.read<PaymentCubit>().paymentStatusList.last['result']['description'], context.read<PaymentCubit>().paymentStatusList.last);
            }

            // Check for payment result URL
            // if (change.url != null && change.url!.contains("https://hadawi.netlify.app/payment-result")) {
            //   Uri uri = Uri.parse(change.url!);
            //   String resourcePath = uri.queryParameters['resourcePath'] ?? '';
            //
            //   if (resourcePath.isNotEmpty) {
            //     await verifyPayment(resourcePath);
            //   } else {
            //     String checkoutId = uri.queryParameters['id'] ?? '';
            //     if (checkoutId.isNotEmpty) {
            //       await verifyPayment("/v1/checkouts/$checkoutId/payment");
            //     }
            //   }
            // }
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('completePayment').toString()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}