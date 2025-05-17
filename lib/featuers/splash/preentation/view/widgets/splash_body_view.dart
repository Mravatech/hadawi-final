import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/widgets/logo_image.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/router/app_router.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';

class SplashBodyView extends StatefulWidget {
  const SplashBodyView({super.key});

  @override
  State<SplashBodyView> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashBodyView>
    with SingleTickerProviderStateMixin {
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    UserDataFromStorage.getData();
    timeDelay(context: context);
    _initDeepLinkHandling();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: const Offset(0, 0))
            .animate(animationController);

    animationController.forward();
  }

  Future<void> _initDeepLinkHandling() async {
    // Listen for incoming links while the app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (error) {
        debugPrint('Deep link error: $error');
        // Don't navigate automatically on error
      },
    );

    try {
      // Handle links that launched the app
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        debugPrint('Got initial link: ${initialLink.toString()}');
        _handleDeepLink(initialLink);
      } else {
        debugPrint('No initial link found');
        // Only navigate to home if the user is logged in
        if (mounted) {
          final isLoggedIn = UserDataFromStorage.userIsGuest ?? false;
          if (isLoggedIn) {
            GoRouter.of(context).go('/home');
          } else {
            GoRouter.of(context).go('/login');
          }
        }
      }
    } catch (e) {
      debugPrint('Error getting initial deep link: $e');
      // Don't navigate automatically on error
    }
  }

// Improve your deep link handling logic
  void _handleDeepLink(Uri uri) {
    debugPrint('Handling deep link: ${uri.toString()}');
    debugPrint('URI scheme: ${uri.scheme}');
    debugPrint('URI host: ${uri.host}');
    debugPrint('URI path: ${uri.path}');
    debugPrint('URI pathSegments: ${uri.pathSegments}');
    debugPrint('URI queryParameters: ${uri.queryParameters}');

    // First, check for Firebase Dynamic Links format
    if (uri.host == 'hadawiapp.page.link') {
      // For Firebase Dynamic Links, we need to resolve the URL first
      FirebaseDynamicLinks.instance.getDynamicLink(uri).then((dynamicLinkData) {
        if (dynamicLinkData != null) {
          final deepLink = dynamicLinkData.link;
          debugPrint('Resolved dynamic link: ${deepLink.toString()}');
          _processDeepLinkUri(deepLink);
        } else {
          debugPrint('Could not resolve dynamic link');
          _processDeepLinkUri(uri); // Try to process the original URI as fallback
        }
      }).catchError((error) {
        debugPrint('Error resolving dynamic link: $error');
        _processDeepLinkUri(uri); // Try to process the original URI as fallback
      });
    } else {
      // For direct deep links (custom schemes), process directly
      _processDeepLinkUri(uri);
    }
  }

// New method to centralize the deep link path processing logic
  void _processDeepLinkUri(Uri uri) {
    // Check for occasion details in various formats

    // 1. Check path-based format: /occasion-details/{id}
    if (uri.path.toLowerCase().startsWith('/occasion-details') && uri.pathSegments.length > 1) {
      final occasionId = uri.pathSegments[1];
      if (mounted) {
        debugPrint('Navigating to occasion details with ID: $occasionId');
        GoRouter.of(context).go('/occasion-details/$occasionId/true');
        return;
      }
    }

    // 2. Check host-based format: occasion-details/{id}
    else if (uri.host.toLowerCase() == 'occasion-details' && uri.pathSegments.isNotEmpty) {
      final occasionId = uri.pathSegments.first;
      if (mounted) {
        debugPrint('Navigating to occasion details with ID: $occasionId');
        GoRouter.of(context).go('/occasion-details/$occasionId/true');
        return;
      }
    }

    // 3. Check query parameter format: ?occasion_id={id}
    else if (uri.queryParameters.containsKey('occasion_id')) {
      final occasionId = uri.queryParameters['occasion_id'];
      if (occasionId != null && mounted) {
        debugPrint('Navigating to occasion details with ID from query param: $occasionId');
        GoRouter.of(context).go('/occasion-details/$occasionId/true');
        return;
      }
    }

    // Default fallback if no specific route is matched
    if (mounted) {
      // Navigate to home or login depending on authentication status
      final isLoggedIn = UserDataFromStorage.userIsGuest ?? false;
      debugPrint('No specific path matched. Navigating to ${isLoggedIn ? 'home' : 'login'}');
      GoRouter.of(context).go(isLoggedIn ? '/home' : '/login');
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
    context.replace(AppRouter.home):
    context.go(AppRouter.login);
  });
}
