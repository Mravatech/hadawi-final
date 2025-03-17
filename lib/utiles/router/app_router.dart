import 'package:flutter/material.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/screen/splash_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/widgets/occasion_details.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String occasionsList = '/occasions-list';
  static const String visitors = '/visitors';
  static const String occasionDetails = '/Occasion-details';


  // Generate route based on settings
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // Extract arguments if available
    final args = settings.arguments;

    // Parse route and parameters (for routes like '/product/123')
    String routeName = settings.name ?? '/';
    String? parameter;

    if (routeName != '/' && routeName.contains('/')) {
      final segments = routeName.split('/');
      if (segments.length > 2 && segments[2].isNotEmpty) {
        routeName = '/${segments[1]}';
        parameter = segments[2];
      }
    }

    switch (routeName) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeLayout(),
        );
      case occasionDetails:
      // Handle the occasion details route with parameter
        final occasionId = parameter ??
            (args is String ? args :
            (args is Map<String, dynamic> ? args['occasionId']?.toString() : ''));

        return MaterialPageRoute(
          builder: (_) => OccasionDetails(occasionId: occasionId!),
        );
      default:
      // 404 page
        return MaterialPageRoute(
          builder: (_) => const NotFoundScreen(),
        );
    }
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('The page you requested was not found.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}