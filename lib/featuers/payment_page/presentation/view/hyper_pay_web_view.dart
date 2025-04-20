import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class HyperPayWebViewScreen extends StatefulWidget {
  final String checkoutId;
  final String? integrityValue;
  final String nonce;
  final Function(Map<String, dynamic>) onPaymentCompleted;

  const HyperPayWebViewScreen({
    Key? key,
    required this.checkoutId,
    required this.integrityValue,
    required this.nonce,
    required this.onPaymentCompleted,
  }) : super(key: key);

  @override
  State<HyperPayWebViewScreen> createState() => _HyperPayWebViewScreenState();
}

class _HyperPayWebViewScreenState extends State<HyperPayWebViewScreen> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupWebViewController();
  }

  void _setupWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Handle payment status redirects
            if (request.url.contains('success') ||
                request.url.contains('failure') ||
                request.url.contains('cancel')) {

              // Extract payment status from URL
              Map<String, dynamic> result = {
                'status': request.url.contains('success') ? 'success' :
                request.url.contains('failure') ? 'failure' : 'cancelled',
                'url': request.url,
              };

              widget.onPaymentCompleted(result);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(_generateHtmlWithCSP());
  }

  String _generateHtmlWithCSP() {
    // The domain to use in the CSP
    String domain = 'eu-test.oppwa.com'; // Use 'eu-prod.oppwa.com' for production

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="Content-Security-Policy"
        content="
          style-src 'self' https://$domain 'unsafe-inline';
          frame-src 'self' https://$domain;
          script-src 'self' https://$domain 'nonce-${widget.nonce}';
          connect-src 'self' https://$domain;
          img-src 'self' https://$domain;
        ">
      <title>Payment</title>
      <style>
        body, html {
          margin: 0;
          padding: 0;
          height: 100%;
          width: 100%;
          display: flex;
          justify-content: center;
          align-items: center;
        }
        .container {
          width: 100%;
          max-width: 500px;
          padding: 20px;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <form action="#" class="paymentWidgets" data-brands="VISA MASTER AMEX"></form>
      </div>
      
      <script nonce="${widget.nonce}">
        var wpwlOptions = {
          style: "card",
          locale: "en",
          onReady: function() {
            console.log("Payment form is ready");
          },
          onSuccess: function(data) {
            window.location.href = "https://success.example.com?" + JSON.stringify(data);
          },
          onError: function(error) {
            window.location.href = "https://failure.example.com?" + JSON.stringify(error);
          }
        };
      </script>
      
      <script 
        src="https://$domain/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}"
        ${widget.integrityValue != null ? 'integrity="${widget.integrityValue}"' : ''}
        crossorigin="anonymous">
      </script>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle cancel action
            widget.onPaymentCompleted({'status': 'cancelled'});
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}