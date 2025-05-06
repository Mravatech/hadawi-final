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
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body { margin: 0; padding: 16px; font-family: -apple-system, BlinkMacSystemFont, sans-serif; }
        .error { color: red; padding: 20px; text-align: center; }
        .loading { text-align: center; padding: 20px; }
      </style>
    </head>
    <body>
      <div id="apple-pay-container">
        <div id="loading-indicator" class="loading">Loading payment gateway...</div>
      </div>
      
      <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=${widget.checkoutId}"></script>
      <script>
        // Debug logging
        console.log("Starting Apple Pay initialization");
        
        // Check if Apple Pay is available
        function checkApplePayAvailability() {
          if (window.ApplePaySession && ApplePaySession.canMakePayments()) {
            console.log("Apple Pay is available");
            return true;
          } else {
            console.log("Apple Pay is not available on this device");
            document.getElementById('loading-indicator').innerHTML = 
              '<div class="error">Apple Pay is not available on this device or browser</div>';
            return false;
          }
        }

        // Configure Apple Pay
        var wpwlOptions = {
          applePay: {
            displayName: "Test App",
            countryCode: "SA",
            currencyCode: "SAR",
            totalAmount: "${widget.amount}",
            onError: function(error) {
              console.error("Apple Pay error:", error);
              document.getElementById('loading-indicator').innerHTML = 
                '<div class="error">Error initializing Apple Pay: ' + error.message + '</div>';
            }
          },
          onReady: function() {
            console.log("Payment widget is ready");
            document.getElementById('loading-indicator').style.display = 'none';
          },
          onError: function(error) {
            console.error("Widget error:", error);
            document.getElementById('loading-indicator').innerHTML = 
              '<div class="error">Payment widget error: ' + error + '</div>';
          }
        };

        // Initialize when page loads
        window.addEventListener('load', function() {
          console.log("Page loaded, checking Apple Pay...");
          checkApplePayAvailability();
        });
      </script>
      
      <form action="https://hadawi.com/payment-result" class="paymentWidgets" data-brands="APPLEPAY"></form>
    </body>
    </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('WebView page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('WebView page finished loading: $url');
            setState(() {
              _isLoading = false;
            });

            // Add JavaScript console log listener
            _controller.runJavaScript('''
              console.log = function(message) {
                window.flutter_inappwebview.callHandler('consoleLog', message);
                console.info(message);
              };
              console.error = function(message) {
                window.flutter_inappwebview.callHandler('consoleError', message);
                console.info('ERROR: ' + message);
              };
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            setState(() {
              _errorMessage = 'Error: ${error.description}';
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final uri = Uri.parse(request.url);
            debugPrint('Navigation request to: ${request.url}');

            if (uri.path.contains("payment-result")) {
              debugPrint('Payment result detected');
              if (uri.queryParameters.containsKey('resourcePath')) {
                _handlePaymentResult(uri.queryParameters['resourcePath']!);
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('JavaScript message: ${message.message}');
        },
      );

    _controller.loadHtmlString(htmlContent);
  }

  Future<void> _handlePaymentResult(String resourcePath) async {
    try {
      debugPrint('Handling payment result with resourcePath: $resourcePath');
      final url = 'https://eu-test.oppwa.com$resourcePath?entityId=8ac7a4ca969f7e8d01969ff847030111';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer OGFjN2E0Yzc5NWEwZjcyZjAxOTVhMzc1MjY1NjAzZjV8Sz9DcD9QeFV4PTVGUWJ1S2MlUHU=',
        },
      );

      final data = json.decode(response.body);
      debugPrint('Payment result data: $data');
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
    } catch (e) {
      debugPrint('Error handling payment result: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error processing payment: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apple Pay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = '';
              });
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = '';
                        });
                        _controller.reload();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}