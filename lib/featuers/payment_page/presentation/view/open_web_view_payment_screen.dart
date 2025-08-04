import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/styles/assets/asset_manager.dart';
import 'package:hadawi_app/styles/colors/color_manager.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClickPayWebView extends StatefulWidget {
  final String url;

  const ClickPayWebView({super.key, required this.url});

  @override
  State<ClickPayWebView> createState() => _ClickPayWebViewState();
}

class _ClickPayWebViewState extends State<ClickPayWebView> {
  late final WebViewController _controller;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('WebView started loading: $url');

            if (url.contains('/return') && !_hasNavigated) {
              _hasNavigated = true;

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!
                        .translate('paymentDoneSuccessfully')
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: ColorManager.primaryBlue,
                  duration: const Duration(seconds: 3),
                ),
              );

              customPushNavigator(context, HomeLayout());
            }
          },
          onPageFinished: (url) {
            debugPrint('WebView finished loading: $url');
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: $error');
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: {
          'User-Agent':
          'Mozilla/5.0 (Linux; Android 10; Mobile; rv:109.0) Gecko/20100101 Firefox/115.0',
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate('payment').toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8B7BA8),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8B7BA8)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.logoWithoutBackground,
              height: 32,
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}