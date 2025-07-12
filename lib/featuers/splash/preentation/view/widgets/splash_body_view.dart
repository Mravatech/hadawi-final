import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/widgets/logo_image.dart';
import 'package:hadawi_app/main.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

import '../../../../home_layout/presentation/view/home_layout/home_layout.dart';

class SplashBodyView extends StatefulWidget {
  const SplashBodyView({super.key});

  @override
  State<SplashBodyView> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashBodyView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    UserDataFromStorage.getData();
    _initAppLinksHandling();
    if(!kIsWeb){
      timeDelay(context: context);
    }
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, 0))
            .animate(animationController);
    animationController.forward();
  }

  Future<void> _initAppLinksHandling() async {
    // Handle app links (for universal links and custom schemes)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleAppLink,
      onError: (error) {
        debugPrint('App link error: $error');
      },
    );

    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        debugPrint('Initial app link: $initialLink');
        _handleAppLink(initialLink);
      }
    } catch (e) {
      debugPrint('Error getting initial app link: $e');
    }
  }

  void _handleAppLink(Uri uri) {
    debugPrint('Received app link: $uri');

    // Extract occasion ID from app link
    String? occasionId;

    // ✅ جديد: دعم روابط Firebase Hosting مثل hadawi-payment.web.app
    if (uri.host == 'hadawi-payment.web.app') {
      if (uri.pathSegments.contains('occasion-details')) {
        int idx = uri.pathSegments.indexOf('occasion-details');
        if (idx < uri.pathSegments.length - 1) {
          occasionId = uri.pathSegments[idx + 1];
        }
      }
    }

    // Handle various URI formats
    if (uri.scheme == 'hadawi' || uri.scheme == 'com.app.hadawiapp') {
      // Custom scheme URI: hadawi://occasion-details/{id}
      if (uri.host == 'occasion-details' && uri.pathSegments.isNotEmpty) {
        occasionId = uri.pathSegments.first;
      }
    } else if (uri.host == 'hadawiapp.page.link') {
      // Firebase Dynamic Link
      if (uri.pathSegments.isNotEmpty) {
        if (uri.pathSegments.contains('occasion-details')) {
          int idx = uri.pathSegments.indexOf('occasion-details');
          if (idx < uri.pathSegments.length - 1) {
            occasionId = uri.pathSegments[idx + 1];
          }
        } else if (uri.pathSegments.length > 0) {
          // This might be a short link, treat the last segment as the ID
          occasionId = uri.pathSegments.last;
        }
      }

      // Check if a link parameter is provided
      if (occasionId == null && uri.queryParameters.containsKey('link')) {
        final linkUri = Uri.tryParse(uri.queryParameters['link']!);
        if (linkUri != null) {
          // Extract ID from the link parameter
          if (linkUri.pathSegments.contains('occasion-details')) {
            int idx = linkUri.pathSegments.indexOf('occasion-details');
            if (idx < linkUri.pathSegments.length - 1) {
              occasionId = linkUri.pathSegments[idx + 1];
            }
          }
        }
      }
    }

    debugPrint('Extracted occasion ID from app link: $occasionId');

    if (occasionId != null && occasionId.isNotEmpty) {
      // Use WidgetsBinding to ensure the navigation happens after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigate using the standard Navigator and the navigatorKey
        HadawiApp.navigatorKey.currentState?.pushNamed(
            AppRoutes.occasionDetails,
            arguments: {
              'occasionId': occasionId,
              'fromHome': true
            }
        );
      });
    } else {
      // Default navigation if no occasion ID is found
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   final isLoggedIn = UserDataFromStorage.userIsGuest;
      //   HadawiApp.navigatorKey.currentState?.pushReplacementNamed(
      //       isLoggedIn ? AppRoutes.home : AppRoutes.login
      //   );
      // });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: slideAnimation,
            builder: (context, _) {
              return SlideTransition(
                position: slideAnimation,
                child: LogoImage(),
              );
            },
          ),
        ],
      ),
    );
  }
}

void timeDelay({required BuildContext context}) {

  Future.delayed(const Duration(seconds: 2), () async {
    print('${UserDataFromStorage.uIdFromStorage}');
    UserDataFromStorage.uIdFromStorage != ''?
    customPushReplacement(context, HomeLayout()):
    customPushReplacement(context, LoginScreen());
  });
}