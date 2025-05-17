import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hadawi_app/featuers/auth/presentation/controller/auth_cubit.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/Login/login_screen.dart';
import 'package:hadawi_app/featuers/auth/presentation/view/register/register_screen.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/controller/home_cubit.dart';
import 'package:hadawi_app/featuers/home_layout/presentation/view/home_layout/home_layout.dart';
import 'package:hadawi_app/featuers/occasions/domain/entities/occastion_entity.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/bloc_observer.dart';
import 'package:hadawi_app/featuers/occasions/presentation/controller/occasion_cubit.dart';
import 'package:hadawi_app/featuers/occasions/presentation/view/occasion_summary.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/controller/occasions_list_cubit.dart';
import 'package:hadawi_app/featuers/occasions_list/presentation/view/my_occasions.dart';
import 'package:hadawi_app/featuers/payment_page/presentation/controller/payment_cubit.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/notification_screen.dart';
import 'package:hadawi_app/featuers/settings/presentation/view/widgets/privacy_policies.dart';
import 'package:hadawi_app/featuers/splash/preentation/view/screen/splash_screen.dart';
import 'package:hadawi_app/featuers/visitors/presentation/controller/visitors_cubit.dart';
import 'package:hadawi_app/featuers/visitors/presentation/view/visitors_screen.dart';
import 'package:hadawi_app/firebase_options.dart';
import 'package:hadawi_app/styles/theme_manger/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hadawi_app/utiles/cashe_helper/cashe_helper.dart';
import 'package:hadawi_app/utiles/helper/material_navigation.dart';
import 'package:hadawi_app/utiles/localiztion/app_localization.dart';
import 'package:hadawi_app/utiles/localiztion/localization_cubit.dart';
import 'package:hadawi_app/utiles/localiztion/localization_states.dart';
import 'package:hadawi_app/utiles/services/dio_helper.dart';
import 'package:hadawi_app/utiles/services/notification_service.dart';
import 'package:hadawi_app/utiles/services/service_locator.dart';
import 'package:hadawi_app/utiles/shared_preferences/shared_preference.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'featuers/visitors/presentation/view/widgets/occasion_details.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => const LoginScreen(),
  redirect: (context, state) {
    final uri = Uri.parse(state.uri.toString());

    // Handle dynamic links with app scheme
    if ((uri.scheme == 'com.app.hadawiapp' || uri.scheme == 'hadawi')) {
      debugPrint('Handling custom scheme in redirect: ${uri.toString()}');

      // Process the path segments
      final pathSegments = uri.pathSegments;

      if (pathSegments.isNotEmpty) {
        OccasionEntity? occasionEntity;
        // Check for occasion details path (case-insensitive)
        if (pathSegments.first.toLowerCase() == 'occasion-details' && pathSegments.length > 1) {
          final occasionId = pathSegments[1];
          return '/occasion-details/$occasionId/true';
        }
      }

      // Default redirect for unprocessed app scheme links
      final isLoggedIn = UserDataFromStorage.userIsGuest ?? false;
      return isLoggedIn ? '/home' : '/login';
    }

    return null; // Continue with normal routing
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/occasion-details/:id/:fromHome',
      builder: (context, state) {
        final occasionId = state.pathParameters['id'];
        final fromHome = state.pathParameters['fromHome'] == 'true';
        return OccasionDetails(occasionId: occasionId!,fromHome: fromHome);
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeLayout(),
    ),
    GoRoute(
      path: '/summary',
      builder: (context, state) => OccasionSummary(),
    ),
    GoRoute(
      path: '/visitors',
      builder: (context, state) => VisitorsScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => NotificationScreen(),
    ),
    GoRoute(
      path: '/privacy-policies',
      builder: (context, state) => PrivacyPoliciesScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/my-occasions',
      builder: (context, state) => MyOccasions(),
    ),
    GoRoute(
        path: '/sign-up',
        builder: (context, state) => const RegisterScreen()
    ),
    // Add catch-all route for handling unknown paths
    GoRoute(
      path: '/:path(.*)',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);

Future<void> main() async {
  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://84d149a4ed2f407b023cd9ca435bab0c@o4509321210494981.ingest.de.sentry.io/4509321270788176';
      options.tracesSampleRate = 1.0; // For performance monitoring (optional)
    },
    appRunner: () async {
      WidgetsFlutterBinding.ensureInitialized();

      ServiceLocator().init();
      await SharedPreferences.getInstance();
      UserDataFromStorage.getData();
      // Note: this should be awaited
      CashHelper.init();
      DioHelper.dioInit();
      Bloc.observer = MyBlocObserver();

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exception.toString().contains('HttpException') &&
            details.exception.toString().contains('Invalid statusCode: 404')) {
          return;
        }
        // Report to Sentry
        Sentry.captureException(
          details.exception,
          stackTrace: details.stack,
        );

        FlutterError.presentError(details);
      };

      NotificationService().initRemoteNotification();

      debugPrint("current date is ${DateTime.now()}");

      runApp(const MyApp());
    },
  );
}

class MyApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance();
    UserDataFromStorage.getData();
    CashHelper.init();
    DioHelper.dioInit();
    _initDeepLinkHandling();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(
            getIt(), getIt(), getIt(), getIt(),
            getIt(), getIt(), getIt(),
            getIt(), getIt(), getIt())..getAllCity()),
        BlocProvider(create: (context) => PaymentCubit()),
        BlocProvider(create: (context) => HomeCubit()..getUserNotifications()..getPrivacyPolices()),
        BlocProvider(create: (context) => OccasionCubit()),
        BlocProvider(create: (context) => VisitorsCubit(getIt())..getAnalysis()),
        BlocProvider(create: (context) => OccasionsListCubit()),
        BlocProvider(create: (context) => LocalizationCubit()..fetchLocalization()),
      ],
      child: BlocBuilder<LocalizationCubit, LocalizationStates>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Hadawi',
            theme: getApplicationTheme(context),
            routerConfig: _router,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("ar", ""),
              Locale("en", ""),
            ],
            locale: LocalizationCubit.get(context).appLocal,
            localeResolutionCallback: (currentLang, supportLang) {
              if (currentLang != null) {
                for (Locale locale in supportLang) {
                  if (locale.languageCode == currentLang.languageCode) {
                    return currentLang;
                  }
                }
              }
              return supportLang.first;
            },
          );
        },
      ),
    );
  }
}