import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class ApplePayWebView extends StatefulWidget {
  final String checkoutId;
  final String amount;

  const ApplePayWebView({super.key, required this.checkoutId, required this.amount});

  @override
  State<ApplePayWebView> createState() => _ApplePayWebViewState();
}

class _ApplePayWebViewState extends State<ApplePayWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}"></script>
      <script>
        var wpwlOptions = {
          applePay: {
            displayName: "Test App",
            countryCode: "SA",
            currencyCode: "SAR",
            totalAmount: "${widget.amount}"
          }
        };
      </script>
    </head>
    <body>
      <form action="https://hadawi.com/payment-result" class="paymentWidgets" data-brands="APPLEPAY"></form>
    </body>
    </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlContent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            if (uri.path.contains("payment-result") && uri.queryParameters.containsKey('resourcePath')) {
              _handlePaymentResult(uri.queryParameters['resourcePath']!);
              return NavigationDecision.prevent; // Prevent navigation and stay within the app
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  Future<void> _handlePaymentResult(String resourcePath) async {
    final url = 'https://eu-test.oppwa.com$resourcePath?entityId=8a8294174d0595bb014d05d829cb01cd';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer OGE4Mjk0MTc0ZDA1OTViYjAxNGQwNWQ4MjllNzAxZDF8OVRuSlBjMm45aA==',
      },
    );

    final data = json.decode(response.body);
    final resultCode = data['result']['code'];
    final resultMessage = data['result']['description'];

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(resultCode.startsWith("000") ? "✅ الدفع ناجح" : "❌ الدفع فشل"),
          content: Text(resultMessage ?? "لا يوجد رسالة"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("تم"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apple Pay')),
      body: WebViewWidget(controller: _controller),
    );
  }
}